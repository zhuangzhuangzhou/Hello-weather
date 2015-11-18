//
//  CityAddCell.m
//  weatherApp
//
//  Created by xalo on 15/10/10.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "CityAddCell.h"

@implementation CityAddCell

- (void)awakeFromNib {
    // Initialization code
    self.cellImageView.layer.cornerRadius = 10;
    self.cellImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
