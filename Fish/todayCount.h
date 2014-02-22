//
//  todayCount.h
//  Fish
//
//  Created by DAWEI FAN on 20/02/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface todayCount : NSObject
{
    NSMutableArray *todayCount_Data;
    
}

+ (todayCount *) sharedInstance;
@property(nonatomic,retain)  NSMutableArray *todayCount_Data;

@end
