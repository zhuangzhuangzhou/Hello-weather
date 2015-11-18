//
//  WeatherDetailView.h
//  weatherApp
//
//  Created by xalo on 15/10/9.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeatherDataModel;

@protocol WeatherDetailViewDelegate <NSObject>

- (void)weatherDetailViewModalNavigationController:(UIView *)weatherDetailView;

@end

@interface WeatherDetailView : UIView

@property (nonatomic, weak) id<WeatherDetailViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITableView *mainScrollView;

@property (strong, nonatomic) UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;

@property (weak, nonatomic) IBOutlet UIButton *locateButton;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;



- (void)updateDataWithModel:(WeatherDataModel *)dataModel
                fromHistory:(BOOL)fromHistory;

@end






















