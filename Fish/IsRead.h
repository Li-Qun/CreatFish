//
//  IsRead.h
//  Fish
//
//  Created by DAWEI FAN on 26/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IsRead : NSObject
{
        NSMutableArray *single_isRead_Data;
}
+ (IsRead *) sharedInstance;
@property(nonatomic,retain)   NSMutableArray *single_isRead_Data;
@end
