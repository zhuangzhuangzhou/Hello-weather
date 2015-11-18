//
//  HeaderView.m
//  weatherApp
//
//  Created by xalo on 15/10/12.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "HeaderView.h"
#import "ForecastView.h"
#import "WeatherDetailView.h"

@implementation HeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance duing animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    self.windLabel.adjustsFontSizeToFitWidth = YES;
    self.aqiStaticLabel.adjustsFontSizeToFitWidth = YES;
}



@end
