//
//  RightViewController.m
//  Fish
//
//  Created by liqun on 12/3/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "RightViewController.h"
#import "BookViewController.h"
#import "TopicViewController.h"

#import "BigFishViewController.h"
#import "AppDelegate.h"
#import <sqlite3.h>
#import "BaiduMobStat.h"
@interface RightViewController ()

@end

@implementation RightViewController
@synthesize target_centerView=target_centerView;
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
    NSString *cName=@"Right&右侧边栏 ";
    [[BaiduMobStat defaultStat]pageviewStartWithName:cName ];
}
-(void)viewDidDisappear:(BOOL)animated
{
    NSString *cName=@"Right&右侧边栏 ";
    [[BaiduMobStat defaultStat]pageviewEndWithName:cName ];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    for (UIView *subviews in [self.view subviews])
    {
        [subviews removeFromSuperview];
    }

    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slideLeft_Back@2X.png"]];
    imgView.frame = self.view.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:imgView atIndex:0];
    [imgView release];

   
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSArray *jsonObj =[parser objectWithString: app.saveName];
    
    UIScrollView *scrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)]autorelease];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.delegate=self;
    UIView *myView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)]autorelease];
    myView.backgroundColor=[UIColor clearColor];
    NSLog(@"==%d",app.targetCenter);
    NSLog(@"centre:%d",target_centerView );
    // if(app.targetCenter<7)
    target_centerView=app.targetCenter;
    // else target_centerView=app.targetCenter;
    BOOL flag=NO;
    int i=0;
    
    for(int j=0;j<jsonObj.count;j++)
    {
        if([ [NSString stringWithFormat:@"%d",target_centerView]isEqualToString:[[jsonObj  objectAtIndex:j] objectForKey:@"pid"]])
        {
            flag=YES;
            //  NSLog(@"%@",[[jsonObj  objectAtIndex:j] objectForKey:@"name"]);
            UIButton *OneButton=[UIButton buttonWithType:UIButtonTypeCustom];
            OneButton.frame=CGRectMake(0, 20+i*45, 320, 44);
            [OneButton setImage:[UIImage imageNamed:@"selectOne@2X"] forState:UIControlStateNormal];
            [myView addSubview:OneButton ];
            UILabel *OneName=[[[UILabel alloc]initWithFrame:CGRectMake(145, 0, 320, 44)]autorelease];
            OneName.textColor=[UIColor whiteColor];
            OneName.text=[[jsonObj  objectAtIndex:j] objectForKey:@"name"];
            [OneButton addSubview:OneName];
            [OneButton addTarget:self action:@selector(PessSwitchRight_Tag:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *pictureOneName=[[[UIImageView alloc]initWithFrame:CGRectMake(90, 10,25 , 25)] autorelease];
            pictureOneName.image=[UIImage imageNamed:@"News@2X.png"];
            [OneButton  addSubview:pictureOneName];
            OneButton.tag=[ [[jsonObj  objectAtIndex:j] objectForKey:@"id"] integerValue];
            OneName.backgroundColor=[UIColor clearColor];
            OneButton.backgroundColor=[UIColor clearColor];
            i++;
        }
    }

       if(!flag)
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"暂无子分类哦 >_<"
                                                         message:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles: nil]autorelease];
        [alert show];
    }
    [scrollView addSubview:myView];
    scrollView.contentSize = myView.frame.size;
    [self.view addSubview:scrollView];

    
}
-(void)buildTheBtn
 {
 
    
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
    sqlite3_finalize(stmt);
    
    //  最后，关闭数据库：
    sqlite3_close(database);
     
    app.saveName=strJson;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
     app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self buildTheBtn];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)PessSwitchRight_Tag:(id)sender
{
    NSString *name;
    NSString *fatherID;
    NSString *isTopic;
    NSString *isGallery;
    NSLog(@"中心视图%d",app.targetCenter);
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%d",btn.tag);
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSArray *jsonObj =[parser objectWithString: app.saveName];
    NSLog(@"%@",jsonObj);
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
        [self.viewDeckController closeRightViewBouncing:^(IIViewDeckController *controller) {
            BookViewController *apiVC = [[[BookViewController alloc] init] autorelease];
            apiVC.target=btn.tag;
            apiVC.NewsPid=fatherID;
            apiVC.NewsName=name;
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];
    }
    else if([isTopic integerValue]==1)
    {
        [self.viewDeckController closeRightViewBouncing:^(IIViewDeckController *controller) {
            TopicViewController *apiVC = [[[TopicViewController alloc] init] autorelease];
            apiVC.targetRight=btn.tag;
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];
    }else if([isGallery integerValue]==1)
    {
        app.targetCenter=btn.tag;
        [self.viewDeckController closeRightViewBouncing:^(IIViewDeckController *controller) {
            BigFishViewController *apiVC = [[[BigFishViewController alloc] init] autorelease];
            apiVC.target=btn.tag;
            [app.BigFish_Description removeAllObjects];
            apiVC.BigFishName=name;
            apiVC.BigFishPid=fatherID;
            app.targetCenter=[fatherID intValue];
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];
    }
}
 
@end
