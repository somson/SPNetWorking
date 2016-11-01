//
//  SPLog.h
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/29.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPLog : NSObject
+ (instancetype)shareInstance;

- (void)printWithMessage:(NSString *)message;

@end
