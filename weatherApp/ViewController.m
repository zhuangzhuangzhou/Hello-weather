//
//  ViewController.m
//  weatherApp
//
//  Created by xalo on 15/10/8.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "PrefixHeader.pch"
#import "WeatherDetailView.h"
#import "WeatherDetailModel.h"
#import "WeatherDataModel.h"
#import "LifeIndexModel.h"
#import "CityManagerController.h"
#import "WeatherInfoModel.h"
#import <MJRefresh.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController () <WeatherDetailViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) SunnyBackgroundView *sunnyView;
@property (nonatomic, strong) ShadeBackgroundView *shadeView;
@property (nonatomic, strong) RainyBackgroundView *rainyView;
@property (nonatomic, strong) SnowBackgroundView *snowyView;

@property (nonatomic, strong) NightSunnyBackgroundView *nightSunnyView;
@property (nonatomic, strong) NightRainyBackgroundView *nightRainyView;
@property (nonatomic, strong) NightSnowBackgroundView  *nightSnowyView;

@property (strong, nonatomic) WeatherDetailView *weatherDetailView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, strong) NSString *currentCounty;


@property (nonatomic, strong) CLLocationManager *locationManager;


@property (nonatomic, strong) NetworkHelper *helper;
@property (nonatomic, strong) FMDatabaseHelper *fmdbHelper;

@property (nonatomic, strong) WeatherDataModel *dataModel;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, assign) BOOL isLocationButton;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.helper = [NetworkHelper sharedInstance];
    self.fmdbHelper = [FMDatabaseHelper shareInstance];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *currentCity = [user objectForKey:kCurrentCity];
    self.currentCity = currentCity;
    self.currentCounty = _currentCity;
    
    if (![user boolForKey:kFirstLauch]) {
        [user setBool:YES forKey:kFirstLauch];
        [user setObject:@(BackgroundViewTypeSunny) forKey:kBackgroundView];
        [user setObject:@"晴" forKey:kCurrentWeatherType];
        [user setObject:@(BackgroundViewTypeAuto) forKey:kUserSetBackgroundView];
        [self _startLocating];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBackgroundChangedNotificationAction:) name:kBackgroundChangedNotification object:nil];
    
    
    
    [self _layoutWeatherDetailView];

}

- (void)_layoutWeatherDetailView{
    self.weatherDetailView = [[[NSBundle mainBundle] loadNibNamed:@"WeatherDetailView" owner:nil options:nil]firstObject];
    _weatherDetailView.delegate = self;
    [_weatherDetailView.locateButton addTarget:self action:@selector(handleLocateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.weatherDetailView];
    
    
    [self _settingPublishTimeLabel:[self _getHistoryRecord]];
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        networkReachablity();
    }];
    _weatherDetailView.mainScrollView.header = header;
    [header setTitle:@"下拉更新天气数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在更新天气数据" forState:MJRefreshStateRefreshing];
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    if (self.currentCity && self.currentCounty) {
        [self.weatherDetailView.mainScrollView.header setState:MJRefreshStateRefreshing];
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSNumber *type = [user objectForKey:kBackgroundView];
    [self _loadBackgroundView:type.integerValue];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkReachableNotification:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

#pragma mark -- 通知响应方法 --
- (void)handleBackgroundChangedNotificationAction:(NSNotification *)sender{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSNumber *type = [user objectForKey:kUserSetBackgroundView];
    if (type.integerValue == BackgroundViewTypeAuto) {
        [self _loadBackgroundView:[self _weatherConditionToBackgroundViewType:[user objectForKey:kCurrentWeatherType]]];
    }else{
        [self _loadBackgroundView:type.integerValue];
    }
}

- (void)handleNetworkReachableNotification:(NSNotification *)sender{
    if ([sender.object isEqualToString:@"NotReachable"]) {
        alertWithCancelButton(self, @"网络连接错误！");
        [self.weatherDetailView.mainScrollView.header endRefreshing];
    }else if ([sender.object isEqualToString:@"Reachable"]){
        if (self.isLocationButton) {
            [self _startLocating];
            self.isLocationButton = NO;
        }else {
           [self _connectToGetDataWithCityName:self.currentCity countyName:self.currentCity];
        }
        
    }
}

#pragma mark -- 加载背景 --
- (void)_loadBackgroundView:(BackgroundViewType)type{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSNumber *customType = [user objectForKey:kUserSetBackgroundView];
    if (customType.integerValue != BackgroundViewTypeAuto) {
        type = customType.integerValue;
    }
    [self _deallocBackgroundViews];
    switch (type) {
        case 1:
        {
            //晴天背景
            self.sunnyView = [[[NSBundle mainBundle] loadNibNamed:@"SunnyView" owner:nil options:nil] firstObject];
            [self.view insertSubview:_sunnyView belowSubview:_weatherDetailView];
            [self.sunnyView addAnimation];
            
            [user setObject:@(BackgroundViewTypeSunny) forKey:kBackgroundView];
        }
            break;
        case 2:
        {
            self.shadeView = [[[NSBundle mainBundle] loadNibNamed:@"ShadeView" owner:nil options:nil] firstObject];
            [self.view insertSubview:_shadeView belowSubview:_weatherDetailView];
            
            [user setObject:@(BackgroundViewTypeShade) forKey:kBackgroundView];
            
        }
            break;
        case 3:
        {
            //下雨背景
            self.rainyView = [[[NSBundle mainBundle] loadNibNamed:@"RainyView" owner:nil options:nil] firstObject];
            [self.view insertSubview:_rainyView belowSubview:_weatherDetailView];
            
            [self.rainyView addAnimation];
            
            [user setObject:@(BackgroundViewTypeRainy) forKey:kBackgroundView];
            
        }
            break;
        case 4:
        {
            //下雪背景
            self.snowyView = [[[NSBundle mainBundle] loadNibNamed:@"SnowyView" owner:nil options:nil] firstObject];
            [self.view insertSubview:_snowyView belowSubview:_weatherDetailView];
            
            [self.snowyView addAnimation];
            
            [user setObject:@(BackgroundViewTypeSnowy) forKey:kBackgroundView];
            
        }
            break;
        case 5:
        {
            //夜晚晴天背景
            self.nightSunnyView = [[[NSBundle mainBundle] loadNibNamed:@"NightSunnyView" owner:nil options:nil] firstObject];
            [self.view insertSubview:_nightSunnyView belowSubview:_weatherDetailView];
            
            [self.nightSunnyView addAnimation];
            
            [user setObject:@(BackgroundViewTypeSnowy) forKey:kBackgroundView];
            
        }
            break;
        case 6:{
            
            self.nightRainyView = [[[NSBundle mainBundle] loadNibNamed:@"NightRainyView" owner:nil options:nil] firstObject];
            [self.view insertSubview:_nightRainyView belowSubview:_weatherDetailView];
            
            [self.nightRainyView addAnimation];
            
            [user setObject:@(BackgroundViewTypeSnowy) forKey:kBackgroundView];
            
        }
            break;
        case 7:{
            
            self.nightSnowyView = [[[NSBundle mainBundle] loadNibNamed:@"NightSnowyView" owner:nil options:nil] firstObject];
            [self.view insertSubview:_nightSnowyView belowSubview:_weatherDetailView];
            
            [self.nightSnowyView addAnimation];
            
        }
        default:
            
            break;
    }
}

- (void)_deallocBackgroundViews{
    [self.sunnyView removeFromSuperview];
    [self.shadeView removeFromSuperview];
    [self.rainyView removeFromSuperview];
    [self.snowyView removeFromSuperview];
    [self.nightSunnyView removeFromSuperview];
    [self.nightRainyView removeFromSuperview];
    [self.nightSnowyView removeFromSuperview];
    self.sunnyView = nil;
    self.shadeView = nil;
    self.rainyView = nil;
    self.snowyView = nil;
    self.nightSunnyView = nil;
    self.nightRainyView = nil;
    self.nightSnowyView = nil;
}

#pragma mark -- 定位按钮方法与代理方法--
- (void)handleLocateButtonAction:(UIButton *)sender{
    
    self.isLocationButton = YES;
    networkReachablity();
}

- (void)_startLocating{
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位服务不可用，请在设置中开启定位！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self showViewController:alert sender:nil];
        return;
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10.0f;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.dimBackground = YES;
    _hud.labelText = @"正在获取位置...";
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    [manager stopUpdatingLocation];
    
    CLLocation *location = locations[0];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            
            self.currentCity = [self _deleteSuffix:test[@"City"]];
            self.currentCounty = [self _deleteSuffix:test[@"SubLocality"]];
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:self.currentCity forKey:kLocatedCity];
            [user setObject:self.currentCounty forKey:kLocatedCounty];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hide:YES];
            });
            
            [self.weatherDetailView.mainScrollView.header setState:MJRefreshStateRefreshing];
        }
    }];
}


- (NSString *)_deleteSuffix:(NSString *)name{
    if (name.length > 2) {
        BOOL b1 = [name containsString:@"市"];
        BOOL b2 = [name containsString:@"区"];
        BOOL b3 = [name containsString:@"县"];
        if (b1 || b2 || b3) {
            NSInteger length = name.length;
            return [name substringToIndex:length - 1];
        }
    }
    return name;
}


- (WeatherInfoModel *)_getHistoryRecord{
    
    WeatherInfoModel *infoModel = [self.fmdbHelper selectCurrentCityWeatherInfoWithCityName:self.currentCity];
    if (infoModel.jsonData == nil) {
        return nil;
    }
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:infoModel.jsonData options:NSJSONReadingAllowFragments error:nil];
    if ([jsonDic[@"errMsg"] isEqualToString:@"success"]) {
        [self _parserWithData:jsonDic fromHistory:YES];
    }
    return infoModel;
}

#pragma mark -- Network --

- (void)_connectToGetDataWithCityName:(NSString *)cityName
                           countyName:(NSString *)countyName{
    if (cityName == nil || countyName == nil) {
        return;
    }
    [self.helper getRequestMethodWithURL:kWeatherAPI parameter:kWeatherAPIParam(countyName)];
    self.helper.dataBlock = ^(NSData *data){
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (![jsonDic[@"errMsg"] isEqualToString:@"success"]) {
            [self.helper getRequestMethodWithURL:kWeatherAPI parameter:kWeatherAPIParam(cityName)];
            self.helper.dataBlock = ^(NSData *data){
                NSDictionary *jsonDicTemp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if (![jsonDicTemp[@"errMsg"] isEqualToString:@"success"]) {
                    return ;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self _databaseOperationWithCityName:cityName data:data];
                    
                    [self _parserWithData:jsonDicTemp fromHistory:NO];
                });
                
            };
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _databaseOperationWithCityName:countyName data:data];
            
            [self _parserWithData:jsonDic fromHistory:NO];
        });
        
    };
    
}

- (void)_databaseOperationWithCityName:(NSString *)cityName
                                  data:(NSData *)data{
    
    WeatherInfoModel *historyInfoModel = [self.fmdbHelper selectCurrentCityWeatherInfoWithCityName:cityName];
    if (historyInfoModel) {
        if (![historyInfoModel.jsonData isEqualToData:data]) {
            WeatherInfoModel *infoModel = [WeatherInfoModel new];
            infoModel.cityName = cityName;
            infoModel.jsonData = data;
            infoModel.updateTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
            [self.fmdbHelper updateCurrentCityWeatherInfoWithModel:infoModel];
            [self _settingPublishTimeLabel:infoModel];
            return;
        }
        [self _settingPublishTimeLabel:historyInfoModel];
    }else {
        WeatherInfoModel *infoModel = [WeatherInfoModel new];
        infoModel.cityName = cityName;
        infoModel.jsonData = data;
        infoModel.updateTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        [self.fmdbHelper insertCurrentCityWeatherInfoWithModel:infoModel];
        [self _settingPublishTimeLabel:infoModel];
    }
}

- (void)_parserWithData:(NSDictionary *)jsonDic fromHistory:(BOOL)fromHistory{
    self.dataModel = [WeatherDataModel new];
    NSDictionary *retDataDic = jsonDic[@"retData"];
    [_dataModel setValuesForKeysWithDictionary:retDataDic];
    _dataModel.todayWeatherDetail = [WeatherDetailModel new];
    NSDictionary *todayDic = retDataDic[@"today"];
    [_dataModel.todayWeatherDetail setValuesForKeysWithDictionary:todayDic];
    _dataModel.todayWeatherDetail.indexArray = [NSMutableArray array];
    NSArray *index = todayDic[@"index"];
    for (int i = 0; i < index.count; i++) {
        LifeIndexModel *indexModel = [LifeIndexModel new];
        [indexModel setValuesForKeysWithDictionary:index[i]];
        [_dataModel.todayWeatherDetail.indexArray addObject:indexModel];
    }
    NSArray *forecastArray = retDataDic[@"forecast"];
    _dataModel.forecastArray = [NSMutableArray array];
    for (int i = 0; i < forecastArray.count; i++) {
        WeatherDetailModel *detailModel = [WeatherDetailModel new];
        [detailModel setValuesForKeysWithDictionary:forecastArray[i]];
        [_dataModel.forecastArray addObject:detailModel];
    }
    
    [self.weatherDetailView updateDataWithModel:_dataModel fromHistory:fromHistory];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *currentWeatherType = [user objectForKey:kCurrentWeatherType];
    BOOL b = [_dataModel.todayWeatherDetail.type isEqualToString:currentWeatherType];
    [user setObject:_dataModel.todayWeatherDetail.type forKey:kCurrentWeatherType];
    [_weatherDetailView.mainScrollView.header endRefreshing];
    if (b) {
        return;
    }
    [self _loadBackgroundView:[self _weatherConditionToBackgroundViewType:_dataModel.todayWeatherDetail.type]];
}



#pragma mark -- 天气状况转换为对应枚举值 --

- (BackgroundViewType)_weatherConditionToBackgroundViewType:(NSString *)weatherCondition{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH";
    NSString *time = [formatter stringFromDate:[NSDate date]];
    BOOL isDaylight = NO;
    if (time.integerValue > 6 && time.integerValue < 18) {
        isDaylight = YES;
    }
    if ([weatherCondition isEqualToString:@"晴"] || [weatherCondition isEqualToString:@"多云"]) {
        if (isDaylight) {
            return BackgroundViewTypeSunny;
        }
        return BackgroundViewTypeNightSunny;
    }else if ([weatherCondition isEqualToString:@"阴"] || [weatherCondition containsString:@"霾"]){
        return BackgroundViewTypeShade;
    }else if ([weatherCondition containsString:@"雨"]){
        if (isDaylight) {
            return BackgroundViewTypeRainy;
        }
        return BackgroundViewTypeNightRainy;
    }else if ([weatherCondition containsString:@"雪"]){
        if (isDaylight) {
            return BackgroundViewTypeSnowy;
        }
        return BackgroundViewTypeNightSnowy;
    }
    return BackgroundViewTypeShade;
}

#pragma mark -- 发布时间计算与显示 --
- (void)_settingPublishTimeLabel:(WeatherInfoModel *)infoModel{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] - infoModel.updateTime.doubleValue;
    _weatherDetailView.publishTimeLabel.text = [self _calculateTimeInterval:timeInterval];
}

- (NSString *)_calculateTimeInterval:(NSTimeInterval)timeInterval{
    if (timeInterval < 60) {
        return [NSString stringWithFormat:@"刚刚发布"];
    }else if (timeInterval >= 60 && timeInterval < 3600){
        return [NSString stringWithFormat:@"%d分钟前发布",(int)timeInterval / 60];
    }else if (timeInterval >= 3600 && timeInterval < 3600 * 24){
        return [NSString stringWithFormat:@"%d小时前发布", (int)timeInterval / 3600];
    }else{
        return [NSString stringWithFormat:@"%d天前发布",(int)timeInterval / 3600 / 24];
    }
}






#pragma mark -- 跳转传值 --
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UINavigationController *navi = [segue destinationViewController];
    CityManagerController *cityManagerVC = [navi.viewControllers firstObject];
    cityManagerVC.cityNameBlock = ^(NSString *cityName, NSString *countyName){
        if ([self.currentCounty isEqualToString:countyName] || [self.currentCity isEqualToString:cityName]) {
            return ;
        }
        self.currentCounty = countyName;
        self.currentCity = cityName;
        
        [_weatherDetailView.mainScrollView.header setState:MJRefreshStateRefreshing];
    };
}

- (void)weatherDetailViewModalNavigationController:(UIView *)weatherDetailView{
    
    [self performSegueWithIdentifier:@"modalSegue" sender:self];
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end















