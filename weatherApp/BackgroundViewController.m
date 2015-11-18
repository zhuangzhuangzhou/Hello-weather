//
//  BackgroundViewController.m
//  weatherApp
//
//  Created by xalo on 15/10/16.
//  Copyright © 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "BackgroundViewController.h"
#import "PrefixHeader.pch"
#import <RESideMenu.h>
#import "BackgroundViewCell.h"
#import "SunnyBackgroundView.h"

@interface BackgroundViewController ()<UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation BackgroundViewController

static NSString * const reuseIdentifier = @"Cell";

- (NSMutableArray *)datasource{
    if (!_datasource) {
        self.datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imageView.image = [UIImage imageNamed:@"selectionBg"];
    [self.view insertSubview:imageView belowSubview:_collectionView];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"selectionBg"]];
    
    [self.collectionView registerClass:[BackgroundViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i < 8; i++) {
        [self.datasource addObject:[UIImage imageNamed:[NSString stringWithFormat:@"bg%d",i]]];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleBackAction:(UIBarButtonItem *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.sideMenuViewController hideMenuViewController];
    
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float itemWidth = (kScreenWidth - 60) / 3;
    CGSize size = CGSizeMake(itemWidth, itemWidth * (1136.0 / 667));
    return size;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BackgroundViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    cell.backgroundImageView.image = self.datasource[indexPath.row];
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSNumber *type = [user objectForKey:kUserSetBackgroundView];
    if (type.integerValue == indexPath.item) {
        cell.currentLabel.hidden = NO;
    }else {
        cell.currentLabel.hidden = YES;
    }
    
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    switch (indexPath.row) {
        case 0:
            [user setObject:@(BackgroundViewTypeAuto) forKey:kUserSetBackgroundView];
            break;
        case 1:
            [user setObject:@(BackgroundViewTypeSunny) forKey:kUserSetBackgroundView];
            break;
        case 2:
            [user setObject:@(BackgroundViewTypeShade) forKey:kUserSetBackgroundView];
            break;
        case 3:
            [user setObject:@(BackgroundViewTypeRainy) forKey:kUserSetBackgroundView];
            break;
        case 4:
            [user setObject:@(BackgroundViewTypeSnowy) forKey:kUserSetBackgroundView];
            break;
        case 5:
            [user setObject:@(BackgroundViewTypeNightSunny) forKey:kUserSetBackgroundView];
            break;
        case 6:
            [user setObject:@(BackgroundViewTypeNightRainy) forKey:kUserSetBackgroundView];
            break;
        case 7:
            [user setObject:@(BackgroundViewTypeNightSnowy) forKey:kUserSetBackgroundView];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kBackgroundChangedNotification object:nil];
    }];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
