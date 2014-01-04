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
    NSMutableArray *singgle_StoreData;
    NSMutableArray *single_Data;
    NSMutableArray *single_Data_name;
    NSMutableArray *single_Data_image;
   
}

+ (Singleton *) sharedInstance;
@property(nonatomic,retain)   NSMutableArray *singgle_StoreData;
@property(nonatomic,retain)   NSMutableArray *single_Data;
@property(nonatomic,retain)   NSMutableArray *single_Data_name;
@property(nonatomic,retain)   NSMutableArray *single_Data_image;

@end
