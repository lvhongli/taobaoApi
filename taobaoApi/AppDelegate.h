//
//  AppDelegate.h
//  taobaoApi
//
//  Created by zifeng on 13-9-4.
//  Copyright (c) 2013年 zifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITracker.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) id<GAITracker> tracker;

@end
