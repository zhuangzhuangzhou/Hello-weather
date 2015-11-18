//
//  WeatherSymbolHelper.h
//  weatherApp
//
//  Created by xalo on 15/10/10.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherSymbolHelper : NSObject

+ (NSString *)getSymbolImageNameWithWeatherType:(NSString *)type;


+ (NSString *)getAQISymbolImageNameWithAQI:(NSString *)aqi;

@end
