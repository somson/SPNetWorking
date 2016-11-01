//
//  SPAppContext.m
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/27.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "SPAppContext.h"
#import "AFNetworkReachabilityManager.h"
#import "SPNetWorkingConfiguration.h"
@implementation SPAppContext

@synthesize userInfo = _userInfo;
@synthesize token = _token;
+ (instancetype)shareInstance{
    static SPAppContext *instance = nil;
    if(instance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[SPAppContext alloc] init];
        });
    }
    return instance;
}

- (void)updateToken:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)cleanUserInfo{
    _token = nil;
    
    self.userInfo = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isOnline{
    BOOL isOnline = NO;
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"CTNetworkingConfiguration" ofType:@"plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:filepath];
        isOnline = [settings[@"isOnline"] boolValue];
    } else {
        isOnline = kSPServiceIsOnline;
    }
    return isOnline;
}
- (NSString *)type{
    return @"iOS";
}

- (NSString *)deviceName{
    return [[UIDevice currentDevice] name];
}

- (BOOL)isReachable{
    if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown){
        return YES;
    }else{
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}
- (NSString *)token{
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    if(token == nil){
        return @"";
    }
    return token;
}
- (NSDictionary *)userInfo{
    if(_userInfo == nil){
        _userInfo = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"userInfo"];
    }
    return _userInfo;
}

- (void)setUserInfo:(NSDictionary *)userInfo{
    _userInfo = [userInfo copy];
    [[NSUserDefaults standardUserDefaults] setObject:_userInfo forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)appVersion{
     return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}
@end
