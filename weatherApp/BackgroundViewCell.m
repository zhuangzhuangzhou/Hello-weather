//
//  BackgroundViewCell.m
//  weatherApp
//
//  Created by xalo on 15/10/16.
//  Copyright © 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "BackgroundViewCell.h"

@implementation BackgroundViewCell


- (UILabel *)currentLabel{
    if (!_currentLabel) {
        self.currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(-30, 0, 80, 30)];
        _currentLabel.text = @"当前";
        _currentLabel.textAlignment = NSTextAlignmentCenter;
        _currentLabel.backgroundColor = [UIColor redColor];
        _currentLabel.transform = CGAffineTransformMakeRotation(-M_PI_4);
        self.contentView.layer.masksToBounds = YES;
        [self.contentView addSubview:_currentLabel];
    }
    return _currentLabel;
}

- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_backgroundImageView];
    }
    return _backgroundImageView;
}

@end
