//
//  GoogleAnalyticsTools.m
//  taobaoApi
//
//  Created by zifeng on 13-12-26.
//  Copyright (c) 2013年 zifeng. All rights reserved.
//

#import "GoogleAnalyticsTools.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"

@interface GoogleAnalyticsTools ()

@end

@implementation GoogleAnalyticsTools

+ (void)updateSearchEvent:(NSString *)screenName searchKey:(NSString *)searchKey
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"%@ 搜索", screenName]
                                                          action:@"搜索按钮"
                                                           label:searchKey
                                                           value:nil] build]];
}

@end
