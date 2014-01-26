//
//  IsRead.m
//  Fish
//
//  Created by DAWEI FAN on 26/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "IsRead.h"

@implementation IsRead
@synthesize single_isRead_Data;
static IsRead * sharedSingleton = nil; //第一步：静态实例，并初始化。
+ (IsRead *) sharedInstance
{
    if (sharedSingleton == nil) {
        sharedSingleton = [[super allocWithZone:NULL] init];//第二步：实例构造检查静态实例是否为nil
    }
    return sharedSingleton;
}
+ (id) allocWithZone:(struct _NSZone *)zone//第三步：重写allocWithZone方法
{
    return [[self sharedInstance] retain];
}

- (id) copyWithZone:(NSZone *) zone//第四步
{
    return self;
}

- (id) retain
{
    return self;
}

- (NSUInteger) retainCount
{
    return NSUIntegerMax;
}
- (oneway void) release
{
    [single_isRead_Data release];
}

- (id) autorelease
{
    return self;
}
-(id)init
{
    @synchronized(self) {
        single_isRead_Data =[[NSMutableArray alloc]init];
        return self;
    }
}

@end
