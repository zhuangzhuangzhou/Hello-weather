//
//  PopUpViewController.m
//  weatherApp
//
//  Created by xalo on 15/10/16.
//  Copyright © 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "PopUpViewController.h"
#import <STPopup.h>
#import "PopupView.h"

@interface PopUpViewController ()

@end

@implementation PopUpViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        //self.view.backgroundColor = [UIColor blackColor];
        self.contentSizeInPopup = CGSizeMake(250, 350);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
        self.title = @"关于我们";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureAction:)];
    [self.view addGestureRecognizer:tap];
    
    
    PopupView *popView = [[[NSBundle mainBundle] loadNibNamed:@"PopupView" owner:nil options:nil] firstObject];
    [self.view addSubview:popView];
}

- (void)handleTapGestureAction:(UITapGestureRecognizer *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
