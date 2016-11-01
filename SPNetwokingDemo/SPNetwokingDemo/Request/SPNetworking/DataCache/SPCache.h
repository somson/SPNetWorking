//
//  SPCache.h
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/27.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPCache : NSObject
+ (instancetype)shareInstance;

- (void)saveCacheWithData:(NSData *)data serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params;

- (NSString *)cacheKeyWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString*)methodName params:(NSDictionary *)params;

- (void)saveCacheWithData:(NSData *)data cacheKey:(NSString *)cacheKey;

- (NSData *)fatchCacheDataWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params;


- (NSData *)fatchCacheDataWithKey:(NSString *)key;

- (void)deleteCacheDataWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params;

- (void)deleteCacheDataWithKey:(NSString *)key;

- (void)clean;

@end
