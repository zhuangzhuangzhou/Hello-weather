//
//  weatherDataModel.h
//  weatherApp
//
//  Created by xalo on 15/10/9.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WeatherDetailModel;

@interface WeatherDataModel : NSObject

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *cityid;
@property (nonatomic, strong) WeatherDetailModel *todayWeatherDetail;
@property (nonatomic, strong) NSMutableArray *forecastArray;

@end
