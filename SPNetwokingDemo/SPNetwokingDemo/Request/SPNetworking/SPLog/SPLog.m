//
//  SPLog.m
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/29.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "SPLog.h"

@implementation SPLog
+ (instancetype)shareInstance{
    static SPLog *instance = nil;
    if(instance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[SPLog alloc] init];
        });
    }
    return instance;
}

- (void)printWithMessage:(NSString *)message{
#ifdef DEBUG
    NSLog(@"log:%@", message);
#endif
}
@end
