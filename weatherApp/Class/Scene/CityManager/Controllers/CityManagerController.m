 //
//  CityManagerController.m
//  weatherApp
//
//  Created by xalo on 15/10/10.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "CityManagerController.h"
#import "CityManagerCell.h"
#import "CityAddCell.h"
#import "PrefixHeader.pch"
#import "CitySearchController.h"
#import "WeatherDataModel.h"
#import "WeatherDetailModel.h"
#import <MJRefresh.h>

@interface CityManagerController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSMutableArray *infoModelArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NetworkHelper *helper;
@property (nonatomic, strong) FMDatabaseHelper *fmdbHelper;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) UIView *menuView;

@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, strong) NSString *currentCounty;
@property (nonatomic, assign) BOOL isUpdating;

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation CityManagerController

- (NSMutableArray *)datasource{
    if (!_datasource) {
        self.datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (NSMutableArray *)infoModelArray{
    if (!_infoModelArray) {
        self.infoModelArray = [NSMutableArray array];
    }
    return _infoModelArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.helper = [NetworkHelper sharedInstance];
    self.fmdbHelper = [FMDatabaseHelper shareInstance];
    
    
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgImage.image = [UIImage imageNamed:@"cityManager.jpg"];
    [self.view addSubview:bgImage];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    [self _getHistoryRecord];
    
    
    self.formatter = [[NSDateFormatter alloc] init];
    _formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkReachabilityNotification:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
}



- (void)_getHistoryRecord{
    [self.infoModelArray setArray:[self.fmdbHelper selectFocusedCityWeatherInfoWithCityName:nil]];
    for (int i = 0; i < self.infoModelArray.count; i++) {
        WeatherInfoModel *model = self.infoModelArray[i];
        if (model.jsonData == nil) {
            break;
        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:model.jsonData options:NSJSONReadingAllowFragments error:nil];
        if ([jsonDic[@"errMsg"] isEqualToString:@"success"]) {
            [self _parserWithData:model.jsonData jsonDic:jsonDic fromHistory:YES isUpdating:NO];
        }
        
    }
}

#pragma mark -- Pass Value --
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CitySearchController *citySearchVC = [segue destinationViewController];
    citySearchVC.cityNameBlock = ^(NSString *cityName, NSString *countyName){
        NSLog(@"%@",cityName);
        for (int i = 0; i < self.datasource.count; i++) {
            if ([[self.datasource[i] city] isEqualToString:cityName] || [[self.datasource[i] city] isEqualToString:countyName]) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                return ;
            }
        }
        
        self.currentCity = cityName;
        self.currentCounty = countyName;
        self.isUpdating = NO;
        networkReachablity();
    };
}


#pragma mark -- Network --
- (void)handleNetworkReachabilityNotification:(NSNotification *)sender{
    if ([sender.object isEqualToString:@"NotReachable"]) {
        alertWithCancelButton(self.navigationController, @"网络连接错误！");
    }else if ([sender.object isEqualToString:@"Reachable"]){
        [self _connectToGetDataWithCityName:self.currentCity countyName:self.currentCounty isUpdating:self.isUpdating];
    }
}

- (void)_connectToGetDataWithCityName:(NSString *)cityName
                           countyName:(NSString *)countyName
                           isUpdating:(BOOL)isUpdating{
    
    
    if (cityName == nil || countyName == nil) {
        return;
    }
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.dimBackground = YES;
    _hud.labelText = @"正在获取天气数据...";
    
    [self.helper getRequestMethodWithURL:kWeatherAPI parameter:kWeatherAPIParam(countyName)];
    
    
    self.helper.dataBlock = ^(NSData *data){
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (![jsonDic[@"errMsg"] isEqualToString:@"success"]) {
            [self.helper getRequestMethodWithURL:kWeatherAPI parameter:kWeatherAPIParam(cityName)];
            self.helper.dataBlock = ^(NSData *data){
                NSDictionary *jsonDicTemp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                
                //[self _databaseOperationWithCityName:cityName data:data isUpdating:isUpdating];
                [self _parserWithData:data jsonDic:jsonDicTemp fromHistory:NO isUpdating:isUpdating];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.hud hide:YES];
                    
                });
                
            };
            return;
        }
        
        
        //[self _databaseOperationWithCityName:countyName data:data isUpdating:isUpdating];
        [self _parserWithData:data jsonDic:jsonDic fromHistory:NO isUpdating:isUpdating];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.hud hide:YES];
        });
        
    };
    
}






- (void)_parserWithData:(NSData *)data jsonDic:(NSDictionary *)jsonDic fromHistory:(BOOL)fromHistory isUpdating:(BOOL)isUpdating{
    WeatherDataModel *dataModel = [WeatherDataModel new];
    NSDictionary *retDataDic = jsonDic[@"retData"];
    [dataModel setValuesForKeysWithDictionary:retDataDic];
    dataModel.todayWeatherDetail = [WeatherDetailModel new];
    NSDictionary *todayDic = retDataDic[@"today"];
    [dataModel.todayWeatherDetail setValuesForKeysWithDictionary:todayDic];
    
    [self _databaseOperationWithCityName:dataModel.city data:data isUpdating:isUpdating];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (fromHistory) {
            [self.datasource addObject:dataModel];
            [self.tableView reloadData];
        }else{
            if (isUpdating) {
                for (int i = 0; i < self.datasource.count; i++) {
                    if ([dataModel.city isEqualToString:[self.datasource[i] city]]) {
                        [self.datasource removeObjectAtIndex:i];
                        [self.datasource insertObject:dataModel atIndex:i];
                        [self.tableView reloadData];
                        break;
                    }
                }
                
            }else{
                [self.datasource addObject:dataModel];
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datasource.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.datasource.count inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
        }

    });
    
}


- (void)_databaseOperationWithCityName:(NSString *)cityName
                                  data:(NSData *)data
                            isUpdating:(BOOL)isUpdating{
    
    WeatherInfoModel *historyInfoModel = [[self.fmdbHelper selectFocusedCityWeatherInfoWithCityName:cityName] firstObject];
    if (isUpdating) {
        if (![historyInfoModel.jsonData isEqualToData:data]) {
            WeatherInfoModel *infoModel = [WeatherInfoModel new];
            infoModel.cityName = cityName;
            infoModel.jsonData = data;
            infoModel.updateTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
            [self.fmdbHelper updateFocusedCityWeatherInfoWithModel:infoModel];
            [self.infoModelArray setArray:[self.fmdbHelper selectFocusedCityWeatherInfoWithCityName:nil]];
        }
    }else {
        WeatherInfoModel *infoModel = [WeatherInfoModel new];
        infoModel.cityName = cityName;
        infoModel.jsonData = data;
        
        infoModel.updateTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        [self.fmdbHelper insertFocusedCityWeatherInfoWithModel:infoModel];
        [self.infoModelArray setArray:[self.fmdbHelper selectFocusedCityWeatherInfoWithCityName:nil]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.datasource.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.datasource.count) {
        CityAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addCell"];
        cell.cellImageView.image = [self createImageWithColor:[UIColor blackColor]];
        return cell;
    }
//    CityManagerCell *cell = (CityManagerCell *)[tableView cellForRowAtIndexPath:indexPath];
//    if (!cell) {
//        cell = [[CityManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normalCell"]; 
//    }
    CityManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
    //cell.cellImageVIew.image = [self createImageWithColor:[UIColor blackColor]];
    
    if (indexPath.row < self.infoModelArray.count) {
        cell.publishTimeLabel.text = [self _calculateTimeInterval:[[NSDate date] timeIntervalSince1970] - [self.infoModelArray[indexPath.row] updateTime].doubleValue];
    }
    
    WeatherDataModel *dataModel = self.datasource[indexPath.row];
    [cell configCellWithModel:dataModel];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureAction:)];
    [cell addGestureRecognizer:longPress];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *cityName = [user objectForKey:kLocatedCity];
    NSString *countyName = [user objectForKey:kLocatedCounty];
    NSString *currentCity = [user objectForKey:kCurrentCity];
    
    if ([dataModel.city isEqualToString:cityName] || [dataModel.city isEqualToString:countyName]) {
        cell.locateImageView.image = [UIImage imageNamed:@"locate_icon.png"];
        cell.locateImageView.hidden = NO;
    }else{
        cell.locateImageView.hidden = YES;
    }
    if ([dataModel.city isEqualToString:currentCity]) {
        cell.currentLabel.hidden = NO;
    }else{
        cell.currentLabel.hidden = YES;
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.datasource.count) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.fmdbHelper deleteFocusedCityWeatherInfoWithCityName:[self.datasource[indexPath.row] city]];
        
        [self.datasource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.datasource.count) {
        return;
    }
    NSString *cityName = [self.datasource[indexPath.row] city];
    self.cityNameBlock(cityName, cityName);
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -- Handle Action --

- (void)handleLongPressGestureAction:(UILongPressGestureRecognizer *)sender{
    if (self.menuView) {
        return;
    }
    CityManagerCell *cell = (CityManagerCell *)sender.view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 80) / 2, cell.contentView.frame.size.height / 2, 80, 80)];
    _menuView.backgroundColor = [UIColor blackColor];
    
    [self animationFadeIn:_menuView];
    [cell.contentView addSubview:_menuView];
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
    refreshButton.frame = CGRectMake(0, 0, 80, 40);
    [refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(handleRefreshButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    refreshButton.tag = 100 + indexPath.row;
    [_menuView addSubview:refreshButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteButton.frame = CGRectMake(0, 40, 80, 40);
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(handleDeleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.tag = 200 + indexPath.row;
    [_menuView addSubview:deleteButton];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureAction:)];
    [self.view addGestureRecognizer:tap];
    
    
}

- (void)handleTapGestureAction:(UITapGestureRecognizer *)tap{
    [self.menuView removeFromSuperview];
    self.menuView = nil;
    [self.view removeGestureRecognizer:tap];
}

- (void)handleRefreshButtonAction:(UIButton *)sender{
    NSInteger rowNum = sender.tag - 100;
    NSString *cityName = [self.datasource[rowNum] city];
    [self.menuView removeFromSuperview];
    self.menuView = nil;
    self.currentCity = cityName;
    self.currentCounty = cityName;
    self.isUpdating = YES;
    networkReachablity();
}

- (void)handleDeleteButtonAction:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag - 200 inSection:0];
    [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    [self.menuView removeFromSuperview];
    self.menuView = nil;
}


- (IBAction)handleBackAction:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)animationFadeIn:(UIView *)view{
    CABasicAnimation *position = [CABasicAnimation animation];
    position.keyPath = @"scale.y";
    position.duration = 0.618;
    position.fromValue = @0;
    position.toValue = @1;
    [view.layer addAnimation:position forKey:nil];
    
    CABasicAnimation *opacity = [CABasicAnimation animation];
    opacity.keyPath = @"opacity";
    opacity.duration = 0.618;
    opacity.fromValue = @0;
    opacity.toValue = @1;
    [view.layer addAnimation:opacity forKey:nil];
}

- (NSString *)_calculateTimeInterval:(NSTimeInterval)timeInterval{
    if (timeInterval < 60) {
        return [NSString stringWithFormat:@"刚刚更新"];
    }else if (timeInterval >= 60 && timeInterval < 3600){
        return [NSString stringWithFormat:@"%d分钟前更新",(int)timeInterval / 60];
    }else if (timeInterval >= 3600 && timeInterval < 3600 * 24){
        return [NSString stringWithFormat:@"%d小时前更新", (int)timeInterval / 3600];
    }else{
        return [NSString stringWithFormat:@"%d天前更新",(int)timeInterval / 3600 / 24];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.menuView) {
        [self.menuView removeFromSuperview];
        self.menuView = nil;
    }
}

-(UIImage *) createImageWithColor: (UIColor *) color
{
    // 描述矩形
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return theImage;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
