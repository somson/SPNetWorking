//
//  ViewController.m
//  SPNetwokingDemo
//
//  Created by 史庆帅 on 2016/11/1.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "ViewController.h"
#import "SPNetworking.h"
#import "GetPlantPromptApiManager.h"
@interface ViewController ()<SPAPIManagerCallBackDelegate, SPAPIManagerDataSource, SPAPIManagerValidator, SPAPIManagerInterceptor>
@property (nonatomic, strong) GetPlantPromptApiManager *plantPromptApiManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark --event response
- (IBAction)send:(id)sender {
    [self.plantPromptApiManager loadData];
}

#pragma mark --SPAPIManagerCallBackDelegate
//处理失败数据
- (void)managerRequestAPIDidFailed:(SPAPIBaseManager *)manager{
    NSLog(@"结果---处理失败数据");
    NSLog(@"%@",manager.response.error);
}
//处理成功数据
- (void)managerRequestAPIDidSuccess:(SPAPIBaseManager *)manager{
    NSLog(@"结果---处理成功数据");
    NSLog(@"%@",manager.response.content);
}
#pragma mark --SPAPIManagerDataSource
//请求参数
- (NSDictionary *)paramsForApiManager:(SPAPIBaseManager *)manager{
    return nil;
}
//显示hud的视图
- (UIView *)hudBackgroundViewForApiManager:(SPAPIBaseManager *)manager{
    return self.view;
}

#pragma mark --SPAPIManagerValidator
//验证param是否正确
-(BOOL)manager:(SPAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)params{
    NSLog(@"验证---验证请求参数是否正确");
    return YES;
}

//验证响应的数据是否正确
- (BOOL)manager:(SPAPIBaseManager *)manager isCorrectWithCallBackData:(NSData *)data{
    NSLog(@"验证---验证响应数据是否正确");
    return YES;
}

#pragma mark -- SPAPIManagerInterceptor
- (BOOL)manager:(SPAPIBaseManager *)manager shouldRequestAPIWithParams:(NSDictionary *)params{
    NSLog(@"拦截---准备发出数据请求，可控制是否请求");
    return YES;
}

- (void)manager:(SPAPIBaseManager *)manager afterRequestingAPIWithParams:(NSDictionary *)params{
    NSLog(@"拦截---已发出数据请求");
}

- (BOOL)manager:(SPAPIBaseManager *)manager beforePerformFailWithResponse:(SPAPIResponse *)response{
    NSLog(@"拦截---处理失败响应数据之前，可控制是否处理失败数据");
    return YES;
}

- (void)manager:(SPAPIBaseManager *)manager afterPerformFailWithResponse:(SPAPIResponse *)resonse{
    NSLog(@"拦截---已处理完失败响应数据");
}

- (BOOL)manager:(SPAPIBaseManager *)manager beforePerformSuccessWithResponse:(SPAPIResponse *)response{
    NSLog(@"拦截---处理成功响应数据之前，可控制是否处理成功数据");
    return YES;
}

- (void)manager:(SPAPIBaseManager *)manager afterPerformSuccessWithResponse:(SPAPIResponse *)resonse{
    NSLog(@"拦截---已处理完成功响应数据");
}


#pragma mark --getters and setters
- (GetPlantPromptApiManager *)plantPromptApiManager{
    if(_plantPromptApiManager == nil){
        _plantPromptApiManager = [[GetPlantPromptApiManager alloc] init];
        _plantPromptApiManager.delegate = self;
        _plantPromptApiManager.dataSource = self;
        _plantPromptApiManager.validator = self;
        _plantPromptApiManager.interceptor = self;
    }
    return _plantPromptApiManager;
}

@end
