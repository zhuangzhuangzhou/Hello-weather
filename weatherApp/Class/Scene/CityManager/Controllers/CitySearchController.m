//
//  CitySearchController.m
//  weatherApp
//
//  Created by xalo on 15/10/10.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "CitySearchController.h"
#import "CityModel.h"
#import "PrefixHeader.pch"
#import "CityRecommendCell.h"
#import "SearchResultCell.h"
#import <CoreLocation/CoreLocation.h>

@interface CitySearchController ()<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, CityRecommendDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *countyArray;

@property (nonatomic, strong) NSMutableArray *searchList;

@property (nonatomic, strong) CLLocationManager *locationManager;


@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation CitySearchController

- (NSMutableArray *)addressArray{
    if (!_addressArray) {
        self.addressArray = [NSMutableArray array];
    }
    return _addressArray;
}

- (NSMutableArray *)cityArray{
    if (!_cityArray) {
        self.cityArray = [NSMutableArray array];
    }
    return _cityArray;
}

- (NSMutableArray *)searchList{
    if (!_searchList) {
        self.searchList = [NSMutableArray array];
    }
    return _searchList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imageView.image = [UIImage imageNamed:@"searchController.jpg"];
    [self.view addSubview:imageView];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //当搜索时隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = NO;
    //设置代理为self
    _searchController.searchResultsUpdater = self;
    //是否在搜索时使背景变暗
    _searchController.dimsBackgroundDuringPresentation = NO;
    //使搜索条自适应当前视图的尺寸
    [_searchController.searchBar sizeToFit];
    _searchController.searchBar.placeholder = @"搜索城市（中文/拼音）";
    [self.searchView addSubview:_searchController.searchBar];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    [NSThread detachNewThreadSelector:@selector(_getAddressInfo) toTarget:self withObject:nil];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hud.dimBackground = YES;
//    _hud.labelText = @"正在获取城市信息";
}

- (void)_getAddressInfo{
    
    
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *array = data[@"address"];
    for (NSDictionary *dic in array) {
        NSString *provinceName = dic[@"name"];
        NSArray *cityArray = dic[@"sub"];
        for (NSDictionary *cityDic in cityArray) {
            NSString *cityName = cityDic[@"name"];
            NSArray *countyArray = cityDic[@"sub"];
            for (NSString *countyName in countyArray) {
                CityModel *model = [CityModel new];
                if ([countyName isEqualToString:@"其他区"]) {
                    model.countyName = cityName;
                    model.countyNamePinyin = [TranslateHelper hanziToPinyin:cityName];
                    model.cityName = cityName;
                }else{
                    model.countyName = countyName;
                    model.countyNamePinyin = [TranslateHelper hanziToPinyin:countyName];
                    model.cityName = cityName;
                }
                model.provinceName = provinceName;
                [self.cityArray addObject:model];
            }
        }
    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.hud hide:YES];
//    });
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *filterString = searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(self.countyName contains[cd] %@) OR (self.countyNamePinyin contains[cd] %@)",filterString, filterString];
    NSArray *predicateArray = [self.cityArray filteredArrayUsingPredicate:predicate];
    [self.searchList setArray:predicateArray];
    [self.tableView reloadData];
}
- (IBAction)handleBackAction:(UIBarButtonItem *)sender {
    if (self.searchController.active) {
        self.searchController.active = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
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
    if (!self.searchController.active) {
        return 1;
    }
    // Return the number of rows in the section.
    return self.searchList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.searchController.active) {
        return 480;
    }
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.searchController.active) {
        CityRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityRecommendCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell" forIndexPath:indexPath];
    cell.cityLabel.text = [self.searchList[indexPath.row] countyName];
    cell.provinceLabel.text = [self.searchList[indexPath.row] provinceName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.searchController.active) {
        return;
    }
    CityModel *cityModel = self.searchList[indexPath.row];
    cityModel.countyName = [self _deleteSuffix:cityModel.countyName];
    cityModel.cityName = [self _deleteSuffix:cityModel.cityName];
    self.cityNameBlock(cityModel.cityName, cityModel.countyName);
    if (self.searchController.active) {
        self.searchController.active = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)recommendCityWithCityName:(NSString *)cityName{
    
    if ([cityName isEqualToString:@"自动定位"]) {
        
        [self _startLocating];
        
    }else {
        self.cityNameBlock(cityName, cityName);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)_startLocating{
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10.0f;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    [manager stopUpdatingLocation];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.dimBackground = YES;
    _hud.labelText = @"正在获取位置...";
    
    
    CLLocation *location = locations[0];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            NSString *currentCity = [self _deleteSuffix:test[@"City"]];
            NSString *currentCounty = [self _deleteSuffix:test[@"SubLocality"]];
            self.cityNameBlock(currentCity, currentCounty);
            
            [self.hud hide:YES];
            
            [self.navigationController popViewControllerAnimated:YES];
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
