//
//  ViewController.m
//  Fish
//
//  Created by liqun on 12/3/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "ViewController.h"
#import "IIViewDeckController.h"
#import "NewViewController.h"

#import "MagazineViewController.h"
#import "SaveViewController.h"

#import "NewsController.h"
#import "LifeViewController.h"
#import "TopicViewController.h"

#import "AppDelegate.h"
#import "StoreUpViewController.h"
#import "Singleton.h"
#import "IsRead.h"

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface ViewController ()

@end

@implementation ViewController
//@synthesize categoryItem=categoryItem;
@synthesize contentRead=contentRead;
@synthesize klpImgArr;
@synthesize klpScrollView1;
@synthesize labelText=labelText;
@synthesize labelDay=labelDay;
- (void)viewWillAppear:(BOOL)animated
{//视图即将可见时调用。默认情况下不执行任何操作
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES ];//把后面的antimated=YES 去掉 就不会过渡出现问题了
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    height_Momente = size.height;
    if(height_Momente==480){
        height=20;
        height5_flag=NO;
        isFive=NO;
    }
    else  {height5_flag=YES;isFive=YES;}
    
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
    [self BuildFirstPage];
}
-(void)reBack:(NSString *)jsonString reLoad :(NSString *)ID
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
        NSString *strJson;
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"test_DB_toolBar7"];
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
        sql = @"select * from buttonList";
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                const unsigned char *theName= sqlite3_column_text(stmt, 1);
                strJson= [NSString stringWithUTF8String: theName];
                break;
            }
        }
        
        SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
        NSDictionary *jsonObj =[parser objectWithString: strJson];
        UIImageView *imgToolView=[[[UIImageView alloc]initWithFrame:CGRectMake(0,heightTooBar, 320, 44)]autorelease];
        imgToolView.image=[UIImage imageNamed:@"toolBar@2X.png"];
        imgToolView.tag=22;
        UIScrollView *scrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)]autorelease];
        
        for(int i=0;i<5;i++)
        {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            NSString* name= [[jsonObj  objectAtIndex:i+1] objectForKey:@"name"];
            button.tag=[[[jsonObj  objectAtIndex:i+1] objectForKey:@"id"]integerValue];
            
            [arrName insertObject:name atIndex:i];
            
            
            
            button.frame=CGRectMake(10+i*60, 0, 30, 40);
            button.showsTouchWhenHighlighted = YES;
            [button addTarget:self action:@selector(Press_Tag:) forControlEvents:UIControlEventTouchDown];
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
            label.text=name;
            label.font  = [UIFont fontWithName:@"Arial" size:15.0];
            label.backgroundColor=[UIColor clearColor];
            UILabel *labelNum=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 28, 25)];
            labelNum.text=[NSString stringWithFormat:@"%@", [[jsonObj  objectAtIndex:i+1] objectForKey:@"today_count"]];
            labelNum.font  = [UIFont fontWithName:@"Arial" size:12.0];
            labelNum.textColor=[UIColor whiteColor];
            labelNum.backgroundColor=[UIColor clearColor];
            UIImageView *imgViewRed=[[[UIImageView alloc]initWithFrame:CGRectMake(30, 7, 28, 25)]autorelease];
            if([labelNum.text isEqual:@"0"])
                imgViewRed.image=[UIImage imageNamed:@"whiteBack.png"];
            else
                imgViewRed.image=[UIImage imageNamed:@"redBack.png"];
            [imgViewRed addSubview:labelNum];
            [button addSubview:imgViewRed];
            [button addSubview:label];
            button.backgroundColor=[UIColor clearColor];
            [scrollView addSubview:button];
            [label release];
            
            
        }
        scrollView.contentSize = CGSizeMake(640, 44);
        [scrollView setShowsHorizontalScrollIndicator:NO];//隐藏横向滚动条
        [imgToolView addSubview:scrollView];
        imgToolView . userInteractionEnabled = YES;
        [self.view addSubview:imgToolView];

        sqlite3_finalize(stmt);
        
        //  最后，关闭数据库：
        sqlite3_close(database);
    
    
        
    }
    else
    {  ///start database
        NSString *strJson;
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"test_DB_Pic3"];
        sqlite3 *database;
        
        if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
        {
            NSLog(@"open success");
        }
        else {
            NSLog(@"open failed");
        }
        char *errorMsg;
        NSString *sql=@"CREATE TABLE IF NOT EXISTS picture (ID INTEGER PRIMARY KEY AUTOINCREMENT,pic TEXT)";         //创建表
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
        {
            NSLog(@"create success");
        }else{
            NSLog(@"create error:%s",errorMsg);
            sqlite3_free(errorMsg);
        }
        
        sql = @"select * from picture";
        sqlite3_stmt *stmt;
        //查找数据
        
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                int i=sqlite3_column_int(stmt, 0)-1;
                
                
                const unsigned char *_pic= sqlite3_column_text(stmt, 1);
                strJson= [NSString stringWithUTF8String: _pic];
                
                break;
                
            }
            
            
        }
        sqlite3_finalize(stmt);
        
        //  最后，关闭数据库：
        sqlite3_close(database);
        
        //创建数据库end
        
        SBJsonParser *parser1 = [[[SBJsonParser alloc] init]autorelease];
        NSDictionary *jsonObj1 =[parser1 objectWithString:  strJson];
        
        NSDictionary *data = [jsonObj1 objectForKey:@"data"];
        NSString *str;
        NSMutableArray *firstPageImage= [[[NSMutableArray alloc] initWithCapacity:data.count]autorelease];
        for (int i =0; i <data.count; i++) {
            
            [firstPageImage insertObject:[data objectAtIndex:i] atIndex: i];
            [arr insertObject:[data objectAtIndex:i] atIndex: i];
        }
        
        
        [self createView:firstPageImage];

    }

}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag isID:(NSString *)ID
{
    NSString* strJson;
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
    
    
    if([ID integerValue]==1)
    {
        //判断是否有本地数据库 有则进入 无则创建
        
        ///start database
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"test_DB_Pic3"];
        sqlite3 *database;
        
        if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
        {
            NSLog(@"open success");
        }
        else {
            NSLog(@"open failed");
        }
        char *errorMsg;
        // 查找数据
        NSString* sql = @"select * from picture";
        sqlite3_stmt *stmt;
        //查找数据
        
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                int i=sqlite3_column_int(stmt, 0)-1;
                
                
                const unsigned char *_pic= sqlite3_column_text(stmt, 1);
                strJson= [NSString stringWithUTF8String: _pic];
                NSLog(@"********%d",i);
            }
            
            SBJsonParser *parser1 = [[[SBJsonParser alloc] init]autorelease];
            NSDictionary *jsonObj1 =[parser1 objectWithString:  strJson];
            
            NSDictionary *data = [jsonObj1 objectForKey:@"data"];
            NSString *str;
            NSMutableArray *firstPageImage= [[[NSMutableArray alloc] initWithCapacity:data.count]autorelease];
            for (int i =0; i <data.count; i++) {
                
                [firstPageImage insertObject:[data objectAtIndex:i] atIndex: i];
                [arr insertObject:[data objectAtIndex:i] atIndex: i];
            }
            
            
            [self createView:firstPageImage];
            
            
        }
       // 删除所有数据 并进行更新数据库操作
        //删除所有数据，条件为1>0永真
        const char *deleteAllSql="delete from picture where 1>0";
        //执行删除语句
        if(sqlite3_exec(database, deleteAllSql, NULL, NULL, &errorMsg)==SQLITE_OK){
            NSLog(@"删除所有数据成功");
        }
        else NSLog(@"delect failde!!!!");
        
        
        sql=@"CREATE TABLE IF NOT EXISTS picture (ID INTEGER PRIMARY KEY AUTOINCREMENT,pic TEXT)";         //创建表
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
        {
            NSLog(@"create success");
        }else{
            NSLog(@"create error:%s",errorMsg);
            sqlite3_free(errorMsg);
        }
        NSString *insertSQLStr = [NSString stringWithFormat:
                                  @"INSERT INTO 'picture' ('pic' ) VALUES ('%@')", jsonString];
        const char *insertSQL=[insertSQLStr UTF8String];
        //插入数据 进行更新操作
        if (sqlite3_exec(database, insertSQL , NULL, NULL, &errorMsg)==SQLITE_OK) {
            NSLog(@"insert operation is ok.");
        }
        else{
            NSLog(@"insert error:%s",errorMsg);
            sqlite3_free(errorMsg);
        }
        sqlite3_finalize(stmt);
        
        //  最后，关闭数据库：
        sqlite3_close(database);
        
        //创建数据库end
    }
    else //==2
    {
        //创建数据库start
        // 首先是数据库要保存的路径
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"test_DB_toolBar7"];
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
        // 查找数据
        sql = @"select * from buttonList";
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                const unsigned char *theName= sqlite3_column_text(stmt, 1);
                 strJson= [NSString stringWithUTF8String: theName];
                break;
            }
        }
       
        SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
        NSDictionary *jsonObj =[parser objectWithString: strJson];
        UIImageView *imgToolView=[[[UIImageView alloc]initWithFrame:CGRectMake(0,heightTooBar, 320, 44)]autorelease];
        imgToolView.image=[UIImage imageNamed:@"toolBar@2X.png"];
        imgToolView.tag=22;
        UIScrollView *scrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)]autorelease];

        for(int i=0;i<5;i++)
        {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            NSString* name= [[jsonObj  objectAtIndex:i+1] objectForKey:@"name"];
            button.tag=[[[jsonObj  objectAtIndex:i+1] objectForKey:@"id"]integerValue];
            
            [arrName insertObject:name atIndex:i];

            
            
            button.frame=CGRectMake(10+i*60, 0, 30, 40);
            button.showsTouchWhenHighlighted = YES;
            [button addTarget:self action:@selector(Press_Tag:) forControlEvents:UIControlEventTouchDown];
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
            label.text=name;
            label.font  = [UIFont fontWithName:@"Arial" size:15.0];
            label.backgroundColor=[UIColor clearColor];
            UILabel *labelNum=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 28, 25)];
            labelNum.text=[NSString stringWithFormat:@"%@", [[jsonObj  objectAtIndex:i+1] objectForKey:@"today_count"]];
            labelNum.font  = [UIFont fontWithName:@"Arial" size:12.0];
            labelNum.textColor=[UIColor whiteColor];
            labelNum.backgroundColor=[UIColor clearColor];
            UIImageView *imgViewRed=[[[UIImageView alloc]initWithFrame:CGRectMake(30, 7, 28, 25)]autorelease];
            if([labelNum.text isEqual:@"0"])
                imgViewRed.image=[UIImage imageNamed:@"whiteBack.png"];
            else
                imgViewRed.image=[UIImage imageNamed:@"redBack.png"];
            [imgViewRed addSubview:labelNum];
            [button addSubview:imgViewRed];
            [button addSubview:label];
            button.backgroundColor=[UIColor clearColor];
            [scrollView addSubview:button];
            [label release];
            
            
        }
        scrollView.contentSize = CGSizeMake(640, 44);
        [scrollView setShowsHorizontalScrollIndicator:NO];//隐藏横向滚动条
        [imgToolView addSubview:scrollView];
        imgToolView . userInteractionEnabled = YES;
        [self.view addSubview:imgToolView];
        
        
        // 删除所有数据 并进行更新数据库操作
        //删除所有数据，条件为1>0永真
        const char *deleteAllSql="delete from buttonList where 1>0";
        //执行删除语句
        if(sqlite3_exec(database, deleteAllSql, NULL, NULL, &errorMsg)==SQLITE_OK){
            NSLog(@"删除所有数据成功");
        }
        else NSLog(@"delect failde!!!!");
        
        sql=@"CREATE TABLE IF NOT EXISTS picture (ID INTEGER PRIMARY KEY AUTOINCREMENT,pic TEXT)";         //创建表
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
        {
            NSLog(@"create success");
        }else{
            NSLog(@"create error:%s",errorMsg);
            sqlite3_free(errorMsg);
        }
        //插入数据
        NSString *insertSQLStr1 = [NSString stringWithFormat:
                                  @"INSERT INTO 'buttonList' ('name') VALUES ('%@')",jsonString  ];
        const char *insertSQL1=[insertSQLStr1 UTF8String];
        
        if (sqlite3_exec(database, insertSQL1 , NULL, NULL, &errorMsg)==SQLITE_OK) {
            NSLog(@"insert operation is ok.");
        }
        else{
            NSLog(@"insert error:%s",errorMsg);
            sqlite3_free(errorMsg);
        }
        sqlite3_finalize(stmt);
        
        //  最后，关闭数据库：
        sqlite3_close(database);
    }
 
}
-(void)createView:(NSMutableArray *)firstPageImage
{
    
    int bottom;
    if(isSeven&&isFive)
    {
        
        bottom=230;
    }
    else if(isSeven&&!isFive)
    {
        bottom=230;
    }else if(!isSeven&&isFive)//
    {
        bottom=230;
    }else {
        
        bottom=200;
    }

    
    labelText.text= [ [arr objectAtIndex:0] objectForKey:@"description"];
    labelText.backgroundColor=[UIColor clearColor];
    labelText.font=[UIFont systemFontOfSize:15.0f];
    labelText.numberOfLines = 0;
    [labelText sizeToFit];
    
    
    
    
    NSDate *date = [[[NSDate alloc]initWithTimeIntervalSince1970:[[ [arr objectAtIndex:0] objectForKey:@"create_time"]integerValue]
                     /1000.0]autorelease];
    
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
        NSString *imgURL=[NSString stringWithFormat:@"http://42.96.192.186/ifish/server/upload/%@",[[firstPageImage objectAtIndex:i]objectForKey:@"image"]];
        [iv setImageWithURL:[NSURL URLWithString: imgURL]
           placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                    success:^(UIImage *image) {NSLog(@"OK");}
                    failure:^(NSError *error) {NSLog(@"NO");}];
        [self.klpScrollView1 addSubview:iv];
        iv = nil;
        
    }
    [self.klpScrollView1 setContentSize:CGSizeMake(size.width * firstPageImage.count, 0)];//只可横向滚动～
    
    self.klpScrollView1.pagingEnabled = YES;
    self.klpScrollView1.showsHorizontalScrollIndicator = NO;
    //往数组里添加成员
    for (int i=0; i<firstPageImage.count; i++) {
        UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(100*i + 5*i,0,size.height+height,70)]autorelease];
        [iv setImage:[UIImage imageNamed:[[firstPageImage objectAtIndex:i] objectForKey:@"image"]  ]];
        [self.klpImgArr addObject:iv];
        iv = nil;
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    
    [self.klpScrollView1 addGestureRecognizer:singleTap];
    //[klpScrollView1 release];
    // [klpImgArr release];
    //  [app.firstPageImage release];
    ///UIScrollerView
    

}
-(void)theTopBar
{
    UIImageView *topBarWhite=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)]autorelease];
    topBarWhite.image=[UIImage imageNamed:@"TitleWhiteBack"];
    [self.view addSubview:topBarWhite];
    UIImageView *topBarRed=[[[UIImageView alloc]initWithFrame:CGRectMake(108, 0, 110, 55)]autorelease];
    topBarRed.image=[UIImage imageNamed:@"TitleRedBack"];
    [topBarWhite addSubview:topBarRed];
    UILabel *titleBigName=[[[UILabel alloc]initWithFrame:CGRectMake(10, 8, 100, 50)]autorelease];
    titleBigName.text=@"环球垂钓";
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    arr=[[[NSMutableArray alloc]init]retain];
}
-(id)translateDate:(id)date
{
    
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
	if (scrollView == self.klpScrollView1) {
		klp.frame = ((UIImageView*)[self.klpImgArr objectAtIndex:index]).frame;
		[klp setAlpha:0];
		[UIView animateWithDuration:0.2f animations:^(void){
			[klp setAlpha:.85f];
		}];
        
        labelText.text= [ [arr objectAtIndex:index] objectForKey:@"description"];
        labelText.backgroundColor=[UIColor clearColor];
        labelText.font=[UIFont systemFontOfSize:15.0f];
        labelText.numberOfLines = 0;
        [labelText sizeToFit];
        
        NSDate *date = [[[NSDate alloc]initWithTimeIntervalSince1970:[[ [arr objectAtIndex:index] objectForKey:@"create_time"]integerValue]
/1000.0]autorelease];
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    
        labelDay.textColor=[UIColor lightGrayColor];
        labelDay.text=[dateFormatter stringFromDate:date];
        labelDay.backgroundColor=[UIColor clearColor];
        labelDay.font=[UIFont systemFontOfSize:15.0f];
        labelDay.numberOfLines = 0;
        
        
        
        
	}else {
		
	}
}

#pragma mark 手势
- (void) handleSingleTap:(UITapGestureRecognizer *) gestureRecognizer{
	CGFloat pageWith = 320;
    
    CGPoint loc = [gestureRecognizer locationInView:self.klpScrollView1];
    NSInteger touchIndex = floor(loc.x / pageWith) ;
    if (touchIndex > app.firstPageImage.count) {
        return;
    }
    NSLog(@"touch index %d",touchIndex);
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
    UIButton *btn = (UIButton *)sender;
   
       NSLog(@"%d",btn.tag);
//    for (UIView *subviews in [self.view subviews]) {
//        if (subviews.tag==22) {
//            [subviews removeFromSuperview];
//        }
//    }//必须从self.view中移除，不能从gpsClickView中移除
    if(btn.tag==2||btn.tag==5||btn.tag==6)
    {
        NewsController *newVC = [[[NewsController alloc] initWithNibName:@"NewsController" bundle:nil]autorelease];
        newVC.hidesBottomBarWhenPushed = YES;
        newVC.target=btn.tag;
        newVC.NewsName=[arrName objectAtIndex:btn.tag-2];
        [self.navigationController pushViewController :newVC animated:YES];
    }
    else if(btn.tag==4)
    {
        LifeViewController *newVC = [[[LifeViewController alloc] initWithNibName:@"LifeViewController" bundle:nil]autorelease];
        self.hidesBottomBarWhenPushed = YES;

        newVC.target=4;//游钓
        [self.navigationController pushViewController :newVC animated:YES];

    }
    else if(btn.tag==3)//专题
    {
        TopicViewController *newVC = [[[ TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil]autorelease];
        newVC.target=3;
        //self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController :newVC animated:YES];

    }
}
- (void)dealloc {
    [labelText release];
    [labelDay release];
    [super dealloc];
}
@end
