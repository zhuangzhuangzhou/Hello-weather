//
//  FMDatabaseHelper.m
//  weatherApp
//
//  Created by xalo on 15/10/12.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "FMDatabaseHelper.h"
#import <FMDatabase.h>
#import "WeatherInfoModel.h"

@implementation FMDatabaseHelper

+ (id)shareInstance{
    static FMDatabaseHelper *helper = nil;
    if (!helper) {
       
        helper = [[FMDatabaseHelper alloc] init];
            
    }
    
    
    return helper;
}

- (NSString *)_getDatabasePath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", documentPath);
    return [documentPath stringByAppendingPathComponent:@"database.db"];
}

- (BOOL)insertCurrentCityWeatherInfoWithModel:(WeatherInfoModel *)model{
//    NSString *databasePath = [self _getDatabasePath];
//    FMDatabase *fmdb = [FMDatabase databaseWithPath:databasePath];
//    if (![fmdb open]) {
//        return NO;
//    }
//    BOOL createTableRes = [fmdb executeUpdate:@"create table if not exists CurrentCity (cityName text unique, jsonData blob, updateTime double)"];
//    if (createTableRes) {
//        BOOL insertRes = [fmdb executeUpdate:@"insert into CurrentCity (cityName, jsonData, updateTime) values (?,?,?)", model.cityName, model.jsonData, model.updateTime];
//        [fmdb close];
//        if (insertRes) {
//            return YES;
//        }
//    }
//    return NO;
    
    return [self insertFocusedCityWeatherInfoWithModel:model];
    
}

- (BOOL)updateCurrentCityWeatherInfoWithModel:(WeatherInfoModel *)model{
//    NSString *databasePath = [self _getDatabasePath];
//    FMDatabase *fmdb = [FMDatabase databaseWithPath:databasePath];
//    if (![fmdb open]) {
//        return NO;
//    }
//    BOOL updateRes = [fmdb executeUpdate:@"update CurrentCity set cityName = ?, jsonData = ?, updateTime = ?",model.cityName, model.jsonData, model.updateTime];
//    [fmdb close];
//    if (updateRes) {
//        return YES;
//    }
//    return NO;
    return [self updateFocusedCityWeatherInfoWithModel:model];
}

- (WeatherInfoModel *)selectCurrentCityWeatherInfoWithCityName:(NSString *)cityName{
//    NSString *databasePath = [self _getDatabasePath];
//    FMDatabase *fmdb = [FMDatabase databaseWithPath:databasePath];
//    if (![fmdb open]) {
//        return nil;
//    }
//    FMResultSet *result = [fmdb executeQuery:@"select * from CurrentCity"];
//    while ([result next]) {
//        WeatherInfoModel *model = [WeatherInfoModel new];
//        model.cityName = [result stringForColumn:@"cityName"];
//        model.jsonData = [result dataForColumn:@"jsonData"];
//        model.updateTime = [NSNumber numberWithDouble:[result doubleForColumn:@"updateTime"]];
//        [fmdb close];
//        return model;
//    }
//    return nil;
    return [[self selectFocusedCityWeatherInfoWithCityName:cityName] firstObject];
}


- (BOOL)insertFocusedCityWeatherInfoWithModel:(WeatherInfoModel *)model{
    NSString *databasePath = [self _getDatabasePath];
    FMDatabase *fmdb = [FMDatabase databaseWithPath:databasePath];
    if (![fmdb open]) {
        return NO;
    }
    BOOL createTableRes = [fmdb executeUpdate:@"create table if not exists FocusedCity (cityName text unique, jsonData blob, updateTime double)"];
    if (createTableRes) {
        BOOL insertRes = [fmdb executeUpdate:@"insert into FocusedCity (cityName, jsonData, updateTime) values (?,?,?)", model.cityName, model.jsonData, model.updateTime];
        [fmdb close];
        if (insertRes) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)updateFocusedCityWeatherInfoWithModel:(WeatherInfoModel *)model{
    NSString *databasePath = [self _getDatabasePath];
    FMDatabase *fmdb = [FMDatabase databaseWithPath:databasePath];
    if (![fmdb open]) {
        return NO;
    }
    BOOL updateRes = [fmdb executeUpdate:@"update FocusedCity set jsonData = ?, updateTime = ? where cityName = ?", model.jsonData, model.updateTime, model.cityName];
    [fmdb close];
    if (updateRes) {
        return YES;
    }
    return NO;
}


- (NSArray *)selectFocusedCityWeatherInfoWithCityName:(NSString *)cityName{
    NSString *databasePath = [self _getDatabasePath];
    FMDatabase *fmdb = [FMDatabase databaseWithPath:databasePath];
    if (![fmdb open]) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    if (cityName == nil) {
        FMResultSet *result = [fmdb executeQuery:@"select * from FocusedCity"];
        
        while ([result next]) {
            WeatherInfoModel *model = [WeatherInfoModel new];
            model.cityName = [result stringForColumn:@"cityName"];
            model.jsonData = [result dataForColumn:@"jsonData"];
            model.updateTime = [NSNumber numberWithDouble:[result doubleForColumn:@"updateTime"]];
            [array addObject:model];
        }
        [fmdb close];
        return array;
    }else{
        FMResultSet *result = [fmdb executeQuery:@"select * from FocusedCity where cityName = ?",cityName];
        while ([result next]) {
            WeatherInfoModel *model = [WeatherInfoModel new];
            model.cityName = [result stringForColumn:@"cityName"];
            model.jsonData = [result dataForColumn:@"jsonData"];
            model.updateTime = [NSNumber numberWithDouble:[result doubleForColumn:@"updateTime"]];
            [array addObject:model];
        }
        return array;
    }
    
}

- (BOOL)deleteFocusedCityWeatherInfoWithCityName:(NSString *)cityName{
    NSString *databasePath = [self _getDatabasePath];
    FMDatabase *fmdb = [FMDatabase databaseWithPath:databasePath];
    if (![fmdb open]) {
        return NO;
    }
    BOOL deleteRes = [fmdb executeUpdate:@"delete from FocusedCity where cityName = ?", cityName];
    if (deleteRes) {
        return YES;
    }
    
    
    return NO;
}

@end























