//
//  XZCScrollerButton.m
//
//  Created by Nemo on 16/1/9.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "XZCScrollerButton.h"
#import "NSString+Size.h"

#define DEFAULT_TITLES_FONT 16.0f
#define DEFAULT_DURATION .4f
#define NUMBER 4


@interface XZCScrollerButton ()<UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger selectIdx;
@property (nonatomic, assign) CGFloat viewWidth;                    //单个组件的宽度
@property (nonatomic, assign) CGFloat viewHeight;                   //单个组件的高度
@property (nonatomic, strong) NSMutableArray *viewRects;            //所有的Lable rect
/// 旧标题数组
@property (nonatomic, strong) NSArray *oldTitle;

@property (nonatomic, strong) UIView *heightLightView;
@property (nonatomic, strong) UIView *heightTopView;
@property (nonatomic, strong) UIView *heightColoreView;
@property (nonatomic, strong) UIView *bottomLine;
/// 底部的label
@property (nonatomic, strong) NSMutableArray *bottomLabelArray;
/// 顶部的label
@property (nonatomic, strong) NSMutableArray *topLabelArray;
/// 顶部的button
@property (nonatomic, strong) NSMutableArray *topBtnArray;

@property (nonatomic, copy) ButtonOnClickBlock buttonBlock;
@property (nonatomic, copy) ButtonClickBlock buttonClick;
@property (nonatomic, strong) UIScrollView *bottom;
@end

@implementation XZCScrollerButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewWidth = frame.size.width;
        _viewHeight = frame.size.height;
        _duration = DEFAULT_DURATION;
        self.selectIdx = 0;
        self.isShowLine = YES;
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (_bottomLine != nil) { return; }
    [self createBottomLabels];
    [self createTopLables];
    [self createTopButtons];
}
- (void)setButtonPositionWithScrollView:(UIScrollView *)scrollView {
    
    self.isScroller = YES;
    CGFloat selectPage = scrollView.contentOffset.x/nScreenWidth();
    if (selectPage > self.titles.count - 1 || selectPage < 0) {
        return;
    }
    
    CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
    
    NSInteger idx = floor(selectPage);
    CGFloat position = selectPage - idx;
    
    CGFloat distance = 0;
    CGFloat x = 0;
    CGFloat lableW = 0;
    
    if (translatedPoint.x < 0) {
        NSValue *curValue = _viewRects[idx];
        distance = curValue.CGRectValue.size.width+16;
        x = curValue.CGRectValue.origin.x + position*distance;
        lableW = curValue.CGRectValue.size.width;
        //NSLog(@"右滑 ===== %f  %f",position,distance);
    }


    if (translatedPoint.x > 0) {
        NSValue *nxtValue = _viewRects[idx];
        idx = (NSInteger)ceil(selectPage);
        NSValue *curValue = _viewRects[idx];
        distance = nxtValue.CGRectValue.size.width+16;
        CGFloat k = 0;
        if (position != 0) {
            k = (1-position)*distance;
        }
        x = curValue.CGRectValue.origin.x - k;
        lableW = curValue.CGRectValue.size.width;
        if (nxtValue.CGRectValue.size.width < curValue.CGRectValue.size.width) {
            CGFloat disW = fabs(nxtValue.CGRectValue.size.width-curValue.CGRectValue.size.width);
            lableW -= disW;
        }
        //NSLog(@"左滑 ===== %f  %f",position,distance);
    }
    if (self.isShowLine) {
        self.bottomLine.left = x;
    }
    self.heightLightView.frame = CGRectMake(x, 0, lableW+16, _viewHeight-2);
    self.heightTopView.left = -x;
    
    self.selectIdx = idx;
}

-(void)setButtonOnClickBlock: (ButtonOnClickBlock) block {
    if (block) {
        _buttonBlock = block;
    }
}

-(void)setButtonClickBlock:(ButtonClickBlock)block{
    if (block) {
        _buttonClick = block;
    }
}

-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    
    if ([_oldTitle isEqualToArray:titles]) {
        return;
    }
    _totalWidth = 0;
    _viewRects = [[NSMutableArray alloc] init];
    CGRect oldRect = CGRectZero;
    for (int i = 0 ; i < titles.count; i ++) {
        NSString *title = titles[i];
        CGFloat width = [title widthForMaxHeight:19 font:FONTBOLDSIZE(16)];
        CGRect rect = CGRectMake(oldRect.origin.x + oldRect.size.width+16, 0, width, _viewHeight-2);
        [_viewRects addObject:[NSValue valueWithCGRect:rect]];
        oldRect = rect;
        _totalWidth += width;
    }
    _totalWidth += (titles.count)*16;

    if (_oldTitle) {
        [self updateTitle];
    }
    
    _oldTitle = [titles mutableCopy];
}


- (void)updateTitle {
    self.bottom.width = _totalWidth;
    NSValue *value = _viewRects[self.selectIdx];
    CGFloat lableW = value.CGRectValue.size.width;
    CGFloat x = value.CGRectValue.origin.x;
    _heightTopView.width = _totalWidth;
    _heightTopView.left = -x;

    _heightLightView.width = lableW;
    _heightLightView.left = x;

    _heightColoreView.width = lableW;

    for (int i = 0; i < _titles.count; i ++) {
        UILabel *btmLb = _bottomLabelArray[i];
        CGRect currentLabelFrame = [self countCurrentRectWithIndex:i];
        btmLb.frame = currentLabelFrame;
        NSString *title = _titles[i];
        btmLb.text = title;
        
        UILabel *topLb = _topLabelArray[i];
        topLb.frame = currentLabelFrame;
        topLb.text = title;
        
        UIButton *btn = _topBtnArray[i];
        btn.frame = currentLabelFrame;
    }
    
}


/**
 *  计算当前高亮的Frame
 *
 *  @param index 当前点击按钮的Index
 *
 *  @return 返回当前点击按钮的Frame
 */
- (CGRect)countCurrentRectWithIndex:(NSInteger)index {
    NSValue *value = _viewRects[index];
    return  CGRectMake(value.CGRectValue.origin.x, 0, value.CGRectValue.size.width, _viewHeight-2);
}

/**
 *  根据索引创建Label
 *
 *  @param index     创建的第几个Index
 *  @param textColor Label字体颜色
 *
 *  @return 返回创建好的label
 */
- (UILabel *)createLabelWithTitlesIndex:(NSInteger)index
                               textFont:(UIFont *)textFont
                              textColor:(UIColor *)textColor {
    CGRect currentLabelFrame = [self countCurrentRectWithIndex:index];
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:currentLabelFrame];
    tempLabel.textColor = textColor;
    tempLabel.text = _titles[index];
    tempLabel.font = textFont;
    tempLabel.minimumScaleFactor = 0.1f;
    tempLabel.textAlignment = NSTextAlignmentCenter;
    return tempLabel;
}

/**
 *  创建最底层的Label
 */
- (void)createBottomLabels {
    _bottomLabelArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _titles.count; i ++) {
        UILabel *tempLabel = [self createLabelWithTitlesIndex:i textFont:_titlesFont?:FONTSIZE(16) textColor:_titlesCustomeColor];
        [self.bottom addSubview:tempLabel];
        [_bottomLabelArray addObject:tempLabel];
    }
}

/**
 *  创建上一层高亮使用的Label
 */
- (void)createTopLables {
    NSValue *value = _viewRects[0];
    CGFloat labelW = value.CGRectValue.size.width;
    
    //label层上的view
    CGRect heightLightViewFrame = CGRectMake(0, 0, labelW+16, _viewHeight-2);
    _heightLightView = [[UIView alloc] initWithFrame:heightLightViewFrame];
    _heightLightView.clipsToBounds = YES;
    
    //动画元素
    _heightColoreView = [[UIView alloc] initWithFrame:heightLightViewFrame];
    _heightColoreView.backgroundColor = _backgroundHeightLightColor;
    if (_radiusBtn > 0) {
        _heightColoreView.layer.cornerRadius = _radiusBtn;
    }
    [_heightLightView addSubview:_heightColoreView];
    
    _heightTopView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, _totalWidth, _viewHeight)];
    
    _topLabelArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _titles.count; i ++) {
        UILabel *label = [self createLabelWithTitlesIndex:i textFont:_titlesHeightFont?:FONTSIZE(16) textColor:_titlesHeightLightColor];
        [_heightTopView addSubview:label];
        [_topLabelArray addObject:label];
    }
    [_heightLightView addSubview:_heightTopView];
    
    [self.bottom addSubview:_heightLightView];
}
/**
 *  创建按钮
 */
- (void)createTopButtons {
    _topBtnArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _titles.count; i ++) {
        CGRect tempFrame = [self countCurrentRectWithIndex:i];
        UIButton *tempButton = [[UIButton alloc] initWithFrame:tempFrame];
        tempButton.tag = i;
        [tempButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottom addSubview:tempButton];
        [_topBtnArray addObject:tempButton];
    }
    if (self.isShowLine) {
        NSValue *value = _viewRects[0];
        CGFloat labelW = value.CGRectValue.size.width;
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(16, _viewHeight-3, _lineWidth?:labelW, 2)];
        _bottomLine.backgroundColor = MAINCOLOR();
        [_bottomLine.layer setMasksToBounds:YES];
        [_bottomLine.layer setCornerRadius:1];
        [self.bottom addSubview:_bottomLine];
    }
}

/**
 *  点击按钮事件
 *
 *  @param sender 点击的相应的按钮
 */
- (void)tapButton:(UIButton *) sender {
    self.selectIdx = sender.tag;
    if (_buttonBlock && sender.tag < _titles.count) {
        _buttonBlock(sender.tag, _titles[sender.tag]);
    }
    
    if (_buttonClick && sender.tag < _titles.count) {
        _isScroller = YES;
        _buttonClick(sender.tag);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isScroller = NO;
        });
    }
    
    [self animationSelectPage:sender.tag];
}

- (void)animationSelectPage:(NSInteger)page {
    
    NSValue *value = _viewRects[page];
    CGFloat lableW = value.CGRectValue.size.width;
    CGFloat x = value.CGRectValue.origin.x;

    __weak typeof(self) weak_self = self;
    [UIView animateWithDuration:_duration animations:^{
        weak_self.heightLightView.frame = CGRectMake(x, 0, lableW, weak_self.viewHeight-2);
        weak_self.heightTopView.left = -x;
        if (weak_self.isShowLine) {
            weak_self.bottomLine.left = x;
        }
    } completion:^(BOOL finished) {}];
    
}
-(void)dealloc
{
    NSLog(@"%s",__func__);
}
-(UIScrollView *)bottom
{
    if (_bottom == nil) {
        _bottom = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 1, _totalWidth, self.frame.size.height-1)];
        _bottom.showsHorizontalScrollIndicator = NO;
        _bottom.delegate = self;
        [self addSubview:_bottom];
    }
    return _bottom;
}


@end
