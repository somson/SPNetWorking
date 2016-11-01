//
//  SPAPIBaseManager.h
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/26.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SPAPIBaseManager, SPAPIResponse, SPFileData;

/**
 *  使用此方法manager能够获取API所需要的数据
 */
@protocol SPAPIManagerDataSource <NSObject>

@required
- (NSDictionary *)paramsForApiManager:(SPAPIBaseManager *)manager;

@optional
- (UIView*)hudBackgroundViewForApiManager:(SPAPIBaseManager *)manager;

- (SPFileData *)uploadDataForApiManager:(SPAPIBaseManager *)manager;
@end

/**
 *  回调时执行此代理的方法
 */
@protocol SPAPIManagerCallBackDelegate <NSObject>
@required

- (void)managerRequestAPIDidSuccess:(SPAPIBaseManager *)manager;

- (void)managerRequestAPIDidFailed:(SPAPIBaseManager *)manager;

@optional
- (void)manager:(SPAPIBaseManager *)manager progress:(NSProgress *)progress;

@end


/**
 *  请求时的拦截方法
 */
@protocol SPAPIManagerInterceptor <NSObject>

@optional
- (BOOL)manager:(SPAPIBaseManager *)manager beforePerformSuccessWithResponse:(SPAPIResponse*)response;

- (void)manager:(SPAPIBaseManager *)manager afterPerformSuccessWithResponse:(SPAPIResponse*)resonse;


- (BOOL)manager:(SPAPIBaseManager *)manager beforePerformFailWithResponse:(SPAPIResponse*)response;


- (void)manager:(SPAPIBaseManager *)manager afterPerformFailWithResponse:(SPAPIResponse*)resonse;

- (BOOL)manager:(SPAPIBaseManager *)manager shouldRequestAPIWithParams:(NSDictionary *)params;

- (void)manager:(SPAPIBaseManager *)manager afterRequestingAPIWithParams:(NSDictionary *)params;

@end

/**
 *  请求时的验证方法
 */
@protocol SPAPIManagerValidator <NSObject>
@required
- (BOOL)manager:(SPAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)params;


- (BOOL)manager:(SPAPIBaseManager *)manager isCorrectWithCallBackData:(NSData *)data;


@end


typedef NS_ENUM(NSInteger, SPAPIManagerRequestErrorType){
    SPAPIManagerRequestErrorTypeDefault, //默认状态
    SPAPIManagerRequestErrorTypeSuccess, //API请求成功且返回数据正确
    SPAPIManagerRequestErrorTypeFailed,  //产生API请求了，但没有成功
    SPAPIManagerRequestErrorTypeNoContent, //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个
    SPAPIManagerRequestErrorTypeParamsError, //请求参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的
    CTAPIManagerRequestErrorTypeTimeout, //请求超时错误
    CTAPIManagerRequestErrorTypeNoNetWork //网络不通，在调用API之前会判断一下当前网络是否通畅
};

/**
 *  请求类型的枚举
 */
typedef  NS_ENUM(NSInteger, SPAPIManagerRequestType){
    SPAPIManagerRequestTypeGet,
    SPAPIManagerRequestTypePost,
    SPAPIManagerRequestTypePut,
    SPAPIManagerRequestTypeDelete,
    SPAPIManagerRequestTypeUpload
};

/**
 *  SPAPIBaseManager的派生类必须符合这些protocal
 */
@protocol SPAPIManager <NSObject>
@required
- (NSString *)methodName;

- (SPAPIManagerRequestType)requestType;

- (BOOL)shouldCache;

- (NSString *)serviceType;
@optional

- (NSData *)uploadData;

- (void)cleanData;

- (NSDictionary *)reformParams:(NSDictionary *)params;

- (BOOL)shouldLoadFromNative;

@end

@interface SPFileData : NSObject
@property (nonatomic, copy) NSData *data;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mimeType;
@end

@interface SPAPIBaseManager : NSObject

@property (nonatomic, weak) id<SPAPIManagerCallBackDelegate>delegate;

@property (nonatomic, weak) id<SPAPIManagerDataSource> dataSource;

@property (nonatomic, weak) NSObject<SPAPIManager> *child;

@property (nonatomic, weak) id<SPAPIManagerInterceptor>interceptor;

@property (nonatomic, weak) id<SPAPIManagerValidator> validator;


@property (nonatomic, assign, readonly) SPAPIManagerRequestErrorType errorType;
@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, strong) SPAPIResponse *response;

/**
 *  请求数据
 *
 *  @return 请求任务的identify
 */
- (NSInteger)loadData;

- (void)cancelRequestWithRequestId:(NSInteger)requestID;

- (void)cancelAllRequests;


//拦截方法 子类可以重写方法
- (BOOL)shouldRequestApiWithParams:(NSDictionary *)params;

- (void)afterRequestingAPIWithParams:(NSDictionary *)params;

- (BOOL)beforePerformSuccessWithResponse:(SPAPIResponse*)response;

- (void)afterPerformSuccessWithResponse:(SPAPIResponse*)resonse;

- (BOOL)beforePerformFailWithResponse:(SPAPIResponse*)response;

- (void)afterPerformFailWithResponse:(SPAPIResponse*)resonse;

@end
