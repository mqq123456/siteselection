//
//  HQRestaurantListViewController.m
//  siteselection
//
//  Created by HeQin on 2017/10/26.
//  Copyright © 2017年 HeQin. All rights reserved.
//

#import "HQRestaurantListViewController.h"
#import "RestaurantListCell.h"
#import "UIImageView+AFNetworking.h"
#import "HQSave.h"
#import "AFRequest.h"
#import "HQWaitingStoreDetailViewController.h"

@interface HQRestaurantListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UITableView *tableView;
@end

@implementation HQRestaurantListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"餐厅列表";
    _dataArray = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self getData];
}

- (void)getData {
    double lat = [[HQSave shared] selectLocation].latitude;
    double lon = [[HQSave shared] selectLocation].longitude;
    NSString *url = [NSString stringWithFormat:@"http://10.1.1.14/sitetesting.5/index.php/getstore/method/%lf/%lf",lat,lon];
    __weak HQRestaurantListViewController *tmpSelf = self;
    [AFRequest GET:url success:^(id responseObject) {
        [tmpSelf setData:responseObject];
    } failure:^(NSError *error) {
        
    }];
}
- (void)setData:(NSDictionary *)dict{
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:dict[@"data"]];
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HQWaitingStoreDetailViewController *waiting = [[HQWaitingStoreDetailViewController alloc] init];
    [self.navigationController pushViewController:waiting animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    RestaurantListCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RestaurantListCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dict = _dataArray[indexPath.row];
    cell.nameLab.text = dict[@"name"];
    cell.price.text = dict[@"price"];
    cell.typeLab.text = [NSString stringWithFormat:@"%@ %@",dict[@"type"],dict[@"address"]];
    cell.descLab.text = dict[@"desc"];
    cell.distanceLab.text = dict[@"distance"];
    cell.star.show_score = [dict[@"score"] floatValue];
    cell.star.show_star = [dict[@"score"] integerValue];
    [cell.iconImg setImageWithURL:[NSURL URLWithString:dict[@"img"]]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

@end
