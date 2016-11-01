//
//  SPAPIResponse.m
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/26.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "SPAPIResponse.h"
#import "NSURLRequest+SPNetworkingMethods.h"
#import "SPLog.h"
@interface SPAPIResponse ()
@property (nonatomic, assign) SPURLResponseStatus status;
@property (nonatomic, copy) NSString *contentString;
@property (nonatomic, copy) id content;
@property (nonatomic, assign) NSInteger requestId;
@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) NSData *responseData;
@property (nonatomic, strong) NSError *error;

//区别该对象是否为缓存的对象
@property (nonatomic, assign) BOOL isCache;
@end
@implementation SPAPIResponse

- (id)initWithData:(NSData *)data{
    if(self = [super init]){
        self.contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.status = [self responseStatusWithError:nil];
        self.requestId = 0;
        self.request = nil;
        self.responseData = data;
        self.isCache = YES;
    }
    return self;
}

- (id)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData status:(SPURLResponseStatus)status{
    if(self = [super init]){
        self.contentString = responseString;
        self.status = status;
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;
        self.isCache = NO;
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        } else {
            self.content = nil;
        }
    }
    return self;
}

- (id)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error{
    if(self = [super init]){
        self.contentString = responseString;
        self.status = [self responseStatusWithError:error];
        self.requestId = [requestId integerValue];
        self.request = request;
        self.requestParams = self.request.requestParams;
        self.responseData = self.responseData;
        self.isCache = NO;
        self.error = error;
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        } else {
            self.content = nil;
        }

    }
    return self;
}
- (SPURLResponseStatus)responseStatusWithError:(NSError *)error{
    if(error){
        SPURLResponseStatus status = SPURLResponseStatusErrorNoNetwork;
        
        if(error.code == NSURLErrorTimedOut){
            status = SPURLResponseStatusErrorTimeout;
        }
        return status;
    }else{
        return SPURLResponseStatusSuccess;
    }
}

- (void)dealloc{
    [[SPLog shareInstance] printWithMessage:[NSString stringWithFormat:@"==dealloc %@", NSStringFromClass([self class])]];

}
@end
