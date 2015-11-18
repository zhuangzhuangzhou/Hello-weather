//
//  CityManagerCell.h
//  weatherApp
//
//  Created by xalo on 15/10/10.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeatherDetailModel;
@class WeatherDataModel;

@interface CityManagerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;
@property (nonatomic, strong) UIImageView *locateImageView;

@property (nonatomic, strong) UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

- (void)configCellWithModel:(WeatherDataModel *)model;


@end
