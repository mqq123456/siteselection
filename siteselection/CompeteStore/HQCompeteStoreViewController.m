//
//  HQCompeteStoreViewController.m
//  siteselection
//
//  Created by HeQin on 2017/10/26.
//  Copyright © 2017年 HeQin. All rights reserved.
//

#import "HQCompeteStoreViewController.h"
#import "HQRestaurantListViewController.h"
#import "HQSave.h"
#import "AFRequest.h"

@interface HQCompeteStoreViewController ()
@property (weak, nonatomic) IBOutlet UIView *infoVIew;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *rangeLab;
@property (weak, nonatomic) IBOutlet UILabel *storeCountLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *starLab;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;

@end

@implementation HQCompeteStoreViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"竞品店铺";
    _infoVIew.layer.borderWidth = 1;
    _infoVIew.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.1.1.14/sitetesting.5/h5/storeavg.html"]]];
    self.webView.scrollView.scrollEnabled = NO;
    self.lookBtn.layer.cornerRadius = 25;
    self.lookBtn.clipsToBounds = YES;
    [self getData];
}
- (void)getData {
    double lat = [[HQSave shared] selectLocation].latitude;
    double lon = [[HQSave shared] selectLocation].longitude;
    NSString *url = [NSString stringWithFormat:@"http://10.1.1.14/sitetesting.5/index.php/getstore/getstoreoverview/%lf/%lf",lat,lon];
    __weak HQCompeteStoreViewController *tmpSelf = self;
    [AFRequest GET:url success:^(id responseObject) {
        [tmpSelf setData:responseObject];
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)setData:(NSDictionary *)dict {
    _rangeLab.text = dict[@"range"];
    _storeCountLab.text = dict[@"store_count"];
    _priceLab.text = dict[@"price"];
    _starLab.text = dict[@"star"];
}
- (IBAction)lookBtnClick:(id)sender {
    HQRestaurantListViewController *store = [[HQRestaurantListViewController alloc] init];
    [self.navigationController pushViewController:store animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
