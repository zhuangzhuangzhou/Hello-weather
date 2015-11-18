//
//  WeatherSymbolHelper.m
//  weatherApp
//
//  Created by xalo on 15/10/10.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "WeatherSymbolHelper.h"

@implementation WeatherSymbolHelper

+ (NSString *)getSymbolImageNameWithWeatherType:(NSString *)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"weatherSymbol" ofType:@"txt"];
    NSString *allLinesString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *allLines = [allLinesString componentsSeparatedByString:@"\n"];
    for (int i = 0; i < allLines.count; i++) {
        NSString *index = [[allLines[i] componentsSeparatedByString:@"\t"] firstObject];
        NSString *typeString = [[allLines[i] componentsSeparatedByString:@"\t"] lastObject];
        if ([type isEqualToString:typeString]) {
            return [NSString stringWithFormat:@"w%@.png", index];
        }
    }
    return [NSString stringWithFormat:@"w%d.png", 44];
}


+ (NSString *)getAQISymbolImageNameWithAQI:(NSString *)aqi{
    NSInteger num = aqi.integerValue;
    if (num < 51) {
        return @"weather_aqi_level_1";
    }else if (num < 101){
        return @"weather_aqi_level_2";
    }else if (num < 201){
        return @"weather_aqi_level_3";
    }else if (num < 301){
        return @"weather_aqi_level_4";
    }else{
        return @"weather_aqi_level_5";
    }
}

@end
