//
//  NavView.h
//  CQ_App
//
//  Created by mac on 2019/4/3.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NavView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *rightIcon;
@property (nonatomic, strong) NSString *leftIcon;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) NSString *rightTitle;
@property (nonatomic, strong) NSString *leftTitle;


@property (nonatomic, copy) void(^leftAction)(void);
@property (nonatomic, copy) void(^rightAction)(void);

- (void)setBackgroundAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
