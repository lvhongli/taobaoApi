//
//  UIPhotoWebViewController.m
//  taobaoApi
//
//  Created by zifeng on 13-9-6.
//  Copyright (c) 2013年 zifeng. All rights reserved.
//

#import "UITaobaoWebViewController.h"

@interface UITaobaoWebViewController ()

@end

@implementation UITaobaoWebViewController

@synthesize networkUrl = _networkUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)closeView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    float navigationHeight = 44;
    float viewWidth = self.view.frame.size.width;
    float viewHeight = self.view.frame.size.height;
    
    // navigation bar
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navigationHeight)];
    navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    navigationBar.items = @[self.navigationItem];
    navigationBar.tintColor = [UIColor blackColor];
    [self.view addSubview:navigationBar];
    
    // close button
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
        UIBarButtonSystemItemCancel target:self action:@selector(closeView)];
    
    // navigation items
    self.navigationItem.leftBarButtonItem = btnDone;
    self.navigationController.title = @"详情页";
    
    // web load
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, navigationHeight, viewWidth, viewHeight - navigationHeight)];
    webView.delegate = self;
    NSURL *url =[NSURL URLWithString:self.networkUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
