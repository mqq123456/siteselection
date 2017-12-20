//
//  WaitingStoreViewController.m
//  siteselection
//
//  Created by HeQin on 2017/10/26.
//  Copyright © 2017年 HeQin. All rights reserved.
//

#import "WaitingStoreViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "HQSave.h"
#import "AFRequest.h"
#import "YWRoundAnnotationView.h"
#import "YWPointAnnotation.h"
#import "HQWaitingStoreDetailViewController.h"

@interface WaitingStoreViewController ()<BMKMapViewDelegate>
{
    BMKMapView* _mapView;
    NSArray *_dataArray;
}
@end

@implementation WaitingStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人流量";
    _dataArray = [NSArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    _mapView = mapView;
    self.view = mapView;
    [self getData];
}
- (void)getData {
    double lat = [[HQSave shared] selectLocation].latitude;
    double lon = [[HQSave shared] selectLocation].longitude;
    [_mapView setCenterCoordinate:[[HQSave shared] selectLocation]];
    [_mapView setZoomLevel:18];
    NSString *url = [NSString stringWithFormat:@"http://10.1.1.14/sitetesting.5/index.php/getwaitingstore/method/%lf/%lf",lat,lon];
    __weak WaitingStoreViewController *tmpSelf = self;
    [AFRequest GET:url success:^(id responseObject) {
        [tmpSelf setData:responseObject];
    } failure:^(NSError *error) {
        
    }];
}
- (void)setData:(NSDictionary *)dict {
    _dataArray = [NSArray arrayWithArray:dict[@"data"]];
    for (int i = 0; i< _dataArray.count; i++) {
        YWPointAnnotation* item = [[YWPointAnnotation alloc]init];
        NSArray *latlon = [dict[@"data"][i][@"location"] componentsSeparatedByString:@","];
        if (latlon.count>1) {
            item.coordinate = CLLocationCoordinate2DMake([latlon[1] doubleValue], [latlon[0] doubleValue]);
        }
        item.title = dict[@"data"][i][@"price_d"];
        item.count = i;
        [_mapView addAnnotation:item];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - BMKMapViewDelegate
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    YWRectAnnotationView *newAnnotationView =(YWRectAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotation"];
    if (newAnnotationView==nil)
    {
        newAnnotationView=[[ YWRectAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    }
    newAnnotationView.titleText=annotation.title;
    newAnnotationView.canShowCallout = NO;
    newAnnotationView.draggable = NO;
    return newAnnotationView;
    return nil;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    YWPointAnnotation *an = (YWPointAnnotation *)view.annotation;
    NSDictionary *dict = _dataArray[an.count];
    HQWaitingStoreDetailViewController *waiting = [[HQWaitingStoreDetailViewController alloc] init];
    waiting.url = dict[@"detail_url"];
    [self.navigationController pushViewController:waiting animated:YES];
}
@end
