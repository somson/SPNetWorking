//
//  NSDictionary+SPNetWorkingMethods.m
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/28.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "NSDictionary+SPNetWorkingMethods.h"
#import "NSArray+SPNetWorkingMethods.m"
@implementation NSDictionary (SPNetWorkingMethods)
- (NSString *)urlParamsString{
    NSArray *sortedArray = [self transformedUrlParamsArray];
    return [sortedArray paramsString];
}

- (NSArray *)transformedUrlParamsArray{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        obj = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)obj,  NULL,  (CFStringRef)@"!*'();:@&;=+$,/?%#[]",  kCFStringEncodingUTF8));
        if ([obj length] > 0) {
            [result addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    NSArray *sortedResult = [result sortedArrayUsingSelector:@selector(compare:)];
    return sortedResult;
}
@end
