//
//  SunnyBackgroundView.m
//  weatherApp
//
//  Created by xalo on 15/10/15.
//  Copyright © 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "SunnyBackgroundView.h"
#import "PrefixHeader.pch"

@interface SunnyBackgroundView ()

@property (weak, nonatomic) IBOutlet UIImageView *sunShineImage;
@property (weak, nonatomic) IBOutlet UIImageView *sunnyCloud1Image;
@property (weak, nonatomic) IBOutlet UIImageView *sunnyCloud2Image;
@property (weak, nonatomic) IBOutlet UIImageView *birdImage;
@property (weak, nonatomic) IBOutlet UIImageView *birdShadowImage;


@end

@implementation SunnyBackgroundView

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

    
    [self _sunShineRotationAnimation];
    
    [self _sunnyCloudMoveAnimation];
    
    [self _birdFlyAnimation];
    
}


- (void)_sunShineRotationAnimation{
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"transform.rotation";
    basicAnimation.fromValue = @(- M_PI / 4);
    basicAnimation.toValue = @( 3 * M_PI / 4);
    basicAnimation.duration = 20;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.repeatCount = MAXFLOAT;
    [self.sunShineImage.layer addAnimation:basicAnimation forKey:nil];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animation];
    opacityAnimation.keyPath = @"opacity";
    opacityAnimation.fromValue = @0;
    opacityAnimation.toValue = @1;
    opacityAnimation.duration = 10;
    opacityAnimation.autoreverses = YES;
    opacityAnimation.repeatCount = MAXFLOAT;
    opacityAnimation.removedOnCompletion = NO;
    [self.sunShineImage.layer addAnimation:opacityAnimation forKey:nil];
}

- (void)_sunnyCloudMoveAnimation{
    CABasicAnimation *cloud1Animation = [CABasicAnimation animation];
    cloud1Animation.keyPath = @"transform.translation.x";
    cloud1Animation.duration = 30;
    cloud1Animation.fromValue = @(-330);
    cloud1Animation.toValue = @(400);
    cloud1Animation.repeatCount = MAXFLOAT;
    cloud1Animation.removedOnCompletion = NO;
    [self.sunnyCloud1Image.layer addAnimation:cloud1Animation forKey:nil];
    
    
    CABasicAnimation *cloud2Animation = [CABasicAnimation animation];
    cloud2Animation.keyPath = @"transform.translation.x";
    cloud2Animation.duration = 40;
    cloud2Animation.fromValue = @(-330);
    cloud2Animation.toValue = @(400);
    cloud2Animation.repeatCount = MAXFLOAT;
    cloud2Animation.removedOnCompletion = NO;
    [self.sunnyCloud2Image.layer addAnimation:cloud2Animation forKey:nil];
}

- (void)_birdFlyAnimation{
    NSMutableArray *birdsArray = [NSMutableArray array];
    NSMutableArray *birdShadowArray = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        [birdsArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"ele_sunnyBird%d.png",i + 1]]];
        [birdShadowArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"ele_sunnyBirdInvertedImage%d.png", i + 1]]];
    }
    self.birdImage.animationImages = birdsArray;
    _birdImage.animationDuration = 1;
    [_birdImage startAnimating];
    
    self.birdShadowImage.animationImages = birdShadowArray;
    _birdShadowImage.animationDuration = 1;
    [_birdShadowImage startAnimating];
    
    CABasicAnimation *flyAnimation = [CABasicAnimation animation];
    flyAnimation.keyPath = @"transform.translation.x";
    flyAnimation.duration = 15;
    flyAnimation.fromValue = @(-100);
    flyAnimation.toValue = @(400);
    flyAnimation.repeatCount = MAXFLOAT;
    flyAnimation.removedOnCompletion = NO;
    [_birdImage.layer addAnimation:flyAnimation forKey:nil];
    [_birdShadowImage.layer addAnimation:flyAnimation forKey:nil];
    
    
}


@end
