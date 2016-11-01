//
//  SPAPIBaseManager.m
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/26.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "SPAPIBaseManager.h"
#import "SPAPIResponse.h"
#import "SPAppContext.h"
#import "SPCache.h"
#import "SPAPIRequest.h"
#import "SPLog.h"
#import <MBProgressHUD.h>
#define RequestAPI(REQUEST_METHOD, REQUEST_ID)                                                 \
{                                                                                              \
__weak typeof(self) weakSelf = self;                                                            \
REQUEST_ID = [self.request request##REQUEST_METHOD##WithParams:apiParams methodName:[self.child methodName] serviceIdentify:[self.child serviceType] success:^(SPAPIResponse *response) {    \
__strong typeof(weakSelf) strongSelf = weakSelf;   \
[[SPLog shareInstance] printWithMessage:@"将从网络加载数据"];\
[strongSelf requestSuccessWithResponse:response];                                                    \
} fail:^(SPAPIResponse *response) {                                                                \
__strong typeof(weakSelf) strongSelf = weakSelf;                                                \
    [strongSelf requestFailedWithResponse:response errorType:SPAPIManagerRequestErrorTypeFailed];   \
}];                                                                                                  \
[self.requestIDList addObject:@(REQUEST_ID)];                                                      \
}

@implementation SPFileData

@end

@interface SPAPIBaseManager()
@property (nonatomic, strong) NSMutableArray *requestIDList;

@property (nonatomic) BOOL isLoading;
@property (nonatomic, assign) BOOL isNativeDataEmpty;
@property (nonatomic, strong) SPCache *cache;
@property (nonatomic, strong) SPAPIRequest *request;

@end
@implementation SPAPIBaseManager

#pragma mark --life Cirle
- (id)init{
    if(self = [super init]){
        _delegate = nil;
        _dataSource = nil;
        _interceptor = nil;
        _validator = nil;
        _errorType = SPAPIManagerRequestErrorTypeDefault;
        if([self conformsToProtocol:@protocol(SPAPIManager)]){
            self.child = (NSObject<SPAPIManager>*)self;
        }else{
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    }
    return self;
}

#pragma mark --public methods
- (NSInteger)loadData{
    NSDictionary *params = [self.dataSource paramsForApiManager:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID{
    [self removeRequestIdWithRequestID:requestID];
    [self.request cancelRequestWithRequestId:@(requestID)];
}
- (void)cancelAllRequests{
    for(NSNumber *requestID in self.requestIDList){
        [self.request cancelRequestWithRequestId:requestID];
    }
    [self.requestIDList removeAllObjects];
}
#pragma mark --internal methods
- (NSInteger)loadDataWithParams:(NSDictionary *)params{
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self.child reformParams:params];
    if([self shouldRequestApiWithParams:apiParams]){
        if([self isCorrectWithParamsData:apiParams]){
            //从外存中加载
            if([self.child shouldLoadFromNative]){
                [self loadDataFromNative];
            }
            
            //从缓存中加载
            if([self.child shouldCache] && [self hasCacheWithParams:apiParams]){
                return 0;
            }
            
            //从网络加载
            if([self isReachable]){
                self.isLoading = YES;
                switch ([self.child requestType]) {
                    case SPAPIManagerRequestTypeGet:
                        RequestAPI(GET, requestId);
                        break;
                    case SPAPIManagerRequestTypePost:
                        RequestAPI(POST, requestId);
                        break;
                    case SPAPIManagerRequestTypePut:
                        RequestAPI(PUT, requestId);
                        break;
                    case SPAPIManagerRequestTypeDelete:
                        RequestAPI(DELETE, requestId);
                        break;
                    case SPAPIManagerRequestTypeUpload:{
                        __weak typeof(self) weakSelf = self;
                        requestId = [self.request requestUPLOADWithParams:apiParams fileData:[self.dataSource uploadDataForApiManager:self] methodName:[self.child methodName] serviceIdentify:[self.child serviceType] success:^(SPAPIResponse *response) {
                            [[SPLog shareInstance] printWithMessage:@"将从网络加载数据"];
                            [weakSelf requestSuccessWithResponse:response];
                        } fail:^(SPAPIResponse *response) {
                            [weakSelf requestFailedWithResponse:response errorType:SPAPIManagerRequestErrorTypeFailed];
                        } progress:^(NSProgress *progress) {
                            [weakSelf requestUploadProgress:progress];
                        }];
                    }
                        
                    default:
                        break;
                }
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kSPAPIManagerRequestID] = @(requestId);
                [self afterRequestingAPIWithParams:params];
                return requestId;
            }else{
                //网络不通
                [self requestFailedWithResponse:nil errorType:CTAPIManagerRequestErrorTypeNoNetWork];
                return requestId;
            }
        }else{
            //Params无效，请求失败
            [self requestFailedWithResponse:nil errorType:SPAPIManagerRequestErrorTypeParamsError];
            return requestId;
        }
    }
    return requestId;
}
- (void)requestUploadProgress:(NSProgress *)progress{
    if([self.delegate respondsToSelector:@selector(manager:progress:)]){
        [self.delegate manager:self progress:progress];
    }
}

- (void)requestFailedWithResponse:(SPAPIResponse *)response errorType:(SPAPIManagerRequestErrorType)errorType{
    if([self.dataSource respondsToSelector:@selector(hudBackgroundViewForApiManager:)]){
        UIView *hudView = [self.dataSource hudBackgroundViewForApiManager:self];
        if(hudView){
            [self hideHudWithView:hudView];
        }
    }
    if([self.dataSource respondsToSelector:@selector(hudBackgroundViewForApiManager:)]){
        UIView *superView = [self.dataSource hudBackgroundViewForApiManager:self];
        if(superView){
            [self showAlertHudWithSuperView:superView text:@"网络错误" duration:1.5];
        }
    }
    self.isLoading = NO;
    self.response = response;
    _errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    
    if([self beforePerformFailWithResponse:response]){
        [self.delegate managerRequestAPIDidFailed:self];
    }
    [self afterPerformFailWithResponse:response];
}

- (void)requestSuccessWithResponse:(SPAPIResponse *)response{
    if([self.dataSource respondsToSelector:@selector(hudBackgroundViewForApiManager:)]){
        UIView *hudView = [self.dataSource hudBackgroundViewForApiManager:self];
        if(hudView){
            [self hideHudWithView:hudView];
        }
    }
    self.isLoading = NO;
    self.response = response;
    [self removeRequestIdWithRequestID:response.requestId];
    
    //存本地
    if([self.child shouldLoadFromNative]){
        if(!response.isCache){
            [[NSUserDefaults standardUserDefaults] setObject:response.responseData forKey:[self.child methodName]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if([self isCorrectWithCallBackData:response.responseData]){
        //先缓存
        if([self.child shouldCache] && !response.isCache){
             [self.cache saveCacheWithData:response.responseData serviceIdentifier:[self.child serviceType] methodName:[self.child methodName] params:response.requestParams];
        }

        if([self beforePerformSuccessWithResponse:response]){
            if([self.child shouldLoadFromNative]){
                if (response.isCache == YES) {//从本地或缓存加载的数据
                    [self.delegate managerRequestAPIDidSuccess:self];
                }
                if (response.isCache == NO) {//网络请求下来的数据
                    [self.delegate managerRequestAPIDidSuccess:self];
                }
            }else{
                [self.delegate managerRequestAPIDidSuccess:self];
            }
        }
        
        [self afterPerformSuccessWithResponse:response];
    }else{
        [self requestFailedWithResponse:response errorType:SPAPIManagerRequestErrorTypeNoContent];
    }
}


- (void)removeRequestIdWithRequestID:(NSInteger)requestId{
    NSNumber *requestIdToRemove = nil;
    for(NSNumber *storeRequestId in self.requestIDList){
        if(storeRequestId.integerValue == requestId){
            requestIdToRemove = storeRequestId;
            break;
        }
    }
    if(requestIdToRemove!=nil){
        [self.requestIDList removeObject:requestIdToRemove];
    }
}
- (BOOL)hasCacheWithParams:(NSDictionary *)params{
    NSData *result = [self.cache fatchCacheDataWithServiceIdentifier:[self.child serviceType] methodName:[self.child methodName] params:params];
    if(result == nil){
        return NO;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        SPAPIResponse *response = [[SPAPIResponse alloc] initWithData:result];
        response.requestParams = params;
        [[SPLog shareInstance] printWithMessage:@"将从本地NSCache加载"];
        [strongSelf requestSuccessWithResponse:response];
        
    });
    return YES;
    
}
- (void)loadDataFromNative{
    //从外存加载
    NSString *methodName = [self.child methodName];
    NSData *result = (NSData *)[[NSUserDefaults standardUserDefaults] dataForKey:methodName];
    if(result){
        self.isNativeDataEmpty = NO;
         __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            SPAPIResponse *response = [[SPAPIResponse alloc] initWithData:result];
            [[SPLog shareInstance] printWithMessage:@"将从本地NSUserDefaults加载"];
            [strongSelf requestSuccessWithResponse:response];
            
        });
    }else{
        self.isNativeDataEmpty = YES;
    }
}
#pragma mark --Validator methods
- (BOOL)isCorrectWithParamsData:(NSDictionary *)params{
    if([self.validator respondsToSelector:@selector(manager:isCorrectWithParamsData:)]){
        return [self.validator manager:self isCorrectWithParamsData:params];
    }
    return YES;
}

- (BOOL)isCorrectWithCallBackData:(NSData *)responseData{
    if([self.validator respondsToSelector:@selector(manager:isCorrectWithCallBackData:)]){
        return [self.validator manager:self isCorrectWithCallBackData:responseData];
    }
    return YES;
}
#pragma mark --Inteceptor methods
/**
 *  当代理是自己时直接return
 *  当代理对象不是自己时就会调用代理方法
 *  若manager的子类想要统一的在该方法里进行操作，子类可以对这些方法进行重写，但必须要调用[super 该方法]
 */
- (BOOL)shouldRequestApiWithParams:(NSDictionary *)params{
     BOOL shouldRequest =  YES;
    if(self != (NSObject*)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldRequestAPIWithParams:)]){
        shouldRequest = [self.interceptor manager:self shouldRequestAPIWithParams:params];
    }
    if(shouldRequest && [self.dataSource respondsToSelector:@selector(hudBackgroundViewForApiManager:)]){
        UIView *hudView = [self.dataSource hudBackgroundViewForApiManager:self];
        if(hudView){
            [self showHudWithView:hudView];
        }
    }
    return shouldRequest;
}

- (void)afterRequestingAPIWithParams:(NSDictionary *)params{
    if(self !=  (NSObject*)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterRequestingAPIWithParams:)]){
        [self.interceptor manager:self afterRequestingAPIWithParams:params];
    }
    
}

- (BOOL)beforePerformSuccessWithResponse:(SPAPIResponse*)response{
    if(self !=  (NSObject*)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformSuccessWithResponse:)]){
        return [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    return YES;
}

- (void)afterPerformSuccessWithResponse:(SPAPIResponse*)resonse{
    _errorType = SPAPIManagerRequestErrorTypeSuccess;
    if(self !=  (NSObject*)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]){
        [self.interceptor manager:self afterPerformSuccessWithResponse:resonse];
    }
}

- (BOOL)beforePerformFailWithResponse:(SPAPIResponse*)response{
    
    if(self !=  (NSObject*)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]){
        return [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
    return YES;
}

- (void)afterPerformFailWithResponse:(SPAPIResponse*)resonse{
    if(self !=  (NSObject*)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]){
        [self.interceptor manager:self afterPerformFailWithResponse:resonse];
    }
}

#pragma mark optionMethods of child
- (void)cleanData{
    [self.cache clean];
    _errorType = SPAPIManagerRequestErrorTypeDefault;
    _isLoading = NO;
    self.isNativeDataEmpty = NO;
}



- (NSDictionary *)reformParams:(NSDictionary *)params{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    if(childIMP == selfIMP){
        return params;
    }
    
    NSDictionary *result = [self.child reformParams:params];
    if(result){
        return result;
    }
    return params;
}

- (BOOL)shouldLoadFromNative{
    return NO;
}

#pragma mark --hud
- (void)showHudWithView:(UIView *)superView{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:superView];
    [superView addSubview:hud];
    [superView bringSubviewToFront:hud];
    hud.detailsLabelText = @"正在加载";
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
}

- (void)hideHudWithView:(UIView *)superView{
    [MBProgressHUD hideAllHUDsForView:superView animated:YES];
}

-(void)showAlertHudWithSuperView:(UIView *)superView text:(NSString *)alertText duration:(CGFloat)seconds{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:superView];
    [superView addSubview:hud];
    [superView bringSubviewToFront:hud];
    
    hud.detailsLabelText = alertText;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    [hud show:YES];
    [hud hide:YES afterDelay:seconds];
}
#pragma mark --getters and setters
- (SPCache *)cache{
    if(_cache == nil){
        _cache = [SPCache shareInstance];
    }
    return _cache;
}

- (SPAPIRequest *)request{
    if(_request == nil){
        _request = [SPAPIRequest shareInstance];
    }
    return _request;
}
- (BOOL)isReachable
{
    BOOL isReachability = [[SPAppContext shareInstance] isReachable];
    if(!isReachability){
        _errorType = CTAPIManagerRequestErrorTypeNoNetWork;
    }
    return isReachability;
}
- (NSMutableArray *)requestIDList{
    if(_requestIDList == nil){
        _requestIDList = [NSMutableArray array];
    }
    return _requestIDList;
}
- (BOOL)isLoading
{
    if (self.requestIDList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}

- (NSString *)description{
    NSString *message = [NSString stringWithFormat:@"\n isLoading = %@\n response = %@ errorType = %ld",@(self.isLoading), self.response, self.errorType];
    [[SPLog shareInstance] printWithMessage:message];
    return message;
}

- (void)dealloc{
    [[SPLog shareInstance] printWithMessage:[NSString stringWithFormat:@"==dealloc %@", NSStringFromClass([self class])]];
}
@end
