//
//  HQLocationFlowViewController.m
//  siteselection
//
//  Created by HeQin on 2017/10/25.
//  Copyright © 2017年 HeQin. All rights reserved.
//

#import "HQLocationFlowViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <WebKit/WebKit.h>

@interface HQLocationFlowViewController ()<UIScrollViewDelegate>
{
    BMKMapView* _mapView;
    UIScrollView *_scrollview;
    UIPageControl *_pageControl;
    WKWebView *_timeWebView;
    WKWebView *_dayWebView;
}
@end

@implementation HQLocationFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人流量";
    self.view.backgroundColor = [UIColor whiteColor];
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    _mapView = mapView;
    self.view = mapView;
    [_mapView setCenterCoordinate:self.coordinate];
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = self.coordinate;
    [_mapView addAnnotation:item];
    [self initScrollView];
}
- (void)initScrollView {
    _scrollview = [[UIScrollView alloc] init];
    _scrollview.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 240,[UIScreen mainScreen].bounds.size.width,240);
    _scrollview.backgroundColor = [UIColor whiteColor];
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*2, 240);
    _scrollview.pagingEnabled = YES;
    _scrollview.delegate = self;
    [self.view addSubview:_scrollview];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.frame = CGRectMake(self.view.frame.size.width/2-10, [UIScreen mainScreen].bounds.size.height-20, 20, 20);
    _pageControl.numberOfPages = 2;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor orangeColor];// 设置非选中页的圆点颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor blueColor]; // 设置选中页的圆点颜色
    [self.view addSubview:_pageControl];
    
    _dayWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 220)];
    _dayWebView.scrollView.scrollEnabled = NO;
    [_dayWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.1.1.14/sitetesting.5/h5/dayflow.html"]]];
    [_scrollview addSubview:_dayWebView];
    _timeWebView = [[WKWebView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 220)];
    [_timeWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.1.1.14/sitetesting.5/h5/hourflow.html"]]];
    _timeWebView.scrollView.scrollEnabled = NO;
    [_scrollview addSubview:_timeWebView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
