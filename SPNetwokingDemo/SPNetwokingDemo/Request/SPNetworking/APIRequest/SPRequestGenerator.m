//
//  SPRequestGenerator.m
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/28.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "SPRequestGenerator.h"
#import <AFNetworking/AFNetworking.h>
#import "SPNetWorkingConfiguration.h"
#import "SPServiceFactory.h"
#import "NSURLRequest+SPNetworkingMethods.h"
#import "SPLog.h"
#import "SPAPIBaseManager.h"
@interface SPRequestGenerator ()
@property (nonatomic, strong) AFHTTPRequestSerializer* httpRequestSerializer;

@end
@implementation SPRequestGenerator

+ (instancetype)sharedInstance{
    static SPRequestGenerator *instance = nil;
    if(instance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[SPRequestGenerator alloc] init];
        });
    }
    return instance;
}

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    
    SPService *service = [[SPServiceFactory shareInstance] serviceWithServiceIdentify:serviceIdentifier];
    //设置请求头
    [self setRequestHeaderWithContent:[service requestHeader]];

    NSString *urlString = [NSString stringWithFormat:@"%@/%@",[service apiBaseUrl],methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{

    SPService *service = [[SPServiceFactory shareInstance] serviceWithServiceIdentify:serviceIdentifier];
    //设置请求头
    [self setRequestHeaderWithContent:[service requestHeader]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",[service apiBaseUrl], methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generatePutRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
 
    SPService *service = [[SPServiceFactory shareInstance] serviceWithServiceIdentify:serviceIdentifier];
    //设置请求头
    [self setRequestHeaderWithContent:[service requestHeader]];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",[service apiBaseUrl],methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"PUT" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generateDeleteRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{

    SPService *service = [[SPServiceFactory shareInstance] serviceWithServiceIdentify:serviceIdentifier];
    //设置请求头
    [self setRequestHeaderWithContent:[service requestHeader]];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",[service apiBaseUrl], methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"DELETE" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    return request;

}
- (NSURLRequest *)generateUploadRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName fileData:(SPFileData *)fileData{
    SPService *service = [[SPServiceFactory shareInstance] serviceWithServiceIdentify:serviceIdentifier];
    //设置请求头
    [self setRequestHeaderWithContent:[service requestHeader]];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",[service apiBaseUrl], methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:requestParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         [formData appendPartWithFileData:fileData.data name:fileData.name fileName:fileData.fileName mimeType:fileData.mimeType];
    } error:NULL];
    request.requestParams = requestParams;
    return request;
}
- (void)setRequestHeaderWithContent:(NSDictionary *)content{
    if(content){
        [content enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self.httpRequestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
   
}
- (AFHTTPRequestSerializer *)httpRequestSerializer{
    if(_httpRequestSerializer == nil){
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kSPRequestTimeoutInterval;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}
- (void)dealloc{
    [[SPLog shareInstance] printWithMessage:[NSString stringWithFormat:@"==dealloc %@", NSStringFromClass([self class])]];
}
@end
