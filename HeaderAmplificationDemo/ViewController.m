//
//  ViewController.m
//  HeaderAmplificationDemo
//
//  Created by mac on 2019/11/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import "HomepageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"=========点击屏幕跳转=========");
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    HomepageViewController *vc = [[HomepageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
