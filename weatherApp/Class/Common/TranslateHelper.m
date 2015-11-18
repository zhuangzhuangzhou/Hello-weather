//
//  TranslateHelper.m
//  Homework-UI-10
//
//  Created by xalo on 15/8/22.
//  Copyright (c) 2015年 西安蓝鸥科技有限公司. All rights reserved.
//

#import "TranslateHelper.h"

@implementation TranslateHelper

//汉字转拼音
+ (NSString *)hanziToPinyin:(NSString *)hanzi{
    NSMutableString *tempHanzi = [NSMutableString stringWithString:hanzi];
    CFStringTransform((CFMutableStringRef)tempHanzi, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)tempHanzi, NULL, kCFStringTransformStripDiacritics, NO);
    return [[tempHanzi stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
}

@end
