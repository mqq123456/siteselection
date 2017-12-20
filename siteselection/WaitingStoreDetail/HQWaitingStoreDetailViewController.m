//
//  HQWaitingStoreDetailViewController.m
//  siteselection
//
//  Created by HeQin on 2017/10/26.
//  Copyright © 2017年 HeQin. All rights reserved.
//

#import "HQWaitingStoreDetailViewController.h"
#import <WebKit/WebKit.h>

@interface HQWaitingStoreDetailViewController ()

@end

@implementation HQWaitingStoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺详情";

    WKWebView *_wkwebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [_wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.view addSubview:_wkwebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
