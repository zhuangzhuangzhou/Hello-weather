//
//  WeatherDetailView.m
//  weatherApp
//
//  Created by xalo on 15/10/9.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "WeatherDetailView.h"
#import "ForecastView.h"
#import "LifeIndexView.h"
#import "PrefixHeader.pch"
#import "WeatherDataModel.h"
#import "WeatherDetailModel.h"
#import "LifeIndexModel.h"
#import "LifeIndexCell.h"
#import "HeaderView.h"

#define kForecastViewWidth 140
#define kForecastViewHeight 180

#define kLifeIndexViewHeight 100

@interface WeatherDetailView () <UITableViewDataSource, UITableViewDelegate>




@property (nonatomic, strong) NSMutableArray *forecastViewArray;

@property (nonatomic, strong) NSMutableArray *lifeIndexArray;

@property (nonatomic, strong) HeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *indexImageArray;



@end

@implementation WeatherDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSMutableArray *)forecastViewArray{
    if (!_forecastViewArray) {
        self.forecastViewArray = [NSMutableArray array];
    }
    return _forecastViewArray;
}

- (NSMutableArray *)lifeIndexArray{
    if (!_lifeIndexArray) {
        self.lifeIndexArray = [NSMutableArray array];
    }
    return _lifeIndexArray;
}

- (NSMutableArray *)indexImageArray{
    if (!_indexImageArray) {
        self.indexImageArray = [NSMutableArray array];
    }
    return _indexImageArray;
}

- (void)awakeFromNib{
    
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 53)];
    _cityLabel.text = @"点我选择城市";
    _cityLabel.textColor = [UIColor lightGrayColor];
    _cityLabel.font = [UIFont systemFontOfSize:36];
    [self.cityButton addSubview:_cityLabel];
    
    
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:nil options:nil] lastObject];
    self.mainScrollView.tableHeaderView = _headerView;
    
    
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.frame = CGRectMake(0, 180, kScreenWidth, kScreenHeight);
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    
    self.mainScrollView.estimatedRowHeight = self.mainScrollView.rowHeight;
    self.mainScrollView.rowHeight = UITableViewAutomaticDimension;
    
    [self.mainScrollView registerNib:[UINib nibWithNibName:@"LifeIndexCell" bundle:nil] forCellReuseIdentifier:@"lifeIndexCell"];
    
    self.headerView.forecastScrollView.contentSize = CGSizeMake(730, 200);
    
    for (int i = 0; i < 5; i++) {
        ForecastView *forecastView = [[[NSBundle mainBundle] loadNibNamed:@"ForecastView" owner:nil options:nil] lastObject];
        forecastView.frame = CGRectMake(5 + (5 + kForecastViewWidth) * i, 0, kForecastViewWidth, kForecastViewHeight);
        [self.forecastViewArray addObject:forecastView];
        [self.headerView.forecastScrollView addSubview:forecastView];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   // return self.lifeIndexArray.count;
    return self.lifeIndexArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LifeIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lifeIndexCell" forIndexPath:indexPath];
    
    LifeIndexModel *model = self.lifeIndexArray[indexPath.row];
    cell.indexTitleLabel.text = model.name;
    cell.indexLevelLabel.text = model.index;
    cell.indexDescLabel.text = model.details;
    cell.lifeIndexImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"index%ld",indexPath.row]];
        
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    LifeIndexModel *model = self.lifeIndexArray[indexPath.row];
//    CGRect frame = [model.details boundingRectWithSize:CGSizeMake(kScreenWidth - 109, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
//    return frame.size.height + 60;
//}



- (void)updateDataWithModel:(WeatherDataModel *)dataModel fromHistory:(BOOL)fromHistory{
    
    
    if (!fromHistory) {
        for (UIView *view in self.subviews) {
            [self animationFadeIn:view];
        }
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:dataModel.city forKey:kCurrentCity];
    
    self.cityLabel.adjustsFontSizeToFitWidth = YES;
    self.cityLabel.attributedText = [self _settingCityLabelWithPinyin:[TranslateHelper hanziToPinyin:dataModel.city] cityName:dataModel.city];
    
    WeatherDetailModel *detailModel = dataModel.todayWeatherDetail;
    self.headerView.lowTempLabel.text = detailModel.lowtemp;
    self.headerView.highTempLabel.text = detailModel.hightemp;
    self.headerView.currentTempLabel.text = detailModel.curTemp;
    self.headerView.conditionLabel.text = detailModel.type;
    
    
//    self.headerView.lowTempLabel.text = @"-10℃";
//    self.headerView.highTempLabel.text = @"0℃";
//    self.headerView.currentTempLabel.text = @"-5℃";
//    self.headerView.conditionLabel.text = @"雪";
    
    
    self.headerView.windLabel.text = [NSString stringWithFormat:@"%@%@", detailModel.fengxiang, detailModel.fengli];
    self.headerView.aqiLabel.text = detailModel.aqi;
    self.headerView.aqiImageView.image = [UIImage imageNamed:[WeatherSymbolHelper getAQISymbolImageNameWithAQI:detailModel.aqi]];
    
    [dataModel.forecastArray insertObject:detailModel atIndex:0];
    
    NSArray *array = @[@"今天", @"明天", @"后天"];
    for (int i = 0; i < dataModel.forecastArray.count; i++) {
        ForecastView *forecastView = self.forecastViewArray[i];
        WeatherDetailModel *forecastModel = dataModel.forecastArray[i];
        
        if (i < 3) {
            forecastView.weekLabel.text = array[i];
        }else{
            forecastView.weekLabel.text = forecastModel.week;
        }
        
        forecastView.dateLabel.text = [[forecastModel.date substringWithRange:NSMakeRange(5, 5)] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        forecastView.highTempLabel.text = forecastModel.hightemp;
        forecastView.lowTempLabel.text = forecastModel.lowtemp;
        forecastView.conditionLabel.text = forecastModel.type;
        forecastView.conditionImageView.image = [UIImage imageNamed:[WeatherSymbolHelper getSymbolImageNameWithWeatherType:forecastModel.type]];
        forecastView.windLabel.text = forecastModel.fengxiang;
        forecastView.windPowerLabel.text = forecastModel.fengli;
    }
    
    [self.lifeIndexArray setArray:detailModel.indexArray];
    [self.mainScrollView reloadData];
    
}




- (void)animationFadeIn:(UIView *)view{
    CABasicAnimation *position = [CABasicAnimation animation];
    position.keyPath = @"transform.scale";
    position.duration = 0.75;
    position.fromValue = @0.618;
    position.toValue = @1;
    [view.layer addAnimation:position forKey:nil];
    
    CABasicAnimation *opacity = [CABasicAnimation animation];
    opacity.keyPath = @"opacity";
    opacity.duration = 0.75;
    opacity.fromValue = @0;
    opacity.toValue = @1;
    [view.layer addAnimation:opacity forKey:nil];
}

- (NSAttributedString *)_settingCityLabelWithPinyin:(NSString *)cityPreName
                                           cityName:(NSString *)citySufName{
    if (cityPreName == nil && citySufName == nil) {
        return nil;
    }
    
    NSString *firstString = [[cityPreName substringToIndex:1] uppercaseString];
    NSString *upperString = [firstString stringByAppendingString:[cityPreName substringFromIndex:1]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@|%@",upperString, citySufName]];
    NSString *string = [NSString stringWithFormat:@"%@|%@",upperString, citySufName];
    
    NSRange range = [string rangeOfString:@"|"];
    NSInteger length = string.length;
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, range.location)];
    [title addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Times New Roman" size:50] range:NSMakeRange(0, range.location)];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(range.location, length - range.location)];
    [title addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:26] range:NSMakeRange(range.location, length - range.location)];
    [title replaceCharactersInRange:range withString:@" | "];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50] range:NSMakeRange(range.location + 1, range.length)];
    return title;
}

- (IBAction)handleCityButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(weatherDetailViewModalNavigationController:)]) {
        [self.delegate weatherDetailViewModalNavigationController:self];
    }
}



@end











