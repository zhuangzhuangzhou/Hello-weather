//
//  RainyBackground.m
//  weatherApp
//
//  Created by xalo on 15/10/14.
//  Copyright © 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "RainyBackgroundView.h"
#import "PrefixHeader.pch"


@interface RainyBackgroundView ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation RainyBackgroundView

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
    
    UIImageView *rainCloud3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1190, 600)];
    rainCloud3.image = [UIImage imageNamed:@"ele_middleRainCloud3"];
    [self addSubview:rainCloud3];
    
    
    UIImageView *rainCloud2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 639, 306)];
    rainCloud2.image = [UIImage imageNamed:@"ele_middleRainCloud2"];
    [self addSubview:rainCloud2];
    
    UIImageView *rainCloud1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 759, 306)];
    rainCloud1.image = [UIImage imageNamed:@"ele_middleRainCloud1"];
    [self addSubview:rainCloud1];
    
}

- (void)addAnimation{
    
    NSInteger count = self.subviews.count;
    for (int i = 4; i < count; i++) {
        int randomNum = arc4random() % 151 + 50;
        [self _rainLineAnimation:self.subviews[i] animationTime:randomNum / 100.0];
    }
    
    
    for (int i = 2; i < 4; i++) {
        [self _rainCloudAnimation:self.subviews[i] animationTime:100 + 20 * i];
    }
    [self _blackCloudAnimation:self.subviews[1] animationTime:180];
    
    if (!self.imageView) {
        for (int i = 0; i < 100; i++) {
            self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-20 + kScreenWidth / 100.0 * i, kScreenHeight / 3.0, 30, 110)];
            
            _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ele_rainLine%d", arc4random() % 2 + 2]];
            [self addSubview:_imageView];
            int randomNum = arc4random() % 151 + 50;
            [self _rainLineAnimation:_imageView animationTime:randomNum / 100.0];
        }
    }else {
        for (int i = 4; i < 104; i++) {
            int randomNum = arc4random() % 151 + 50;
            [self _rainLineAnimation:self.subviews[i] animationTime:randomNum / 100.0];
        }
    }
    
}


- (void)_rainLineAnimation:(UIImageView *)view animationTime:(double)time{
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    CABasicAnimation *transform_x = [CABasicAnimation animation];
    transform_x.keyPath = @"transform.translation.x";
    transform_x.fromValue = @0;
    transform_x.toValue = @200;
    
    
    CABasicAnimation *transform_y = [CABasicAnimation animation];
    transform_y.keyPath = @"transform.translation.y";
    transform_y.fromValue = @(-89);
    transform_y.toValue = @1200;
    
    animationGroup.removedOnCompletion = NO;
    animationGroup.duration = time;
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.animations = @[transform_x, transform_y];
    
    [view.layer addAnimation:animationGroup forKey:nil];
    
    CABasicAnimation *opacity = [CABasicAnimation animation];
    opacity.keyPath = @"opacity";
    opacity.fromValue = @0;
    opacity.toValue = @1;
    opacity.duration = 1;
    opacity.removedOnCompletion = NO;
    [view.layer addAnimation:opacity forKey:nil];
}

- (void)_rainCloudAnimation:(UIImageView *)view animationTime:(double)time{
    CABasicAnimation *transform_x = [CABasicAnimation animation];
    transform_x.keyPath = @"transform.translation.x";
    transform_x.fromValue = @(-759);
    transform_x.toValue = @(400);
    transform_x.duration = time;
    transform_x.repeatCount = MAXFLOAT;
    transform_x.removedOnCompletion = NO;
    [view.layer addAnimation:transform_x forKey:nil];
}

- (void)_blackCloudAnimation:(UIImageView *)view animationTime:(double)time{
    CABasicAnimation *transform_x = [CABasicAnimation animation];
    transform_x.keyPath = @"transform.translation.x";
    transform_x.fromValue = @(-759);
    transform_x.toValue = @(0);
    transform_x.duration = time;
    transform_x.repeatCount = MAXFLOAT;
    transform_x.autoreverses = YES;
    transform_x.removedOnCompletion = NO;
    [view.layer addAnimation:transform_x forKey:nil];
}

@end
