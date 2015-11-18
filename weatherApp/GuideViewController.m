//
//  GuideViewController.m
//  weatherApp
//
//  Created by xalo on 15/10/17.
//  Copyright © 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "GuideViewController.h"
#import "PrefixHeader.pch"

@interface GuideViewController ()<UIScrollViewDelegate>

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _layoutGuideView];
}

- (void)_layoutGuideView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [scrollView setContentSize:CGSizeMake(kScreenWidth * 2, 0)];
    scrollView.delegate = self;
    [scrollView setPagingEnabled:YES];
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView setBounces:NO];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [imageView setImage:[UIImage imageNamed:@"Guide1"]];
    [scrollView addSubview:imageView];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    [imageView1 setImage:[UIImage imageNamed:@"Guide2"]];
    
    [scrollView addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    imageView2.image = [UIImage imageNamed:@"Guide3"];
    imageView2.userInteractionEnabled = YES;
    [scrollView addSubview:imageView2];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点击进入" forState:UIControlStateNormal];
    [button setTitleColor:kSystemTextColor forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = kSystemTextColor.CGColor;
    button.layer.borderWidth = 1.5;
    [button setFrame:CGRectMake((kScreenWidth - 150) / 2, kScreenHeight - 140, 150, 45)];
    [button addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.userInteractionEnabled = YES;
    [imageView2 addSubview:button];
    
    
    [self.view addSubview:scrollView];
    
    
    UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40)];
    page.numberOfPages = 2;
    page.currentPage = 0;
    page.tag = 5000;
    
    [self.view addSubview:page];
}

- (void)handleButtonAction:(UIButton *)sender{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *rootViewController = [storyBoard instantiateViewControllerWithIdentifier:@"rootViewController"];
    [self presentViewController:rootViewController animated:YES completion:nil];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:5000];
    CGFloat offset_x = scrollView.contentOffset.x;
    page.currentPage = offset_x / kScreenWidth;
    
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
