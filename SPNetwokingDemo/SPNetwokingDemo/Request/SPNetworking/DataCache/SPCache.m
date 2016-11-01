//
//  SPCache.m
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/27.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "SPCache.h"
#import "SPNetWorkingConfiguration.h"
#import "SPCachedObject.h"
#import "NSDictionary+SPNetWorkingMethods.h"
#import "SPLog.h"

@interface SPCache()
@property (nonatomic, strong) NSCache *cache;

@end
@implementation SPCache
+ (instancetype)shareInstance{
    static SPCache *instance = nil;
    if(instance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[SPCache alloc] init];
        });
    }
    return instance;
}
#pragma mark --public mothods
- (void)saveCacheWithData:(NSData *)data serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params{
    NSString *key = [self cacheKeyWithServiceIdentifier:serviceIdentifier methodName:methodName params:params];
    
    [self saveCacheWithData:data cacheKey:key];
}

- (NSString *)cacheKeyWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString*)methodName params:(NSDictionary *)params{
    NSString *key = [NSString stringWithFormat:@"%@%@%@",serviceIdentifier,methodName,[params urlParamsString]];
    return key;
}

- (void)saveCacheWithData:(NSData *)data cacheKey:(NSString *)cacheKey{
    
    SPCachedObject *cacheObject = [self.cache objectForKey:cacheKey];
    if(cacheObject == nil){
        cacheObject = [[SPCachedObject alloc] init];
    }
    [cacheObject updateContent:data];
    [self.cache setObject:cacheObject forKey:cacheKey];
}


- (NSData *)fatchCacheDataWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params{
    NSString *key = [self cacheKeyWithServiceIdentifier:serviceIdentifier methodName:methodName params:params];
    return [self fatchCacheDataWithKey:key];
}

- (NSData *)fatchCacheDataWithKey:(NSString *)key{
    SPCachedObject *object = [self.cache objectForKey:key];
    if([object isOutDated]){
        return nil;
    }
    return object.content;
}

- (void)deleteCacheDataWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params{
    NSString *key = [self cacheKeyWithServiceIdentifier:serviceIdentifier methodName:methodName params:params];
    [self deleteCacheDataWithKey:key];
}
- (void)deleteCacheDataWithKey:(NSString *)key{
    [self.cache removeObjectForKey:key];
}

- (void)clean{
    [self.cache removeAllObjects];
}
#pragma mark --getters and setters
- (NSCache *)cache{
    if(_cache == nil){
        _cache = [[NSCache alloc] init];
        _cache.countLimit = kSPCacheCount;
    }
    return _cache;
}
- (void)dealloc{
    [[SPLog shareInstance] printWithMessage:[NSString stringWithFormat:@"==dealloc %@", NSStringFromClass([self class])]];
}

@end
