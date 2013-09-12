//
//  UIMainViewController.m
//  taobaoApi
//
//  Created by zifeng on 13-9-12.
//  Copyright (c) 2013年 zifeng. All rights reserved.
//

#import "UIMainViewController.h"
#import "UITaobaoProductViewController.h"
#import "UIYoukuSearchViewController.h"

@interface UIMainViewController ()

@end

@implementation UIMainViewController

static NSString *code_key = @"code";
static NSString *code_key_taobao = @"taobao";
static NSString *code_key_youku = @"youku";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dataTargetLoad:(UIGestureRecognizer *)sender
{
    NSString *code = [sender.view.layer valueForKey:code_key];
    
    if([code isEqualToString:code_key_taobao]) {
        UITaobaoProductViewController *viewController = [[UITaobaoProductViewController alloc] initWithNibName:@"UITaobaoProductViewController" bundle:nil];
        [self presentModalViewController:viewController animated:YES];
    }
    
    if([code isEqualToString:code_key_youku]) {
        UIYoukuSearchViewController *viewController = [[UIYoukuSearchViewController alloc]
            initWithNibName:@"UIYoukuSearchViewController" bundle:nil];
        [self presentModalViewController:viewController animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"loading.png"]];
    
    float labelSide = 95;
    float labelInsetX = 25;
    float labelSpace = 10;
    float titleHeight = 20;
    float imageSide = 50;
    float buttonSide = 32;
    float buttonSpace = 60;
    float buttonInsetY = 160;
    
    NSArray *dataArray = [[NSArray alloc] initWithObjects:code_key_taobao, code_key_youku, @"building", @"building", @"building", @"building", @"building", @"building", nil];
    for (int i = 0; i < dataArray.count; i ++) {
        NSString *data = [dataArray objectAtIndex:i];
       
        float dataViewInsetX = labelInsetX + (i % 2) * (labelSide + labelSpace);
        float dataViewInsetY = labelInsetX + ceil(i / 2) * (labelSide + labelSpace);
        
        UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(dataViewInsetX, dataViewInsetY, labelSide, labelSide)];
        dataView.backgroundColor = UIColorFromRGBWithAlpha(0x5B97D7, 1.0);
        [self.view addSubview:dataView];
        
        dataView.userInteractionEnabled = YES;
        [dataView.layer setValue:data forKey:code_key];
        UITapGestureRecognizer *dataViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dataTargetLoad:)];
        [dataView addGestureRecognizer:dataViewTap];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelSpace, labelSide, titleHeight)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = data;
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [dataView addSubview:titleLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((labelSide - imageSide) / 2, titleHeight + labelSpace, imageSide, imageSide)];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", data]]];
        [dataView addSubview:imageView];
    }
    
    NSArray *buttonArray = [[NSArray alloc] initWithObjects:@"opr_download", @"opr_clear", @"opr_refresh", @"opr_set", @"opr_add", nil];
    for(int i = 0; i < buttonArray.count; i ++) {
        NSString *button = [buttonArray objectAtIndex:i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((labelInsetX + labelSide + labelSpace) * 2 , buttonInsetY + i * buttonSpace, buttonSide, buttonSide)];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", button]]];
        [self.view addSubview:imageView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
