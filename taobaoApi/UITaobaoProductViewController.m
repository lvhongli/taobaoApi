//
//  UITaobaoProductViewController.m
//  taobaoApi
//
//  Created by zifeng on 13-9-11.
//  Copyright (c) 2013年 zifeng. All rights reserved.
//

#import "UITaobaoProductViewController.h"
#import "TopIOSClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UITaobaoApiViewController.h"

@interface UITaobaoProductViewController ()

@end

@implementation UITaobaoProductViewController

@synthesize tableView = _tableView;
@synthesize tableList = _tableList;
@synthesize searchBar = _searchBar;

static NSString *nameKey = @"name";
static NSString *picKey = @"pic_url";
static NSString *pidKey = @"product_id";
static NSString *priceKey = @"price";
static NSString *imgsKey = @"product_imgs";
static NSString *propImgsKey = @"product_prop_imgs";

static float searchBarHeight = 44;
static NSInteger pageSize = 50;
static float cellHeight = 60;

- (void)productSearch
{
    NSString *searchKey = self.searchBar.text;
    if([searchKey length] == 0) {
        NSString *defaultKey = @"nine west 鞋";
        searchKey = defaultKey;
        self.searchBar.placeholder = defaultKey;
    }
    
    if(self.pageNo == 0) {
        self.pageNo = 1;
    } else {
        self.pageNo += 1;
    }
    
    TopIOSClient *iosClient = [TopIOSClient getIOSClientByAppKey:api_taobao_seller_key];
    [iosClient refreshTokenByUserId:api_taobao_uid];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"taobao.products.search" forKey:@"method"];
    [params setValue:[NSString stringWithFormat:@"%@,%@,%@,%@", nameKey, picKey, pidKey, priceKey] forKey:@"fields"];
    [params setValue:searchKey forKey:@"q"];
    [params setValue:[NSString stringWithFormat:@"%i", pageSize] forKey:@"page_size"];
    [params setValue:[NSString stringWithFormat:@"%i", self.pageNo] forKey:@"page_no"];
    
    TopApiResponse *response = [iosClient api:@"GET" params:params userId:api_taobao_uid];
    
    if([response error]) {
        NSLog(@"taobao.products.search api call result : %@", [response error]);
    } else {
        NSData *jsonData = [[response content] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        [tempArr addObjectsFromArray:self.tableList];
        [tempArr addObjectsFromArray:[[[result objectForKey:@"products_search_response"] objectForKey:@"products"] objectForKey:@"product"]];
        self.tableList = tempArr;
        [self.tableView reloadData];
    }
}

- (void)closeView
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)tableViewLoad
{
    float viewWidth = self.view.frame.size.width;
    float viewHeight = self.view.frame.size.height;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(searchBarHeight, 0, viewWidth - searchBarHeight, searchBarHeight)];
    self.searchBar.delegate = self;
    for(UIView *barView in self.searchBar.subviews) {
        if([barView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [barView removeFromSuperview];
        }
        if([barView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            UITextField *searchTextField = (UITextField *) barView;
            searchTextField.enablesReturnKeyAutomatically = NO;
        }
    }
    [self.view addSubview:self.searchBar];
    
    UILabel *backView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, searchBarHeight, searchBarHeight)];
    backView.text = @"X";
    backView.backgroundColor = [UIColor clearColor];
    backView.textAlignment = UITextAlignmentCenter;
    backView.font = [UIFont systemFontOfSize:24];
    backView.textColor = UIColorFromRGBWithAlpha(0xC8C8C8, 1.0);
    [self.view addSubview:backView];
    
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    [backView addGestureRecognizer:backViewTap];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, searchBarHeight, viewWidth, viewHeight - searchBarHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"table cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *data = [self.tableList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [data objectForKey:nameKey];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    
    cell.detailTextLabel.text = [data objectForKey:priceKey];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:[data objectForKey:picKey]]
                   placeholderImage:[UIImage imageNamed:@"skype.png"]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (NSArray *)getProduct:(NSString *)productId
{
    NSMutableArray *networkImgsList = [[NSMutableArray alloc] init];
    
    TopIOSClient *iosClient = [TopIOSClient getIOSClientByAppKey:api_taobao_seller_key];
    [iosClient refreshTokenByUserId:api_taobao_uid];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"taobao.product.get" forKey:@"method"];
    [params setValue:[NSString stringWithFormat:@"%@,%@,%@", picKey, imgsKey, propImgsKey] forKey:@"fields"];
    [params setValue:productId forKey:@"product_id"];
    
    TopApiResponse *response = [iosClient api:@"GET" params:params userId:api_taobao_uid];
    
    if([response error]) {
        NSLog(@"taobao.product.get api call result : %@", [response error]);
    } else {
        NSString *taobaoCdn = @"http://img01.taobaocdn.com/bao/uploaded/";
        
        NSData *jsonData = [[response content] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NSString *picUrl = [[[result objectForKey:@"product_get_response"] objectForKey:@"product"] objectForKey:@"pic_url"];
        
        if(picUrl != nil) {
            [networkImgsList addObject:picUrl];
        }
        
        NSArray *imgsList = [[[[result objectForKey:@"product_get_response"] objectForKey:@"product"] objectForKey:@"product_imgs"] objectForKey:@"product_img"];
        
        for(NSDictionary *img in imgsList){
            [networkImgsList addObject: [NSString stringWithFormat:@"%@%@", taobaoCdn, [img objectForKey:@"url"]]];
        }
        NSArray *propImgsList = [[[[result objectForKey:@"product_get_response"] objectForKey:@"product"] objectForKey:@"product_prop_imgs"] objectForKey:@"product_prop_img"];
        for(NSDictionary *img in propImgsList){
            [networkImgsList addObject: [NSString stringWithFormat:@"%@%@", taobaoCdn, [img objectForKey:@"url"]]];
        }
    }
    
    return networkImgsList;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = [self.tableList objectAtIndex:indexPath.row];
    
    NSString *pid = [data objectForKey:pidKey];
    NSArray *networkList = [self getProduct:pid];
    
    UITaobaoApiViewController *networkGallery = [[UITaobaoApiViewController alloc] init];
    networkGallery.networkGalleryArray = networkList;
    networkGallery.networkUrl = [NSString stringWithFormat:@"http://spu.tmall.com/spu_detail.htm?spu_id=%@", pid];
    [self presentViewController:networkGallery animated:YES completion:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // UITableView only moves in one direction, y axis
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0) {
        [self productSearch];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    self.pageNo = 0;
    self.tableList = nil;
    [self productSearch];
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // register ios client
    [TopIOSClient registerIOSClient:api_taobao_seller_key appSecret:api_taobao_seller_secret callbackUrl:@"appcallbackshopbaobei://" needAutoRefreshToken:TRUE];
    
    [self tableViewLoad];
    [self productSearch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
