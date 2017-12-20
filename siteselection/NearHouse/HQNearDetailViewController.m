//
//  HQNearDetailViewController.m
//  siteselection
//
//  Created by HeQin on 2017/10/25.
//  Copyright © 2017年 HeQin. All rights reserved.
//

#import "HQNearDetailViewController.h"

@interface HQNearDetailViewController ()

@end

@implementation HQNearDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
