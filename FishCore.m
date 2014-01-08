//
//  FishCore.m
//  Fish
//
//  Created by DAWEI FAN on 13/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "FishCore.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "JSONKit.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
@implementation FishSave
@synthesize tileArray=tileArray;
@end

@implementation CategoryItem
@synthesize CategoryId=CategoryId;
@synthesize CategoryPid=CategoryPid;
@synthesize CategoryFlag=CategoryFlag;
@synthesize CategoryImage=CategoryImage;
@synthesize CategoryLevel=CategoryLevel;
@synthesize CategoryName=CategoryName;
//查询 - 列表 [category/read_lst]


@end

///////////////////////////////////////////////////////////
@implementation ContentRead
@synthesize filter_is_sticky=filter_is_sticky;
@synthesize filter_category_id=filter_category_id;
@synthesize offset=offset;
@synthesize delegate=delegate;
@synthesize content=content;
@synthesize total=total;
@synthesize categoryItem=categoryItem;
-(void)Category
{
    NSURL *url = [ NSURL URLWithString : @"http://42.96.192.186/ifish/server/index.php/app/mgz/category/read_lst" ];
    __block ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL :url];
    [request setRequestMethod:@"POST"];
    // ASIHTTPRequest 支持 iOS 4.0 的块语法，你可以把委托方法定义到块中
    [request setCompletionBlock :^{
        // 请求响应结束，返回 responseString
        NSString *responseString = [request responseString ]; // 对于 2 进制数据，使用 NSData 返回
        //[delegate reBack:responseString];
        [delegate getJsonString:responseString isPri:@"2"];
    }];
    [request setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [request startAsynchronous ];
}
//content/read_lst
//查询 - 列表
-(void)fetchList:( NSString  * )ID isPri:(NSString*)flag  Out:(NSString *) Offset;
{
    NSURL *url = [ NSURL URLWithString : @"http://42.96.192.186/ifish/server/index.php/app/mgz/content/read_lst" ];
    __block ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL :url];
     [request setRequestMethod:@"POST"];
     [request setPostValue:ID forKey:@"filter_category_id"];
     [request setPostValue:flag forKey:@"filter_is_sticky"];
     [request setPostValue:Offset forKey:@"offset"];
 
     NSLog(@"%d",[request responseStatusCode]);
    [request setCompletionBlock :^{
        NSString * jsonString  =  [request responseString];
        [delegate getJsonString :jsonString isPri:flag ];
        //        NSDictionary *jsondictionary=[jsonString JSONValue];
     //  NSLog(@"++++%@+++++++",jsonString);

    }];
    [request setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [request startAsynchronous ];//异步


}
//杂志分期
-(void)Magazine:(NSString *)ID Out:(NSString *)Offent
{
    NSURL *url = [ NSURL URLWithString : @"http://42.96.192.186/ifish/server/index.php/app/mgz/weekly/read_lst" ];
    __block ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL :url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:ID forKey:@"filter_category_id"];
    [request setPostValue:Offent forKey:@"offset"];
    
    [request setDelegate:self];
    [request setCompletionBlock :^{
     
        NSString * jsonString  =  [request responseString];
        [delegate getJsonString:jsonString isPri:@"0"];
        
    }];
    [request setFailedBlock :^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        
    }];
    
    [request startAsynchronous ];//异步
}
//杂志查询列表
-(void)Magazine:(NSString*)ID isPri:(NSString *)flag WeeklyId:(NSString *) Id Out:(NSString *)Offset;
{
    NSURL *url = [ NSURL URLWithString : @"http://42.96.192.186/ifish/server/index.php/app/mgz/content/read_lst" ];
    __block ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL :url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:ID forKey:@"filter_category_id"];
    [request setPostValue:flag forKey:@"filter_is_sticky"];
    [request setPostValue:Offset forKey:@"offset"];
    [request setPostValue:Id forKey:@"filter_weekly_id"];
   
    NSLog(@"%d",[request responseStatusCode]);
    [request setCompletionBlock :^{
        NSString * json  =  [request responseString];
       
       [delegate reBack :json];
             }];
    [request setFailedBlock :^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [request startAsynchronous ]; 
}
//查询 - 详细 [content/read_dtl
-(void)ContentDetail:(NSString*) content_id
{
    NSURL *url = [ NSURL URLWithString : @"http://42.96.192.186/ifish/server/index.php/app/mgz/content/read_dtl" ];
    __block ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL :url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:content_id forKey:@"content_id"];
    
    [request setDelegate:self];
    [request setCompletionBlock :^{
        // 请求响应结束，返回 responseString
           NSString * jsonString  =  [request responseString];
        
           //NSLog(@"++++%@+++++++",jsonString);
        
    }];
    [request setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        
    }];
    [request startAsynchronous ];//异步
}
//setting/read_lst查询 - 列表
-(void)ContentSetting
{
    NSURL *url = [ NSURL URLWithString : @"http://42.96.192.186/ifish/server/index.php/app/mgz/setting/read_lst"];
    __block ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL :url];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock :^{
        
        NSString * jsonString  =  [request responseString];
        [delegate getJsonString:jsonString isPri:@"0"];
        
    }];
    [request setFailedBlock :^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [request startAsynchronous ];

}
//【反馈】添加 [feedback/create]
-(void)Submmit:(NSString *)contact typeBack:(NSString *)feedback_category content:(NSString *)feedback_content
{
     NSURL *url = [ NSURL URLWithString : @"http://42.96.192.186/ifish/server/index.php/app/mgz/feedback/create"];
    __block ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL :url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:contact forKey:@"contact"];
    [request setPostValue:feedback_category forKey:@"feedback_category"];
    [request setPostValue:feedback_content forKey:@"feedback_content"];
    
    NSLog(@"%d",[request responseStatusCode]);
    [request setCompletionBlock :^{
        NSString * string =  [request responseString];
        [delegate reBack:string];
    }];
    [request setFailedBlock :^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [request startAsynchronous ];

}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    BOOL success = ([request responseStatusCode] == 200);
    NSLog(@"%d",[request responseStatusCode]);
    if(success)
    {
     //   NSString * jsonString  =  [request responseString];
       //[ self appendToDataSource:jsonString];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error ];
    NSLog ( @"%@" ,error. userInfo );
}

-(void)dealloc
{
    [content release];
    [super dealloc];
}
@end
















