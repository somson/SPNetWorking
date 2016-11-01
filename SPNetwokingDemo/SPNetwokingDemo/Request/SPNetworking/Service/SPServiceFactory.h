//
//  SPServiceFactory.h
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/28.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPService.h"
@interface SPServiceFactory : NSObject
+ (instancetype)shareInstance;


- (SPService<SPServiceProtocol> *)serviceWithServiceIdentify:(NSString *)serviceIdentify;

@end
