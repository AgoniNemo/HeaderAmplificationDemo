//
//  NemoScrollerView.m
//
//  Created by Nemo on 16/2/17.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "NemoScrollerView.h"
#import "XZCScrollView.h"

#define SLIDINGWIDTH 230

@interface NemoScrollerView ()<UIScrollViewDelegate>
{
    CGFloat _y;
}
@property (nonatomic ,assign) BOOL isClick;
@property (nonatomic,weak) XZCScrollView *scrollview;

@end

@implementation NemoScrollerView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];
        
        self.backgroundColor = COLORFFFFFF();
        
    }
    return self;
}
-(void)createView{
    
    XZCScrollerButton *scroller = [[XZCScrollerButton alloc] initWithFrame:CGRectMake(0, 0, nScreenWidth(),44)];
    scroller.totalWidth = SLIDINGWIDTH;
    
    scroller.backgroundHeightLightColor = COLORFFFFFF();
    scroller.titlesHeightLightColor = [UIColor redColor];
    scroller.titlesCustomeColor = GRAYCOLOR();
    _scroller = scroller;
    
    __weak typeof(self) ws = self;
    [_scroller setButtonClickBlock:^(NSInteger tag) {
        ws.isClick = YES;
        ws.selectPage = tag;
        [ws.scrollview setContentOffset:CGPointMake(tag*nScreenWidth(), 0) animated:YES];
        if (ws.srollerAction) {
            ws.srollerAction(tag);
        }
    }];
    [self addSubview:scroller];
    
    
    _y = CGRectGetHeight(scroller.frame);
    XZCScrollView *scrollview = [[XZCScrollView alloc] init];
    scrollview.pagingEnabled = YES;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.delegate = self;
    scrollview.bounces = NO;
    [self addSubview:scrollview];
    self.scrollview = scrollview;
}


#pragma --mark FiltrateFunction

#pragma --mark setFunction

-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    _scroller.lineColor = lineColor;
}

-(void)setTextFont:(CGFloat)textFont
{
    _textFont = textFont;
    _scroller.titlesFont = FONTSIZE(textFont);
}
- (void)setFont:(UIFont *)font {
    _font = font;
    _scroller.titlesFont = font;
}
- (void)setHeightFont:(UIFont *)heightFont {
    _heightFont = heightFont;
    _scroller.titlesHeightFont = heightFont;
}

-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _scroller.titlesHeightLightColor = textColor;
}
-(void)setViewController:(UIViewController *)viewController{
    _viewController = viewController;
    _scrollview.frame = CGRectMake(0, _y, nScreenWidth(), self.height-_y);
    _scrollview.viewController = viewController;
}

-(void)setSelectPage:(NSInteger)selectPage{
    _selectPage = selectPage;
    CGFloat x = nScreenWidth()*selectPage;
    self.isClick = YES;
    [_scrollview setContentOffset:CGPointMake(x, 0) animated:NO];
//    [_scroller setButtonPositionWithNumber:_scrollview.contentOffset.x];
    [_scroller animationSelectPage:selectPage];

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"%s%@",__func__,NSStringFromCGPoint(scrollView.contentOffset));
    
    NSInteger i = scrollView.contentOffset.x/nScreenWidth();
    self.selectPage = i;
    if (self.srollerAction) {
        self.srollerAction(i);
    }
}
- (void)setTopViewColor:(UIColor *)topViewColor
{
    _topViewColor = topViewColor;
    _scroller.backgroundHeightLightColor = topViewColor;
    _scroller.backgroundColor = topViewColor;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    NSLog(@"%s",__func__);
    self.isClick = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"%s%@",__func__,NSStringFromCGPoint(scrollView.contentOffset));
    if (self.isClick) return;
    [_scroller setButtonPositionWithNumber:scrollView.contentOffset.x];
}

-(void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
    _scrollview.viewControllers = viewControllers;
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _scroller.titles = self.titles;
    _scrollview.contentSize = CGSizeMake(self.titles.count*nScreenWidth(), _y);
    
}
-(void)dealloc{
    
    NSLog(@"%s",__func__);
}
@end
