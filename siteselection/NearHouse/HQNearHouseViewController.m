//
//  HQNearHouseViewController.m
//  siteselection
//
//  Created by HeQin on 2017/10/25.
//  Copyright © 2017年 HeQin. All rights reserved.
//

#import "HQNearHouseViewController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "HQNearDetailViewController.h"
#import "HQSave.h"
@interface HQNearHouseViewController ()<UITableViewDelegate,UITableViewDataSource,BMKPoiSearchDelegate>
{
    BMKPoiSearch *_searcher;
    BMKPoiSearch *_searcher1;
}
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UITableView *tableView;
@end

@implementation HQNearHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近住宅";
    //初始化检索对象
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher1 =[[BMKPoiSearch alloc]init];
    _dataArray = [[NSMutableArray alloc] init];
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 1;
    option.pageCapacity = 50;
    option.location = [HQSave shared].selectLocation;
    option.keyword = @"住宅";
    BOOL flag = [_searcher poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:poiResultList.poiInfoList];
        [_tableView reloadData];
    }else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
    
}
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode {
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        HQNearDetailViewController *detail = [[HQNearDetailViewController alloc] init];
        detail.url = poiDetailResult.detailUrl;
        [self.navigationController pushViewController:detail animated:YES];
    }
}
//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated{
    _searcher.delegate = nil;
    _searcher1.delegate = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    _searcher.delegate = self;
    _searcher1.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
    BMKPoiInfo *info = _dataArray[indexPath.row];
    BMKPoiDetailSearchOption *option = [[BMKPoiDetailSearchOption alloc] init];
    option.poiUid = info.uid;
    BOOL flag = [_searcher1 poiDetailSearch:option];
    if(flag)
    {
        NSLog(@"详情检索发送成功");
    }
    else
    {
        NSLog(@"详情检索发送失败");
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier: SimpleTableIdentifier];
    }
    BMKPoiInfo *info = _dataArray[indexPath.row];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = info.address;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
@end
