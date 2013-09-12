//
//  UIYoukuSearchViewController.m
//  taobaoApi
//
//  Created by zifeng on 13-9-11.
//  Copyright (c) 2013年 zifeng. All rights reserved.
//

#import "UIYoukuSearchViewController.h"
#import "UIYoukuDictionary.h"
#import "UIWebViewController.h"

@interface UIYoukuSearchViewController ()

@end

@implementation UIYoukuSearchViewController

@synthesize tableView = _tableView;
@synthesize tableList = _tableList;
@synthesize searchBar = _searchBar;

static float searchBarHeight = 44;
static NSInteger pageSize = 50;
static float cellHeight = 60;

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
    
    cell.textLabel.text = [data videoTitle];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    
    int oneMinute = 60;
    int videoDuration = [[data videoDuration] integerValue];
    int videoMinute = ceil(videoDuration / oneMinute);
    int videoSecond = ceil(videoDuration % oneMinute);
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i分%i秒", videoMinute, videoSecond];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:[data videoThumbnail]]
        placeholderImage:[UIImage imageNamed:@"skype.png"]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = [self.tableList objectAtIndex:indexPath.row];
    NSString *link = [data videoLink];
    
    UIWebViewController *networkView = [[UIWebViewController alloc] init];
    networkView.networkUrl = link;
    [self presentViewController:networkView animated:YES completion:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // UITableView only moves in one direction, y axis
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0) {
        [self videoSearch];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    self.pageNo = 0;
    self.tableList = nil;
    [self videoSearch];
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)videoSearch
{
    NSString *searchKey = self.searchBar.text;
    if([searchKey length] == 0) {
        NSString *defaultKey = @"少女时代 舞蹈";
        searchKey = defaultKey;
        self.searchBar.placeholder = defaultKey;
    }
    
    if(self.pageNo == 0) {
        self.pageNo = 1;
    } else {
        self.pageNo += 1;
    }
    
    /*
     时间范围 today: 今日 week: 本周 month: 本月 history: 历史
     排序 published: 发布时间 view-count: 总播放数 comment-count: 总评论数
        reference-count: 总引用数 favorite-count: 总收藏数 relevance: 相关度
     公开类型 all: 公开 friend: 仅好友观看 password: 输入密码观看
     付费状态 付费 1 免费 0
     */
    NSString *period = @"history";
    NSString *orderby = @"view-count";
    NSString *publicType = @"all";
    NSString *paid = @"0";
    
    NSString *api = @"/v2/searches/video/by_keyword.json";
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           api_youku_key, @"client_id",
                           searchKey, @"keyword",
                           period, @"period",
                           orderby, @"orderby",
                           publicType, @"public_type",
                           paid, @"paid",
                           [NSString stringWithFormat:@"%i", self.pageNo], @"page",
                           [NSString stringWithFormat:@"%i", pageSize], @"count", nil];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_youku_baseurl]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSURLRequest *request = [httpClient requestWithMethod:@"GET" path:api parameters:param];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            [tempArr addObjectsFromArray:self.tableList];
            [tempArr addObjectsFromArray:[JSON videoArray]];
            self.tableList = tempArr;
            [self.tableView reloadData];
        }
                                         
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"youku.search api call result : %@", error);
        }
    ];
    
    [operation start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self tableViewLoad];
    [self videoSearch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
