//
//  ForecastView.h
//  weatherApp
//
//  Created by xalo on 15/10/9.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastView : UIView

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *highTempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *conditionImageView;
@property (weak, nonatomic) IBOutlet UILabel *lowTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *windPowerLabel;


@end
