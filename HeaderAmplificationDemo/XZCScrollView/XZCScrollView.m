//
//  XZCScrollView.m
//
//  Created by Nemo on 16/2/19.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "XZCScrollView.h"


@implementation XZCScrollView

-(void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
    for (int i = 0; i < viewControllers.count; i ++) {
        UIViewController *vc = viewControllers[i];
        vc.view.frame = CGRectMake(i*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
        NSAssert(self.viewController != nil, @"没有设置代理控制器！");
        [_viewController addChildViewController:vc];
        [self addSubview:vc.view];
    }
}

-(void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
