//
//  SPCachedObject.m
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/27.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "SPCachedObject.h"
#import "SPNetWorkingConfiguration.h"

@interface SPCachedObject ()
@property (nonatomic, copy) NSData *content;
@property (nonatomic, copy) NSDate *lastUpdateTime;

@end
@implementation SPCachedObject

- (id)initWithContent:(NSData *)content{
    if(self = [super init]){
        self.content = content;
    }
    return self;
}

-(void)updateContent:(NSData *)content{
    self.content = content;
}

- (void)setContent:(NSData *)content{
    _content = [content copy];
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}

- (BOOL)isEmpty{
    if(self.content == nil){
        return NO;
    }
    return YES;
}

- (BOOL)isOutDated{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    if(interval > kSPCacheOutdateTimeSeconds){
        return YES;
    }
    return NO;
}
@end
