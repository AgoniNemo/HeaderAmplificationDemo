//
//  UIView+Refresh.h
//  HeaderAmplificationDemo
//
//  Created by mac on 2019/11/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Refresh)


/**
 下拉刷新
 
 @param scrollView 需要添加刷新的tableview
 @param position icon位置（默认：{10，34}navBar左上角）
 @param block 刷新回调
 */
- (void)refreshWithObject:(UIScrollView *)scrollView atPoint:(CGPoint)position downRefresh:(void(^)(void))block;

/**
 结束刷新动作
 */
- (void)endRefresh;

/**
 开始刷新
 */
- (void)beginRefresh;

/**
 释放观察者，用于手动释放，否则将会在界面退出时自动释放
 */
- (void)freeReFresh;

@end

NS_ASSUME_NONNULL_END
