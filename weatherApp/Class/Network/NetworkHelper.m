//
//  NetworkHelper.m
//  Lesson-UI-18-NetWork
//
//  Created by xalo on 15/8/26.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "NetworkHelper.h"

@interface NetworkHelper ()



@end

@implementation NetworkHelper




+ (id)sharedInstance{
    static NetworkHelper *helper = nil;
//    @synchronized (self) {
//        if (!helper) {
//            helper = [[NetworkHelper alloc] init];
//        }
//    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!helper) {
            helper = [[NetworkHelper alloc] init];
        }
    });
    
    return helper;
}


- (void)getRequestMethodWithURL:(NSString *)urlStr parameter:(NSString *)parameter{
    
    //判断请求是否有parameter,如果有，urlStr需要拼接parameter；
    NSMutableString *urlMutableString = [NSMutableString stringWithString:urlStr];
    if (parameter) {
        [urlMutableString appendFormat:@"?%@", parameter];
    }
    NSString *utfURL = [urlMutableString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //创建url
    NSURL *url = [NSURL URLWithString:utfURL];
    
    //创建request
   // NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"dd045dc13feba5ede5fa8257ccc075b9" forHTTPHeaderField: @"apikey"];
    
    
//    //创建同步连接
//    NSError *error;
//    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//    //解析请求回来的json的值
//    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    
    //创建异步连接
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            return;
        }
        self.dataBlock(data);
    }];
}



- (void)postRequestMethodWithURL:(NSString *)urlStr parameter:(NSString *)parameter{
    
    NSString *utfURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:utfURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            return;
        }
        self.dataBlock(data);
        
    }];
}



@end

























