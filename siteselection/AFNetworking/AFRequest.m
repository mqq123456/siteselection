//
//  AFRequest.m
//  siteselection
//
//  Created by HeQin on 2017/10/26.
//  Copyright © 2017年 HeQin. All rights reserved.
//

#import "AFRequest.h"
#import "AFNetworking.h"

@implementation AFRequest
/**
 *  GET请求,自定义请求头
 *
 *  @param URL        请求地址
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 */
+ (void)GET:(NSString *)URL success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer setValue:@"text/plain;text/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSLog(@"requestURL = %@",URL);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"responseObject = %@",[responseObject description]);
        if (success) { success(responseObject); }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (failure) {
            failure ? failure(error) : nil;
            NSLog(@"error = %@",error);
        }
    }];
}
@end
