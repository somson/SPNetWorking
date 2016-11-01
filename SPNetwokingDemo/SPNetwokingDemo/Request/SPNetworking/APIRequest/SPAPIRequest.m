//
//  SPAPIRequest.m
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/26.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "SPAPIRequest.h"
#import "SPRequestGenerator.h"
#import "AFNetworking.h"
#import "SPAPIResponse.h"
#import "SPLog.h"
#import "SPAPIBaseManager.h"
@interface SPAPIRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableDictionary *dataTasks;
@end
@implementation SPAPIRequest
+ (instancetype)shareInstance{
    static SPAPIRequest *instance = nil;
    if(instance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[self alloc] init];
        });
    }
    return instance;
}

- (NSInteger)requestGETWithParams:(NSDictionary *)params methodName:(NSString *)methodName serviceIdentify:(NSString *)serviceIdentify success:(requestCallBack)success fail:(requestCallBack)fail{
    NSURLRequest *request = [[SPRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:serviceIdentify requestParams:params methodName:methodName];
    NSInteger requestId = [[self requestApiWithRequest:request success:success fail:fail] integerValue];
    return requestId;
    
}

- (NSInteger)requestPOSTWithParams:(NSDictionary *)params methodName:(NSString *)methodName serviceIdentify:(NSString *)serviceIdentify success:(requestCallBack)success fail:(requestCallBack)fail{
    NSURLRequest *request = [[SPRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:serviceIdentify requestParams:params methodName:methodName];
    NSInteger requestId = [[self requestApiWithRequest:request success:success fail:fail] integerValue];
    return requestId;
}

- (NSInteger)requestPUTWithParams:(NSDictionary *)params methodName:(NSString *)methodName serviceIdentify:(NSString *)serviceIdentify success:(requestCallBack)success fail:(requestCallBack)fail{
    NSURLRequest *request = [[SPRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:serviceIdentify requestParams:params methodName:methodName];
    NSInteger requestId = [[self requestApiWithRequest:request success:success fail:fail] integerValue];
    return requestId;
}

- (NSInteger)requestDELETEWithParams:(NSDictionary *)params methodName:(NSString *)methodName serviceIdentify:(NSString *)serviceIdentify success:(requestCallBack)success fail:(requestCallBack)fail{
    NSURLRequest *request = [[SPRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:serviceIdentify requestParams:params methodName:methodName];
    NSInteger requestId = [[self requestApiWithRequest:request success:success fail:fail] integerValue];
    return requestId;
}

- (NSInteger)requestUPLOADWithParams:(NSDictionary *)params fileData:(SPFileData *)fileData methodName:(NSString *)methodName
                     serviceIdentify:(NSString *)serviceIdentify success:(requestCallBack)success fail:(requestCallBack)fail progress:(void (^)(NSProgress *))progress{
     NSURLRequest *request = [[SPRequestGenerator sharedInstance] generateUploadRequestWithServiceIdentifier:serviceIdentify requestParams:params methodName:methodName fileData:fileData];
    NSInteger requestId = [[self requestApiWithRequest:request success:success fail:fail progress:progress] integerValue];
    return requestId;
}
- (NSNumber *)requestApiWithRequest:(NSURLRequest *)request success:(requestCallBack)success fail:(requestCallBack)fail progress:(void (^)(NSProgress *))progress{
    NSLog(@"======requestUrl = %@",request.URL);
    NSLog(@"======requestHeader = %@",request.allHTTPHeaderFields);
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.manager uploadTaskWithStreamedRequest:request progress:progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dataTasks removeObjectForKey:requestID];
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if(error){
            SPAPIResponse *response = [[SPAPIResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData error:error];
            fail ? fail(response):nil;
        }else{
            SPAPIResponse *response = [[SPAPIResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData status:SPURLResponseStatusSuccess];
            if(success){
                success(response);
            }
        }
    }];
    NSNumber *requestId = @([dataTask taskIdentifier]);
    self.dataTasks[requestId] = dataTask;
    [dataTask resume];
    return requestId;
}

- (NSNumber *)requestApiWithRequest:(NSURLRequest *)request success:(requestCallBack)success fail:(requestCallBack)fail{
    NSLog(@"======requestUrl = %@",request.URL);
    NSLog(@"======requestHeader = %@",request.allHTTPHeaderFields);
    __block NSURLSessionDataTask *dataTask = nil;
    
    dataTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dataTasks removeObjectForKey:requestID];
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if(error){
            SPAPIResponse *response = [[SPAPIResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData error:error];
            fail ? fail(response):nil;
        }else{
            SPAPIResponse *response = [[SPAPIResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData status:SPURLResponseStatusSuccess];
            if(success){
                success(response);
            }
        }
        
    }];
    
    NSNumber *requestId = @([dataTask taskIdentifier]);
    self.dataTasks[requestId] = dataTask;
    [dataTask resume];
    return requestId;
}
- (void)cancelRequestWithRequestId:(NSNumber *)requestId{
    NSURLSessionDataTask *requestOperation = self.dataTasks[requestId];
    [requestOperation cancel];
    [self.dataTasks removeObjectForKey:requestId];
}

- (NSMutableDictionary *)dataTasks{
    if(_dataTasks == nil){
        _dataTasks = [[NSMutableDictionary alloc] init];
    }
    return _dataTasks;
}
- (AFHTTPSessionManager *)manager{
    if(_manager == nil){
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.securityPolicy.allowInvalidCertificates = YES;
        _manager.securityPolicy.validatesDomainName = NO;
    }
    return _manager;
}

- (void)dealloc{
    [[SPLog shareInstance] printWithMessage:[NSString stringWithFormat:@"==dealloc %@", NSStringFromClass([self class])]];
}
@end
