//
//  HQCharacteristicViewController.m
//  siteselection
//
//  Created by HeQin on 2017/10/25.
//  Copyright © 2017年 HeQin. All rights reserved.
//

#import "HQCharacteristicViewController.h"
#import <WebKit/WebKit.h>
@interface HQCharacteristicViewController ()
{
    WKWebView *_wkwebView;
}
@end

@implementation HQCharacteristicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客群属性";
    self.view.backgroundColor = [UIColor whiteColor];
    _wkwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    [_wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.1.1.14/sitetesting.5/h5/flowage.html"]]];
    _wkwebView.scrollView.scrollEnabled = NO;
    [self.view addSubview:_wkwebView];
    NSArray *array = [NSArray arrayWithObjects:@"年龄",@"性别",@"职业",@"收入",@"常驻人口", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    segment.selectedSegmentIndex = 0;
    segment.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.width + 10, [UIScreen mainScreen].bounds.size.width - 20, 40);
    [self.view addSubview:segment];
    [segment addTarget:self action:@selector(segementClick:) forControlEvents:UIControlEventValueChanged];
}

- (void)segementClick:(UISegmentedControl *)seg {
    NSInteger Index = seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            [_wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.1.1.14/sitetesting.5/h5/flowage.html"]]];
            break;
        case 1:
            [_wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.1.1.14/sitetesting.5/h5/flowsex.html"]]];
            break;
        case 2:
            [_wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.1.1.14/sitetesting.5/h5/flowocc.html"]]];
            break;
        case 3:
            [_wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.1.1.14/sitetesting.5/h5/flowincome.html"]]];
            break;
        case 4:
            [_wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.1.1.14/sitetesting.5/h5/flowlive.html"]]];
            break;
        default:
            break;
    }
            
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
