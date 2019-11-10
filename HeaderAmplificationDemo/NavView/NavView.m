//
//  NavView.m
//  CQ_App
//
//  Created by mac on 2019/4/3.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "NavView.h"

@interface NavView()
@property (nonatomic, weak) UILabel  *titleLb;
@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation NavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    self.leftBtn = leftBtn;
    
    //设置标题
    UILabel *titleLb = [[UILabel alloc] init];
    [titleLb sizeToFit];
    titleLb.font = FONTSIZE(18);
    // 开始的时候看不见，所以alpha值为0
    titleLb.textColor = self.titleColor?:RGBACOLOR(34, 34, 34, 0);
    [self addSubview:titleLb];
    self.titleLb = titleLb;
}
/**
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        return nil;
    }
    return hitView;
}*/

#pragma --mark action
- (void)leftBtnAction:(UIButton *)btn {
    if (self.leftAction) {
        self.leftAction();
    }
}

- (void)rightBtnAction:(UIButton *)btn {
    if (self.rightAction) {
        self.rightAction();
    }
}

#pragma --mark set
- (void)setLeftIcon:(NSString *)leftIcon {
    _leftIcon = leftIcon;
    [self.leftBtn setImage:[UIImage imageNamed:leftIcon] forState:UIControlStateNormal];
    [self.leftBtn setImage:[UIImage imageNamed:leftIcon] forState:UIControlStateHighlighted];
}

- (void)setRightIcon:(NSString *)rightIcon {
    _rightIcon = rightIcon;
    [self.rightBtn setImage:[UIImage imageNamed:rightIcon] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:rightIcon] forState:UIControlStateHighlighted];
}
- (void)setRightTitle:(NSString *)rightTitle{
    _rightTitle = rightTitle;
    [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = FONTSIZE(14);
    [self.rightBtn setTitleColor:MAINCOLOR() forState:UIControlStateNormal];
}
- (void)setLeftTitle:(NSString *)leftTitle{
    _leftTitle = leftTitle;
    [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = FONTSIZE(14);
    [self.leftBtn setTitleColor:MAINCOLOR() forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLb.textColor = titleColor;
}
-(void)setTitle:(NSString *)title {
    _title = title;
    self.titleLb.text = title;
    
}

- (void)setBackgroundAlpha:(CGFloat)alpha {
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:alpha];
    self.titleLb.alpha = alpha;
}
- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat wh = [UIImage imageNamed:self.leftIcon].size.height;
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(wh);
        make.left.mas_equalTo(16);
        make.bottom.inset(10);
    }];

    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.bottom.inset(10);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_lessThanOrEqualTo(nScreenWidth()-112);
    }];
    
}

-(UIButton *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
    }
    return _rightBtn;
}

@end
