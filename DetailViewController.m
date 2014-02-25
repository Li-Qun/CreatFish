//
//  DetailViewController.m
//  Fish
//
//  Created by DAWEI FAN on 19/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"

#import "CustomURLCache.h"
#import "MBProgressHUD.h"


#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
#import "UIMenuItem+CXAImageSupport.h"

#import "Singleton.h"
#import "IsRead.h"
#import "todayCount.h"

#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import "sqlite3.h"
//#import "BaiduMobStat.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize showWebView=showWebView;
@synthesize Data=Data;
@synthesize tableView=tableView;
@synthesize jsString=jsString;
@synthesize htmlText=htmlText;

@synthesize page_num=page_num;
@synthesize page_label=page_label;
@synthesize htmlTextTotals=htmlTextTotals;
@synthesize momentID=momentID;
@synthesize fatherID=fatherID;
@synthesize pre_Page=pre_Page;
@synthesize next_Page=next_Page;
@synthesize leftSwipeGestureRecognizer,rightSwipeGestureRecognizer;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
                                                                     diskCapacity:200 * 1024 * 1024
                                                                         diskPath:nil
                                                                        cacheTime:0];
        [CustomURLCache setSharedURLCache:urlCache];
        [urlCache release];
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGSize size = rect.size;
        
        totalHeight = size.height;
        
        if(totalHeight==480)
        {
            isFive=NO;
        }else isFive=YES;
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version <7.0)
            isSeven=NO;
        else isSeven=YES;
    }
    return self;
}
//百度页面统计
-(void)viewDidAppear:(BOOL)animated
{
//    NSString *cName=[NSString stringWithFormat:@"detail&阅读"];
//    [[BaiduMobStat defaultStat]pageviewStartWithName:cName ];
}
-(void)viewDidDisappear:(BOOL)animated
{
//    NSString *cName=[NSString stringWithFormat:@"detail&阅读"];
//    [[BaiduMobStat defaultStat]pageviewEndWithName:cName ];
}
- (void)viewDidLoad
{
    isShare=NO;
}

- (void)viewWillAppear:(BOOL)animated
{//视图即将可见时调用。默认情况下不执行任何操作
     self.navigationController.toolbarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
    
    [super viewWillAppear:animated];
    if(isShare==NO)
    {
        self.view.backgroundColor=[UIColor whiteColor];
        app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        for (UIView *subviews in [self.view subviews])
        {
            [subviews removeFromSuperview];
        }
        [super viewDidLoad];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"readBack@2X.png"]];
        imgView.frame = self.view.bounds;
        imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view insertSubview:imgView atIndex:0];
        [imgView release];
        
        app.topBarView.userInteractionEnabled = YES;//使添加的按钮可选
        fontSize=16.0;
        line_height=18.0;
        Data=[[NSMutableDictionary alloc]init];
        jsString=[[[NSString alloc]init]retain] ;
        htmlTextTotals=[[NSMutableString alloc]init];
        
        NSLog(@" fa :%@  child :%@",fatherID,momentID);
        app.momentID=momentID;
        app.fatherID=fatherID;
        
        ContentRead * contentRead =[[[ContentRead alloc]init]autorelease];
        [contentRead setDelegate:self];//设置代理
        
        [contentRead Content:fatherID Detail:momentID];

        showWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, 320, totalHeight)];
        showWebView.delegate=self;
        showWebView.scrollView.delegate=self;
        showWebView.backgroundColor=[UIColor clearColor];
        showWebView.opaque = NO;
        
        self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
        [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
        isShare=YES;
    }
    else
    {
        
    }
}
-(void)buildTheTopBar
{
    float heightTopbar;
    float littleHeinght;
    if(isSeven&&isFive)
    {
        heightTopbar=60;
        littleHeinght=10;
    }
    else if(isSeven&&!isFive)
    {
        heightTopbar=60;
        littleHeinght=10;
    }else if(!isSeven&&isFive)//
    {
        heightTopbar=60;
        littleHeinght=10;
    }else {
        heightTopbar=45;
        littleHeinght=0;
    }

    //创建导航按钮start
    app. topBarView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, heightTopbar)];
    app. topBarView.image=[UIImage imageNamed:@"topViewBarWhite"];
    [self.view addSubview:app.topBarView];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(10, littleHeinght, 60, 60);
    [backBtn setImage:[UIImage imageNamed:@"BackImg@2X"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backParentView) forControlEvents:UIControlEventTouchUpInside];
    [app.topBarView  addSubview:backBtn];
    
    UIButton *wordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    wordBtn.frame=CGRectMake(160, littleHeinght,60, 60);
    [wordBtn setImage:[UIImage imageNamed:@"AaImg@2X"] forState:UIControlStateNormal];
    [wordBtn addTarget:self action:@selector(PressWord:) forControlEvents:UIControlEventTouchUpInside];
    [app.topBarView  addSubview:wordBtn];
    
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame=CGRectMake(260, littleHeinght, 60, 60);
    [shareBtn setImage:[UIImage imageNamed:@"shareImg@2X"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
    [app.topBarView  addSubview:shareBtn];
    
    saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame=CGRectMake(225, littleHeinght*2, 30, 30);
    
     SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    int j=0;
    [saveBtn setImage:[UIImage imageNamed:@"saveImgNormal@2X"] forState:UIControlStateNormal];
    for(int i=0;i<app.saveNum;i++)
    {
        NSDictionary *jsonObj =[parser objectWithString: [[Singleton sharedInstance].single_Data objectAtIndex:i]];
        if([momentID isEqualToString:[jsonObj objectForKey:@"id"]])
        {
            [saveBtn setImage:[UIImage imageNamed:@"saveImgHighted@2X"] forState:UIControlStateNormal];
            j=1;
            break;
        }
    }
    if(j==0)
    {
        
    }
    [saveBtn addTarget:self action:@selector(SaveBook:) forControlEvents:UIControlEventTouchUpInside];
    [app.topBarView  addSubview:saveBtn];
    [saveBtn setImage:[UIImage imageNamed:@"saveImgHighted@2X"] forState:UIControlStateHighlighted];
    
    app.topBarView.userInteractionEnabled = YES;//使添加的按钮可选
    
    //创建导航按钮end
    
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{//关闭了 详细页面 detail  的 右边栏
    if (sender.direction == UISwipeGestureRecognizerDirectionRight)//na
    {
        if(!isOpenL&&!isOpenR)
        {
            [self.viewDeckController toggleLeftViewAnimated:YES];
            isOpenL=YES;
        }
        if(!isOpenL&&isOpenR)
        {
          //  [self.viewDeckController toggleRightViewAnimated:YES];
            isOpenR=NO;
        }
        
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {//bie
        
        if(!isOpenR&&!isOpenL)
        {
           // [self.viewDeckController toggleRightViewAnimated:YES];
            isOpenR=YES;//
        }
        if(isOpenL&&!isOpenR)
        {
            [self.viewDeckController toggleLeftViewAnimated:YES];
            isOpenL=NO;
        }
    }
}
-(void)reBack:(NSString *)jsonString reLoad:(NSString *)ID Offent:(NSString *)Out
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //耗时的一些操作
        NSString * strJson;
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:[NSString stringWithFormat:@"detailRead"]];
        
        sqlite3 *database;
        
        if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
        {
            NSLog(@"open success");
        }
        else {
            NSLog(@"open failed");
        }
        char *errorMsg;
        NSString* sql=@"CREATE TABLE IF NOT EXISTS detailWebView_ID (ID TEXT,pic TEXT)";         //创建表
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
        {
            NSLog(@"create success");
        }else{
            NSLog(@"create error:%s",errorMsg);
            sqlite3_free(errorMsg);
        }
        BOOL flag=NO;
        sqlite3_stmt *stmtq;
        sql=[NSString stringWithFormat:@"select count (*) from detailWebView_ID where ID='%@'",ID];
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmtq,nil)==SQLITE_OK)
        {
            while (sqlite3_step(stmtq)==SQLITE_ROW) {
                
                const unsigned char *_id= sqlite3_column_text(stmtq, 0);
                strJson= [NSString stringWithUTF8String: _id];
                if([strJson isEqualToString:@"0"])//count ==0 记录不存在
                {
                    flag=YES;
                }
            }

        }
        sqlite3_finalize(stmtq);
        sqlite3_stmt *stmt;
        sql =[NSString stringWithFormat:@"select pic from detailWebView_ID where ID='%@'",ID];
        //查找数据
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                if(sqlite3_column_count(stmt)==0)
                {
                    flag=YES;
                    break;
                }
                const unsigned char *_id=sqlite3_column_text(stmt, 0);
                strJson=[NSString stringWithUTF8String:_id];
                break;
                
            }
            
        }
        sqlite3_finalize(stmt);//  最后，关闭数据库：
        sqlite3_close(database);//创建数据库end
        
 
        dispatch_async(dispatch_get_main_queue(), ^{//主线程
            
            if(flag||[self isBlankString:strJson])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"该缓存为空，请连接网络使用"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
                [alert release];
                [self buildTheTopBar];
                
            }
            else
            {
                //[self buildTheTopBar];
                SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
                NSDictionary *jsonObj =[parser objectWithString:strJson];
                
                
                
                // moment=[[jsonObj objectForKey:@"id"]intValue];
                
                htmlText=[[[NSString alloc]init]retain];
                app.saveId=[jsonObj objectForKey:@"id"];
                app.saveImage=strJson;
                app.share_String=[jsonObj objectForKey:@"name"];
                
                htmlText=[jsonObj objectForKey:@"content"];
                app.next_Page=[jsonObj objectForKey:@"next_id"];
                app.pre_Page=[jsonObj objectForKey:@"prev_id"];
                NSLog(@"next:%@  pre:%@",app.next_Page,app.pre_Page);
                //[htmlTextTotals appendFormat:[NSString stringWithFormat: htmlText]];
                //<body style="background-color: transparent">//设置网页背景透明
                
                jsString = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-size:%fpx; line-height:%fpx;background-color: transparent;}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>%@</body> \n"
                            "</html>",  fontSize ,line_height,htmlText];
                
                [self.navigationController setNavigationBarHidden:YES];
                
                
                NSURL *urlBai=[NSURL URLWithString:@"http://42.96.192.186"];
                [showWebView loadHTMLString:jsString baseURL:   urlBai];
                showWebView.delegate=self;
                showWebView.scrollView.delegate=self;
                
                self.view.backgroundColor=[UIColor clearColor];
                
                [showWebView setUserInteractionEnabled: YES ];
                //UIWebView
                //[receiveStr release];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                
                //showWebView.
                
            }
            
        });
    });
 
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //耗时的一些操作
            // NSString * strJson;
            NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPaths=[array objectAtIndex:0];
            NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:[NSString stringWithFormat:@"detailRead"]];
            
            sqlite3 *database;
            
            if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
            {
                NSLog(@"open success");
            }
            else {
                NSLog(@"open failed");
            }
            char *errorMsg;
            NSString* sql=@"CREATE TABLE IF NOT EXISTS detailWebView_ID(ID TEXT,pic TEXT)";         //创建表
            if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
            {
                NSLog(@"create success");
            }else{
                NSLog(@"create error:%s",errorMsg);
                sqlite3_free(errorMsg);
            }
            sqlite3_stmt *stmt;
            // 查找数据
            sql =  [ NSString stringWithFormat: @"select pic from detailWebView_ID where ID='%@'",ID];
            
            //查找数据
            int flag=0;
            if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
            {
                NSLog(@"%d",sqlite3_step(stmt));
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    flag=1;
                    break;
                    // const unsigned char *_id=sqlite3_column_text(stmt, 0);
                }
            }
            if(flag==0)
            {
                char *Sql = "insert into 'detailWebView_ID' ('ID','pic')values (?,?);";
                if (sqlite3_prepare_v2(database, Sql, -1, &stmt, nil) == SQLITE_OK) {
                    sqlite3_bind_text(stmt, 1,[ID   UTF8String], -1, NULL);
                    sqlite3_bind_text(stmt, 2,[jsonString   UTF8String], -1, NULL);
                }
                if (sqlite3_step(stmt) != SQLITE_DONE)
                    NSLog(@"Something is Wrong!");
            }
            
            
            sqlite3_finalize(stmt);//  最后，关闭数据库：
            sqlite3_close(database);//创建数据库end
            
            //建立是否已读数据库
          //  /*
            NSString *strID;
            NSArray *array1=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPaths1=[array1 objectAtIndex:0];
            NSString *str=[NSString stringWithFormat:@"NewsViewController"];
            NSString *databasePaths1=[documentsPaths1 stringByAppendingPathComponent:str];
            sqlite3 *database1;
            
            if (sqlite3_open([databasePaths1 UTF8String], &database1)==SQLITE_OK)
            {
                NSLog(@"open success");
            }
            else {
                NSLog(@"open failed");
            }
            
            char *errorMsg1;
            NSString *sql1=@"CREATE TABLE IF NOT EXISTS isReadList (ID TEXT)"; //创建表
            if (sqlite3_exec(database1, [sql1 UTF8String], NULL, NULL, &errorMsg1)==SQLITE_OK )
            {
                NSLog(@"create success");
            }else{
                NSLog(@"create error:%s",errorMsg1);
                sqlite3_free(errorMsg1);
            }
            sql1= @"select ID from isReadList";
            sqlite3_stmt *stmt1;
            //查找数据
            SBJsonParser *parser1 = [[[SBJsonParser alloc] init]autorelease];
            NSDictionary *jsonObj1 =[parser1 objectWithString:jsonString];
            int OK;
            if(sqlite3_prepare_v2(database1, [sql1 UTF8String], -1, &stmt1, nil)==SQLITE_OK)
            {
                OK=0;
                while (sqlite3_step(stmt1)==SQLITE_ROW) {
                    
                    
                    const unsigned char *_id1= sqlite3_column_text(stmt1, 0);
                    strID= [NSString stringWithUTF8String: _id1];
                    if([strID isEqualToString: ID ])
                    {
                        OK=1;
                        break;
                    }
                }
            }
          // */
            
            if(OK==0)
            {
                char *Sql = "insert into 'isReadList' ('ID')values (?);";
                if (sqlite3_prepare_v2(database1, Sql, -1, &stmt1, nil) == SQLITE_OK) {
                    sqlite3_bind_text(stmt1, 1,[ID  UTF8String], -1, NULL);
                    [[IsRead sharedInstance].single_isRead_Data insertObject: ID atIndex:app.isReadCount++] ;
                }
                if (sqlite3_step(stmt1) != SQLITE_DONE)
                    NSLog(@"Something is Wrong!");
                NSLog(@"插入已读数据库");
                
                
                sqlite3_finalize(stmt1);
                sqlite3_close(database1);
                
                /*
        
                
                NSString *date_Create=[jsonObj1 objectForKey:@"create_time"];
                NSString* date_Today;
                NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
                [formatter  setDateFormat:@"20YY-MM-dd"];
                date_Today = [formatter stringFromDate:[NSDate date]];
                
                NSDate *date_Created= [[[NSDate alloc]initWithTimeIntervalSince1970:[ date_Create integerValue]]autorelease];
                
                
                date_Create =[formatter stringFromDate:date_Created];
                
                //判断是否已读 是指对于今天 created 的日期的新闻是否已读
                NSLog(@"今天日期%@    创建日期%@",date_Today ,date_Create);
               // if(![ date_Create isEqualToString:date_Today])///是今天的日期并且id不在数据库里 是未读  插入数据库
                if([ date_Create isEqualToString:date_Today])///是今天的日期并且id不在数据库里 是未读  插入数据库
                {
                    //判断 是否是今天 的资讯start catogory_id->pid
                    SBJsonParser *_parser = [[[SBJsonParser alloc] init]autorelease];
                    NSArray *_jsonObj =[_parser objectWithString: app.toolbar_js];
                    
                    for(int i=1;i<_jsonObj.count;i++)
                    {
                        if([[jsonObj1 objectForKey:@"category_id"]isEqualToString:[[_jsonObj  objectAtIndex:i] objectForKey:@"id"]])
                        {
                            for(int j=0;j<app.array_btID.count;j++)
                            {
                                if([[app.array_btID objectAtIndex:j] isEqualToString:[[_jsonObj  objectAtIndex:i] objectForKey:@"pid"]]||[[[_jsonObj  objectAtIndex:i] objectForKey:@"pid"]isEqualToString:@"0"])
                                {
                                    
                                    NSLog(@"%@",[todayCount sharedInstance].todayCount_Data);
                                    
                                    
                                    int  plus=   [[[todayCount sharedInstance].todayCount_Data objectAtIndex:j]integerValue]-1;
                                    [[todayCount sharedInstance].todayCount_Data removeObjectAtIndex:j];
                                    
                                    NSString *str=[NSString stringWithFormat:@"%d",plus];
                                    
                                    [[todayCount sharedInstance].todayCount_Data insertObject:str atIndex:j];
                                    NSLog(@"%@",[todayCount sharedInstance].todayCount_Data);
                                    

                                    
                        ///今天新闻条数 数据库start
                                    
      /*
                                    
                                   // NSString *strID;
                                    NSArray *arr=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                    NSString *documentsPaths_Today=[arr objectAtIndex:0];
                                    NSString *databasePaths2=[documentsPaths_Today stringByAppendingPathComponent:@"today_total"];
                                    sqlite3 *database2;
                                    
                                    if (sqlite3_open([databasePaths2 UTF8String], &database2)==SQLITE_OK)
                                    {
                                        NSLog(@"open success");
                                    }
                                    else {
                                        NSLog(@"open failed");
                                    }
  
                                   NSString* Sql1=@"CREATE TABLE IF NOT EXISTS todaySum (ID TEXT,date,TEXT)";//创建表
                                    if (sqlite3_exec(database2, [Sql1 UTF8String], NULL, NULL, &errorMsg1)==SQLITE_OK )
                                    {
                                        NSLog(@"创建打开toolbar");
                                    }else{
                                        NSLog(@"create error:%s",errorMsg1);
                                    
                                    }
                                    // 删除所有数据 并进行更新数据库操作
                                    //删除所有数据，条件为1>0永真
                                    const char *deleteAllSql_count="delete from todaySum where 1>0";
                                    //执行删除语句
                                    if(sqlite3_exec(database2, deleteAllSql_count, NULL, NULL, &errorMsg1)==SQLITE_OK){
                                        NSLog(@"删除所有数据成功");
                                    }
                                    else NSLog(@"delect failde!!!!%s",errorMsg1);
                                    
                                    //插入数据
                                    for(int i=0;i<[todayCount sharedInstance].todayCount_Data.count;i++)
                                    {
                                        NSString* insertSQLStr = [NSString stringWithFormat:
                                                        @"INSERT INTO 'todaySum' ('ID','date') VALUES ('%@','%@')",[[todayCount sharedInstance].todayCount_Data objectAtIndex:i],date_Create];
                                        const char *insertSQL_count=[insertSQLStr UTF8String];
                                        
                                        if (sqlite3_exec(database2, insertSQL_count , NULL, NULL, &errorMsg1)==SQLITE_OK) {
                                            NSLog(@"insert operation is ok.");
                                        }
                                        else{
                                            NSLog(@"insert error:%s",errorMsg1);
                                            
                                        }
                                        
                                    }
                                    sqlite3_free(errorMsg1);
                                    sqlite3_close(database2);
                                    
                        ///今天新闻条数 end
 
                                }
                            }
                        }
                    }
                    //判断 是否是今天 的资讯end
                    
                }
                else
                {
                    
                }//*/
            }
             
            
            //建立是否已读数据库
            dispatch_async(dispatch_get_main_queue(), ^{//主线程
                
                
                SBJsonParser *parser =
                [[[SBJsonParser alloc] init]autorelease];
                NSDictionary *jsonObj =[parser objectWithString:jsonString];
                
                
                
                //moment=[[jsonObj objectForKey:@"id"]intValue];
                
                htmlText=[[[NSString alloc]init]retain];
                app.saveId=[jsonObj objectForKey:@"id"];
                app.saveImage=jsonString;
                app.share_String=[jsonObj objectForKey:@"name"];
                
                htmlText=[jsonObj objectForKey:@"content"];
                app.next_Page=[jsonObj objectForKey:@"next_id"];
                app.pre_Page=[jsonObj objectForKey:@"prev_id"];
                NSLog(@"next:%@  pre:%@",app.next_Page,app.pre_Page);
                //[htmlTextTotals appendFormat:[NSString stringWithFormat: htmlText]];
                //<body style="background-color: transparent">//设置网页背景透明
                
                jsString = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-size:%fpx; line-height:%fpx;background-color: transparent;}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>%@</body> \n"
                            "</html>",  fontSize ,line_height,htmlText];
                
                [self.navigationController setNavigationBarHidden:YES];
                app.jsonString=jsonString;
                ///////////
                
                NSURL *urlBai=[NSURL URLWithString:ImageWeb_Head];
                [showWebView loadHTMLString:jsString baseURL:   urlBai];
                showWebView.delegate=self;
                showWebView.scrollView.delegate=self;
                
                self.view.backgroundColor=[UIColor clearColor];
                
                [showWebView setUserInteractionEnabled: YES ];
                //UIWebView
                //[receiveStr release];
                
                //  [self.view addSubview:showWebView];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                
                //showWebView.
            });
        });
    }
}
#pragma mark - webview
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";//加载提示语言
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    app.showView=[self creat_theScrollview];
    showWebView.scrollView.delegate=self;
    [showWebView stringByEvaluatingJavaScriptFromString:@"imageWidth(305);"];//设置网络图片统一宽度320
   // NSString *str1= [showWebView stringByEvaluatingJavaScriptFromString:@"init();"];
    [self buildTheTopBar];
    [self.view addSubview:showWebView];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   [self addTapOnWebView];//调用触摸图片事件
}
//创建UIwebView 网络浏览图片start
-( UIView *)creat_theScrollview
{
    NSString *searchText = [showWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    NSString *regTags = @"src=((.+)('|\.gif|\.jpg|\.png))";//@"<img [^>]*src\\s*=\\s*\"([^>]+)\"";
    NSMutableArray *arr=[[[NSMutableArray alloc]init]autorelease];
    arr=[self match_fun:searchText Regex:regTags];
   // NSLog(@"结果 arr :%@",arr);
    int count=arr.count;
    UIView *showView = [[UIView alloc] initWithFrame:self.view.frame];
    UIScrollView *scrowllView_detail=[[[UIScrollView alloc]init]autorelease];
    scrowllView_detail.frame=CGRectMake(10, 95, 300, 240);
    scrowllView_detail.backgroundColor=[UIColor blackColor];
    scrowllView_detail. contentSize = CGSizeMake(320*count, 0);
    scrowllView_detail. delegate=self;
    
    for(int i=0;i<count;i++)
    {
        NSString *str1=[NSString stringWithFormat:@"%@",[arr objectAtIndex:i]];
        str1= [str1 substringFromIndex:5];
        NSString *imgURL=[NSString stringWithFormat:@"%@%@",ImageWeb_Head,str1];
       // NSLog(@"打印网络图片相对路径%@",imgURL);
        app.pic_URL=imgURL;
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(310*i, 0, 300, 240)];
        [imageView setImageWithURL:[NSURL URLWithString:imgURL]
                  placeholderImage:[UIImage imageNamed:@"moren.png"]
                           success:^(UIImage *image) {NSLog(@"UIwebView图片显示成功OK");}
                           failure:^(NSError *error) {NSLog(@"UIwebView顶图片显示失败NO%@",error);}];
        [scrowllView_detail addSubview:imageView];
    }
    
    [showView addSubview:scrowllView_detail];
    showView.backgroundColor = [UIColor blackColor];
   
    UIImageView * bottomBackBar=[[[UIImageView alloc]initWithFrame:CGRectMake(0, showView.frame.size.height-80, 320,80 )]autorelease];
    bottomBackBar.image=[UIImage imageNamed:@"BottomBar_webImage"];
    [showView addSubview:bottomBackBar];
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame=CGRectMake(218, 10, 32, 31);
    [shareBtn setImage:[UIImage imageNamed:@"Share_webImage@2X"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackBar  addSubview:shareBtn];
    
    UIButton *isCloseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    isCloseBtn.frame=CGRectMake(275, 10, 25, 35);
    [isCloseBtn setImage:[UIImage imageNamed:@"Close_webImage@2X"] forState:UIControlStateNormal];
    [isCloseBtn addTarget:self action:@selector(isCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackBar addSubview:isCloseBtn];
    bottomBackBar.userInteractionEnabled=YES;
   // [self.view addSubview:showView];
    return showView;
}
//创建UIwebView 网络浏览图片end
//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection
didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
}
//正则法则start
-(NSMutableArray*)match_fun:(NSString *)searchText Regex:(NSString *)regTags
{
    NSMutableArray *arr=[[[NSMutableArray alloc]init]autorelease];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                  
                                                                           options:NSRegularExpressionCaseInsensitive    // 还可以加一些选项，例如：不区分大小写
                                  
                                                                             error:&error];
    NSLog(@"正则法则 判断结果：   %@",error);
    NSArray *matches = [regex matchesInString:searchText
                        
                                      options:0
                        
                                        range:NSMakeRange(0, [searchText length])];
   // NSLog(@"%@",matches);
    // 用下面的办法来遍历每一条匹配记录
    // NSString *re=@"[iI][mM][gG][\s]*[sS][rR][cC][\s]*=[\s'\"]*(?<ref_value>.*?(\.gif|\.jpg|\.png)) ";
    int i=0;
    for (NSTextCheckingResult *match in matches) {
        
        NSRange matchRange = [match range];
        
        NSString *tagString = [searchText substringWithRange:matchRange];  // 整个匹配串

        [arr insertObject:tagString atIndex:i];
        i++;
        //NSLog(@"tagString:     %@",tagString);

        
    }
    return  arr;
}
//正则法则end
/////查看web 图片
-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.showWebView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}
#pragma mark- TapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
 
    CGPoint pt = [sender locationInView:self.showWebView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [self.showWebView stringByEvaluatingJavaScriptFromString:imgURL];
    NSLog(@"image url=%@", urlToSave);
    if (urlToSave.length > 0) {
        [self showImageURL:urlToSave point:pt];
    }
}

//呈现图片
-(void)showImageURL:(NSString *)url point:(CGPoint)point
{
    app.pic_URL=url;
    [self.view addSubview:app.showView];
}
//移除图片查看视图
-(void)isCancelBtn//-(void)handleSingleViewTap:(UITapGestureRecognizer *)sender
{
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]||[obj isKindOfClass:[UIView class]]) {
            [obj removeFromSuperview];
        }
    }
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"readBack@2X.png"]];//防止浏览网络图片后的阴影
    imgView.frame = self.view.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:imgView atIndex:0];
    [imgView release];
    [self buildTheTopBar];
    [self.view addSubview:showWebView];
    [showWebView.scrollView setScrollEnabled:YES];

}
//////查看web图片  end


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////存储网页图片start
/*
-(void)storePic:(id )url
{
    //  CustomURLCache *mainUrl=(CustomURLCache *)[NSURLCache sharedURLCache];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *URL=[NSURL URLWithString:url];
    UIImage *cachedImage = [manager imageWithURL:URL]; // 将需要缓存的图片加载进来
    if (cachedImage) {
        // 如果Cache命中，则直接利用缓存的图片进行有关操作
        
        NSLog(@"SSSS");
        NSLog(@"=====%@",url );//OK
        [self performSelectorInBackground:@selector(loadImageFromUrl:) withObject:url];
        
    } else {
        // 如果Cache没有命中，则去下载指定网络位置的图片，并且给出一个委托方法
        // Start an async download
        [manager downloadWithURL:url delegate:self];
        NSLog(@"%@",url );//ok
    }
}
//开辟线程来解决图片加载方式阻塞了main线程
-(void)loadImageFromUrl: (NSString*)url {
    NSURL  *imageUrl = [NSURL URLWithString:url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    //  [self performSelectorOnMainThread:@selector(updateImageView:) withObject:imageData waitUntilDone:NO];
}
//更新显示下载的图片
-(void) updateImageView:(NSData*) data {
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:app.pic_URL];
    imageView.image = [UIImage imageWithData:data];
    [self.view addSubview:imageView];
}//*/
//////存储网页图片end

//菜单按钮响应start
- (void)viewWillLayoutSubviews
{
    
}

#pragma mark -
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
#pragma mark -响应对UIWebView 文本操作start
-(void)wordBigAction:(id)sender
{
    fontSize+=5.0;
    if(fontSize>=40.0)fontSize=40.0;
    jsString = [NSString stringWithFormat:@"<html> \n"
                "<head> \n"
                "<style type=\"text/css\"> \n"
                "body {font-size:%fpx; line-height:%fpx;}\n"
                "</style> \n"
                "</head> \n"
                "<body>%@</body> \n"
                "</html>",  fontSize ,line_height, htmlText];
    
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSURL *urlBai=[NSURL URLWithString:@"http://42.96.192.186"];
    [showWebView loadHTMLString:jsString baseURL:   urlBai];
    [showWebView stringByEvaluatingJavaScriptFromString:jsString];
    

}
-(void)wordSmallAction:(id)sender
{
    fontSize-=5.0;
    if(fontSize<=16)fontSize=16;
    jsString = [NSString stringWithFormat:@"<html> \n"
                "<head> \n"
                "<style type=\"text/css\"> \n"
                "body {font-size:%fpx; line-height:%fpx;}\n"
                "</style> \n"
                "</head> \n"
                "<body>%@</body> \n"
                "</html>",  fontSize ,line_height, htmlText];
    
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURL *urlBai=[NSURL URLWithString:@"http://42.96.192.186"];
    [showWebView loadHTMLString:jsString baseURL:   urlBai];
    [showWebView stringByEvaluatingJavaScriptFromString:jsString];
}

-(void)lineSmallAction:(id)sender
{
    line_height-=5.0;
    if(line_height<=18)line_height=18;
    jsString = [NSString stringWithFormat:@"<html> \n"
                "<head> \n"
                "<style type=\"text/css\"> \n"
                "body {font-size:%fpx; line-height:%fpx;}\n"
                "</style> \n"
                "</head> \n"
                "<body>%@</body> \n"
                "</html>",  fontSize ,line_height, htmlText];
    
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURL *urlBai=[NSURL URLWithString:@"http://42.96.192.186"];
    [showWebView loadHTMLString:jsString baseURL:   urlBai];
    [showWebView stringByEvaluatingJavaScriptFromString:jsString];
    
}
-(void)lineBigAction:(id)sender
{
    line_height+=5.0;
    if(line_height>=48)fontSize=48;
    jsString = [NSString stringWithFormat:@"<html> \n"
                "<head> \n"
                "<style type=\"text/css\"> \n"
                "body {font-size:%fpx; line-height:%fpx;}\n"
                "</style> \n"
                "</head> \n"
                "<body>%@</body> \n"
                "</html>",  fontSize ,line_height, htmlText];
    
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURL *urlBai=[NSURL URLWithString:@"http://42.96.192.186"];
    [showWebView loadHTMLString:jsString baseURL:   urlBai];
    [showWebView stringByEvaluatingJavaScriptFromString:jsString];

}
-(void)shareBtn
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    //构造分享内容
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:self
                                               authManagerViewDelegate:self];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:self
                                                          friendsViewDelegate:self
                                                        picViewerViewDelegate:nil];
    NSString *string=[NSString stringWithFormat:@"%@%@%@",shareContent1,app.share_String,shareContent2];
    id<ISSContent> publishContent = [ShareSDK content:string
                                       defaultContent:string
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.huiztech.com"
                                          description:@"这是一条测试信息"
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
///收藏提示对话框
-(void)SaveBook :(id)sender
{
    UIAlertView *alert =[[[UIAlertView alloc] initWithTitle:@"亲～"
                                                   message:@"您要收藏当前阅读内容么"
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:@"取消",nil ]autorelease];
   [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(buttonIndex==0)//确定
    {
    [saveBtn setImage:[UIImage imageNamed:@"saveImgHighted@2X"] forState:UIControlStateNormal];
////////////
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //耗时的一些操作
            //NSString * strJsonID;
            NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPaths=[array objectAtIndex:0];
            NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:[NSString stringWithFormat:@"detailRead"]];
            
            sqlite3 *database;
            
            if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
            {
                NSLog(@"open success");
            }
            else {
                NSLog(@"open failed");
            }
            char *errorMsg;
            NSString* sql=@"CREATE TABLE IF NOT EXISTS detailIDD (ID TEXT,pic TEXT)";         //创建表
            if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
            {
                NSLog(@"create success");
            }else{
                NSLog(@"create error:%s",errorMsg);
                sqlite3_free(errorMsg);
            }
            sqlite3_stmt *stmt;
            // 查找数据
            sql =[NSString stringWithFormat: @"select ID from detailIDD where ID='%@'",app.saveId];
            
            //查找数据
            int OK=0;
            if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
            {
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    const unsigned char *_id=sqlite3_column_text(stmt, 0);
                    // const unsigned char *_pic= sqlite3_column_text(stmt, 1);
                    if([app.saveId isEqualToString:[NSString stringWithUTF8String:_id]] )
                    {
                        OK=1;
                        break;
                    }
                }
            }
            if(OK==0)
            {
                char *Sql = "insert into 'detailIDD' ('ID','pic')values (?,?);";
                if (sqlite3_prepare_v2(database, Sql, -1, &stmt, nil) == SQLITE_OK) {
                    sqlite3_bind_text(stmt, 1,[app.saveId   UTF8String], -1, NULL);
                    sqlite3_bind_text(stmt, 2,[app.saveImage   UTF8String], -1, NULL);
                }
                if (sqlite3_step(stmt) != SQLITE_DONE)
                    NSLog(@"Something is Wrong!");
            }
            sqlite3_finalize(stmt);//  最后，关闭数据库：
            sqlite3_close(database);//创建数据库end
            dispatch_async(dispatch_get_main_queue(), ^{//主线程
                
                if(OK==0)
             [[Singleton sharedInstance].single_Data insertObject:app.saveImage atIndex:app.saveNum++] ;
                
            });
        });
    }
    else if(buttonIndex==1)//取消
    {
        [saveBtn setImage:[UIImage imageNamed:@"saveImgNormal@2X"] forState:UIControlStateNormal];
    }
}
#pragma mark -响应对UIWebView 文本操作start
-(void)PressWord:(id)sender
{
    
     //菜单按钮选项
    [[UIMenuController sharedMenuController] setTargetRect:[sender frame] inView:app.topBarView];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    
    UIMenuItem *wordBig = [[[UIMenuItem alloc] initWithTitle:nil action:@selector(wordBigAction:)]autorelease];
    [wordBig  setTitle:@"字体大"];
    UIMenuItem *wordSmall = [[[UIMenuItem alloc] initWithTitle:nil action:@selector(wordSmallAction:)]autorelease];
    [wordSmall setTitle:@"字体小"];
    
    UIMenuItem *lineSmall = [[[UIMenuItem alloc] initWithTitle:@"间距窄" action:@selector(lineSmallAction:)]autorelease];
    
    UIMenuItem *lineBig = [[[UIMenuItem alloc] initWithTitle: @"间距宽" action:@selector(lineBigAction:)]autorelease];
    [UIMenuController sharedMenuController].menuItems = @[wordBig,wordSmall,lineSmall,lineBig ];
    NSLog(@"XXX进入字体调整");
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[showWebView.scrollView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}
-(void)testFinishedLoadData{
	
    [self finishReloadingData];
    [self setFooterView];
}
#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:showWebView.scrollView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:showWebView.scrollView];
        [self setFooterView];
    }
}

-(void)setFooterView{

    CGFloat height = MAX(showWebView.scrollView.contentSize.height, showWebView.scrollView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              showWebView.scrollView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         showWebView.scrollView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [showWebView.scrollView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
	{
        [_refreshFooterView refreshLastUpdatedDate];
    }
}


-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        [_refreshFooterView removeFromSuperview];
    }
     _refreshFooterView = nil;
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
	{
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
	
	// overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
   
    [self testFinishedLoadData];
	 NSLog(@"刷新完成");
    NSLog(@"%@  %@",app.pre_Page,app.fatherID);
    if(app.pre_Page.length!=0&&app.fatherID!=0)
    {
       
         [self Pressleft];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"没有更多了，去返回查看其它精彩游钓资讯吧!", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil] show];
    }
   
}
//加载调用的方法
-(void)getNextPageView
{

    [self removeFooterView];
    [self testFinishedLoadData];

    if(app.next_Page.length!=0)
    {
        [self PressGo];
       
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"没有更多了，去返回查看其它精彩阅钓资讯吧!", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil] show];
        
    }
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView//防止加载提示页面滞留
{
    //刷新设置
    [self createHeaderView];
	[self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    [_refreshHeaderView refreshLastUpdatedDate];
    //刷新设置end

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //把在浏览图片时候 webview 上的滚动 加载功能 屏蔽掉
    if(scrollView==showWebView.scrollView)
    {
        isImage_scrollView=NO;
    }
    else
    {
        [showWebView.scrollView setScrollEnabled:NO];
        isImage_scrollView=YES;
    }
    if(!isImage_scrollView)
    {
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        }
        else  if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
        }
    }
	
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if(scrollView==showWebView.scrollView)
    {
        isImage_scrollView=NO;
    }
    else
    {
        [showWebView.scrollView setScrollEnabled:NO];
        isImage_scrollView=YES;
    }
    if(!isImage_scrollView)
    {
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        }
        
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
        }

    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	
	return [NSDate date]; // should return date data source was last changed
	
}
-(void)backParentView
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void)PressGo
{
    if(app.fatherID.length==0)
        app.fatherID=@"0";
    
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.8f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
    NSLog(@"Fa %@    next:%@  pre： %@",app.fatherID,app.next_Page,app.pre_Page);
    
    ContentRead * contentRead =[[[ContentRead alloc]init]autorelease];
    [contentRead setDelegate:self];//设置代理
    
    [contentRead Content:app.fatherID Detail:app.next_Page];
    
   // [showWebView reload];
    
    
   // [self buildTheTopBar];
   
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
	[UIView commitAnimations];
}
-(void)Pressleft
{
    if(app.fatherID.length==0)
        app.fatherID=@"0";
    
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.8f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
    
     NSLog(@"Fa %@    next:%@  pre： %@",app.fatherID,app.next_Page,app.pre_Page);
    
    ContentRead * contentRead =[[[ContentRead alloc]init]autorelease];
    [contentRead setDelegate:self];//设置代理
    [contentRead Content:app.fatherID Detail:app.pre_Page];
   // [showWebView reload];
    
   // [self buildTheTopBar];
    app.topBarView.userInteractionEnabled = YES;//使添加的按钮可选
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
	[UIView commitAnimations];
}


@end
