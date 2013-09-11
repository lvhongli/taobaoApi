//
//  UIPhotoWebViewController.h
//  taobaoApi
//
//  Created by zifeng on 13-9-6.
//  Copyright (c) 2013年 zifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITaobaoWebViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) NSString *networkUrl;

@end
