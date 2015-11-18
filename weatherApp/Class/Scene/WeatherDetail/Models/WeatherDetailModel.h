//
//  WeatherDetailModel.h
//  weatherApp
//
//  Created by xalo on 15/10/9.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDetailModel : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *week;
@property (nonatomic, strong) NSString *curTemp;
@property (nonatomic, strong) NSString *aqi;
@property (nonatomic, strong) NSString *fengxiang;
@property (nonatomic, strong) NSString *fengli;
@property (nonatomic, strong) NSString *hightemp;
@property (nonatomic, strong) NSString *lowtemp;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSMutableArray *indexArray;



@end
