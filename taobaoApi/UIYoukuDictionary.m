//
//  UIYoukuDictionary.m
//  taobaoApi
//
//  Created by zifeng on 13-9-11.
//  Copyright (c) 2013年 zifeng. All rights reserved.
//

#import "UIYoukuDictionary.h"

@implementation NSDictionary (youku)

- (NSArray *)videoArray
{
    return [self objectForKey:@"videos"];
}

- (NSString *)videoThumbnail
{
    return [self objectForKey:@"thumbnail"];
}

- (NSString *)videoDuration
{
    return [self objectForKey:@"duration"];
}

- (NSString *)videoTitle
{
    return [self objectForKey:@"title"];
}

- (NSString *)videoLink
{
    return [self objectForKey:@"link"];
}

@end
