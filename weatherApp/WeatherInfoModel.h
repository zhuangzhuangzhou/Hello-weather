//
//  WeatherInfoModel.h
//  weatherApp
//
//  Created by xalo on 15/10/12.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherInfoModel : NSObject

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSData *jsonData;
@property (nonatomic, strong) NSNumber *updateTime;

@end
