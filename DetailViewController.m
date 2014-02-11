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

#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import "sqlite3.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize showWebView=showWebView;
//@synthesize dictForData=dictForData;
@synthesize Data=Data;
@synthesize tableView=tableView;
@synthesize jsString=jsString;
@synthesize htmlText=htmlText;
@synthesize arrIDList=arrIDList;
@synthesize arrIDListNew=arrIDListNew;
@synthesize page_num=page_num;
@synthesize page_label=page_label;
@synthesize htmlTextTotals=htmlTextTotals;
@synthesize momentID=momentID;
@synthesize fatherID=fatherID;
@synthesize pre_Page=pre_Page;
@synthesize next_Page=next_Page;
@synthesize leftSwipeGestureRecognizer,rightSwipeGestureRecognizer;
//@synthesize detailImage=detailImage;
//@synthesize detailName=detailName;
//@synthesize detailID=detailID;
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
- (void)viewWillAppear:(BOOL)animated
{//视图即将可见时调用。默认情况下不执行任何操作
     self.navigationController.toolbarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
    
    [super viewWillAppear:animated];
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
}
-(void)buildTheTopBar
{
    float heightTopbar;
    float littleHeinght;
    if(isSeven&&isFive)
    {
        heightTopbar=60;
        littleHeinght=23;
    }
    else if(isSeven&&!isFive)
    {
        heightTopbar=60;
        littleHeinght=23;
    }else if(!isSeven&&isFive)//
    {
        heightTopbar=60;
        littleHeinght=20;
    }else {
        heightTopbar=45;
        littleHeinght=10;
    }

    //创建导航按钮start
    app. topBarView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, heightTopbar)];
    app. topBarView.image=[UIImage imageNamed:@"topViewBarWhite"];
    [self.view addSubview:app.topBarView];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(10, littleHeinght, 26, 25);
    [backBtn setImage:[UIImage imageNamed:@"BackImg@2X"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backParentView) forControlEvents:UIControlEventTouchUpInside];
    [app.topBarView  addSubview:backBtn];
    
    UIButton *wordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    wordBtn.frame=CGRectMake(175, littleHeinght+3, 28, 20);
    [wordBtn setImage:[UIImage imageNamed:@"AaImg@2X"] forState:UIControlStateNormal];
    [wordBtn addTarget:self action:@selector(PressWord:) forControlEvents:UIControlEventTouchUpInside];
    [app.topBarView  addSubview:wordBtn];
    
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame=CGRectMake(280, littleHeinght, 26, 25);
    [shareBtn setImage:[UIImage imageNamed:@"shareImg@2X"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
    [app.topBarView  addSubview:shareBtn];
    
    saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame=CGRectMake(230, littleHeinght, 26, 25);
    
    [saveBtn setImage:[UIImage imageNamed:@"saveImgNormal@2X"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(SaveBook:) forControlEvents:UIControlEventTouchUpInside];
    [app.topBarView  addSubview:saveBtn];
    [saveBtn setImage:[UIImage imageNamed:@"saveImgHighted@2X"] forState:UIControlStateHighlighted];
    
    app.topBarView.userInteractionEnabled = YES;//使添加的按钮可选
    
    //创建导航按钮end
    
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight)//na
    {
        if(!isOpenL&&!isOpenR)
        {
            [self.viewDeckController toggleLeftViewAnimated:YES];
            isOpenL=YES;
        }
        if(!isOpenL&&isOpenR)
        {
            [self.viewDeckController toggleRightViewAnimated:YES];
            isOpenR=NO;
        }
        
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {//bie
        
        if(!isOpenR&&!isOpenL)
        {
            [self.viewDeckController toggleRightViewAnimated:YES];
            isOpenR=YES;
        }
        if(isOpenL&&!isOpenR)
        {
            [self.viewDeckController toggleLeftViewAnimated:YES];
            isOpenL=NO;
        }
    }
}

- (void)viewDidLoad
{
    
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
        NSString* sql=@"CREATE TABLE IF NOT EXISTS detail (ID TEXT,pic TEXT)";         //创建表
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
        {
            NSLog(@"create success");
        }else{
            NSLog(@"create error:%s",errorMsg);
            sqlite3_free(errorMsg);
        }
        sqlite3_stmt *stmt;
         BOOL flag=NO;
        sql =[NSString stringWithFormat:@"select pic from detail where ID='%@'",ID];
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
            
            if(flag)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"该缓存为空，请连接网络使用"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert release];
                
            }
            else
            {
                [self buildTheTopBar];
                SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
                NSDictionary *jsonObj =[parser objectWithString:strJson];
                
                
                
                // moment=[[jsonObj objectForKey:@"id"]intValue];
                
                htmlText=[[[NSString alloc]init]retain];
                app.saveId=[jsonObj objectForKey:@"id"];
                app.saveImage=jsonString;
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
                
                arrIDList=[[NSMutableArray alloc]init];
                
               // [self.view addSubview:showWebView];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                
                //showWebView.

            }
            
        });
    });

}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag isID:(NSString *)ID Offent:(NSString *)Out
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
        NSString* sql=@"CREATE TABLE IF NOT EXISTS detail (ID TEXT,pic TEXT)";         //创建表
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
        {
            NSLog(@"create success");
        }else{
            NSLog(@"create error:%s",errorMsg);
            sqlite3_free(errorMsg);
        }
        sqlite3_stmt *stmt;
        // 查找数据
        sql =  [ NSString stringWithFormat: @"select ID from detail  where ID=%@",app.saveId];
        
        //查找数据
        int flag=0;
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                const unsigned char *_id=sqlite3_column_text(stmt, 0);
                if([[NSString stringWithUTF8String:_id] isEqualToString:app.saveId])
                {
                    flag=1;
                    break;
                }
            }
        }
        if(flag==0)
        {
            char *Sql = "insert into 'detail' ('ID','pic')values (?,?);";
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
        NSString *strID;
        NSArray *array1=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths1=[array1 objectAtIndex:0];
        NSString *str=[NSString stringWithFormat:@"News_dataBases"];
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
        if(OK==0)
        {
            NSString *string=[jsonObj1 objectForKey:@"create_time"];
            NSString* date;
            NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
            [formatter  setDateFormat:@"20YY-MM-dd"];
            date = [formatter stringFromDate:[NSDate date]];
            if([string isEqualToString:date])///是今天的日期并且id不在数据库里 是未读  插入数据库 
            {
                char *Sql = "insert into 'isReadList' ('ID')values (?);";
                if (sqlite3_prepare_v2(database1, Sql, -1, &stmt1, nil) == SQLITE_OK) {
                    sqlite3_bind_text(stmt1, 1,[ID  UTF8String], -1, NULL);
                    [[IsRead sharedInstance].single_isRead_Data insertObject: ID atIndex:app.isReadCount++] ;
                }
                if (sqlite3_step(stmt1) != SQLITE_DONE)
                    NSLog(@"Something is Wrong!");
            }
        }
        sqlite3_finalize(stmt1);
        sqlite3_close(database1);
        
        
        //建立是否已读数据库
        dispatch_async(dispatch_get_main_queue(), ^{//主线程
            
            [self buildTheTopBar];
            SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
            NSDictionary *jsonObj =[parser objectWithString:jsonString];
            
            
            
            //moment=[[jsonObj objectForKey:@"id"]intValue];
            
            htmlText=[[[NSString alloc]init]retain];
            app.saveId=[jsonObj objectForKey:@"id"];
            app.saveImage=jsonString;
            
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
            
            NSURL *urlBai=[NSURL URLWithString:@"http://42.96.192.186"];
            [showWebView loadHTMLString:jsString baseURL:   urlBai];
            showWebView.delegate=self;
            showWebView.scrollView.delegate=self;
            
            self.view.backgroundColor=[UIColor clearColor];
            
            [showWebView setUserInteractionEnabled: YES ];
            //UIWebView
            //[receiveStr release];
            
            arrIDList=[[NSMutableArray alloc]init];
            
          //  [self.view addSubview:showWebView];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            //showWebView.
            
            
            
            
        });
    });
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
    showWebView.scrollView.delegate=self;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
    [showWebView stringByEvaluatingJavaScriptFromString:@"imageWidth(305);"];//设置网络图片统一宽度320
    [showWebView stringByEvaluatingJavaScriptFromString:@"init();"];
    [self.view addSubview:showWebView];
    //刷新设置
    [self createHeaderView];
	[self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    [_refreshHeaderView refreshLastUpdatedDate];
    //刷新设置end
    [self addTapOnWebView];//调用触摸图片事件
}
//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection
didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
}
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
    
    UIImageView *showView = [[UIImageView alloc] initWithFrame:self.view.frame  ];
    showView.center = point;
    [UIView animateWithDuration:0.5f animations:^{
        CGPoint newPoint = self.view.center;
        newPoint.y += 20;
        showView.center = newPoint;
    }];
    showView.backgroundColor = [UIColor clearColor];
    showView.alpha = 0.9;
    showView.userInteractionEnabled = YES;
    [self.view addSubview:showView];
    UIImageView * bottomBackBar=[[[UIImageView alloc]initWithFrame:CGRectMake(0, showView.frame.size.height-80, 320,80 )]autorelease];
    bottomBackBar.image=[UIImage imageNamed:@"BottomBar_webImage"];
    [showView addSubview:bottomBackBar];
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame=CGRectMake(218, 10, 32, 31);
    [shareBtn setImage:[UIImage imageNamed:@"Share_webImage@2X"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareThewebImage) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackBar  addSubview:shareBtn];
    
    UIButton *isCloseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    isCloseBtn.frame=CGRectMake(275, 10, 25, 35);
    [isCloseBtn setImage:[UIImage imageNamed:@"Close_webImage@2X"] forState:UIControlStateNormal];
    [isCloseBtn addTarget:self action:@selector(isCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackBar addSubview:isCloseBtn];
    bottomBackBar.userInteractionEnabled=YES;

    [showView setImageWithURL:[NSURL URLWithString:url]];
//    
//    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleViewTap:)];
//    [showView addGestureRecognizer:singleTap];
//    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)shareThewebImage
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    //构造分享内容
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
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

    id<ISSContent> publishContent = [ShareSDK content:app.pic_URL
                                       defaultContent:@"分享我的阅钓心得"
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
//移除图片查看视图
-(void)isCancelBtn//-(void)handleSingleViewTap:(UITapGestureRecognizer *)sender
{
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            [obj removeFromSuperview];
        }
    }
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"readBack@2X.png"]];
    imgView.frame = self.view.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:imgView atIndex:0];
    [imgView release];
    [self buildTheTopBar];
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

- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender
{
    if (action == @selector(cameraAction:) ||
        action == @selector(broomAction:) ||
        action == @selector(textAction:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
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
                                                         allowCallback:NO
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
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"默认分享内容，没内容时显示"
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
    UIAlertView *alert =[[[UIAlertView alloc] initWithTitle:@"hello"
                                                   message:@"收藏当前阅读内容"
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
    [[UIMenuController sharedMenuController] setTargetRect:[sender frame] inView:self.view];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    
    UIMenuItem *wordBig = [[[UIMenuItem alloc] initWithTitle:nil action:@selector(wordBigAction:)]autorelease];
    [wordBig  setTitle:@"字体大"];
    UIMenuItem *wordSmall = [[[UIMenuItem alloc] initWithTitle:nil action:@selector(wordSmallAction:)]autorelease];
    [wordSmall setTitle:@"字体小"];
    
    UIMenuItem *lineSmall = [[[UIMenuItem alloc] initWithTitle:@"间距窄" action:@selector(lineSmallAction:)]autorelease];
    
    UIMenuItem *lineBig = [[[UIMenuItem alloc] initWithTitle: @"间距宽" action:@selector(lineBigAction:)]autorelease];
    [UIMenuController sharedMenuController].menuItems = @[wordBig,wordSmall,lineSmall,lineBig ];
    //菜单按钮选项
    [[UIMenuController sharedMenuController] setTargetRect:CGRectMake(175, 23, 28, 20) inView:self.view];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
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
    
    
    [self buildTheTopBar];
   
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
    
    [self buildTheTopBar];
    app.topBarView.userInteractionEnabled = YES;//使添加的按钮可选
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
	[UIView commitAnimations];
}


@end
