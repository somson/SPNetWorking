//
//  SPService.h
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/28.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol  SPServiceProtocol <NSObject>
@required

@property (nonatomic, readonly) BOOL isOnline;
@property (nonatomic, readonly) NSString *offlineApiBaseUrl;
@property (nonatomic, readonly) NSString *onlineApiBaseUrl;
@property (nonatomic, readonly) NSDictionary *requestHeader;

@optional
@property (nonatomic, readonly) NSString *offlineApiVersion;
@property (nonatomic, readonly) NSString *onlineApiVersion;

@end

@interface SPService : NSObject

@property (nonatomic, weak) id<SPServiceProtocol> child;

@property (nonatomic, copy, readonly) NSString *apiBaseUrl;

@property (nonatomic, copy, readonly) NSString *apiVersion;

@property (nonatomic, copy, readonly) NSDictionary *requestHeader;

@end
