//
//  SPCachedObject.h
//  SPNetWorking
//
//  Created by 史庆帅 on 16/9/27.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPCachedObject : NSObject
@property (nonatomic, copy, readonly) NSData *content;

@property (nonatomic, copy, readonly) NSDate *lastUpdateTime;

@property (nonatomic, readonly) BOOL isEmpty;

@property (nonatomic, readonly) BOOL isOutDated;

- (id)initWithContent:(NSData *)content;

- (void)updateContent:(NSData *)content;

@end
