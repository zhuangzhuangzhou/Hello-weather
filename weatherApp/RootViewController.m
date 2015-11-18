//
//  RootViewController.m
//  weatherApp
//
//  Created by xalo on 15/10/16.
//  Copyright © 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "RootViewController.h"
#import "PrefixHeader.pch"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)awakeFromNib{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImage = [UIImage imageNamed:@"resideMenu.jpg"];
    self.bouncesHorizontally = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
