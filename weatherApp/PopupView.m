//
//  PopupView.m
//  weatherApp
//
//  Created by xalo on 15/10/16.
//  Copyright © 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "PopupView.h"
#import "PrefixHeader.pch"

#define kViewWidth 250

@interface PopupView ()

@property (nonatomic, strong) NSArray *datasource;
@end

@implementation PopupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kViewWidth - 100) / 2, 10, 100, 100)];
    imageView.image = [UIImage imageNamed:@"about"];
    imageView.layer.cornerRadius = 15;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((kViewWidth - 100) / 2, 110, 100, 40)];
    nameLabel.text = @"清新天气";
    nameLabel.font = [UIFont systemFontOfSize:24];
    [self addSubview:nameLabel];
    
    UILabel *versionLable = [[UILabel alloc] initWithFrame:CGRectMake((kViewWidth - 120) / 2, 150, 120, 21)];
    versionLable.text = @"For iPhone V1.0";
    versionLable.textColor = [UIColor lightGrayColor];
    [self addSubview:versionLable];
    
}


//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.datasource.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CGRect frame = [self.datasource[indexPath.row] boundingRectWithSize:CGSizeMake(220, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
//    return frame.size.height;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.textLabel.text = self.datasource[indexPath.row];
//    cell.textLabel.textColor = [UIColor darkGrayColor];
//    cell.textLabel.numberOfLines = 0;
//    return cell;
//}

@end

























