//
//  BookViewController.m
//  Fish
//
//  Created by DAWEI FAN on 10/02/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "BookViewController.h"

#import "FishCore.h"
#import "IsRead.h"

#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "Reachability.h"


#import "SBJson.h"
#import "JSONKit.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "InformationCell.h"
#import "OneCell.h"
#import "NewCell.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "IIViewDeckController.h"
#import "RightViewController.h"
#import "sqlite3.h"
#import "BaiduMobStat.h"
@interface BookViewController ()

@end

@implementation BookViewController
@synthesize Delegate;
@synthesize arr=arr;
@synthesize arrPic=arrPic;
@synthesize arrLabel=arrLabel;
@synthesize arrID=arrID;
@synthesize NewsId=NewsId;
@synthesize NewsImage=NewsImage;
@synthesize NewsFlag=NewsFlag;
@synthesize NewsLevel=NewsLevel;
@synthesize NewsName=NewsName;
@synthesize NewsPid=NewsPid;
@synthesize target=target;
@synthesize targetCentre=targetCentre;
@synthesize leftSwipeGestureRecognizer,rightSwipeGestureRecognizer;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
//百度页面统计
-(void)viewDidAppear:(BOOL)animated
{
    NSString *cName=[NSString stringWithFormat:@"Book&%@",NewsName];
    [[BaiduMobStat defaultStat]pageviewStartWithName:cName ];
}
-(void)viewDidDisappear:(BOOL)animated
{
   NSString *cName=[NSString stringWithFormat:@"Book&%@",NewsName];
    [[BaiduMobStat defaultStat]pageviewEndWithName:cName ];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    height_Momente = size.height;
    
    if(height_Momente==480)
    {
        isFive=NO;
    }else isFive=YES;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version <7.0)
        isSeven=NO;
    else isSeven=YES;
    
    ContentRead * contentRead =[[[ContentRead alloc]init]autorelease];
    [contentRead setDelegate:self];//设置代理
    app.targetCenter=[NewsPid intValue];
    NSLog(@"%d %d",target,app.targetCenter);
    str=[NSString stringWithFormat:@"%d",target];
    NewsID=[str integerValue];
    [contentRead fetchList:[NSString stringWithFormat:@"%d",app.targetCenter] isPri:@"1" Out:@"0"];
    
    
}
//-(void)translate:(NSString *)ID_Num
//{
//    DetailViewController *detail=[[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil]autorelease];
//    detail.momentID=ID_Num;
//    [self.navigationController pushViewController:detail animated:YES];
//}
//-(void)make_Sure_theCenter:(NSString *)ID_Num
//{
//
//}

- (void)viewDidLoad
{
    self.view.backgroundColor=[UIColor whiteColor];
    isFirstLoad=NO;
    newSumCount=0;
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    arr=[[[NSMutableArray alloc]init]retain];
    arrPic=[[[NSMutableArray alloc]init]retain];
    arrLabel=[[[NSMutableArray alloc]init]retain];
    arrID=[[[NSMutableArray alloc]init]retain];
    arrTopId=[[[NSMutableArray alloc]init]retain];
    
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.toolbarHidden = YES;
    
    
    
    // app.targetCenter=target;
    NSLog(@"centre  %d",app.targetCenter);
    str=[NSString stringWithFormat:@"%d",target];
    
    ContentRead * contentRead =[[[ContentRead alloc]init]autorelease];
    [contentRead setDelegate:self];//设置代理
    
    [contentRead fetchList:str isPri:@"0" Out:@"0"];
    
    tabView=[[[UITableView alloc]init]retain];
    scrollView_Book = [[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 178)]retain];
    tabView.showsHorizontalScrollIndicator=NO;
    tabView.showsVerticalScrollIndicator=NO;
    
    
    [super viewDidLoad];
    //  [arr release];
    isOpenR=NO;isOpenL=NO;
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if(sender.view ==scrollView_Book)
    {
        
    }
    else
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
}
-(void)buildTheTopBar
{
    float heightTopbar;
    float littleHeinght;
    int labelName;
    if(isSeven&&isFive)
    {
        heightTopbar=65;
        littleHeinght=20+5;
        labelName=0;
    }
    else if(isSeven&&!isFive)
    {
        heightTopbar=65;
        littleHeinght=20+5;
        labelName=0;
    }else if(!isSeven&&isFive)//
    {
        heightTopbar=45;
        littleHeinght=10;
        labelName=7;
    }else {
        heightTopbar=45;
        littleHeinght=10;
        labelName=12;
    }
    
    UIImageView *topBarView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, heightTopbar)]autorelease];
    topBarView.image=[UIImage imageNamed:@"topBarRed"];
    [self.view addSubview:topBarView];
    
    UIImageView *wordView=[[[UIImageView alloc]initWithFrame:CGRectMake(105, littleHeinght/2, 90, 23)]autorelease];
    wordView.image=[UIImage imageNamed:@"word"];
    // [topBarView addSubview:wordView];
    UILabel *name=[[[UILabel alloc]initWithFrame:CGRectMake(105,littleHeinght/2+3-labelName,95,65-littleHeinght)]autorelease];
    name.textColor=[UIColor whiteColor];
    name.text=NewsName;
    name.textAlignment = UITextAlignmentCenter;
    name.font =[UIFont boldSystemFontOfSize:21];
    name.shadowColor = [UIColor grayColor];
    name.shadowOffset = CGSizeMake(0.0,0.5);
    name.backgroundColor=[UIColor clearColor];
    [topBarView addSubview:name];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(10,littleHeinght, 37, 30);
    leftBtn.tag=10;
    [leftBtn setImage:[UIImage imageNamed:@"LeftBtn@2X"] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(PessSwitch_BtnTag:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(270,littleHeinght, 37, 30);
    [rightBtn setImage:[UIImage imageNamed:@"RightBtn@2X"] forState:UIControlStateNormal];
    [self.view addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(PessSwitch_BtnTag:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag=20;
    
    tabView.frame=CGRectMake(0, heightTopbar, 320, height_Momente);
    
}
-(void)reBack:(NSString *)jsonString reLoad:(NSString *)ID Offent:(NSString *)Out
{
    if([jsonString isEqualToString:@"0"])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //耗时的一些操作
            
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

            BOOL flag=NO;
            //初始查询该条记录是否存在 不存在 提示 存在 读取并 加载
            NSString* sql =[NSString stringWithFormat:@"select  count(*) from picture where ID='%@' and Offent='%@'",ID,Out];
             sqlite3_stmt *stmt;
             if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
             {
                 while (sqlite3_step(stmt)==SQLITE_ROW) {
                     
                     const unsigned char *_id= sqlite3_column_text(stmt, 0);
                     strJson= [NSString stringWithUTF8String: _id];
                    if([strJson isEqualToString:@"0"])//count ==0 记录不存在
                     {
                         flag=YES;
                     }
                 }
             }
            
            sql =[NSString stringWithFormat:@"select pic from picture where ID='%@' and Offent='%@'",ID,Out];
       
            //查找数据
           
            
            if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
            {
                
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    if(sqlite3_column_count(stmt)==0)
                    {
                        flag=YES;
                        break;
                    }
                    const unsigned char *_id= sqlite3_column_text(stmt, 0);
                    strJson= [NSString stringWithUTF8String: _id];
                }
            }
            
            sqlite3_finalize(stmt);
            sqlite3_close(database);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{//主线程
                
                if(flag||[self isBlankString:strJson])
                {
                    [MBProgressHUD hideHUDForView:tabView animated:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"该缓存为空，请连接网络使用"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                    
                }
                else if(!flag)
                {
                    SBJsonParser *parser1 = [[[SBJsonParser alloc] init]autorelease];
                    NSDictionary *jsonObj1 =[parser1 objectWithString:  strJson];
                    
                    NSArray *data = [jsonObj1 objectForKey:@"data"];
                    total += data.count;
                    NSLog(@"资讯条目数量 : %d",total);
                    NSLog(@"total : %d",total);
                    newSumCount=arr.count;
                    for (int i =0; i <data.count; i++) {
                        
                        [arr insertObject:[data objectAtIndex:i] atIndex: newSumCount];
                        newSumCount++;
                    }
                    [MBProgressHUD hideHUDForView:tabView animated:YES];
                    [self build_TableView];
                }
            });
        });
    }
    else{
        
        [self buildTheTopBar];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //耗时的一些操作
            
            NSString *strJson;
            NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPaths=[array objectAtIndex:0];
            NSString *str1=[NSString stringWithFormat:@"NewsTop_dataBases"];
            NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:str1];
            sqlite3 *database;
            
            if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
            {
                NSLog(@"open success");
            }
            else {
                NSLog(@"open failed");
            }
            
            char *errorMsg;
            NSString *sql=@"CREATE TABLE IF NOT EXISTS picture (ID TEXT,pic TEXT)"; //创建表
            if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
            {
                NSLog(@"create success");
            }else{
                NSLog(@"create error:%s",errorMsg);
                sqlite3_free(errorMsg);
            }
            sql =[NSString stringWithFormat:@"select pic from picture where ID='%@'",ID];
            sqlite3_stmt *stmt;
            //查找数据
            
            if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
            {
                
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    
                    const unsigned char *_id= sqlite3_column_text(stmt, 0);
                    strJson= [NSString stringWithUTF8String: _id];
                    // const unsigned char *_pic= sqlite3_column_text(stmt, 1);
                    //strJson= [NSString stringWithUTF8String: _pic];
                    break;
                }
            }
            sqlite3_finalize(stmt);
            sqlite3_close(database);
            
            app.jsonStringOne=strJson;
            dispatch_async(dispatch_get_main_queue(), ^{//主线程
                
                app.jsonStringOne=strJson;
                
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
        app.jsonString=jsonString;
        
        isFistLevel=[flag intValue];
        
        if(isFistLevel==0)
        {
            
            SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
            NSDictionary *jsonObj =[parser objectWithString: jsonString];
            
            NSDictionary *data = [jsonObj objectForKey:@"data"];
            if(data.count==0)
            {
                [MBProgressHUD hideHUDForView:tabView animated:YES];
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"没有更多阅钓信息了～"
                                                                delegate:nil
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles: @"确定",nil]autorelease];
                [alert show];
                
            }
            else
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //耗时的一些操作
                    
                    
                    // NSString *strJson;
                    NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsPaths=[array objectAtIndex:0];
                    NSString *str1=[NSString stringWithFormat:@"NewsViewController"];
                    NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:str1];
                    sqlite3 *database;
                    
                    if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
                    {
                        NSLog(@"open success");
                    }
                    else {
                        NSLog(@"open failed");
                    }
                    
                    char *errorMsg;
                    NSString *sql=@"CREATE TABLE IF NOT EXISTS picture (ID TEXT,Offent TEXT,pic TEXT)"; //创建表
                    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
                    {
                        NSLog(@"create success");
                    }else{
                        NSLog(@"create error:%s",errorMsg);
                        sqlite3_free(errorMsg);
                    }
                    sql =[NSString stringWithFormat:@"select ID from picture where ID='%@' and Offent='%@'",ID,Out];
                    sqlite3_stmt *stmt;
                    //查找数据
                    BOOL OK=NO;
                    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
                    {
                        
                        while (sqlite3_step(stmt)==SQLITE_ROW) {
                            
                            
                            const unsigned char *_id= sqlite3_column_text(stmt, 0);
                            NSString *Id= [NSString stringWithUTF8String: _id];
                            // const unsigned char *_pic= sqlite3_column_text(stmt, 1);
                            // strJson= [NSString stringWithUTF8String: _pic];
                            if([ID isEqualToString:Id])
                            {
                                OK=YES;
                                break;
                            }
                        }
                    }
                    if(!OK)
                    {
                        NSString *insertSQLStr = [NSString stringWithFormat:
                                                  @"INSERT INTO 'picture' ('ID','Offent','pic' ) VALUES ('%@','%@','%@')", ID,Out,jsonString];
                        const char *insertSQL=[insertSQLStr UTF8String];
                        //插入数据 进行更新操作
                        if (sqlite3_exec(database, insertSQL , NULL, NULL, &errorMsg)==SQLITE_OK) {
                            NSLog(@"insert operation is ok.");
                        }
                        else{
                            NSLog(@"insert error:%s",errorMsg);
                            sqlite3_free(errorMsg);
                        }
                    }
                    sqlite3_finalize(stmt);
                    sqlite3_close(database);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{//主线程
                        
                        SBJsonParser *parser1 = [[[SBJsonParser alloc] init]autorelease];
                        NSDictionary *jsonObj1 =[parser1 objectWithString:  jsonString];
                        
                        NSArray *data = [jsonObj1 objectForKey:@"data"];
                        total += data.count;
                        NSLog(@"资讯条目数量 : %d",total);
                        newSumCount=arr.count;
                        for (int i =0; i <data.count; i++) {
                            
                            [arr insertObject:[data objectAtIndex:i] atIndex: newSumCount];
                            newSumCount++;
                        }
                        [MBProgressHUD hideHUDForView:tabView animated:YES];
                        [self build_TableView];
                    });
                });
                
            }
            
        }
        else if (isFistLevel==1)
        {
            [self buildTheTopBar];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //耗时的一些操作
                //  NSString *strJson;
                NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPaths=[array objectAtIndex:0];
                NSString *str2=[NSString stringWithFormat:@"NewsTop_dataBases"];
                NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:str2];
                sqlite3 *database;
                
                if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
                {
                    NSLog(@"open success");
                }
                else {
                    NSLog(@"open failed");
                }
                
                char *errorMsg;
                NSString *sql=@"CREATE TABLE IF NOT EXISTS picture (ID TEXT,pic TEXT)"; //创建表
                if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
                {
                    NSLog(@"create success");
                }else{
                    NSLog(@"create error:%s",errorMsg);
                    sqlite3_free(errorMsg);
                }
                sql =[NSString stringWithFormat:@"select ID from picture where ID='%@'",ID];
                sqlite3_stmt *stmt;
                //查找数据
                BOOL OK=NO;
                if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
                {
                    
                    while (sqlite3_step(stmt)==SQLITE_ROW) {
                        
                        
                        const unsigned char *_id= sqlite3_column_text(stmt, 0);
                        NSString *Id= [NSString stringWithUTF8String: _id];
                        // const unsigned char *_pic= sqlite3_column_text(stmt, 1);
                        // strJson= [NSString stringWithUTF8String: _pic];
                        if([ID isEqualToString:Id])
                        {
                            OK=YES;
                            break;
                        }
                    }
                }
                if(!OK)
                {
                    NSString *insertSQLStr = [NSString stringWithFormat:
                                              @"INSERT INTO 'picture' ('ID','pic' ) VALUES ('%@','%@')", ID,jsonString];
                    const char *insertSQL=[insertSQLStr UTF8String];
                    //插入数据 进行更新操作
                    if (sqlite3_exec(database, insertSQL , NULL, NULL, &errorMsg)==SQLITE_OK) {
                        NSLog(@"insert operation is ok.");
                    }
                    else{
                        NSLog(@"insert error:%s",errorMsg);
                        sqlite3_free(errorMsg);
                    }
                }
                sqlite3_finalize(stmt);
                sqlite3_close(database);
                app.jsonStringOne=jsonString;
                dispatch_async(dispatch_get_main_queue(), ^{//主线程
                    
                    
                    app.jsonStringOne=jsonString;
                    
                });
            });
        }

    }
    
}
-(void)build_TableView
{
    
    [self createHeaderView];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    [_refreshHeaderView refreshLastUpdatedDate];
    
    tabView.delegate=self;
    tabView.dataSource=self;//设置双重代理 很重要
    [tabView setBackgroundColor:[UIColor clearColor]];
    [tabView setSeparatorStyle:UITableViewCellSeparatorStyleNone];//hidden the lines
    [tabView reloadData];
    [self.view addSubview:tabView];
    
}
-(void)PessSwitch_BtnTag:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag==10)
    {
        [self.viewDeckController toggleLeftViewAnimated:YES];
        
    }
    else
    {
        [self.viewDeckController toggleRightViewAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
        return  170;
    else
        return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",total);
    return (total+1);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationCell *cell=(InformationCell*)[tableView dequeueReusableCellWithIdentifier:@"InformationCell"];
    
    
    if(indexPath.row==0)
    {
    
        NewCell *cellOne=(NewCell*)[tableView dequeueReusableCellWithIdentifier:@"NewCell"];
        static NSString *cellIdentifiter = @"Cellidentifiter";
        
        if(cellOne==nil)
        {
            cellOne= [[NewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifiter];
            NSMutableArray* dataPic;
            NSMutableArray* dataLabel;
            NSMutableArray *dataTitle;
            dataPic=[[[NSMutableArray alloc]init]autorelease];
            dataLabel=[[[NSMutableArray alloc]init]autorelease];
            SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
            NSArray *jsonObj =[parser objectWithString:app.jsonStringOne];
            for(int i=0;i<jsonObj.count ;i++)
            {
                [dataPic insertObject:[NSString stringWithFormat:@"%@%@",Image_Head,[[jsonObj objectAtIndex:i] objectForKey:@"image"]] atIndex:i];
                [dataLabel insertObject: [[jsonObj objectAtIndex:i]objectForKey:@"name"] atIndex:i];
                [arrTopId insertObject:  [[jsonObj objectAtIndex:i]objectForKey:@"id"]  atIndex:i];
            }
            
            scrollView_Book.contentSize = CGSizeMake(320*dataPic.count, 0);
            scrollView_Book.delegate=self;
            for(int i=0;i<dataPic.count;i++)
            {
                UIImageView *imageView=[[[UIImageView alloc]initWithFrame:CGRectMake(320*i, 0, 320,  178)]autorelease];
                imageView.tag = i+1;
                [imageView setImageWithURL:[NSURL URLWithString: [dataPic objectAtIndex:i]]
                                  placeholderImage:[UIImage imageNamed:@"moren.png"]
                                           success:^(UIImage *image) {NSLog(@"资讯置顶图片显示成功OK");}
                                           failure:^(NSError *error) {NSLog(@"资讯置顶图片显示失败NO");}];
                
                
                
                UIImageView *clearBack=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 143, 320,30)]autorelease];
                clearBack.image=[UIImage imageNamed:@"clearBack@2X"];
                [imageView addSubview:clearBack];
                UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(300, 10, 9, 11)];
                arrow.image=[UIImage imageNamed:@"theArrow"];
                [clearBack addSubview:arrow];
                UILabel *title_label=[[[UILabel alloc]initWithFrame:CGRectMake(2, 0, 299, 30)]autorelease];
                title_label.text=[dataLabel objectAtIndex:i];
                
                title_label.textColor=[UIColor whiteColor];
                title_label.backgroundColor=[UIColor clearColor];
                title_label.font=[UIFont boldSystemFontOfSize:14];
                
                [clearBack addSubview:title_label];
                
                UILabel *num_label=[[UILabel alloc]initWithFrame:CGRectMake(270, 0, 41,30)];
                num_label.text=[NSString stringWithFormat:@"%d/%d",i+1,dataPic.count];
                num_label.textColor=[UIColor whiteColor];
                num_label.backgroundColor=[UIColor clearColor];
                num_label.font=[UIFont boldSystemFontOfSize:14];
                [clearBack addSubview:num_label];
                [scrollView_Book addSubview:imageView];
                
            }
            UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap1:)]autorelease];
            [singleTap setNumberOfTapsRequired:1];
            
            [scrollView_Book  addGestureRecognizer:singleTap];
            [cellOne addSubview:scrollView_Book];
            
        }
        
        return cellOne;
    }
    else
    {
        if(cell==nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InformationCell" owner:[InformationCell class] options:nil];
            cell = (InformationCell *)[nib objectAtIndex:0];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        NSDictionary* dict = [arr objectAtIndex:(indexPath.row-1)];
        
        cell.labelForCategory_id.text=[dict objectForKey:@"category_id"];
        
        cell.labelForName.text=[dict objectForKey:@"name"];
         cell.labelForName.textColor =[UIColor redColor ];
        NSLog(@"%d",[IsRead sharedInstance].single_isRead_Data.count);
        if(app.isRead)
        {
            for(int i=0;i<app.isReadCount;i++)
            {
                if([[dict objectForKey:@"id"]isEqualToString: [[IsRead sharedInstance].single_isRead_Data objectAtIndex:i]  ])
                {
                    cell.labelForName.textColor =[UIColor blackColor ];
                }
            }
        }
        cell.labelForName.font=[UIFont systemFontOfSize:15.0f];
        
        
        cell.labelForID.text=[dict objectForKey:@"description"];
        cell.labelForID.font=[UIFont systemFontOfSize:12.0f];
        cell.labelForID.textColor=[UIColor grayColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *imgURL=[NSString stringWithFormat:@"%@%@",Image_Head,[dict objectForKey:@"image"]];
        //#import "UIImageView+WebCache.h" 加载网络图片方法start
        [cell.imgView setImageWithURL:[NSURL URLWithString: imgURL]
                     placeholderImage:[UIImage imageNamed:@"moren.png"]
                              success:^(UIImage *image) {NSLog(@"OK");}
                              failure:^(NSError *error) {NSLog(@"NO");}];
        
        
        //#import "UIImageView+WebCache.h" 加载网络图片方法end
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row>0)
    {
        CGRect cellFrameInTableView = [tableView rectForRowAtIndexPath:indexPath];
        CGRect cellFrameInSuperview = [tableView convertRect:cellFrameInTableView toView:[tableView superview]];
        DetailViewController *detail=[[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil]autorelease];
        
        NSMutableDictionary* dict = [self.arr objectAtIndex:indexPath.row-1];
        detail.yOrigin=cellFrameInSuperview.origin.y;
        detail.momentID=[dict objectForKey:@"id"];
        NSLog(@"NewsID :  %d",NewsID);
        detail.fatherID=[NSString stringWithFormat:@"%d",NewsID];
        
        [self.navigationController pushViewController:detail animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
        NSLog(@"%@",app.next_Page);
    }
}

-(void)theFirstCell_Transport:(NSString *)ID_Num
{
    DetailViewController *detail=[[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil]autorelease];
    detail.momentID= ID_Num;
    detail.fatherID=@"0";
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;//滑动隐藏toolbar
{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;//不滑动 显示toolbar
{
    NSLog(@"g滚动");
    if (scrollView == scrollView_Book)
    {
		CGFloat pageWidth = scrollView.frame.size.width;
		page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        NSLog(@"page   :%d",page);
        UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap1:)]autorelease];
        [singleTap setNumberOfTapsRequired:1];
        
        [scrollView_Book  addGestureRecognizer:singleTap];

	}
}
#pragma mark 手势
- (void) handleSingleTap1:(UITapGestureRecognizer *) gestureRecognizer{
    if(arrTopId.count==0)
    {
        
    }
    else
    {
        DetailViewController *detail=[[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil]autorelease];
        
        detail.momentID=[arrTopId objectAtIndex:page];
        detail.fatherID=@"0";
        [self.navigationController pushViewController:detail animated:YES];
    }
}
///ScrollView end
-(void)pressLeftSlide
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
    
}
-(void)pressRightSlide
{
    [self.viewDeckController toggleRightViewAnimated:YES];
}
//- (void)dealloc {
//
//    [super dealloc];
//}
//加载瀑布流start
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
    
    [tabView addSubview:_refreshHeaderView];
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading: tabView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading: tabView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(tabView.contentSize.height, tabView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              tabView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         tabView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [tabView addSubview:_refreshFooterView];
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
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:tabView animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"正在加载更多~~";//加载提示语言
        [hud show:YES];

        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:1.0];
    }
    
    // overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
    NSLog(@"刷新完成");
    [self testFinishedLoadData];
    
}
//加载调用的方法
-(void)getNextPageView
{
    NSString *str1=[NSString stringWithFormat:@"%d",target];
    ContentRead * contentRead =[[[ContentRead alloc]init]autorelease];
    [contentRead setDelegate:self];
    NSString *str2=[NSString stringWithFormat:@"%d",total];//更改加载更多的方式 计数器 （int）total为偏移量
    [contentRead fetchList:str1 isPri:@"0" Out:str2];
    [tabView reloadData];
    [self removeFooterView];
    [self testFinishedLoadData];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView==scrollView_Book)
    {
        
    }
    else
    {
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        }
        
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
        }

    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(scrollView==scrollView_Book)
    {
        
    }
    else
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



//加载瀑布流end
@end