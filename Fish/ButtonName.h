//
//  ButtonName.h
//  Fish
//
//  Created by DAWEI FAN on 20/02/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ButtonName : NSObject
{
    NSMutableArray *buttonName;
    
}

+ (ButtonName *) sharedInstance;
@property(nonatomic,retain)  NSMutableArray *buttonName;


@end
