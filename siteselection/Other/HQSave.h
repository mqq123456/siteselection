//
//  HQSave.h
//  siteselection
//
//  Created by HeQin on 2017/10/26.
//  Copyright © 2017年 HeQin. All rights reserved.
//  单例对象，保存一些数据

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HQSave : NSObject
+ (HQSave *)shared;
@property (nonatomic, assign) CLLocationCoordinate2D selectLocation;
@end
