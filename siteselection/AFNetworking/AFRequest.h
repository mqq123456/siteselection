//
//  AFRequest.h
//  siteselection
//
//  Created by HeQin on 2017/10/26.
//  Copyright © 2017年 HeQin. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 请求成功的Block */
typedef void(^HttpRequestSuccess)(id responseObject);
/** 请求失败的Block */
typedef void(^HttpRequestFailed)(NSError *error);

@interface AFRequest : NSObject

/**
 GET请求

 @param URL 请求地址
 @param success 请求成功的回调
 @param failure 请求失败的回调
 */
+ (void)GET:(NSString *)URL success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

@end
