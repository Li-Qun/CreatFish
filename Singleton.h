//
//  Singleton.h
//  Fish
//
//  Created by DAWEI FAN on 04/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject
{
    NSMutableArray *single_Data;
    int isFirstOpen_View;
}

+ (Singleton *) sharedInstance;
@property(nonatomic,retain)   NSMutableArray *single_Data;
@property(nonatomic)int isFirstOpen_View;

@end
