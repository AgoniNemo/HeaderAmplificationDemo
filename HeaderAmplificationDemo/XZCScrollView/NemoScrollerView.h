//
//  NemoScrollerView.h
//
//  Created by Nemo on 16/2/17.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZCScrollerButton.h"

typedef void (^SrollerClick)(NSInteger tag);

@interface NemoScrollerView : UIView

@property (nonatomic,weak) XZCScrollerButton *scroller;

@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,weak) UIViewController *viewController;
@property (nonatomic,strong) NSArray *viewControllers;

@property (nonatomic,assign) CGFloat lineHeight;

@property (nonatomic,strong) UIColor *lineColor;

@property (nonatomic,strong) UIColor *topViewColor;

@property (nonatomic,assign) CGFloat textFont;

@property (nonatomic,strong) UIFont *font;
@property (nonatomic,strong) UIFont *heightFont;

@property (nonatomic,strong) UIColor *textColor;

@property (nonatomic,assign) NSInteger selectPage;

@property (nonatomic,copy) SrollerClick srollerAction;

@end
