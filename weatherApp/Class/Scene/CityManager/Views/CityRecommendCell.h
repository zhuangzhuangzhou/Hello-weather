//
//  CityRecommendCell.h
//  weatherApp
//
//  Created by xalo on 15/10/10.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityRecommendDelegate <NSObject>

- (void)recommendCityWithCityName:(NSString *)cityName;

@end

@interface CityRecommendCell : UITableViewCell

@property (nonatomic, weak) id<CityRecommendDelegate> delegate;

@end
