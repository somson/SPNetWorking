//
//  SPTestService.m
//  GardenApp
//
//  Created by 史庆帅 on 2016/10/10.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "SPTestService.h"
#import "SPAppContext.h"
@implementation SPTestService
- (NSString *)onlineApiBaseUrl{
    return @"http://123.56.204.69:8081/ciao-api";
}
- (NSString *)offlineApiBaseUrl{
    return @"http://123.56.204.69:8081/ciao-api";
}
- (BOOL)isOnline{
    return [[SPAppContext shareInstance] isOnline];
}

- (NSDictionary *)requestHeader{
    return nil;
}
@end
