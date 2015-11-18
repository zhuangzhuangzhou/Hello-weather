//
//  ShadeBackgroundView.m
//  weatherApp
//
//  Created by xalo on 15/10/15.
//  Copyright © 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "ShadeBackgroundView.h"
#import "PrefixHeader.pch"

@implementation ShadeBackgroundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.layer.masksToBounds = YES;
}

@end
