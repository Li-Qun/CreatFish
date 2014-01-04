//
//  Singleton.m
//  Fish
//
//  Created by DAWEI FAN on 04/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
@synthesize single_Data;
static Singleton * sharedSingleton = nil; //第一步：静态实例，并初始化。

+ (Singleton *) sharedInstance
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
    [singgle_StoreData release];
    [single_Data release];
    [single_Data_name release];
    [single_Data_image release];
}

- (id) autorelease
{
    return self;
}
-(id)init
{
    @synchronized(self) {
        singgle_StoreData=[[ NSMutableArray alloc]init];
        single_Data=[[NSMutableArray alloc]init];
        single_Data_image=[[NSMutableArray alloc]init];
        single_Data_name=[[NSMutableArray alloc]init];
        [super init];//往往放一些要初始化的变量.
        return self;
    }
}

@end