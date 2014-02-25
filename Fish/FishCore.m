//
//  FishCore.m
//  Fish
//
//  Created by DAWEI FAN on 13/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "FishCore.h"

#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

#import "SBJson.h"
#import "JSONKit.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"


///////////////////////////////////////////////////////////
@implementation ContentRead
@synthesize filter_is_sticky=filter_is_sticky;
@synthesize filter_category_id=filter_category_id;
@synthesize offset=offset;
@synthesize delegate=delegate;
@synthesize content=content;
@synthesize total=total;
//@synthesize categoryItem=categoryItem;
-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {

    }
    return isExistenceNetwork;
}
-(void)Category
{
    if([self isConnectionAvailable])
    {
        NSString *string=[NSString stringWithFormat:@"%@category/read_lst",Root];
        NSLog(@"%@",string);
        NSURL *url = [ NSURL URLWithString :  string ];
        __block ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL :url];
        [request setRequestMethod:@"POST"];
        // ASIHTTPRequest 支持 iOS 4.0 的块语法，你可以把委托方法定义到块中
        [request setCompletionBlock :^{
            // 请求响应结束，返回 responseString
            NSString *responseString = [request responseString ]; // 对于 2 进制数据，使用 NSData 返回
            //[delegate reBack:responseString];
            [delegate getJsonString:responseString isPri:@"6" isID:@"0" Offent:@"0"];
        }];
        [request setFailedBlock :^{
            // 请求响应失败，返回错误信息
            NSLog(@"HTTP 响应码：%d",[request responseStatusCode]);
            NSError *error = [request error ];
//            [delegate reBack:@"6" reLoad:@"0"];
            NSLog ( @"error:%@" ,[error userInfo ]);
            
            [self mention];
        }];
        [request startAsynchronous ];
    }
    else{
          [delegate reBack:@"6" reLoad:@"0" Offent:@"0"];
    }
}
//content/read_lst
//查询 - 列表
-(void)fetchList:( NSString  * )ID isPri:(NSString*)flag  Out:(NSString *) Offset;
{
   if([self isConnectionAvailable])
   {
       NSString *string=[NSString stringWithFormat:@"%@content/read_lst",Root];
       
       NSURL *url = [ NSURL URLWithString :  string ];
       __block ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL :url];
       [request setRequestMethod:@"POST"];
       [request setPostValue:ID forKey:@"filter_category_id"];
       [request setPostValue:flag forKey:@"filter_is_sticky"];
       [request setPostValue:Offset forKey:@"offset"];
       
       NSLog(@"%d",[request responseStatusCode]);
       [request setCompletionBlock :^{
           NSString * jsonString  =  [request responseString];
           [delegate getJsonString :jsonString isPri:flag isID:ID Offent:Offset];
           //        NSDictionary *jsondictionary=[jsonString JSONValue];
           //  NSLog(@"++++%@+++++++",jsonString);
           
       }];
       [request setFailedBlock :^{
           // 请求响应失败，返回错误信息
         //  [delegate reBack:flag reLoad:ID];
           NSLog(@"HTTP 响应码：%d",[request responseStatusCode]);
           NSError *error = [request error ];
           NSLog ( @"error:%@" ,[error userInfo ]);
            [self mention ];
//
       }];
       [request startAsynchronous ];//异步

   }
   else{
       
        [delegate reBack:flag reLoad:ID Offent:Offset];
   }
}
//【画廊】查询 - 列表 [gallery/read_lst]
-(void)gallery:(NSString *)content_id
{
    if([self isConnectionAvailable])
    {
        NSString *string=[NSString stringWithFormat:@"%@gallery/read_lst",Root];
        NSURL *url = [ NSURL URLWithString :  string ];
        __block ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL :url];
        [request setRequestMethod:@"POST"];
        [request setPostValue:content_id forKey:@"content_id"];
        
        [request setDelegate:self];
        [request setCompletionBlock :^{
            
            NSString * jsonString  =  [request responseString];
            [delegate  getJsonString:jsonString isPri:@"0" isID:content_id Offent:@"0"];
        }];
        [request setFailedBlock :^{
            
//            [delegate reBack:@"0" reLoad:content_id];
            NSError *error = [request error ];
            NSLog ( @"error:%@" ,[error userInfo ]);
             [self mention ];
        }];
        [request startAsynchronous ];//异步
    }
    else
    {
        [delegate reBack:@"0" reLoad:content_id Offent:@"0"];
    }
   
}
//查询 - 详细  阅读界面[content/read_dtl
-(void)Content:(NSString *)current_category_id  Detail:(NSString*)content_id
{
    if([self isConnectionAvailable])
    {
        NSString *string=[NSString stringWithFormat:@"%@content/read_dtl",Root];
        NSURL *url = [ NSURL URLWithString :  string ];
      
        __block ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL :url];
        [request setRequestMethod:@"POST"];
        
        [request setPostValue:current_category_id forKey:@"current_category_id"];
        [request setPostValue:content_id forKey:@"content_id"];
        
        
        [request setDelegate:self];
        [request setCompletionBlock :^{
            NSString * jsonString  =  [request responseString];
            [delegate getJsonString:jsonString isPri:@"0" isID:content_id Offent:current_category_id];
            // [delegate reBack :jsonString];
        }];
        [request setFailedBlock :^{
            NSError *error = [request error ];
            NSLog ( @"error:%@" ,[error userInfo ]);
             [self mention ];
        }];
        [request startAsynchronous ];//异步
    }
    else
    {
        [delegate reBack:@"5" reLoad:content_id Offent:current_category_id];
    }
    
}
 //setting/read_lst查询 - 列表
-(void)ContentSetting
{
    if([self isConnectionAvailable])
    {
        NSString *string=[NSString stringWithFormat:@"%@setting/read_lst",Root];
        NSURL *url = [ NSURL URLWithString :  string ];
        __block ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL :url];
        [request setRequestMethod:@"POST"];
        [request setCompletionBlock :^{
            
            NSString * jsonString  =  [request responseString];
            [delegate getJsonString:jsonString isPri:@"first" isID:@"0" Offent:@"0"];
            
        }];
        [request setFailedBlock :^{
          //  [delegate reBack:@"5" reLoad:@"0"];
            NSError *error = [request error ];
            NSLog ( @"error:%@" ,[error userInfo ]);
             [self mention:[request responseStatusCode]];
        }];
        [request startAsynchronous ];

    }
    else
    {
        [delegate reBack:@"5" reLoad:@"0" Offent:@"0"];
    }
}
//【反馈】添加 [feedback/create]
-(void)Submmit:(NSString *)contact typeBack:(NSString *)feedback_category content:(NSString *)feedback_content
{
    NSString *string=[NSString stringWithFormat:@"%@feedback/create",Root];
    NSURL *url = [ NSURL URLWithString :  string ];
    __block ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL :url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:contact forKey:@"contact"];
    [request setPostValue:feedback_category forKey:@"feedback_category"];
    [request setPostValue:feedback_content forKey:@"feedback_content"];
    
    NSLog(@"%d",[request responseStatusCode]);
    [request setCompletionBlock :^{
        NSString * string =  [request responseString];
        [delegate reBack:string reLoad:@"0" Offent:@"0"];
    }];
    [request setFailedBlock :^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
         [self mention ];
    }];
    [request startAsynchronous ];

}
-(void)mention
{
        
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"服务器无响应"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil]autorelease];
    [alert show];
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    BOOL success = ([request responseStatusCode] == 200);
    NSLog(@"HTTP 响应码：%d",[request responseStatusCode]);
    if(success)
    {
     //   NSString * jsonString  =  [request responseString];
       //[ self appendToDataSource:jsonString];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"＊＊＊＊＊＊HTTP 响应码：%d",[request responseStatusCode]);
    NSError *error = [request error ];
    NSLog ( @"%@" ,error. userInfo );
}

-(void)dealloc
{
    [content release];
    [super dealloc];
}
@end
















