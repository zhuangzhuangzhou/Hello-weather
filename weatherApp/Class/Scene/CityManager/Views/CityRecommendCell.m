//
//  CityRecommendCell.m
//  weatherApp
//
//  Created by xalo on 15/10/10.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "CityRecommendCell.h"
#import "PrefixHeader.pch"

#define kOffset 15
#define kButtonWidth ((kScreenWidth - kOffset * 4) / 3)
#define kButtonHeight 30
#define kBegin_Y 65

@implementation CityRecommendCell

- (void)awakeFromNib {
    // Initialization code
    NSArray *titleArray = @[@"自动定位", @"北京", @"天津", @"上海", @"重庆", @"长春", @"哈尔滨", @"郑州", @"武汉", @"长沙", @"南宁", @"广州", @"海口", @"南京", @"杭州", @"南昌", @"济南", @"合肥"];
    int count = 0;
    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 3; j++) {
            [self _createButtonWithTitle:titleArray[count] frame:CGRectMake(kOffset + (kOffset + kButtonWidth) * j, kBegin_Y + (kOffset + kButtonHeight) * i, kButtonWidth, kButtonHeight) tag:100 + count];
            count++;
        }
    }
    
}

- (void)_createButtonWithTitle:(NSString *)title
                         frame:(CGRect)frame
                           tag:(NSInteger)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.showsTouchWhenHighlighted = YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.backgroundColor = [UIColor blackColor];
    button.alpha = 0.5;
    button.tag = tag;
    [button addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
}

- (void)handleButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(recommendCityWithCityName:)]) {
        [self.delegate recommendCityWithCityName:[sender titleForState:UIControlStateNormal]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
