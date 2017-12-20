//
//  HQFlowInfoViewController.m
//  siteselection
//
//  Created by HeQin on 2017/10/24.
//  Copyright © 2017年 HeQin. All rights reserved.
//

#import "HQFlowInfoViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "HQFlowDetailView.h"
#import "HQNearHouseViewController.h"
#import "HQNearOfficeViewController.h"
#import "HQLocationFlowViewController.h"
#import "HQCharacteristicViewController.h"
#import "HQSave.h"
#import "AFRequest.h"
@interface HQFlowInfoViewController ()<BMKMapViewDelegate>
{
    BMKMapView* _mapView;
    HQFlowDetailView *_infoView;
    BMKPointAnnotation *_pointAnnotation;
    CLLocationCoordinate2D _selectLocation;
}
@end

@implementation HQFlowInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客流情况";
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    _mapView = mapView;
    self.view = mapView;
    [self addTipView];
    [self addInfoView];
   
}
- (void)getData:(CLLocationCoordinate2D)coo {
    [_mapView setZoomLevel:17.3];
    [_mapView setCenterCoordinate:coo];
    _selectLocation = coo;
    double lat = coo.latitude;
    double lon = coo.longitude;
    NSString *url = [NSString stringWithFormat:@"http://10.1.1.14/sitetesting.5/index.php/getheatmap/method/%lf/%lf",lat,lon];
    __weak HQFlowInfoViewController *tmpSelf = self;
    [AFRequest GET:url success:^(id responseObject) {
        [tmpSelf addHeatMap:responseObject];
    } failure:^(NSError *error) {
        
    }];
}

- (void)addTipView {
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 20)];
    tipView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:193.0/255.0 blue:37.0/255.0 alpha:0.85];
    [self.view addSubview:tipView];
    UIImageView *tipImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
    tipImg.image = [UIImage imageNamed:@"tip.png"];
    [tipView addSubview:tipImg];
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 300, 20)];
    tipLabel.text = @"点击地图任意一点，查看单点人流量";
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.textColor =[UIColor whiteColor];
    [tipView addSubview:tipLabel];
    
}
- (void)addInfoView {
    _infoView = [[[NSBundle mainBundle] loadNibNamed:@"HQFlowDetailView" owner:self options:nil]lastObject];
    _infoView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 90, [UIScreen mainScreen].bounds.size.width, 90);

    [self touchMap:[HQSave shared].selectLocation name:@"选择点"];
    [_infoView layoutIfNeeded];
    [self.view addSubview:_infoView];
    [_infoView.detail addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_infoView.houseBtn addTarget:self action:@selector(houseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_infoView.workBtn addTarget:self action:@selector(workBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_infoView.peopleBtn addTarget:self action:@selector(peopleBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)detailBtnClick {
    HQLocationFlowViewController *location = [[HQLocationFlowViewController alloc] init];
    location.coordinate = _selectLocation;
    [self.navigationController pushViewController:location animated:YES];
}
- (void)houseBtnClick {
    HQNearHouseViewController *house = [[HQNearHouseViewController alloc] init];
    [self.navigationController pushViewController:house animated:YES];
}
- (void)workBtnClick {
    HQNearOfficeViewController *office = [[HQNearOfficeViewController alloc] init];
    [self.navigationController pushViewController:office animated:YES];
}
- (void)peopleBtnClick {
    HQCharacteristicViewController *chara = [[HQCharacteristicViewController alloc] init];
    [self.navigationController pushViewController:chara animated:YES];
}
//添加热力图
-(void)addHeatMap:(NSDictionary *)dict{
    [_infoView.houseBtn setTitle:dict[@"near"][@"residence"] forState:UIControlStateNormal];
    [_infoView.workBtn setTitle:dict[@"near"][@"office"] forState:UIControlStateNormal];
    [_infoView.peopleBtn setTitle:dict[@"near"][@"people"] forState:UIControlStateNormal];
    //创建热力图数据类
    [_mapView removeHeatMap];
    BMKHeatMap* heatMap = [[BMKHeatMap alloc]init];
    heatMap.mRadius = 32;
    //创建渐变色类
    UIColor* color1 = [UIColor blueColor];
    UIColor *color2 = [UIColor colorWithRed:77.0/255.0 green:233.0/255.0 blue:125.0/255.0 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:121.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1];
    UIColor* color4 = [UIColor yellowColor];
    UIColor *color5 = [UIColor colorWithRed:224.0/255.0 green:117.0/255.0 blue:59.0/255.0 alpha:1];
    UIColor* color6 = [UIColor redColor];
    NSArray*colorInitialArray = [[NSArray alloc]initWithObjects:color1,color2,color3,color4,color5,color6, nil];
    BMKGradient* gradient = [[BMKGradient alloc]initWithColors:colorInitialArray startPoints:@[@"0.1f", @"0.3f", @"0.5f", @"0.7f", @"0.9f", @"1f"]];
    //如果用户自定义了渐变色则按自定义的渐变色进行绘制否则按默认渐变色进行绘制
    heatMap.mGradient = gradient;
    
    //创建热力图数据数组
    NSMutableArray* data = [NSMutableArray array];
    NSArray *hots = dict[@"data"];
    for(int i = 0; i<hots.count; i++)
    {
        //创建BMKHeatMapNode
        BMKHeatMapNode* heapmapnode_test = [[BMKHeatMapNode alloc]init];
//        //此处示例为随机生成的坐标点序列，开发者使用自有数据即可
//        CLLocationCoordinate2D coor;
//        float random = (arc4random()%1000)*0.000001;
//        float random2 = (arc4random()%1000)*0.000001;
//        float random3 = (arc4random()%1000)*0.0000001;
//        float random4 = (arc4random()%1000)*0.0000001;
//
//        if(i%8==0){
//            coor.latitude = 40.002246429100019+random;
//            coor.longitude = 116.48825763098939+random2;
//        }else if(i%8 ==1){
//            coor.latitude = 40.002246429100019-random;
//            coor.longitude = 116.48825763098939-random2;
//        }else if(i%8 ==2){
//            coor.latitude = 40.002246429100019+random;
//            coor.longitude = 116.48825763098939-random2;
//        }else if(i%8==3){
//            coor.latitude = 40.002246429100019+random;
//            coor.longitude = 116.48825763098939+random2;
//        }else if(i%8 ==4){
//            coor.latitude = 40.002246429100019-random;
//            coor.longitude = 116.48825763098939-random2;
//        }else if(i%8 ==5){
//            coor.latitude = 40.002246429100019+random3;
//            coor.longitude = 116.48825763098939+random4;
//        }else if(i%8 ==5){
//            coor.latitude = 40.002246429100019-random3;
//            coor.longitude = 116.48825763098939-random4;
//        }else{
//            coor.latitude = 40.002246429100019;
//            coor.longitude = 116.48825763098939;
//        }
        NSString *pt = hots[i][@"pt"];
        NSArray *latlon = [pt componentsSeparatedByString:@","];
        if (latlon.count>1) {
           heapmapnode_test.pt = CLLocationCoordinate2DMake([latlon[0] doubleValue], [latlon[1] doubleValue]);
        }
        //随机生成点强度
        heapmapnode_test.intensity = [hots[i][@"intensity"] doubleValue];
        //添加BMKHeatMapNode到数组
        [data addObject:heapmapnode_test];
    }
    //将点数据赋值到热力图数据类
    heatMap.mData = data;
    //调用mapView中的方法根据热力图数据添加热力图
    [_mapView addHeatMap:heatMap];
    
    
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
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    [self touchMap:coordinate name:@"选择点"];
}
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi {
    [self touchMap:mapPoi.pt name:mapPoi.text];
}
- (void)touchMap:(CLLocationCoordinate2D)coordinate name:(NSString *)name{
    _infoView.name.text = [NSString stringWithFormat:@"%@附近5公里",name];
    [_mapView removeAnnotation:_pointAnnotation];
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = coordinate;
    [_mapView addAnnotation:item];
    _pointAnnotation = item;
    [self getData:coordinate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
