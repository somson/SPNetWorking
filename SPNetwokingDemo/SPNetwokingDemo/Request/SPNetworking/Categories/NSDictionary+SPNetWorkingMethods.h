//
//  NSDictionary+SPNetWorkingMethods.h
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/28.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SPNetWorkingMethods)
- (NSString *)urlParamsString;
- (NSArray *)transformedUrlParamsArray;

@end
