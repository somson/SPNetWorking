//
//  SPAppContext.h
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/27.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SPAppContext : NSObject

@property (nonatomic, readonly) BOOL isOnline;

//设备信息
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *deviceName;

//运行环境相关
@property (nonatomic, assign, readonly) BOOL isReachable;

//用户token相关
@property (nonatomic, copy, readonly) NSString *token;

//用户信息相关
@property (nonatomic, copy) NSDictionary *userInfo;

//app信息
@property (nonatomic, copy, readonly) NSString *appVersion;

+ (instancetype)shareInstance;

- (void)updateToken:(NSString *)token;

- (void)cleanUserInfo;



@end
