//
//  TopicViewController.m
//  Fish
//
//  Created by DAWEI FAN on 18/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "TopicViewController.h"
#import "MagazineViewController.h"
#import "SaveViewController.h"

#import "NewsController.h"
#import "LifeViewController.h"

#import "IIViewDeckController.h"
#import <sqlite3.h>
@interface TopicViewController ()

@end

@implementation TopicViewController
@synthesize klpImgArr;
@synthesize klpScrollView1;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
//        for (UIView *subviews in [self.view subviews])
//        {
//            [subviews removeFromSuperview];
//        }
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGSize size = rect.size;
        CGFloat width = size.width;
        height_Momente = size.height;
        if(height_Momente==480){
            height=20;
            height5_flag=NO;
        }
        else  height5_flag=YES;
        // 判断设备的iOS 版本号
        float  version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if(version==7.0)
        {
            Kind7=YES;
        }
        else Kind7=NO;

        
            }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    
}
-(void)buildToolBar
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

    
    
    imgToolView.frame= CGRectMake(0,heightTooBar, 320, 44);
    imgToolView.image=[UIImage imageNamed:@"toolBar@2X.png"];
    imgToolView.tag=22;
    //创建数据库start
    // 首先是数据库要保存的路径
    NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPaths=[array objectAtIndex:0];
    NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"test_DB_toolBar1"];
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
    NSString *sql=@"CREATE TABLE IF NOT EXISTS buttonList (ID INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,num TEXT)";
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
    //查找数据
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
    {
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            
            int i=sqlite3_column_int(stmt, 0)-1;
            if(i==5)break;
            
            const unsigned char *theName= sqlite3_column_text(stmt, 1);
            
            NSString *name_Database= [NSString stringWithUTF8String: theName];
            const unsigned char *num= sqlite3_column_text(stmt, 2);
            
            NSString *Num_Database= [NSString stringWithUTF8String: num];
            NSString *name=[[[NSString alloc]init]autorelease];
            
            
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            if(i<5)
            {
                name= [NSString stringWithFormat: name_Database];
                button.tag=[Num_Database integerValue];
                [arrName insertObject:name atIndex:i];
            }
            //                else if(i==4){
            //                    name= [NSString stringWithFormat:@"收藏"];
            //                    button.tag=100;
            //                }
            button.frame=CGRectMake(10+i*60, 0, 30, 40);
            button.showsTouchWhenHighlighted = YES;
            [button addTarget:self action:@selector(Press_Tag:) forControlEvents:UIControlEventTouchDown];
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
            label.text=name;
            label.font  = [UIFont fontWithName:@"Arial" size:15.0];
            label.backgroundColor=[UIColor clearColor];
            UILabel *labelNum=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 28, 25)];
            labelNum.text=[NSString stringWithFormat: Num_Database];
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
    }
    scrollView.contentSize = CGSizeMake(640, 0);
    [scrollView setShowsHorizontalScrollIndicator:NO];//隐藏横向滚动条
    [scrollView setShowsVerticalScrollIndicator:NO];//隐藏横向滚动条

    [imgToolView addSubview:scrollView];
    imgToolView . userInteractionEnabled = YES;
    [self.view addSubview:imgToolView];
    
    sqlite3_finalize(stmt);
    
    //  最后，关闭数据库：
    sqlite3_close(database);
    
    //创建数据库end
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)]autorelease];
    imgToolView=[[[UIImageView alloc]init]autorelease];
    
    [self buildToolBar];
    
//    NSArray* klpArr = [NSArray arrayWithObjects:@"images-1.jpeg",@"images-2.jpeg",@"images-3.jpeg",@"images-4.jpeg",@"images-5.jpeg",@"images-6.jpeg",@"images-1.jpeg"
//              ,@"images-2.jpeg",@"images-3.jpeg",@"images-4.jpeg",@"images-5.jpeg",@"images-6.jpeg",nil];
//	self.klpImgArr = [[NSMutableArray alloc] initWithCapacity:12];
//    CGSize size = self.klpScrollView1.frame.size;
//	for (int i=0; i < [klpArr count]; i++) {
//        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(size.width * i, 0, size.width, size.height)];
//        [iv setImage:[UIImage imageNamed:[klpArr objectAtIndex:i]]];
//        [self.klpScrollView1 addSubview:iv];
//        iv = nil;
//    }
//    [self.klpScrollView1 setContentSize:CGSizeMake(size.width * 12, size.height)];
//	
//	self.klpScrollView1.pagingEnabled = YES;
//    self.klpScrollView1.showsHorizontalScrollIndicator = NO;
    
    
    
    [self createView];
    
    
}
-(void)createView//:(NSMutableArray *)firstPageImage
{
    ///UIScrollerView
    NSArray* klpArr = [NSArray arrayWithObjects:@"images-1.jpeg",@"images-2.jpeg",@"images-3.jpeg",@"images-4.jpeg",@"images-5.jpeg",@"images-6.jpeg",@"images-1.jpeg"
                                ,@"images-2.jpeg",@"images-3.jpeg",@"images-4.jpeg",@"images-5.jpeg",@"images-6.jpeg",nil];

    self.klpImgArr = [[NSMutableArray alloc] initWithCapacity:klpArr.count];
    CGSize size = self.klpScrollView1.frame.size;
    if(height_Momente==480)  height=60;
    for (int i=0; i < klpArr.count; i++) {
        UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(size.width * i, 0, size.width, size.height+height)]autorelease];
//        NSString *imgURL=[NSString stringWithFormat:@"http://42.96.192.186/ifish/server/upload/%@",[klpArr objectAtIndex:i]];
//        [iv setImageWithURL:[NSURL URLWithString: imgURL]
//           placeholderImage:[UIImage imageNamed:@"placeholder.png"]
//                    success:^(UIImage *image) {NSLog(@"OK");}
//                    failure:^(NSError *error) {NSLog(@"NO");}];
//        [self.klpScrollView1 addSubview:iv];
//        iv = nil;
        
                [iv setImage:[UIImage imageNamed:[klpArr objectAtIndex:i]]];
               [self.klpScrollView1 addSubview:iv];
              iv = nil;

        
    }
    [self.klpScrollView1 setContentSize:CGSizeMake(size.width * klpArr.count, 0)];//只可横向滚动～
    
    self.klpScrollView1.pagingEnabled = YES;
    self.klpScrollView1.showsHorizontalScrollIndicator = NO;
    //往数组里添加成员
    for (int i=0; i<klpArr.count; i++) {
        UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(100*i + 5*i,0,size.height+height,70)]autorelease];
        [iv setImage:[UIImage imageNamed:[klpArr objectAtIndex:i]]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(btn.tag<5&&btn.tag!=2&&btn.tag!=3)
    {
        NewsController *newVC = [[[NewsController alloc] initWithNibName:@"NewsController" bundle:nil]autorelease];
        newVC.hidesBottomBarWhenPushed = YES;
        newVC.target=btn.tag-1;
        newVC.NewsName=[arrName objectAtIndex:btn.tag-1];
        [self.navigationController pushViewController :newVC animated:YES];
    }
    else if(btn.tag==3)
    {
        LifeViewController *newVC = [[[LifeViewController alloc] initWithNibName:@"LifeViewController" bundle:nil]autorelease];
        newVC.target=2;
        //self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController :newVC animated:YES];
        
    }
    else if(btn.tag==2)
    {
        TopicViewController *newVC = [[[ TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil]autorelease];
        //  newVC.target=2;
        //self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController :newVC animated:YES];
        
    }
    else if(btn.tag==100)
    {
        
    }
}

@end
