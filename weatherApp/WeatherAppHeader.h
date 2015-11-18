
//
//  weatherAppHeader.h
//  weatherApp
//
//  Created by xalo on 15/10/8.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#ifndef weatherApp_WeatherAppHeader_h
#define weatherApp_WeatherAppHeader_h


#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

#define kSystemTextColor [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0]



typedef NS_ENUM(NSUInteger, BackgroundViewType){
    BackgroundViewTypeAuto = 0,
    BackgroundViewTypeSunny,
    BackgroundViewTypeShade,
    BackgroundViewTypeRainy,
    BackgroundViewTypeSnowy,
    BackgroundViewTypeNightSunny,
    BackgroundViewTypeNightRainy,
    BackgroundViewTypeNightSnowy
    
};

/******** API **********************/

#define kWeatherAPI [NSString stringWithFormat:@"http://apis.baidu.com/apistore/weatherservice/recentweathers"]

#define kWeatherAPIParam(CITYNAME) [NSString stringWithFormat:@"cityname=%@", CITYNAME]


#define kTimeAPI [NSString stringWithFormat:@"http://apis.baidu.com/apistore/weatherservice/cityname"]
#define kTimeAPIParam(CITYNAME) [NSString stringWithFormat:@"cityname=%@", CITYNAME]



#define kFirstLauch @"firstLauch"
#define kLocatedCity @"locatedCity"
#define kLocatedCounty @"locatedCounty"
#define kCurrentCity @"currentCity"
#define kCurrentWeatherType @"currentWeatherType"
#define kBackgroundView @"backgroundView"


#define kUserSetBackgroundView @"userSetBackgroundView"


#define kBackgroundChangedNotification @"backgroundChangedNotification"


#import "NetworkHelper.h"
#import "TranslateHelper.h"
#import "WeatherSymbolHelper.h"
#import "FMDatabaseHelper.h"
#import <AFNetworkReachabilityManager.h>



#import "SunnyBackgroundView.h"
#import "ShadeBackgroundView.h"
#import "RainyBackgroundView.h"
#import "SnowBackgroundView.h"
#import "NightSunnyBackgroundView.h"
#import "NightRainyBackgroundView.h"
#import "NightSnowBackgroundView.h"


static inline void alertWithCancelButton(UIViewController *presentViewController ,NSString *message){
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    
    if ([presentViewController isKindOfClass:[UINavigationController class]]) {
        [presentViewController presentViewController:alert animated:YES completion:nil];
        return;
    }
    if ([presentViewController isKindOfClass:[UIViewController class]]) {
        [presentViewController showViewController:alert sender:nil];
    }
    
}

static inline void networkReachablity(){
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
            [[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingReachabilityDidChangeNotification object:@"NotReachable"];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingReachabilityDidChangeNotification object:@"Reachable"];
        }
    }];
    [manager stopMonitoring];
}

#endif


