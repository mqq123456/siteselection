//
//  HQFlowInfoView.m
//  siteselection
//
//  Created by HeQin on 2017/10/25.
//  Copyright © 2017年 HeQin. All rights reserved.
//

#import "HQFlowDetailView.h"

@implementation HQFlowDetailView

- (void)layoutIfNeeded {
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 90, [UIScreen mainScreen].bounds.size.width, 90);
}
- (void)layoutSubviews {
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 90, [UIScreen mainScreen].bounds.size.width, 90);
}

@end
