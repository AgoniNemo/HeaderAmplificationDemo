//
//  HeaderView.m
//  HeaderAmplificationDemo
//
//  Created by mac on 2019/11/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView()
@property (nonatomic, weak) UIView *ctView;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *introductionLb;
@property (nonatomic, weak) UILabel *nameLb;
@property (nonatomic, weak) UILabel *numberLb;

@end

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup {
    
    self.backgroundColor = COLOREDEDED();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -30, nScreenWidth(), self.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"de0df3bf59f5487cb5864e62ab1651aa"];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    
    UIView *ctView = [[UIView alloc] init];
    ctView.backgroundColor = COLORFFFFFF();
    [self addSubview:ctView];
    self.ctView = ctView;
    [ctView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.mas_equalTo(24);
        make.height.mas_equalTo(100);
    }];
    [ctView.layer setMasksToBounds:YES];
    [ctView.layer setCornerRadius:20];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"x1bjmo1dmho"];
    [ctView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.inset(16);
        make.size.mas_equalTo(60);
    }];
    [iconView.layer setMasksToBounds:YES];
    [iconView.layer setCornerRadius:8];
    
    UILabel *nameLb = [[UILabel alloc] init];
    nameLb.text = @"超强的爆米花";
    nameLb.font = FONTSIZE(18);
    nameLb.textColor = MAINCOLOR();
    [ctView addSubview:nameLb];
    self.nameLb = nameLb;
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView);
        make.left.equalTo(iconView.mas_right).offset(6);
        make.right.equalTo(ctView).inset(94);
    }];
    
    UILabel *introductionLb = [[UILabel alloc] init];
    introductionLb.text = @"个人介绍";
    introductionLb.numberOfLines = 2;
    introductionLb.font = FONTSIZE(14);
    introductionLb.textColor = COLOR888888();
    [ctView addSubview:introductionLb];
    self.introductionLb = introductionLb;
    [introductionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLb.mas_bottom).offset(2);
        make.left.equalTo(nameLb);
        make.width.mas_equalTo(180);
    }];
    
    [self createLb];
}


- (void)createLb {
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOREDEDED();
    [self.ctView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(21);
        make.size.mas_equalTo(CGSizeMake(.8, 50));
        make.right.inset(81);
    }];
    
    UILabel *numberLb = [[UILabel alloc] init];
    numberLb.textColor = MAINCOLOR();
    numberLb.font = FONTBOLDSIZE(20);
    numberLb.text = @"2";
    [self.ctView addSubview:numberLb];
    self.numberLb = numberLb;
    [numberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line);
        make.left.equalTo(line.mas_right).offset(16);
        make.right.equalTo(self.ctView).inset(16);
    }];
    
    UILabel *lb = [[UILabel alloc] init];
    lb.text = @"好友";
    lb.textColor = COLOR888888();
    lb.font = FONTSIZE(14);
    [self.ctView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numberLb.mas_bottom);
        make.left.equalTo(numberLb);
    }];
    
    UIView *touchView = [[UIView alloc] init];
    [self.ctView addSubview:touchView];
    [touchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numberLb);
        make.left.equalTo(numberLb);
        make.bottom.equalTo(lb);
        make.right.equalTo(self.ctView);
    }];
}

- (void)overScrollAction:(CGFloat) offsetY {
    CGFloat scaleRatio = fabs(offsetY)/370.0f;
    CGFloat overScaleHeight = (370.0f * scaleRatio)/2;
    self.imageView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(scaleRatio + 1.0f, scaleRatio + 1.0f), CGAffineTransformMakeTranslation(0, -overScaleHeight));
}

@end
