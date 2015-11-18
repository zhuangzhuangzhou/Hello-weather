//
//  CityManagerCell.m
//  weatherApp
//
//  Created by xalo on 15/10/10.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "CityManagerCell.h"
#import "WeatherDetailModel.h"
#import "WeatherDataModel.h"
#import "PrefixHeader.pch"

@interface CityManagerCell ()

@property (weak, nonatomic) IBOutlet UILabel *curTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *weatherTypeLabel;

@end

@implementation CityManagerCell


- (void)awakeFromNib {
    // Initialization code
    self.cellImageVIew.layer.cornerRadius = 10;
    self.cellImageVIew.layer.masksToBounds = YES;
    self.cellImageVIew.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)locateImageView{
    if (!_locateImageView) {
        self.locateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 48, 18, 25, 30)];
        [self.contentView addSubview:_locateImageView];
    }
    return _locateImageView;
}

- (UILabel *)currentLabel{
    if (!_currentLabel) {
        self.currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(-30, 0, 80, 30)];
        _currentLabel.backgroundColor = [UIColor redColor];
        _currentLabel.textColor = [UIColor darkTextColor];
        _currentLabel.textAlignment = NSTextAlignmentCenter;
        _currentLabel.text = @"当前";
        _currentLabel.font = [UIFont systemFontOfSize:14];
        _currentLabel.transform = CGAffineTransformMakeRotation(-M_PI_4);
        [self.cellImageVIew addSubview:_currentLabel];
    }
    return _currentLabel;
}

- (void)configCellWithModel:(WeatherDataModel *)model{
    self.cityLabel.text = model.city;
    self.curTempLabel.text = model.todayWeatherDetail.curTemp;
    self.weatherTypeLabel.text = model.todayWeatherDetail.type;
}

@end
