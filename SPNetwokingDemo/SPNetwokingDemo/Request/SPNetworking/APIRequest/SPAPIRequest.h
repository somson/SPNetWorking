//
//  SPAPIRequest.h
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/26.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SPFileData;
@class SPAPIResponse;

typedef void(^requestCallBack) (SPAPIResponse *response);
@interface SPAPIRequest : NSObject
+ (instancetype)shareInstance;


- (NSInteger)requestGETWithParams:(NSDictionary*)params methodName:(NSString *)methodName
                   serviceIdentify:(NSString*)serviceIdentify success:(requestCallBack)success fail:(requestCallBack)fail;

- (NSInteger)requestPOSTWithParams:(NSDictionary*)params methodName:(NSString *)methodName
                   serviceIdentify:(NSString *)serviceIdentify success:(requestCallBack)success fail:(requestCallBack)fail;

- (NSInteger)requestPUTWithParams:(NSDictionary*)params methodName:(NSString *)methodName
                   serviceIdentify:(NSString *)serviceIdentify success:(requestCallBack)success fail:(requestCallBack)fail;

- (NSInteger)requestDELETEWithParams:(NSDictionary*)params methodName:(NSString *)methodName
                     serviceIdentify:(NSString *)serviceIdentify success:(requestCallBack)success fail:(requestCallBack)fail;

- (NSInteger)requestUPLOADWithParams:(NSDictionary *)params fileData:(SPFileData *)fileData methodName:(NSString *)methodName
                     serviceIdentify:(NSString *)serviceIdentify success:(requestCallBack)success fail:(requestCallBack)fail progress:(void(^)(NSProgress *progress))progress;

- (NSNumber *)requestApiWithRequest:(NSURLRequest *)request success:(requestCallBack)success fail:(requestCallBack)fail;

- (NSNumber *)requestApiWithRequest:(NSURLRequest *)request success:(requestCallBack)success fail:(requestCallBack)fail progress:(void (^)(NSProgress *))progress;

- (void)cancelRequestWithRequestId:(NSNumber *)requestId;


@end
