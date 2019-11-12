//
//  GesturesTableView.m
//
//  Created by mac on 2019/9/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "GesturesTableView.h"
#import <objc/runtime.h>
#import "RefreshView.h"

//刷新icon区间
CG_INLINE CGFloat MARGINTOP() {
    return 50;
}
//下拉刷新icon 的大小
CG_INLINE CGFloat ICONSIZE() {
    return 24;
}
//旋转一圈所用时间
CG_INLINE CGFloat CircleTime() {
    return 0.8;
}
//icon刷新完返回最顶端的时间
CG_INLINE CGFloat IconBackTime() {
    return 0.25;
}
typedef NS_ENUM(NSInteger,StatusOfRefresh) {
    Refresh_Default = 1,     //非刷新状态，该值不能为0
    Refresh_BeginRefresh,    //刷新状态
    Refresh_None             //全非状态（即不是刷新 也不是 非刷新状态）
};

@interface GesturesTableView()
// 监测范围的临界点,>0代表向上滑动多少距离,<0则是向下滑动多少距离
@property (nonatomic, assign)CGFloat threshold;

// 记录scrollView.contentInset.top
@property (nonatomic, assign)CGFloat marginTop;

//记录刷新状态
@property (nonatomic, assign)StatusOfRefresh refreshStatus;

//用于刷新回调
@property (nonatomic, copy)void(^refreshBlock)(void);

//刷新动画
@property (nonatomic, strong) CABasicAnimation *animation;

//偏移量累加
@property (nonatomic, assign) CGFloat offsetCollect;

//刷新view
@property (nonatomic, strong) RefreshView *refreshView;

@property (nonatomic, assign) CGPoint oldoOffset;


@end

@implementation GesturesTableView

//是否让手势透传到子视图
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    CGFloat headerHeight = self.categoryViewHeight ?: (nScreenHeight() - kStatusBarAndNavigationBarHeight);
    CGPoint currentPoint = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(CGRectMake(0, self.contentSize.height - headerHeight, nScreenWidth(), headerHeight), currentPoint)) {
        return YES;
    }
    return NO;
}


/**icon下拉范围**/
- (CGFloat)threshold {
    return -MARGINTOP();
}

/**offsetcollection**/
- (CGFloat)offsetCollect {
    return 7;
}

- (void)addRefreshViewForView:(UIView *)view atPoint:(CGPoint)position downRefresh:(void(^)(void))block {
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    self.refreshBlock = block;
    
    if (!self.refreshView) {
        CGRect positionFrame;
        
        if (position.x || position.y) {
            positionFrame = CGRectMake(position.x, self.frame.origin.y + position.y, ICONSIZE(), ICONSIZE());
        } else {
            positionFrame = CGRectMake(16, self.frame.origin.y + kStatusBarAndNavigationBarHeight - ICONSIZE(), ICONSIZE(), ICONSIZE());
        }
        self.refreshView = [[RefreshView alloc] initWithFrame:positionFrame];
    }
    
    [view addSubview:self.refreshView];
}

-(void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
    
    if (!self.refreshBlock) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    //屏蔽掉全非状态时的操作
    if (self.refreshStatus ==  Refresh_None) {
        return;
    }
    
    //屏蔽掉开始进入界面时的系统下拉动作
    if (self.refreshStatus == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.refreshStatus =  Refresh_Default;
        });
        return;
    }
    
    // 实时监测scrollView.contentInset.top， 系统优化以及手动设置contentInset都会影响contentInset.top。
    if (self.marginTop != self.contentInset.top) {
        self.marginTop = self.contentInset.top;
    }
    
    CGFloat offsetY = self.contentOffset.y;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.oldoOffset = contentOffset;
    });
    
    /**异步调用主线程**/
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            /**非刷新状态**/
            if (strongSelf.refreshStatus ==  Refresh_Default) {
                [strongSelf defaultHandleWithOffSet:offsetY];
                
                /**刷新状态**/
            } else if (strongSelf.refreshStatus ==  Refresh_BeginRefresh) {
                [strongSelf refreshingHandleWithOffSet:offsetY];
            }
        });
    });
}

/**
 非刷新状态时的处理
 
 @param offsetY tableview滚动偏移量
 */
- (void)defaultHandleWithOffSet:(CGFloat)offsetY {
    // 向下滑动时<0，向上滑动时>0；
    CGFloat defaultoffsetY = offsetY + self.marginTop;
    
    /**刷新动作区间**/
    if (defaultoffsetY > self.threshold && defaultoffsetY < 0) {
        [self.refreshView setContentOffset:CGPointMake(0, defaultoffsetY)];
        
        /*
         注意：将default动作处理只放到 动作区间 和 超过/等于 临界点 的逻辑块里
         目的：实现只有在下拉动作时才会有动作处理，否则没有
         
         */
        [self anmiationHandelwithStatus: Refresh_Default
                          needAnimation:YES];
    }
    
    /**(@"刷新临界点，把刷新icon置为最大区间")**/
    if (defaultoffsetY <= self.threshold && self.refreshView.contentOffset.y != self.threshold) {
        [self.refreshView setContentOffset:CGPointMake(0, self.threshold)];
    }
    
    /**超过/等于 临界点后松手开始刷新，不松手则不刷新**/
    if (defaultoffsetY <= self.threshold && self.refreshView.contentOffset.y == self.threshold) {
        if (self.isDragging) {
            //NSLog(@"不刷新");
            //default动作处理
            [self anmiationHandelwithStatus: Refresh_Default
                              needAnimation:YES];
            
        } else {
            //NSLog(@"开始刷新");
            //刷新状态动作处理
            [self anmiationHandelwithStatus: Refresh_BeginRefresh
                              needAnimation:YES];
            // 由非刷新状态 进入 刷新状态
            [self beginRefresh];
        }
    }
    
    /**当tableview回滚到顶端的时候把刷新的iconPosition置零**/
    if (defaultoffsetY >= 0 && self.refreshView.contentOffset.y != 0) {
        [self.refreshView setContentOffset:CGPointMake(0, 0)];
        //当回到原始位置后，转角也回到原始位置
        [self trangleToBeOriginal];
    }
}

/**
 刷新状态时的处理
 
 @param offsetY tableview滚动偏移量
 */
- (void)refreshingHandleWithOffSet:(CGFloat)offsetY {
    //转换坐标（相对费刷新状态）
    CGFloat refreshoffsetY = offsetY + self.marginTop + self.threshold;
    /**刷新状态时动作区间**/
    if (refreshoffsetY > self.threshold && refreshoffsetY < 0) {
        [self.refreshView setContentOffset:CGPointMake(0, refreshoffsetY)];
    }
    
    /**刷新状态临界点，把刷新icon置为最大区间**/
    if (refreshoffsetY <= self.threshold && self.refreshView.contentOffset.y != self.threshold) {
        [self.refreshView setContentOffset:CGPointMake(0, self.threshold)];
    }
    
    /**当tableview相对坐标回滚到顶端的时候把刷新的iconPosition置零**/
    if (refreshoffsetY >= 0 && self.refreshView.contentOffset.y != 0) {
        [self.refreshView setContentOffset:CGPointMake(0, 0)];
    }
}

- (void)beginRefresh {
    self.refreshView.hidden = NO;
    self.refreshView.refreshIcon.alpha = 1;
    [self.refreshView setContentOffset:CGPointMake(0, self.threshold)];
    [self anmiationHandelwithStatus: Refresh_BeginRefresh
                      needAnimation:YES];
    [self beginRefreshView];
}

/**
 开始刷新
 */
- (void)beginRefreshView {
    //状态取反 保证一次刷新只执行一次回调
    if (self.refreshStatus !=  Refresh_BeginRefresh) {
        self.refreshStatus =  Refresh_BeginRefresh;
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    }
}


/**
 动作处理
 
 */
- (void)anmiationHandelwithStatus:(StatusOfRefresh)status needAnimation:(BOOL)need {
    if (!need) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    if (self.refreshView.refreshIcon.isHidden) {
        self.refreshView.refreshIcon.hidden = NO;
        [UIView animateWithDuration:0.05 animations:^{
            weakSelf.refreshView.refreshIcon.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    /**
     非刷新状态下的动作处理
     */
    if (status ==  Refresh_Default) {
        /**把nsPoint结构体转换为cgPoint**/
        CGPoint oldPoint = self.oldoOffset;
        CGPoint newPoint = self.contentOffset;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (oldPoint.y < newPoint.y) {
                weakSelf.refreshView.refreshIcon.transform = CGAffineTransformRotate(weakSelf.refreshView.refreshIcon.transform,-weakSelf.offsetCollect/50);
                
//                NSLog(@"向上拉动");
            } else if (oldPoint.y > newPoint.y) {
                weakSelf.refreshView.refreshIcon.transform = CGAffineTransformRotate(weakSelf.refreshView.refreshIcon.transform,weakSelf.offsetCollect/50);
                
//                NSLog(@"向下拉动");
                
            } else {
                //NSLog(@"没有拉动");
            }
        });
        
        /**
         刷新状态下的动作处理
         */
    } else if (status ==  Refresh_BeginRefresh) {
        if (!self.animation) {
            self.animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //逆时针效果
            weakSelf.animation.fromValue = [NSNumber numberWithFloat:0.f];
            weakSelf.animation.toValue =  [NSNumber numberWithFloat: -M_PI *2];
            weakSelf.animation.duration  = CircleTime();
            weakSelf.animation.autoreverses = NO;
            weakSelf.animation.removedOnCompletion = NO;
            weakSelf.animation.fillMode =kCAFillModeForwards;
            weakSelf.animation.repeatCount = MAXFLOAT; //一直自旋转
            [weakSelf.refreshView.refreshIcon.layer addAnimation:weakSelf.animation forKey:@"refreshing"];
        });
    }
}

/**
 角度还原:用于非刷新时回到顶部 和 刷新状态endRefresh 中
 */
- (void)trangleToBeOriginal {
    self.refreshView.refreshIcon.transform = CGAffineTransformIdentity;
    self.refreshView.refreshIcon.hidden = YES;
}

/**
 结束刷新 对外接口
 */
- (void)endRefresh {
    if (!self) {
        return;
    }
    //延迟刷新0.3秒，避免立即返回tableview时offset不稳定造成反弹等不理想的效果
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf endRefreshView];
    });
}

/**
 结束刷新执行函数
 */
- (void)endRefreshView {
    /**
     仿微信当下拉一直拖住时，icon不会返回
     虽然在repeat的计时器里，但是该方法只会回调一次
     原理：nstimer默认是放在defaultrunloop中的，当下拉拖住时runloop改成了tracking模式，同一时间下线程只能处理一种runloop模式，所以滚动时timer只注册不执行，当松开手时拖拽动作执行完毕，runloop回到default模式下，这个时候nstimer被执，block开始回调，在第一次回调后又调用了invalidate方法将计时器释放了
     注意** 最后用invalidate把计时器释放掉
     */
    __weak typeof(self) weakSelf = self;
    if (self.isDragging) {
        //iOS10 以上
        if (@available(iOS 10, *)) {
            [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [weakSelf endRefresh];
                [timer invalidate];
            }];
            //iOS10 以下
        } else {
            [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timerCall:) userInfo:nil repeats:YES];
        }
        
        return;
    }
    
    //当结束刷新时，把状态置为全非状态，避免在[UIView animateWithDuration:0.2]icon返回动作中的人为干预，造成icon闪顿现象
    if (self.refreshStatus !=  Refresh_None) {
        self.refreshStatus =  Refresh_None;
        
        [UIView animateWithDuration:IconBackTime() animations:^{
            [weakSelf.refreshView setContentOffset:CGPointMake(0, 0)];
            weakSelf.refreshView.refreshIcon.alpha = 0;
        } completion:^(BOOL finished) {
            //结束动画
            [weakSelf.refreshView.refreshIcon.layer removeAnimationForKey:@"refreshing"];
            
            //当回到原始位置后，转角也回到原始位置
            [weakSelf trangleToBeOriginal];
            
            //结束后将状态重置为非刷新状态 以备下次刷新
            weakSelf.refreshStatus =  Refresh_Default;
        }];
    }
}

/**
 计时器调用方法
 
 @param timer nstimer
 */
- (void)timerCall:(NSTimer *)timer {
    [self endRefresh];
    [timer invalidate];
}

@end
