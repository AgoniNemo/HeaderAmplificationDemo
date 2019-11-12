//
//  NavView.h
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
@property (nonatomic, strong) NSString *moreIcon;

@property (nonatomic, copy) void(^leftAction)(void);
@property (nonatomic, copy) void(^rightAction)(void);
@property (nonatomic, copy) void(^moreAction)(void);

- (void)setBackgroundAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
