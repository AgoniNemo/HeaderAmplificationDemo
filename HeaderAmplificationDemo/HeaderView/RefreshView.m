//
//  RefreshView.m
//
//  Created by Nemo on 2019/9/8.
//  Copyright © 2019 mac. All rights reserved.
//

#import "RefreshView.h"

@implementation RefreshView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.bounces = NO;
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        self.backgroundColor = [UIColor clearColor];
        [self creatMainUI];
    }
    return self;
}

- (void)creatMainUI {
    if (!_refreshIcon) {
        _refreshIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    self.frame.size.width,
                                                                    self.frame.size.height)];
    }
    _refreshIcon.hidden = YES;
    _refreshIcon.image = [[UIImage imageNamed:@"public_loading"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _refreshIcon.contentMode = UIViewContentModeScaleAspectFit;
    _refreshIcon.clipsToBounds = YES;
    _refreshIcon.layer.cornerRadius = self.frame.size.width/2.0;
    [self addSubview:_refreshIcon];
}

@end
