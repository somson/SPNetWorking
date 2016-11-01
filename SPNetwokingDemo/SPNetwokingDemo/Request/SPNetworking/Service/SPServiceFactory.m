//
//  SPServiceFactory.m
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/28.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "SPServiceFactory.h"
#import "SPTestService.h"
#import "SPLog.h"

NSString * const kSPServiceTest = @"kSPServiceTest";
@implementation SPServiceFactory
+ (instancetype)shareInstance{
    static SPServiceFactory *instance = nil;
    if(instance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[SPServiceFactory alloc] init];
        });
    }
    return instance;
}

- (SPService<SPServiceProtocol> *)serviceWithServiceIdentify:(NSString *)serviceIdentify{
    SPTestService *service = [[SPTestService alloc] init];
    if([serviceIdentify isEqualToString:kSPServiceTest]){
         service = [[SPTestService alloc] init];
    }
    return service;
}

- (void)dealloc{
    [[SPLog shareInstance] printWithMessage:[NSString stringWithFormat:@"==dealloc %@", NSStringFromClass([self class])]];
}

@end
