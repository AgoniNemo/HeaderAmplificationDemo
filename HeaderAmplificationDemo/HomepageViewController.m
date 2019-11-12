//
//  HomepageViewController.m
//  HeaderAmplificationDemo
//
//  Created by mac on 2019/11/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "HomepageViewController.h"
#import "UIViewController+Hidden.h"
#import "NemoScrollerView.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "GesturesTableView.h"
#import "HeaderView.h"
#import "NavView.h"

@interface HomepageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) GesturesTableView *tableView;
@property (nonatomic, assign) BOOL isCannotScroll;
@property (nonatomic, assign) CGFloat fixedH;
@property (nonatomic, weak) HeaderView *headerView;
@property (nonatomic, weak) NavView *navView;
@property (nonatomic, weak) OneViewController *actVC;
@property (nonatomic, weak) TwoViewController *scVC;
@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置代理即可
    self.navigationController.delegate = self;
}
- (void)setup {
    
    CGFloat headerH = nScreenWidth()*268/375+52;
    self.fixedH = headerH+24-kStatusBarAndNavigationBarHeight;
    
    HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, nScreenWidth(), headerH)];
    self.headerView = headerView;
    GesturesTableView *tableView = [[GesturesTableView alloc] initWithFrame:self.view.bounds];
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.tableHeaderView = headerView;
    
    tableView.backgroundColor = COLORF9F9F9();
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 24;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGFloat footerH = nScreenHeight()-kStatusBarAndNavigationBarHeight;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, nScreenWidth(), nScreenHeight()-kStatusBarAndNavigationBarHeight)];
    footerView.backgroundColor = COLORFFFFFF();
    tableView.tableFooterView = footerView;
    
    NSArray <NSString *>*titles = @[@"One",@"Two"];
    NemoScrollerView *scroll = [[NemoScrollerView alloc] initWithFrame:CGRectMake(0, 0, nScreenWidth(), footerH)];
    scroll.titles = titles;
    scroll.lineColor = MAINCOLOR();
    scroll.textColor = MAINCOLOR();
    scroll.font = FONTSIZE(16);
    scroll.heightFont = FONTBOLDSIZE(16);
    
    OneViewController *actVC = [[OneViewController alloc] init];
    WeakSelf
    actVC.scrollerLeaveTopAction = ^{
        weakSelf.isCannotScroll = NO;
    };
    self.actVC = actVC;
    TwoViewController *scVC = [[TwoViewController alloc] init];
    scVC.scrollerLeaveTopAction = ^{
        weakSelf.isCannotScroll = NO;
    };
    self.scVC = scVC;
    scroll.viewController = self;
    scroll.viewControllers = @[actVC,scVC];
    [footerView addSubview:scroll];
    
    CALayer *topLine = [[CALayer alloc] init];
    topLine.frame = CGRectMake(0, 0, nScreenWidth(), 0.5);
    topLine.backgroundColor = COLOREDEDED().CGColor;
    [scroll.scroller.layer addSublayer:topLine];
    
    CALayer *line = [[CALayer alloc] init];
    line.frame = CGRectMake(0, 43.5, nScreenWidth(), 0.5);
    line.backgroundColor = COLOREDEDED().CGColor;
    [scroll.scroller.layer addSublayer:line];
    
    __weak typeof(tableView) weakTable = tableView;
    [tableView addRefreshViewForView:self.view atPoint:CGPointZero downRefresh:^{
        //开始刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //3 秒后结束刷新
            [weakTable endRefresh];
        });
        NSLog(@"=========test=========");
    }];

    [self createNavView];
}
- (void)createNavView {
    
    NavView *navView = [[NavView alloc] initWithFrame:CGRectMake(0, 0, nScreenWidth(), kStatusBarAndNavigationBarHeight)];
    [navView setBackgroundAlpha:0];
    navView.leftIcon = @"public_back_white";
    navView.rightIcon = @"public_share_more_white";
    navView.titleColor = MAINCOLOR();
    navView.title = @"超强的爆米花";
    [self.view addSubview:navView];
    self.navView = navView;
    WeakSelf
    navView.leftAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        [self.headerView overScrollAction:offsetY];
    }else {
        if (self.isCannotScroll) {
            scrollView.contentOffset = CGPointMake(0, self.fixedH);
            scrollView.bounces = NO;
        }else{
            if (self.fixedH <= offsetY) {
                self.isCannotScroll = YES;
                [self subScrollEnabled:YES];
                scrollView.contentOffset = CGPointMake(0, offsetY);
                scrollView.bounces = NO;
            }else{
                scrollView.bounces = YES;
            }
        }
    }
    [self updateNavigationBarBackgroundColor:offsetY];

}

- (void)updateNavigationBarBackgroundColor:(CGFloat)offsetY {
    CGFloat alpha = 0;
    if (self.tableView.contentOffset.y <  self.fixedH-10) {
        alpha = self.tableView.contentOffset.y / (self.fixedH-10);
    }else {
        alpha = 1;
    }
    self.navView.rightIcon = (alpha == 1) ? @"public_share_more":@"public_share_more_white";
    self.navView.leftIcon = (alpha == 1) ? @"public_back":@"public_back_white";
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.navView setBackgroundAlpha:alpha];
        self.navView.titleColor = RGBACOLOR(34, 34, 34, alpha);
    }];
    
}
- (void)subScrollEnabled:(BOOL)b {
    self.scVC.scrollEnabled = b;
    self.actVC.scrollEnabled = b;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    return cell;
}
@end
