//
//  NavView.m
//
//  Created by mac on 2019/4/3.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "NavView.h"

@interface NavView()
@property (nonatomic, weak) UILabel  *titleLb;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *moreBtn;
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
    
    //设置标题
    UILabel *titleLb = [[UILabel alloc] init];
    [titleLb sizeToFit];
    titleLb.font = FONTSIZE(18);
    // 开始的时候看不见，所以alpha值为0
    titleLb.textColor = self.titleColor?:RGBACOLOR(34, 34, 34, 0);
    [self addSubview:titleLb];
    self.titleLb = titleLb;
}

#pragma --mark action
- (void)leftBtnAction {
    !self.leftAction ?: self.leftAction();
}

- (void)rightBtnAction {
    !self.rightAction ?: self.rightAction();
}

- (void)moreBtnAction {
    !self.moreAction ?: self.moreAction();
}

#pragma --mark set
- (void)setLeftIcon:(NSString *)leftIcon {
    _leftIcon = leftIcon;
    [self.leftBtn setImage:[UIImage imageNamed:leftIcon] forState:UIControlStateNormal];
    [self.leftBtn setImage:[UIImage imageNamed:leftIcon] forState:UIControlStateHighlighted];
}
-(void)setMoreIcon:(NSString *)moreIcon {
    _moreIcon = moreIcon;
    [self.moreBtn setImage:[UIImage imageNamed:moreIcon] forState:UIControlStateNormal];
    [self.moreBtn setImage:[UIImage imageNamed:moreIcon] forState:UIControlStateHighlighted];
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
    
    
    CGFloat difference = 112;
    if (_moreBtn) {
        difference += 40;
    }
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.inset(10);
        make.height.mas_equalTo(24);
        make.width.mas_lessThanOrEqualTo(nScreenWidth()-difference);
    }];
    
}

-(UIButton *)moreBtn {
    if (_moreBtn == nil) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.inset(56);
            make.bottom.inset(10);
        }];
    }
    return _moreBtn;
}
-(UIButton *)leftBtn {
    if (_leftBtn == nil) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBtn];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.bottom.inset(10);
        }];
    }
    return _leftBtn;
    
}
-(UIButton *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.inset(16);
            make.bottom.inset(10);
        }];
    }
    return _rightBtn;
}

@end
