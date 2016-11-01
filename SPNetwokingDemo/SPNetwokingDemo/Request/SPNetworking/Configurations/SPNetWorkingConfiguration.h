//
//  AFNetWorkingConfiguration.h
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/27.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#ifndef SPNetWorkingConfiguration_h
#define SPNetWorkingConfiguration_h

typedef NS_ENUM(NSUInteger, SPURLResponseStatus)
{
    SPURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的CTAPIBaseManager来决定。
    SPURLResponseStatusErrorTimeout,
    SPURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

static NSTimeInterval kSPRequestTimeoutInterval = 10;

//缓存相关
static NSTimeInterval kSPCacheOutdateTimeSeconds = 300;
static NSInteger kSPCacheCount = 50;
static BOOL kSPServiceIsOnline = NO;

//发起请求后，params字典里面，用这个key可以取出requestID
static NSString *kSPAPIManagerRequestID = @"kSPAPIManagerRequestID";
// services
extern NSString * const kSPServiceTest;
#endif /* SPNetWorkingConfiguration_h */
