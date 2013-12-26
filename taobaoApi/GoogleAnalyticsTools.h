//
//  GoogleAnalyticsTools.h
//  taobaoApi
//
//  Created by zifeng on 13-12-26.
//  Copyright (c) 2013年 zifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoogleAnalyticsTools : NSObject

+ (void)updateSearchEvent:(NSString *)screenName searchKey:(NSString *)searchKey;

@end
