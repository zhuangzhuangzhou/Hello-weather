//
//  NightSnowBackgroundView.m
//  weatherApp
//
//  Created by xalo on 15/10/17.
//  Copyright © 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "NightSnowBackgroundView.h"
#import "PrefixHeader.pch"

@interface NightSnowBackgroundView ()

@property (nonatomic, strong) UIImageView *snowGrainImage;

@end

@implementation NightSnowBackgroundView

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

- (void)addAnimation{
    
    if (!self.snowGrainImage) {
        NSValue *frame2 = [NSValue valueWithCGRect:CGRectMake(0, 0, 16, 16)];
        NSValue *frame3 = [NSValue valueWithCGRect:CGRectMake(0, 0, 6, 6)];
        NSValue *frame4 = [NSValue valueWithCGRect:CGRectMake(0, 0, 6, 6)];
        NSValue *frame5 = [NSValue valueWithCGRect:CGRectMake(0, 0, 8, 10)];
        NSArray *frameArray = @[frame2, frame3, frame4, frame5];
        for (int i = 0; i < 300; i++) {
            int randomNum = arc4random() % 4 + 2;
            self.snowGrainImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"ele_snowGrain%d",randomNum]]];
            CGRect frame = [frameArray[randomNum - 2] CGRectValue];
            frame.origin.x = kScreenWidth / 300.0 * i;
            _snowGrainImage.frame = frame;
            [self addSubview:_snowGrainImage];
            int randomTime = arc4random() % 200 + 50;
            [self _snowGrainAnimation:_snowGrainImage animationTime:randomTime / 10.0];
        }
    }else {
        for (int i = 2; i < self.subviews.count; i++) {
            int randomTime = arc4random() % 200 + 50;
            [self _snowGrainAnimation:self.subviews[i] animationTime:randomTime / 10.0];
        }
    }
}

- (void)_snowGrainAnimation:(UIImageView *)view animationTime:(double)time{
    
    
    CABasicAnimation *transform_y = [CABasicAnimation animation];
    transform_y.keyPath = @"transform.translation.y";
    transform_y.fromValue = @(-89);
    transform_y.toValue = @1200;
    
    transform_y.duration = time;
    transform_y.repeatCount = MAXFLOAT;
    transform_y.removedOnCompletion = NO;
    
    [view.layer addAnimation:transform_y forKey:nil];
    
    CABasicAnimation *opacity = [CABasicAnimation animation];
    opacity.keyPath = @"opacity";
    opacity.fromValue = @0;
    opacity.toValue = @1;
    opacity.duration = 1;
    opacity.removedOnCompletion = NO;
    [view.layer addAnimation:opacity forKey:nil];
}

@end
