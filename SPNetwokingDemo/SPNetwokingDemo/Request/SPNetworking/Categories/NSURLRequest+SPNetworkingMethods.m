//
//  NSURLRequest+CTNetworkingMethods.m
//  RTNetworking
//
//  Created by casa on 14-5-26.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "NSURLRequest+SPNetworkingMethods.h"
#import <objc/runtime.h>

static void *SPNetworkingRequestParams;

@implementation NSURLRequest (SPNetworkingMethods)

- (void)setRequestParams:(NSDictionary *)requestParams
{
    objc_setAssociatedObject(self, &SPNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams
{
    return objc_getAssociatedObject(self, &SPNetworkingRequestParams);
}

@end
