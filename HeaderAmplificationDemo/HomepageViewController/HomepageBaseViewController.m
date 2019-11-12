//
//  HomepageBaseViewController.m
//
//  Created by Nemo on 2019/9/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import "HomepageBaseViewController.h"

@interface HomepageBaseViewController ()

@end

@implementation HomepageBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    self.tableView.showsVerticalScrollIndicator = scrollEnabled;
    if (!scrollEnabled) {
        self.tableView.contentOffset = CGPointZero;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollEnabled) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY <= 0) {
            self.scrollEnabled = NO;
            !self.scrollerLeaveTopAction ?: self.scrollerLeaveTopAction();
        }
    }else{
        self.scrollEnabled = NO;
    }
}
@end
