//
//  UITaobaoProductViewController.h
//  taobaoApi
//
//  Created by zifeng on 13-9-11.
//  Copyright (c) 2013年 zifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface UITaobaoProductViewController : GAITrackedViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSArray *tableList;
@property(strong, nonatomic) UISearchBar *searchBar;
@property(assign, nonatomic) NSInteger pageNo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title;

@end
