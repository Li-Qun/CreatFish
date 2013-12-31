//
//  FishTests.m
//  FishTests
//
//  Created by liqun on 12/3/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "FishTests.h"
#import "FishCore.h"



#import "SBJson.h"
 


@implementation FishTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

//- (void)testExample
//{
//    STFail(@"Unit tests are not implemented yet in FishTests");
//}
-(void)testCaddvd
{

    ContentRead *contentRead=[[ContentRead alloc]init];
  
    [contentRead fetchList:@"1" isPri:@"1" Out:@"1"];
   
     
}




@end
