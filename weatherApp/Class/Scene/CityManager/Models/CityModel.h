//
//  CityModel.h
//  weatherApp
//
//  Created by xalo on 15/10/10.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property (nonatomic, strong) NSString *countyName;
@property (nonatomic, strong) NSString *countyNamePinyin;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *provinceName;

@end
