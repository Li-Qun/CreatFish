//
//  ViewController.m
//  Fish
//
//  Created by liqun on 12/3/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "ViewController.h"
#import "IIViewDeckController.h"
#import "BigFishViewController.h"
#import "TopicViewController.h"
#import  "DetailViewController.h"
#include "BookViewController.h"

#import "AppDelegate.h"
#import "StoreUpViewController.h"
#import "Singleton.h"
#import "ButtonName.h"
#import "todayCount.h"
#import "IsRead.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import <Foundation/Foundation.h>
#import <sqlite3.h>
//#import "BaiduMobStat.h"
@interface ViewController ()

@end

@implementation ViewController

@synthesize contentRead=contentRead;
@synthesize klpImgArr;
@synthesize klpScrollView1;
@synthesize labelText=labelText;
@synthesize textView=textView;
@synthesize labelDay=labelDay;


//百度页面统计
-(void)viewDidAppear:(BOOL)animated
{
//    NSString *cName=@"View&首页";
//    [[BaiduMobStat defaultStat]pageviewStartWithName:cName ];
}
-(void)viewDidDisappear:(BOOL)animated
{
//    NSString *cName=@"View&首页";
//    [[BaiduMobStat defaultStat]pageviewEndWithName:cName ];
}

- (void)viewWillAppear:(BOOL)animated
{//视图即将可见时调用。默认情况下不执行任何操作
    
    [super viewWillAppear:animated];
    [textView setEditable:NO];
    textView.backgroundColor=[UIColor clearColor];
    [self.navigationController setNavigationBarHidden:YES ];//把后面的antimated=YES 去掉 就不会过渡出现问题了
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;

    height_Momente = size.height;
    if(height_Momente==480){
        height=20;
        height5_flag=NO;
        isFive=NO;
    }
    else  {height5_flag=YES;isFive=YES;
    }
    // 判断设备的iOS 版本号
    float  version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version==7.0)
    {
        Kind7=YES;
        isSeven=YES;
    }
    else {
        Kind7=NO;
        isSeven=NO;
    }
    [self theTopBar];
    [self _init];
 }
-(void)BuildFirstPage
{
    [contentRead fetchList:@"1" isPri:@"0" Out:@"0"];
    [contentRead Category];
}

-(void)_init
{
    arrName=[[[NSMutableArray alloc]init]retain];
    contentRead =[[[ContentRead alloc]init]autorelease];
    contentRead.delegate=self;
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app build];
   //通过KEY找到value
    if(isFirstOpen)
    {
        [self BuildFirstPage];
        isFirstOpen=NO;
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.view.backgroundColor=[UIColor whiteColor];
    // scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    arr=[[[NSMutableArray alloc]init]retain];
    isFirstOpen=YES;
}

-(void)reBack:(NSString *)jsonString reLoad :(NSString *)ID Offent:(NSString *)Out
{
     
    float heightTooBar;
    float buttonHeight;
    
    if(height5_flag&&Kind7)
    {
        heightTooBar=height_Momente-height-44;
        buttonHeight=5+height_Momente-44-height;
    }else if(height5_flag&&!Kind7)
    {
        heightTooBar=height_Momente-44;
        buttonHeight=5+height_Momente-44-20;
    }
    else if (!height5_flag&&Kind7)
    {
        heightTooBar=height_Momente-44;
        buttonHeight=5+height_Momente-44 ;
    }
    else {
        heightTooBar=height_Momente-height-44 ;
        buttonHeight=5+height_Momente-44-height;
    }
    
    
    if([jsonString isEqualToString:@"6"])
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *strJson;
            NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPaths=[array objectAtIndex:0];
            NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"NewsViewController"];
            //  然后建立数据库，新建数据库这个苹果做的非常好，非常方便
            sqlite3 *database;
            //新建数据库，存在则打开，不存在则创建
            if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
            {
                NSLog(@"open success");
            }
            else {
                NSLog(@"open failed");
            }
            // 对数据库建表操作：如果在些程序的过程中，发现表的字段要更改，一定要删除之前的表，如何做，就是删除程序或者换个表名，主键是自增的
            char *errorMsg;
            NSString *sql=@"CREATE TABLE IF NOT EXISTS buttonList (ID INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT)";
            //创建表
            if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
            {
                NSLog(@"create success");
            }else{
                NSLog(@"create error:%s",errorMsg);
                sqlite3_free(errorMsg);
            }
            // 查找数据
            BOOL flag=NO;
            sql = @"select * from buttonList";
            sqlite3_stmt *stmt;
            if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
            {
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    if(sqlite3_column_count(stmt)==0)
                    {
                        flag=YES;
                        break;
                    }
                    const unsigned char *theName= sqlite3_column_text(stmt, 1);
                    strJson= [NSString stringWithUTF8String: theName];
                    break;
                }
            }
            /////start
            SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
            NSArray *jsonObj =[parser objectWithString:strJson];
   
     /*
            //
            NSString* date_Today;
            NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
            [formatter  setDateFormat:@"20YY-MM-dd"];
            date_Today = [formatter stringFromDate:[NSDate date]];

            
            ///今天新闻条数 数据库start
            
            
            sql=@"CREATE TABLE IF NOT EXISTS todaySum (ID TEXT,date TEXT)";
            //创建表
            if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
            {
                NSLog(@"创建打开toolbar");
            }else{
                NSLog(@"create error:%s",errorMsg);
                sqlite3_free(errorMsg);
            }
//            sqlite3_stmt *stmt;
            BOOL isFresh=NO;
            sql=[NSString stringWithFormat:@"select date from todaySum where date ='%@'",date_Today];
            if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
            {
                
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    if(sqlite3_column_count(stmt)==0)
                        break;
                    else
                    {
                        isFresh=YES;
                        break;
                    }
                }
            }
            int j=0;
            if(isFresh)//数据库的存储是当天的Today-count
            {
                NSString *today_count=@"0";
                BOOL flag=NO;
                sql= @"select ID  from todaySum";
                if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
                {
                    
                    [[todayCount sharedInstance].todayCount_Data removeAllObjects];
                    while (sqlite3_step(stmt)==SQLITE_ROW) {
                        if(sqlite3_column_count(stmt)==0)
                        {
                            flag=YES;
                            break;
                        }
                        const unsigned char *_id= sqlite3_column_text(stmt, 0);
                        if(_id==NULL)break;//字符串为空
                        today_count= [NSString stringWithUTF8String: _id];
                        [[todayCount sharedInstance].todayCount_Data insertObject:today_count atIndex:j];
                        j++;
                    }
                }
                
            }
            else
            {
                if(flag||!isFresh)
                {
                    int k=0;
                    [app.array_btID removeAllObjects];
                    for(int i=0;i<jsonObj.count;i++)
                    {
                        [[todayCount sharedInstance].todayCount_Data removeAllObjects];
                        for(int i=1;i<jsonObj.count;i++)
                        {
                            if([[[jsonObj  objectAtIndex:i] objectForKey:@"pid"] integerValue]==0)
                            {
                                [[todayCount sharedInstance].todayCount_Data addObject:[[jsonObj  objectAtIndex:i] objectForKey:@"today_count"] ];
                            }
                        }
                    }
                }
            }
            int k=0;
            [app.array_btID removeAllObjects];
            for(int i=0;i<jsonObj.count;i++)
            {
                if([[[jsonObj  objectAtIndex:i] objectForKey:@"pid"] integerValue]==0&&i!=0)
                {
                    
                    [app.array_btID insertObject:[[jsonObj  objectAtIndex:i] objectForKey:@"id"] atIndex:k];
                    
                    k++;
                }
            }*/
            sqlite3_finalize(stmt);
            sqlite3_close(database);

/*
            sqlite3_finalize(stmt);
 
            sqlite3_close(database);
 
            SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
            NSArray *jsonObj =[parser objectWithString: strJson];
 
            int j=0;
            [app.array_btID removeAllObjects];
            for(int i=0;i<jsonObj.count;i++)
            {
                if([[[jsonObj  objectAtIndex:i] objectForKey:@"pid"] integerValue]==0&&i!=0)
                {
                    
                    [app.array_btID insertObject:[[jsonObj  objectAtIndex:i] objectForKey:@"id"] atIndex:j];
                    
                    
                    j++;
                }
            }
 */

            int j=0;
            [app.array_btID removeAllObjects];
            for(int i=0;i<jsonObj.count;i++)
            {
                if([[[jsonObj  objectAtIndex:i] objectForKey:@"pid"] integerValue]==0&&i!=0)
                {
                    
                    [app.array_btID insertObject:[[jsonObj  objectAtIndex:i] objectForKey:@"id"] atIndex:j];
                    
                    
                    j++;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{//主线程
                if(flag)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"该缓存为空，请连接网络使用"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                }
                else
                {
//                    app.saveName=strJson;
//                    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
//                    NSArray *jsonObj =[parser objectWithString: strJson];
//                    UIImageView *imgToolView=[[[UIImageView alloc]initWithFrame:CGRectMake(0,heightTooBar, 320, 44)]autorelease];
//                    imgToolView.image=[UIImage imageNamed:@"toolBar@2X.png"];
//                    imgToolView.tag=22;
//                    UIScrollView *scrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)]autorelease];
//                    int j=0;
//                    for(int i=1;i<jsonObj.count;i++)
//                    {
//                        if([[[jsonObj  objectAtIndex:i] objectForKey:@"pid"] integerValue]==0)
//                        {
//                            NSLog(@"%@",[[jsonObj  objectAtIndex:i] objectForKey:@"name"]);
//                            
//                            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//                            NSString* name= [[jsonObj  objectAtIndex:i] objectForKey:@"name"];
//                            button.tag=[[[jsonObj  objectAtIndex:i] objectForKey:@"id"]integerValue];
//                            ////////
//                            if([Singleton sharedInstance].isFirstOpen_View)
//                            {
//                                [[ButtonName sharedInstance].buttonName addObject:name];
//                                [[todayCount sharedInstance].todayCount_Data addObject:[[jsonObj  objectAtIndex:i] objectForKey:@"today_count"] ];
//                            }
//                            button.tag=[[[jsonObj  objectAtIndex:i] objectForKey:@"id"]integerValue];
//                            ///////
// 
//                            
//                            [arrName insertObject:name atIndex:j];
//                            
//                            button.frame=CGRectMake(10+j*60, 0, 30, 40);
//                            button.showsTouchWhenHighlighted = YES;
//                            [button addTarget:self action:@selector(Press_Tag:) forControlEvents:UIControlEventTouchDown];
//                            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
//                            label.text=name;
//                            label.font  = [UIFont fontWithName:@"Arial" size:15.0];
//                            label.backgroundColor=[UIColor clearColor];
//                            
//                            UILabel *labelNum=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 28, 25)];
//                            labelNum.text=[NSString stringWithFormat:@"%@",[[todayCount sharedInstance].todayCount_Data objectAtIndex:j]];
//                            
//                            labelNum.text=[NSString stringWithFormat:@"%@", [[jsonObj  objectAtIndex:i] objectForKey:@"today_count"]];
//                            labelNum.font  = [UIFont fontWithName:@"Arial" size:12.0];
//                            labelNum.textColor=[UIColor whiteColor];
//                            labelNum.backgroundColor=[UIColor clearColor];
//                            UIImageView *imgViewRed=[[[UIImageView alloc]initWithFrame:CGRectMake(30, 7, 28, 25)]autorelease];
//                            if([labelNum.text  integerValue]<=0)
//                            {
//                                imgViewRed.image=[UIImage imageNamed:@"whiteBack.png"];
//                            }
//                            else
//                                imgViewRed.image=[UIImage imageNamed:@"redBack.png"];
//                            [imgViewRed addSubview:labelNum];
//                            [button addSubview:imgViewRed];
//                            [button addSubview:label];
//                            button.backgroundColor=[UIColor clearColor];
//                            [scrollView addSubview:button];
//                            [label release];
//                        
//                            j++;
//                        }
//                    } [Singleton sharedInstance].isFirstOpen_View=NO;
//                    scrollView.contentSize = CGSizeMake(640, 44);
//                    [scrollView setShowsHorizontalScrollIndicator:NO];//隐藏横向滚动条
//                    [imgToolView addSubview:scrollView];
//                    imgToolView . userInteractionEnabled = YES;
//                    [self.view addSubview:imgToolView];
//                }
//
                    
                    
                    
                    app.saveName=strJson;
                    app.toolbar_js=strJson;
                    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
                    NSArray *jsonObj =[parser objectWithString: strJson];
                    UIImageView *imgToolView=[[[UIImageView alloc]initWithFrame:CGRectMake(0,heightTooBar, 320, 44)]autorelease];
                    imgToolView.image=[UIImage imageNamed:@"toolBar@2X.png"];
                    imgToolView.tag=22;
                    UIScrollView *scrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)]autorelease];
                    
                    int j=0;
                    for(int i=1;i<jsonObj.count;i++)
                    {
                        if([[[jsonObj  objectAtIndex:i] objectForKey:@"pid"] integerValue]==0)
                        {
                            NSLog(@"%@",[[jsonObj  objectAtIndex:i] objectForKey:@"name"]);
                            
                            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                            NSString* name= [[jsonObj  objectAtIndex:i] objectForKey:@"name"];
                            ////////
                            if([Singleton sharedInstance].isFirstOpen_View)
                            {
                                 [[ButtonName sharedInstance].buttonName addObject:name];
                                 [[todayCount sharedInstance].todayCount_Data addObject:[[jsonObj  objectAtIndex:i] objectForKey:@"today_count"] ];
                            }
                            button.tag=[[[jsonObj  objectAtIndex:i] objectForKey:@"id"]integerValue];
                            ///////
                            
                            [arrName insertObject:name atIndex:j];
                            
                            button.frame=CGRectMake(10+j*60, 0, 30, 40);
                            button.showsTouchWhenHighlighted = YES;
                            [button addTarget:self action:@selector(Press_Tag:) forControlEvents:UIControlEventTouchDown];
                            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
                            label.text=name;
                            label.font  = [UIFont fontWithName:@"Arial" size:15.0];
                            label.backgroundColor=[UIColor clearColor];
                            UILabel *labelNum=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 28, 25)];
                            
                            
                            
                            labelNum.text=[NSString stringWithFormat:@"%@",[[todayCount sharedInstance].todayCount_Data objectAtIndex:j]];
                            
                            labelNum.font  = [UIFont fontWithName:@"Arial" size:12.0];
                            labelNum.textColor=[UIColor whiteColor];
                            labelNum.backgroundColor=[UIColor clearColor];
                            UIImageView *imgViewRed=[[[UIImageView alloc]initWithFrame:CGRectMake(30, 7, 28, 25)]autorelease];
                            if([labelNum.text  integerValue]<=0)
                            {
                                // labelNum.text=@"0";
                                imgViewRed.image=[UIImage imageNamed:@"whiteBack.png"];
                            }
                            
                            else
                                imgViewRed.image=[UIImage imageNamed:@"redBack.png"];
                            [imgViewRed addSubview:labelNum];
                            [button addSubview:imgViewRed];
                            [button addSubview:label];
                            button.backgroundColor=[UIColor clearColor];
                            [scrollView addSubview:button];
                            [label release];
                            
                            j++;
                        }
                        
                    }[Singleton sharedInstance].isFirstOpen_View=NO;
                    
                    scrollView.contentSize = CGSizeMake(640, 44);
                    [scrollView setShowsHorizontalScrollIndicator:NO];//隐藏横向滚动条
                    [imgToolView addSubview:scrollView];
                    imgToolView . userInteractionEnabled = YES;
                    [self.view addSubview:imgToolView];
                }

                
            });
        });
  
        
    }
    else
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            ///start database
            NSString *strJson;
            NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPaths=[array objectAtIndex:0];
            NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"NewsViewController"];
            sqlite3 *database;
            
            if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
            {
                NSLog(@"open success");
            }
            else {
                NSLog(@"open failed");
            }
            char *errorMsg;
            NSString *sql=@"CREATE TABLE IF NOT EXISTS firstViewImages (ID INTEGER PRIMARY KEY AUTOINCREMENT,pic TEXT)";         //创建表
            if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
            {
                NSLog(@"create success");
            }else{
                NSLog(@"create error:%s",errorMsg);
                sqlite3_free(errorMsg);
            }
            
            sql = @"select * from firstViewImages";
            sqlite3_stmt *stmt;
            //查找数据
            BOOL flag=NO;
            if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
            {
                int i=0;
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    i=1;
                    if(sqlite3_column_count(stmt)==0)
                    {
                        flag=YES;
                        break;
                    }
                    //int i=sqlite3_column_int(stmt, 0)-1;
                    const unsigned char *_pic= sqlite3_column_text(stmt, 1);
                    strJson= [NSString stringWithUTF8String: _pic];
                    break;
                }
                if(i==0)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"该缓存为空，请连接网络使用"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles: nil];
                    [alert release];
                    sqlite3_finalize(stmt);
                    sqlite3_close(database);
                    return ;
                }
            }
            
            sqlite3_finalize(stmt);
            
            //  最后，关闭数据库：
            sqlite3_close(database);
            
            //创建数据库end
            
            dispatch_async(dispatch_get_main_queue(), ^{//主线程
                
                if(flag)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"该缓存为空，请连接网络使用"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles: nil];
                    [alert release];
                    
                }else
                {
                    SBJsonParser *parser1 = [[[SBJsonParser alloc] init]autorelease];
                    NSDictionary *jsonObj1 =[parser1 objectWithString:  strJson];
                    
                    NSArray *data = [jsonObj1 objectForKey:@"data"];
                    //NSString *str;
                    NSMutableArray *firstPageImage= [[[NSMutableArray alloc] initWithCapacity:data.count]autorelease];
                    for (int i =0; i <data.count; i++) {
                        
                        [firstPageImage insertObject:[data objectAtIndex:i] atIndex: i];
                        [arr insertObject:[data objectAtIndex:i] atIndex: i];
                    }
                    [self createView:firstPageImage];

                }

            });
        });
       
    }

}
- (BOOL) isBlankString:(NSString *)string {//判断字符串是否为空 方法
    
    if (string == nil || string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}

-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag isID:(NSString *)ID Offent:(NSString *)Out
{
    
    if([self isBlankString:jsonString])
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"网络不佳，请重新操作试试看～"
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles: @"确定",nil]autorelease];
        [alert show];
        
    }
    else
    {
        float heightTooBar;
        float buttonHeight;
        if(height5_flag&&Kind7)
        {
            heightTooBar=height_Momente-height-44;
            buttonHeight=5+height_Momente-44-height;
        }else if(height5_flag&&!Kind7)
        {
            heightTooBar=height_Momente-44-20;
            buttonHeight=5+height_Momente-44-20;
        }
        else if (!height5_flag&&Kind7)
        {
            heightTooBar=height_Momente-44;
            buttonHeight=5+height_Momente-44 ;
        }
        else {
            heightTooBar=height_Momente-height-44;
            buttonHeight=5+height_Momente-44-height;
        }
        if([ID isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //耗时的一些操作
                ///start database
                NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPaths=[array objectAtIndex:0];
                NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"NewsViewController"];
                sqlite3 *database;
                
                if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
                {
                    NSLog(@"open success");
                }
                else {
                    NSLog(@"open failed");
                }
                char *errorMsg;
                NSString* sql=@"CREATE TABLE IF NOT EXISTS firstViewImages (ID INTEGER PRIMARY KEY AUTOINCREMENT,pic TEXT)";         //创建表
                if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
                {
                    NSLog(@"首页图片表打开");
                }else{
                    NSLog(@"create 首页图片表打开error:%s",errorMsg);
                    sqlite3_free(errorMsg);
                }
                // 删除所有数据 并进行更新数据库操作
                //删除所有数据，条件为1>0永真
                const char *deleteAllSql="delete from firstViewImages where 1>0";
                //执行删除语句
                if(sqlite3_exec(database, deleteAllSql, NULL, NULL, &errorMsg)==SQLITE_OK){
                    NSLog(@"删除所有数据成功");
                }
                else NSLog(@"delect failde!!!!");
                
                
                NSString *insertSQLStr = [NSString stringWithFormat:
                                          @"INSERT INTO 'firstViewImages' ('pic' ) VALUES ('%@')", jsonString];
                const char *insertSQL=[insertSQLStr UTF8String];
                //插入数据 进行更新操作
                if (sqlite3_exec(database, insertSQL , NULL, NULL, &errorMsg)==SQLITE_OK) {
                    NSLog(@"insert operation is ok.");
                }
                else{
                    NSLog(@"insert error:%s",errorMsg);
                    sqlite3_free(errorMsg);
                }
                //sqlite3_finalize(stmt);
                
                //  最后，关闭数据库：
                sqlite3_close(database);
                
                //创建数据库end
                
                dispatch_async(dispatch_get_main_queue(), ^{//主线程
                    
                    
                    SBJsonParser *parser1 = [[[SBJsonParser alloc] init]autorelease];
                    NSDictionary *jsonObj1 =[parser1 objectWithString:  jsonString];
                    
                    NSArray *data = [jsonObj1 objectForKey:@"data"];
                    
                    NSMutableArray *firstPageImage= [[[NSMutableArray alloc] initWithCapacity:data.count]autorelease];
                    for (int i =0; i <data.count; i++) {
                        
                        [firstPageImage insertObject:[data objectAtIndex:i] atIndex: i];
                        [arr insertObject:[data objectAtIndex:i] atIndex: i];
                    }
                    
                    [self createView:firstPageImage];
                    
                });
            });
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPaths=[array objectAtIndex:0];
                NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"NewsViewController"];
                //  然后建立数据库，新建数据库这个苹果做的非常好，非常方便
                sqlite3 *database;
                //新建数据库，存在则打开，不存在则创建
                if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
                {
                    NSLog(@"首页按钮栏打开");
                }
                else {
                    NSLog(@"open failed");
                }
                // 对数据库建表操作：如果在些程序的过程中，发现表的字段要更改，一定要删除之前的表，如何做，就是删除程序或者换个表名，主键是自增的
                char *errorMsg;
                NSString *sql=@"CREATE TABLE IF NOT EXISTS buttonList (ID INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT)";
                //创建表
                if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
                {
                    NSLog(@"创建打开toolbar");
                }else{
                    NSLog(@"create error:%s",errorMsg);
                    sqlite3_free(errorMsg);
                }
                // 删除所有数据 并进行更新数据库操作
                //删除所有数据，条件为1>0永真
                const char *deleteAllSql="delete from buttonList where 1>0";
                //执行删除语句
                if(sqlite3_exec(database, deleteAllSql, NULL, NULL, &errorMsg)==SQLITE_OK){
                    NSLog(@"删除所有数据成功");
                }
                else NSLog(@"delect failde!!!!");
                
                //插入数据
                NSString *insertSQLStr = [NSString stringWithFormat:
                                          @"INSERT INTO 'buttonList' ('name') VALUES ('%@')",jsonString  ];
                const char *insertSQL=[insertSQLStr UTF8String];
                
                if (sqlite3_exec(database, insertSQL , NULL, NULL, &errorMsg)==SQLITE_OK) {
                    NSLog(@"insert operation is ok.");
                }
                else{
                    NSLog(@"insert error:%s",errorMsg);
                    sqlite3_free(errorMsg);
                }

                sqlite3_close(database);
                
  /////start
               
                SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
                NSArray *jsonObj =[parser objectWithString: jsonString];
                
                 /*
                //
                NSString* date_Today;
                NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
                [formatter  setDateFormat:@"20YY-MM-dd"];
                date_Today = [formatter stringFromDate:[NSDate date]];
                
                
                
                
                ///今天新闻条数 数据库start
                NSArray *arr1=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPaths_Today=[arr1 objectAtIndex:0];
                NSString *databasePaths2=[documentsPaths_Today stringByAppendingPathComponent:@"today_total"];
                sqlite3 *database2;
                
                if (sqlite3_open([databasePaths2 UTF8String], &database2)==SQLITE_OK)
                {
                    NSLog(@"open success");
                }
                else {
                    NSLog(@"open failed");
                }
                 char *errorMsg1;
                NSString* Sql1=@"CREATE TABLE IF NOT EXISTS todaySum (ID TEXT,date,TEXT)";//创建表
                if (sqlite3_exec(database2, [Sql1 UTF8String], NULL, NULL, &errorMsg1)==SQLITE_OK )
                {
                    NSLog(@"创建打开toolbar");
                }else{
                    NSLog(@"create error:%s",errorMsg1);
                    sqlite3_free(errorMsg1);
                }

                
                sqlite3_stmt *stmt;
                BOOL isFresh=NO;
                Sql1=[NSString stringWithFormat:@"select date from todaySum where date ='%@'",date_Today];
                if(sqlite3_prepare_v2(database2, [Sql1 UTF8String], -1, &stmt, nil)==SQLITE_OK)
                {
                    
                    while (sqlite3_step(stmt)==SQLITE_ROW) {
                        if(sqlite3_column_count(stmt)==0)
                            break;
                        else
                        {
                            isFresh=YES;
                            break;
                        }
                    }
                }
                int j=0;
                if(isFresh)//数据库的存储是当天的Today-count
                {
                    NSString *today_count=@"0";
                    BOOL flag=NO;
                    Sql1= @"select ID  from todaySum";
                    if(sqlite3_prepare_v2(database2, [Sql1 UTF8String], -1, &stmt, nil)==SQLITE_OK)
                    {
                        
                        [[todayCount sharedInstance].todayCount_Data removeAllObjects];
                        while (sqlite3_step(stmt)==SQLITE_ROW) {
                            if(sqlite3_column_count(stmt)==0)
                            {
                                flag=YES;
                                break;
                            }
                            const unsigned char *_id= sqlite3_column_text(stmt, 0);
                            if(_id==NULL)break;//字符串为空
                            today_count= [NSString stringWithUTF8String: _id];
                            [[todayCount sharedInstance].todayCount_Data insertObject:today_count atIndex:j];
                            j++;
                        }
                     }
                     if(!flag)
                     {
                        
                     }
                }
                else
                {
                    if(flag||!isFresh)
                    {
                        int k=0;
                        [app.array_btID removeAllObjects];
                        for(int i=0;i<jsonObj.count;i++)
                        {
                            [[todayCount sharedInstance].todayCount_Data removeAllObjects];
                            for(int i=1;i<jsonObj.count;i++)
                            {
                                if([[[jsonObj  objectAtIndex:i] objectForKey:@"pid"] integerValue]==0)
                                {
                                    [[todayCount sharedInstance].todayCount_Data addObject:[[jsonObj  objectAtIndex:i] objectForKey:@"today_count"] ];
                                }
                            }
                        }
                    }
                }
                  sqlite3_finalize(stmt);
                  sqlite3_close(database2);
                 */
                int k=0;
                [app.array_btID removeAllObjects];
                for(int i=0;i<jsonObj.count;i++)
                {
                    if([[[jsonObj  objectAtIndex:i] objectForKey:@"pid"] integerValue]==0&&i!=0)
                    {
                        
                        [app.array_btID insertObject:[[jsonObj  objectAtIndex:i] objectForKey:@"id"] atIndex:k];
                        
                        k++;
                    }
                }

  
                
                dispatch_async(dispatch_get_main_queue(), ^{//主线程
                    
                    app.saveName=jsonString;
                    app.toolbar_js=jsonString;
                    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
                    NSArray *jsonObj =[parser objectWithString: jsonString];
                    UIImageView *imgToolView=[[[UIImageView alloc]initWithFrame:CGRectMake(0,heightTooBar, 320, 44)]autorelease];
                    imgToolView.image=[UIImage imageNamed:@"toolBar@2X.png"];
                    imgToolView.tag=22;
                    UIScrollView *scrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)]autorelease];
                    
                    int j=0;
                    for(int i=1;i<jsonObj.count;i++)
                    {
                        if([[[jsonObj  objectAtIndex:i] objectForKey:@"pid"] integerValue]==0)
                        {
                            NSLog(@"%@",[[jsonObj  objectAtIndex:i] objectForKey:@"name"]);
                            
                            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                            NSString* name= [[jsonObj  objectAtIndex:i] objectForKey:@"name"];
                            ////////
                            if([Singleton sharedInstance].isFirstOpen_View)
                            {
                                [[ButtonName sharedInstance].buttonName addObject:name];
                                [[todayCount sharedInstance].todayCount_Data addObject:[[jsonObj  objectAtIndex:i] objectForKey:@"today_count"] ];
                            }
                            button.tag=[[[jsonObj  objectAtIndex:i] objectForKey:@"id"]integerValue];
                            ///////
                            
                            [arrName insertObject:name atIndex:j];
                            
                            button.frame=CGRectMake(10+j*60, 0, 30, 40);
                            button.showsTouchWhenHighlighted = YES;
                            [button addTarget:self action:@selector(Press_Tag:) forControlEvents:UIControlEventTouchDown];
                            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
                            label.text=name;
                            label.font  = [UIFont fontWithName:@"Arial" size:15.0];
                            label.backgroundColor=[UIColor clearColor];
                            UILabel *labelNum=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 28, 25)];
                            
                            
                            
                            labelNum.text=[NSString stringWithFormat:@"%@",[[todayCount sharedInstance].todayCount_Data objectAtIndex:j]];
                                           
                            labelNum.font  = [UIFont fontWithName:@"Arial" size:12.0];
                            labelNum.textColor=[UIColor whiteColor];
                            labelNum.backgroundColor=[UIColor clearColor];
                            UIImageView *imgViewRed=[[[UIImageView alloc]initWithFrame:CGRectMake(30, 7, 28, 25)]autorelease];
                            if([labelNum.text  integerValue]<=0)
                            {
                               // labelNum.text=@"0";
                                 imgViewRed.image=[UIImage imageNamed:@"whiteBack.png"];
                            }
                            
                            else
                                imgViewRed.image=[UIImage imageNamed:@"redBack.png"];
                            [imgViewRed addSubview:labelNum];
                            [button addSubview:imgViewRed];
                            [button addSubview:label];
                            button.backgroundColor=[UIColor clearColor];
                            [scrollView addSubview:button];
                            [label release];
                           
                            j++;
                        }
                        
                    }[Singleton sharedInstance].isFirstOpen_View=NO;
                    
                    scrollView.contentSize = CGSizeMake(640, 44);
                    [scrollView setShowsHorizontalScrollIndicator:NO];//隐藏横向滚动条
                    [imgToolView addSubview:scrollView];
                    imgToolView . userInteractionEnabled = YES;
                    [self.view addSubview:imgToolView];
                    
                });
            });
            
        }

    }
}
-(void)createView:(NSMutableArray *)firstPageImage
{
    int bottom;
    int share_height;
    share_height=0;
    if(isSeven&&isFive)
    {
        bottom=230;
        share_height=20;
    }
    else if(isSeven&&!isFive)
    {
        share_height=20;
        bottom=230;
    }else if(!isSeven&&isFive)//
    {
        bottom=230;
        share_height=10;
    }else {
        
        bottom=200;
    }

    //frame=CGRectMake(35,308,265,60);
    labelText.text= [ [arr objectAtIndex:0] objectForKey:@"description"];
    labelText.backgroundColor=[UIColor clearColor];
    labelText.font=[UIFont systemFontOfSize:15.0f];
    labelText.numberOfLines = 0;
    labelText.lineBreakMode =  NSLineBreakByTruncatingTail;
    //[labelText sizeToFit];
    
    textView.text= [ [arr objectAtIndex:0] objectForKey:@"description"];
    textView.backgroundColor=[UIColor clearColor];
    textView.font=[UIFont systemFontOfSize:14.0f];
    [textView setEditable:NO];
    textView.scrollEnabled=YES;
    textView.showsVerticalScrollIndicator=NO;
    
    UIButton *share=[UIButton buttonWithType:UIButtonTypeCustom];
    share.frame=CGRectMake(280, 150+57+share_height, 35,35 );
    [share setImage:[UIImage imageNamed:@"shareFirstView@2X"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(Press_share) forControlEvents:UIControlEventTouchDown];
    share.highlighted=NO;
    [self.view  addSubview:share];
    
    
    
    
    NSDate *date = [[[NSDate alloc]initWithTimeIntervalSince1970:[[ [arr objectAtIndex:0] objectForKey:@"create_time"]integerValue]
                      ]autorelease];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    
    
    labelDay.textColor=[UIColor lightGrayColor];
    labelDay.text=[dateFormatter stringFromDate:date];  ;
    labelDay.backgroundColor=[UIColor clearColor];
    labelDay.font=[UIFont systemFontOfSize:15.0f];
    labelDay.numberOfLines = 0;
    
    
    klpScrollView1.frame=CGRectMake(0, 57, 320,bottom);

    ///UIScrollerView
    index = 0;
    self.klpImgArr = [[NSMutableArray alloc] initWithCapacity:firstPageImage.count];
    CGSize size = self.klpScrollView1.frame.size;
  //  if(height_Momente==480)  height=60;
    for (int i=0; i < [firstPageImage count]; i++) {
        UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(size.width * i, 0, size.width, size.height)]autorelease];
        NSString *imgURL=[NSString stringWithFormat:@"%@%@",Image_Head,[[firstPageImage objectAtIndex:i]objectForKey:@"image"]];

        [iv setImageWithURL:[NSURL URLWithString: imgURL]
           placeholderImage:[UIImage imageNamed:@"moren.png"]
                    success:^(UIImage *image) {NSLog(@"OK");}
                    failure:^(NSError *error) {NSLog(@"NO");}];
        [self.klpScrollView1 addSubview:iv];
        iv = nil;
        
    }
    [self.klpScrollView1 setContentSize:CGSizeMake(size.width * firstPageImage.count, 0)];//只可横向滚动～
    
    self.klpScrollView1.pagingEnabled = YES;
    self.klpScrollView1.showsHorizontalScrollIndicator = YES;
    //self.klpScrollView1.indicatorStyle=
    
    //往数组里添加成员
    for (int i=0; i<firstPageImage.count; i++) {
        UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(100*i + 5*i,0,size.height+height,70)]autorelease];
        [iv setImage:[UIImage imageNamed:[[firstPageImage objectAtIndex:i] objectForKey:@"image"]  ]];
        [self.klpImgArr addObject:iv];
        iv = nil;
    }
    
    UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap1:)]autorelease];
    [singleTap setNumberOfTapsRequired:1];
    
    [self.klpScrollView1 addGestureRecognizer:singleTap];
    //[klpScrollView1 release];
    // [klpImgArr release];
    //  [app.firstPageImage release];
    ///UIScrollerView
}
-(void)Press_share
{
    
    NSLog(@"选择分享图片序号：%d",index);
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                        allowCallback:NO
                                                        authViewStyle:SSAuthViewStyleFullScreenPopup
                                                         viewDelegate:self
                                              authManagerViewDelegate:self];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"首页分享"
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:self
                                                          friendsViewDelegate:self
                                                        picViewerViewDelegate:nil];
    
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    //构造分享内容
    NSString *string=[NSString stringWithFormat:@"%@%@%@",shareContent1,[ [arr objectAtIndex:index] objectForKey:@"description"],shareContent2];
    id<ISSContent> publishContent = [ShareSDK content:string
                                       defaultContent:@"分享我的阅钓心得"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.huiztech.com"
                                          description:@"这条新闻值得分享一下"
                                            mediaType:SSPublishContentMediaTypeNews];
 
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions: shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

-(void)theTopBar
{
    int height_sum;
    if(height5_flag&&Kind7)
    {
        height_sum=0;
    }
    else if(height5_flag&&!Kind7)
    {
        height_sum=10;
    }
    else if (!height5_flag&&Kind7)
    {
        height_sum=0;
    }
    else
    {
        height_sum=10;
    }
    UIImageView *topBarWhite=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)]autorelease];
    topBarWhite.image=[UIImage imageNamed:@"TitleWhiteBack"];
    [self.view addSubview:topBarWhite];
    UIImageView *topBarRed=[[[UIImageView alloc]initWithFrame:CGRectMake(108, 0, 110, 55-height_sum )]autorelease];
    topBarRed.image=[UIImage imageNamed:@"TitleRedBack"];
    [topBarWhite addSubview:topBarRed];
    UILabel *titleBigName=[[[UILabel alloc]initWithFrame:CGRectMake(10, 8-height_sum, 100, 50)]autorelease];
    titleBigName.text=@"   阅钓";
    titleBigName.textColor=[UIColor whiteColor];
    titleBigName.backgroundColor=[UIColor clearColor];
    titleBigName.font =[UIFont boldSystemFontOfSize:22];
    //titleBigName.font = [UIFont fontWithName:@"Courier" size:20];
    titleBigName.shadowColor = [UIColor grayColor];
    titleBigName.shadowOffset = CGSizeMake(0.0,0.5);
    [topBarRed addSubview:titleBigName];
    UILabel *smallTitle=[[[UILabel alloc]initWithFrame:CGRectMake(138, 43,110,55)]autorelease];
    smallTitle.textColor=[UIColor lightGrayColor];
    smallTitle.text=@"首页";//AppleGothic
    smallTitle.backgroundColor=[UIColor clearColor];
   // [self.view addSubview:smallTitle];
}

#pragma mark-- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{\
	//NSLog(@"scrollViewDidScroll");
	if (scrollView == self.klpScrollView1) {
		CGFloat pageWidth = scrollView.frame.size.width;
		int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		index = page;
       
	}else {
		
	}
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //	NSLog(@"scrollViewWillBeginDragging");
	if (scrollView == self.klpScrollView1) {
        
	}else {
		
	}
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	//NSLog(@"scrollViewDidEndDecelerating");
	if (scrollView == self.klpScrollView1)
    {
		klp.frame = ((UIImageView*)[self.klpImgArr objectAtIndex:index]).frame;
		[klp setAlpha:0];
		[UIView animateWithDuration:0.2f animations:^(void){
			[klp setAlpha:.85f];
		}];
        
        labelText.text= [ [arr objectAtIndex:index] objectForKey:@"description"];
        labelText.backgroundColor=[UIColor clearColor];
        labelText.font=[UIFont systemFontOfSize:15.0f];
        labelText.numberOfLines = 0;
        labelText.lineBreakMode = UILineBreakModeTailTruncation;
        //[labelText sizeToFit];
        
        textView.text= [ [arr objectAtIndex:index] objectForKey:@"description"];
        textView.backgroundColor=[UIColor clearColor];
        textView.font=[UIFont systemFontOfSize:14.0f];
        [textView setEditable:NO];
        textView.scrollEnabled=YES;
        textView.showsVerticalScrollIndicator=NO;
        
        NSDate *date = [[[NSDate alloc]initWithTimeIntervalSince1970:[[ [arr objectAtIndex:index] objectForKey:@"create_time"]integerValue]]autorelease];
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    
        labelDay.textColor=[UIColor lightGrayColor];
        labelDay.text=[dateFormatter stringFromDate:date];
        labelDay.backgroundColor=[UIColor clearColor];
        labelDay.font=[UIFont systemFontOfSize:15.0f];
        labelDay.numberOfLines = 0;
        int share_height;
        share_height=0;
        if(isSeven&&isFive)
        {
            share_height=20;
            
        }
        else if(isSeven&&!isFive)
        {
             share_height=20;
        }else if(!isSeven&&isFive)
        {
            
            share_height=10;
        }else {
            
        }
        

        UIButton *share=[UIButton buttonWithType:UIButtonTypeCustom];
        share.frame=CGRectMake(280, 150+57+share_height, 35,35 );
        [share setImage:[UIImage imageNamed:@"shareFirstView@2X"] forState:UIControlStateNormal];
        [share addTarget:self action:@selector(Press_share) forControlEvents:UIControlEventTouchDown];
        share.highlighted=NO;
        [self.view  addSubview:share];
        
        NSLog(@"首页滑动到%d",index);
        UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap1:)]autorelease];
        [singleTap setNumberOfTapsRequired:1];
        
        [self.klpScrollView1 addGestureRecognizer:singleTap];
  
	}else {
		
	}
}

#pragma mark 手势
- (void) handleSingleTap1:(UITapGestureRecognizer *) gestureRecognizer{
	CGFloat pageWith = 320;
    
    CGPoint loc = [gestureRecognizer locationInView:self.klpScrollView1];
    NSInteger touchIndex = floor(loc.x / pageWith) ;
    if (touchIndex > arr.count) {
        return;
    }
    NSLog(@"首页touch index %d",touchIndex);
    //进入详细阅读
    NSDictionary* dict = [arr objectAtIndex:touchIndex];
    
    DetailViewController *detail=[[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil]autorelease];
    detail.momentID=[dict objectForKey:@"id"];
     detail.fatherID=@"0";
    [self.navigationController pushViewController:detail animated:YES];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/******Button Press*******/

-(void)clickLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickRightButton
{
     [self.viewDeckController toggleRightViewAnimated:YES];
}
-(void)Press_Tag:(id)sender
{
    NSString *name;
    NSString *fatherID;
    NSString *isTopic;
    NSString *isGallery;
    UIButton *btn = (UIButton *)sender;
   
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSArray *jsonObj =[parser objectWithString: app.saveName];
    int i;
    for(i=1;i<jsonObj.count;i++)
    {
        if([[[jsonObj  objectAtIndex:i] objectForKey:@"id"] integerValue]==btn.tag)
        {
            name= [[jsonObj  objectAtIndex:i] objectForKey:@"name"];
            fatherID= [[jsonObj  objectAtIndex:i] objectForKey:@"pid"];
            isGallery =[[jsonObj  objectAtIndex:i] objectForKey:@"is_gallery"];
            isTopic =[[jsonObj  objectAtIndex:i] objectForKey:@"is_special_topic"];
            break;
        }
    }
    
    if([isGallery integerValue]==0&& [isTopic integerValue]==0)
    {
        BookViewController *newVC = [[[BookViewController alloc] initWithNibName:@"BookViewController" bundle:nil]autorelease];
        newVC.hidesBottomBarWhenPushed = YES;
        newVC.target=btn.tag;
        newVC.NewsName=name;
        newVC.NewsPid=[NSString stringWithFormat:@"%d",btn.tag];
        [self.navigationController pushViewController :newVC animated:YES];
        

    }
    else if([isTopic integerValue]==1)
    {
        TopicViewController *newVC = [[[ TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil]autorelease];
        newVC.target=btn.tag;
       
        [self.navigationController pushViewController :newVC animated:YES];
    }
    else if([isGallery integerValue]==1)
    {
       BigFishViewController *newVC = [[[ BigFishViewController alloc] initWithNibName:@"BigFishViewController" bundle:nil]autorelease];
        self.hidesBottomBarWhenPushed = YES;
        newVC.BigFishName=name;
        newVC.target=btn.tag;//游钓
        newVC.BigFishPid=[NSString stringWithFormat:@"%d",btn.tag];
        app.targetCenter=btn.tag;
        
        [self.navigationController pushViewController :newVC animated:YES];
    }
}
- (void)dealloc {
    [labelText release];
    [labelDay release];
    [textView release];
    [super dealloc];
}
@end
