//
//  SPService.m
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/28.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "SPService.h"
#import "SPLog.h"

@implementation SPService
- (id)init{
    if(self = [super init]){
        if([self conformsToProtocol:@protocol(SPServiceProtocol)]){
            self.child = (id<SPServiceProtocol>)self;
        }
    }
    return self;
}

- (NSString *)apiBaseUrl{
    return [self.child isOnline] ? [self.child onlineApiBaseUrl] : [self.child offlineApiBaseUrl];
}

- (NSString *)apiVersion{
    return [self.child isOnline] ? [self.child onlineApiVersion] : [self.child offlineApiVersion];
}

- (NSDictionary *)requestHeader{
    return [self.child requestHeader];
}
- (void)dealloc{
    [[SPLog shareInstance] printWithMessage:[NSString stringWithFormat:@"==dealloc %@", NSStringFromClass([self class])]];
}
@end
