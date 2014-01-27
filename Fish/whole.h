//
//  whole.h
//  Fish
//
//  Created by DAWEI FAN on 27/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface whole : NSObject
{
    NSString *wholeString;
}
+ (whole*) sharedInstance;
@property(nonatomic,retain) NSString *wholeString;
@end
