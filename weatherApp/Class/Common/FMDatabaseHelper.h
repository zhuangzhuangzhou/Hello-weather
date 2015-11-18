//
//  FMDatabaseHelper.h
//  weatherApp
//
//  Created by xalo on 15/10/12.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WeatherInfoModel;

@interface FMDatabaseHelper : NSObject

+ (id)shareInstance;

- (BOOL)insertCurrentCityWeatherInfoWithModel:(WeatherInfoModel *)model;
- (BOOL)updateCurrentCityWeatherInfoWithModel:(WeatherInfoModel *)model;
- (WeatherInfoModel *)selectCurrentCityWeatherInfoWithCityName:(NSString *)cityName;

- (BOOL)insertFocusedCityWeatherInfoWithModel:(WeatherInfoModel *)model;
- (BOOL)updateFocusedCityWeatherInfoWithModel:(WeatherInfoModel *)model;
- (NSArray *)selectFocusedCityWeatherInfoWithCityName:(NSString *)cityName;
- (BOOL)deleteFocusedCityWeatherInfoWithCityName:(NSString *)cityName;

@end
