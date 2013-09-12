//
//  UIYoukuDictionary.h
//  taobaoApi
//
//  Created by zifeng on 13-9-11.
//  Copyright (c) 2013年 zifeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (youku)

- (NSArray *)videoArray;
- (NSString *)videoThumbnail;
- (NSString *)videoDuration;
- (NSString *)videoTitle;
- (NSString *)videoLink;

@end
