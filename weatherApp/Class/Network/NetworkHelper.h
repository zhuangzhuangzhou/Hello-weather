//
//  NetworkHelper.h
//  Lesson-UI-18-NetWork
//
//  Created by xalo on 15/8/26.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkHelperDelegate <NSObject>

- (void)netWorkHelperWithDictionary:(NSDictionary *)dic;

@end

typedef void(^DataBlock)(id);

@interface NetworkHelper : NSObject



@property (nonatomic, copy) DataBlock dataBlock;

@property (nonatomic, copy) void(^imageDataBlock)(id);

+ (id)sharedInstance;

//get请求
//@parameter 请求所需的参数
- (void)getRequestMethodWithURL:(NSString *)urlStr
                      parameter:(NSString *)parameter;

//post请求
- (void)postRequestMethodWithURL:(NSString *)urlStr
                       parameter:(NSString *)parameter;


@end
