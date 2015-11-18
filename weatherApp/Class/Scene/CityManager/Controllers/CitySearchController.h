//
//  CitySearchController.h
//  weatherApp
//
//  Created by xalo on 15/10/10.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CityNameBlock)(NSString *, NSString *);

@interface CitySearchController : UIViewController

@property (nonatomic, copy) CityNameBlock cityNameBlock;

@end
