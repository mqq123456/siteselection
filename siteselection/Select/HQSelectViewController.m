//
//  HQSelectViewController.m
//  siteselection
//
//  Created by HeQin on 2017/10/24.
//  Copyright © 2017年 HeQin. All rights reserved.
//

#import "HQSelectViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "HQResultViewController.h"
#import "HQSave.h"

@interface HQSelectViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView* _mapView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch* _geocodesearch;
    BMKPointAnnotation *_pointAnnotation;
    CLLocationCoordinate2D _selectLocation;
}
@property (nonatomic, assign) CLLocationCoordinate2D myLocation;
@end

@implementation HQSelectViewController
- (void)setMyLocation:(CLLocationCoordinate2D)myLocation {
    _myLocation = myLocation;
    if (myLocation.latitude > 1 && myLocation.longitude > 1) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 发起地理编码搜索
            [self reverseGeocode:myLocation];
        });
    }
}
-(void)reverseGeocode:(CLLocationCoordinate2D)pt {
    _selectLocation = pt;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){NSLog(@"反geo检索发送成功");}else{
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = pt;
        [_mapView addAnnotation:item];
        _pointAnnotation = item;
        _mapView.centerCoordinate = pt;
        NSLog(@"反geo检索发送失败");
    }
}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        [_mapView removeAnnotation:_pointAnnotation];
        _pointAnnotation = nil;
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _pointAnnotation = item;
        _mapView.centerCoordinate = result.location;
    }
}

-(void)initLocationService {
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"餐厅选址评估";
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    [self initLocationService];
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    _mapView = mapView;
    //_mapView.showsUserLocation = YES;//显示定位图层
    self.view = mapView;
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    selectBtn.frame = CGRectMake(30, [UIScreen mainScreen].bounds.size.height - 80, [UIScreen mainScreen].bounds.size.width - 60, 50);
    [selectBtn setTitle:@"查询" forState:UIControlStateNormal];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [selectBtn setTintColor:[UIColor whiteColor]];
    [selectBtn setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
    selectBtn.layer.cornerRadius = 25;
    selectBtn.clipsToBounds = YES;
    [selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
}
- (void)selectBtnClick {
    //保存经纬度信息
    [HQSave shared].selectLocation = _selectLocation;
    HQResultViewController *result = [[HQResultViewController alloc] init];
    [self.navigationController pushViewController:result animated:YES];
}
- (void)touchMap:(CLLocationCoordinate2D)coordinate {
    [self reverseGeocode:coordinate];
}
#pragma mark - BMKMapViewDelegate
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _geocodesearch.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil;
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    [self touchMap:coordinate];
}
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi {
    [self touchMap:mapPoi.pt];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        //newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        [newAnnotationView setSelected:YES];
        return newAnnotationView;
    }
    return nil;
}
#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    self.myLocation = userLocation.location.coordinate;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
