//
//  HomepageBaseViewController.h
//  xiangwan
//
//  Created by Nemo on 2019/9/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomepageBaseViewController : UITableViewController

@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, copy) void (^scrollerLeaveTopAction)(void);


@end

NS_ASSUME_NONNULL_END
