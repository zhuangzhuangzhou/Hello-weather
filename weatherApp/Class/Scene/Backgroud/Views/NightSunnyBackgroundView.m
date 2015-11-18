//
//  NightSunnyBackgroundView.m
//  weatherApp
//
//  Created by xalo on 15/10/17.
//  Copyright © 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "NightSunnyBackgroundView.h"
#import "PrefixHeader.pch"

@interface NightSunnyBackgroundView ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation NightSunnyBackgroundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}

- (void)addAnimation{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:<#(NSTimeInterval)#> target:<#(nonnull id)#> selector:<#(nonnull SEL)#> userInfo:<#(nullable id)#> repeats:<#(BOOL)#>]
//    for (int i = 0; i < 10; i++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth / 10.0) * i, kScreenHeight - 100, 24, 24)];
//        imageView.image = [UIImage imageNamed:@"ele_sunnyNightFirefly.png"];
//        [self addSubview:imageView];
//        [self firflyAndStarAnimation:imageView time:1];
//    }
//    NSLog(@"%@", self.subviews);
}





- (void)firflyAndStarAnimation:(UIImageView *)view time:(double)time{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animation];
    opacityAnimation.keyPath = @"opacity";
    opacityAnimation.fromValue = @0;
    opacityAnimation.toValue = @1;
    opacityAnimation.duration = 10;
    opacityAnimation.autoreverses = YES;
    opacityAnimation.repeatCount = 1;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [view.layer addAnimation:opacityAnimation forKey:nil];
}

@end
