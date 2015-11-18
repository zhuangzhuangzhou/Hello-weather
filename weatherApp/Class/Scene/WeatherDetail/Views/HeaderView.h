//
//  HeaderView.h
//  weatherApp
//
//  Created by xalo on 15/10/12.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HeaderView : UIView


@property (weak, nonatomic) IBOutlet UILabel *lowTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *highTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aqiImageView;

@property (weak, nonatomic) IBOutlet UILabel *aqiStaticLabel;

@property (weak, nonatomic) IBOutlet UILabel *aqiLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *forecastScrollView;

@end
