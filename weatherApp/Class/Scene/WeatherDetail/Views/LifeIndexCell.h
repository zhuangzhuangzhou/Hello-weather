//
//  LifeIndexCell.h
//  weatherApp
//
//  Created by xalo on 15/10/12.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeIndexCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *lifeIndexImageView;
@property (weak, nonatomic) IBOutlet UILabel *indexTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *indexLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *indexDescLabel;


@end
