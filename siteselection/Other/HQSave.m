//
//  HQSave.m
//  siteselection
//
//  Created by HeQin on 2017/10/26.
//  Copyright © 2017年 HeQin. All rights reserved.
//

#import "HQSave.h"

@implementation HQSave
+ (HQSave *)shared {
    static HQSave *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
@end
