//
//  GetPlantPromptApiManager.m
//  SPNetwokingDemo
//
//  Created by 史庆帅 on 2016/11/1.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "GetPlantPromptApiManager.h"
#import "SPNetWorkingConfiguration.h"
@implementation GetPlantPromptApiManager
//请求接口名称
- (NSString *)methodName{
    return @"plantType/getPlantPrompt";
}
//请求接口类型
- (SPAPIManagerRequestType)requestType{
    return SPAPIManagerRequestTypeGet;
}
//使用的哪个服务
- (NSString *)serviceType{
    return kSPServiceTest;
}
//是否缓存
- (BOOL)shouldCache{
    return NO;
}
@end
