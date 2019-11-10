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
{
    NSInteger _count;
    NSInteger _tag;
}
@property (nonatomic, assign) CGFloat viewWidth;                    //单个组件的宽度
@property (nonatomic, assign) CGFloat viewHeight;                   //单个组件的高度
@property (nonatomic, strong) NSMutableArray *viewRects;            //所有的Lable rect

@property (nonatomic, strong) UIView *heightLightView;
@property (nonatomic, strong) UIView *heightTopView;
@property (nonatomic, strong) UIView *heightColoreView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) NSMutableArray * labelMutableArray;
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

-(void)setButtonPositionWithNumber:(CGFloat)position{
    self.isScroller = YES;
    CGFloat selectPage = position/nScreenWidth();
    NSInteger  index = 0;
    if (selectPage > 1) {
        index = selectPage;
    }
    CGFloat offset = (selectPage+1) * 16;

    NSValue *value = _viewRects[index];
    CGFloat lableW = value.CGRectValue.size.width;
    CGFloat x = (lableW + offset)/nScreenWidth()*position;
    
    NSValue *lastValue = nil;
    if (_viewRects.count > 0) {
        lastValue = _viewRects[_viewRects.count-1];
    }
    if (x <= 16) {
        x = 16;
    }else if (x >= lastValue.CGRectValue.origin.x){
        x = lastValue.CGRectValue.origin.x;
//        NSLog(@">=>=>=>=>=");
    }

    self.bottomLine.left = x;
    self.heightLightView.frame = CGRectMake(x, 0, lableW+16, _viewHeight-2);
    self.heightTopView.left = -x;
}

-(void) setButtonOnClickBlock: (ButtonOnClickBlock) block {
    if (block) {
        _buttonBlock = block;
    }
}

-(void) setButtonClickBlock:(ButtonClickBlock)block{
    if (block) {
        _buttonClick = block;
    }
}

-(void)setTitles:(NSArray *)titles{
    _titles = titles;
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
- (void) createBottomLabels {
    for (int i = 0; i < _titles.count; i ++) {
        UILabel *tempLabel = [self createLabelWithTitlesIndex:i textFont:_titlesFont?:FONTSIZE(16) textColor:_titlesCustomeColor];
        [self.bottom addSubview:tempLabel];
        [_labelMutableArray addObject:tempLabel];
    }
}

/**
 *  创建上一层高亮使用的Label
 */
- (void) createTopLables {
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
    
    for (int i = 0; i < _titles.count; i ++) {
        UILabel *label = [self createLabelWithTitlesIndex:i textFont:_titlesHeightFont?:FONTSIZE(16) textColor:_titlesHeightLightColor];
        [_heightTopView addSubview:label];
    }
    [_heightLightView addSubview:_heightTopView];
    
    [self.bottom addSubview:_heightLightView];
}
/**
 *  创建按钮
 */
- (void) createTopButtons {
    for (int i = 0; i < _titles.count; i ++) {
        CGRect tempFrame = [self countCurrentRectWithIndex:i];
        UIButton *tempButton = [[UIButton alloc] initWithFrame:tempFrame];
        tempButton.tag = i;
        [tempButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottom addSubview:tempButton];
    }
    NSValue *value = _viewRects[0];
    CGFloat labelW = value.CGRectValue.size.width;
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(16, _viewHeight-3, _lineWidth?:labelW, 2)];
    _bottomLine.backgroundColor = MAINCOLOR();
    [_bottomLine.layer setMasksToBounds:YES];
    [_bottomLine.layer setCornerRadius:1];
    [self.bottom addSubview:_bottomLine];
    
}

/**
 *  点击按钮事件
 *
 *  @param sender 点击的相应的按钮
 */
- (void)tapButton:(UIButton *) sender {
    
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
    NSInteger  index = 0;
    if (page > 1) {
        index = page;
    }
    CGFloat offset = (page+1) * 16;
    NSValue *value = _viewRects[index];
    CGFloat labelW = value.CGRectValue.size.width;
    CGFloat x = (labelW * page) + offset;
    if (x <= 16) {
        x = 16;
    }
    CGFloat sp = (_viewRects.count -1 == page)?0:16;
    __weak typeof(self) weak_self = self;
    [UIView animateWithDuration:_duration animations:^{
        weak_self.heightLightView.frame = CGRectMake(x, 0, labelW+sp, weak_self.viewHeight-2);
        weak_self.heightTopView.left = -x;
        weak_self.bottomLine.left = x;
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
