
//
//  todayCount.m
//  Fish
//
//  Created by DAWEI FAN on 20/02/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "todayCount.h"

@implementation todayCount
@synthesize todayCount_Data=todayCount_Data;

static todayCount * sharedSingleton = nil; //第一步：静态实例，并初始化。

+ (todayCount *) sharedInstance
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
    [todayCount_Data release];
}

- (id) autorelease
{
    return self;
}
-(id)init
{
    @synchronized(self) {
        todayCount_Data=[[NSMutableArray alloc]init];
        return self;
    }
}

@end