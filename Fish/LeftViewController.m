//
//  LeftViewController.m
//  Fish
//

//  Created by liqun on 12/3/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "LeftViewController.h"
#import "IIViewDeckController.h"
#import "NewsController.h"
#import "ViewController.h"
#import "AppDelegate.h"

#import "LifeViewController.h"
#import "StoreUpViewController.h"
#import "SettingViewController.h"
#import "TViewController.h"
#import "NewsController.h"

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface LeftViewController ()

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.view.backgroundColor=[UIColor blackColor];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    arrName=[[[NSMutableArray alloc]init]retain];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version <7.0)
        isSeven=NO;
    else isSeven=YES;
    contentRead =[[[ContentRead alloc]init]autorelease];
    contentRead.delegate=self;
    [contentRead Category];
}
-(NSMutableDictionary *)build_DataBase:(NSDictionary *)jsonObj
{
    
    //创建数据库start
    // 首先是数据库要保存的路径
    NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPaths=[array objectAtIndex:0];
    NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"test_DB_Left3"];
    //  然后建立数据库，新建数据库这个苹果做的非常好，非常方便
    sqlite3 *database;
    //新建数据库，存在则打开，不存在则创建
    if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
    {
        //NSLog(@"open success");
    }
    else {
      //  NSLog(@"open failed");
    }
    char *errorMsg;
    NSString *sql=@"CREATE TABLE IF NOT EXISTS leftB (ID INTEGER PRIMARY KEY AUTOINCREMENT,num TEXT,name TEXT, image TEXT)";//创建表
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
    {
        //NSLog(@"create success");
    }else{
       // NSLog(@"create error:%s",errorMsg);
        sqlite3_free(errorMsg);
    }

    for(int i=0;i<5;i++)
    {
        NSString *insertSQLStr = [NSString stringWithFormat:
                                  @"INSERT INTO 'leftB' ('NUM','NAME', 'image') VALUES ('%@','%@', 'png')",[[jsonObj  objectAtIndex:i] objectForKey:@"id"],[[jsonObj  objectAtIndex:i] objectForKey:@"name"]];
        const char *insertSQL=[insertSQLStr UTF8String];
        //插入数据
        if (sqlite3_exec(database, insertSQL , NULL, NULL, &errorMsg)==SQLITE_OK) {
            //NSLog(@"insert operation is ok.");
        }
        else{
          //  NSLog(@"insert error:%s",errorMsg);
            sqlite3_free(errorMsg);
        }

    }
       // 查找数据
    sql = @"select * from leftB";
    sqlite3_stmt *stmt;
    //查找数据
    NSMutableDictionary *new_json= [NSMutableDictionary dictionaryWithObjectsAndKeys:0,1,2,3,nil];
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
    {
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            
            int userId=sqlite3_column_int(stmt, 0);
            const unsigned char *Num= sqlite3_column_text(stmt, 1);
            NSString *num= [NSString stringWithUTF8String: Num];
            const unsigned char *Name= sqlite3_column_text(stmt, 2);
            NSString *name= [NSString stringWithUTF8String: Name];
            int i=userId-1;
            if(i>4)break;
            NSMutableDictionary *arrD=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"id",@"name",nil];
            
            [arrD setObject:num forKey:@"id"];
            [arrD setObject:name forKey:@"name"];
            NSString *str=[NSString stringWithFormat:@"%d",userId-1];
            [new_json setObject:arrD forKey:str];
            [arrName insertObject:name atIndex:i];
        }
    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return new_json;
}
-(void)reBack:(NSString *)jsonString
{
    [self.navigationController setNavigationBarHidden:YES];
    if([jsonString isEqualToString:@"1"])
    {
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"test_DB_Left"];
        sqlite3 *database;
        if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
        {
            NSLog(@"open success");
        }
        else {
            NSLog(@"open failed");
        }
   
        // 查找数据
        NSString *sql = @"select * from cap";
        sqlite3_stmt *stmt;
        //查找数据
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                int userId=sqlite3_column_int(stmt, 0);
                const unsigned char *password= sqlite3_column_text(stmt, 1);
                
                NSString *name= [NSString stringWithUTF8String: password];
                const unsigned char *num= sqlite3_column_text(stmt, 2);
                
                NSString *Num= [NSString stringWithUTF8String: num];
                NSLog(@"UserId:%i,num:%@,password:%@",userId,Num,name);
               //  [arrName insertObject:name atIndex:i];
            }
        }
        sqlite3_finalize(stmt);
        
        //  最后，关闭数据库：
        sqlite3_close(database);
        
        //创建数据库end
    }
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag isID:(NSString *)ID
{
    [self.navigationController setNavigationBarHidden:YES];
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSDictionary *jsonObj =[parser objectWithString: jsonString];
    int height;
    if(isSeven) height=60;
    else height=45;
    NSMutableDictionary *new_Json=[self build_DataBase:jsonObj];
    UIScrollView *scrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)]autorelease];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.delegate=self;
    UIView *myView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)]autorelease];
    myView.backgroundColor=[UIColor clearColor];
    UIImageView *imageViewTitle=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
    imageViewTitle.image=[UIImage imageNamed:@"LeftTitle@2X"];
    [myView addSubview:imageViewTitle];
    UILabel *mainTitle=[[[UILabel alloc]initWithFrame:CGRectMake(105, 0, 320, height)]autorelease];
    mainTitle.text=@"阅钓";
    mainTitle.backgroundColor=[UIColor clearColor];
    mainTitle.font = [UIFont boldSystemFontOfSize:20];
    mainTitle.textColor=[UIColor whiteColor];
    [imageViewTitle addSubview:mainTitle];
     //首页
    UIButton *firstBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    firstBtn.frame=CGRectMake(0, height+2, 320, 44);
    [firstBtn setImage:[UIImage imageNamed:@"selectOne@2X"] forState:UIControlStateNormal];
    [myView addSubview:firstBtn ];
    UILabel *firstPageName=[[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 320, 44)]autorelease];
    firstPageName.textColor=[UIColor whiteColor];
    firstPageName.text=@"首页";
    [firstBtn  addSubview:firstPageName];
    UIImageView *pictureFistPage=[[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,25 , 25)] autorelease];
    pictureFistPage.image=[UIImage imageNamed:@"firstPage@2X.png"];
    [firstBtn  addSubview:pictureFistPage];
    firstBtn.tag=103;
    [firstBtn addTarget:self action:@selector(PessSwitch_Tag:) forControlEvents:UIControlEventTouchUpInside];
    firstPageName.backgroundColor=[UIColor clearColor];
    //////创建动态按钮start
 
      NSLog(@"%@",[[new_Json objectForKey:@"0"]objectForKey:@"name"]);
    
    
    for (int i=0; i<5;i++)
    {
        NSString *key=[NSString stringWithFormat:@"%d",i];
        UIButton *OneButton=[UIButton buttonWithType:UIButtonTypeCustom];
        OneButton.frame=CGRectMake(0, height+44+5+i*45, 320, 44);
        [OneButton setImage:[UIImage imageNamed:@"selectOne@2X"] forState:UIControlStateNormal];
        [myView addSubview:OneButton ];
        UILabel *OneName=[[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 320, 44)]autorelease];
        OneName.textColor=[UIColor whiteColor];
        OneName.text=[NSString stringWithFormat: [[new_Json objectForKey:key]objectForKey:@"name"]];
        [OneButton addSubview:OneName];
        [OneButton addTarget:self action:@selector(PessSwitch_Tag:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *pictureOneName=[[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,25 , 25)] autorelease];
        pictureOneName.image=[UIImage imageNamed:@"News@2X.png"];
        [OneButton  addSubview:pictureOneName];
        OneButton.tag=[[NSString stringWithFormat: [[jsonObj  objectAtIndex:i] objectForKey:@"id"]]integerValue];
        UIImageView *theRedNum=[[[UIImageView alloc]initWithFrame:CGRectMake(200, 10, 28, 22)]autorelease];
        [OneButton addSubview:theRedNum];
        UILabel *labelNum=[[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 28, 22)]autorelease];
        labelNum.text=[[new_Json objectForKey:key]objectForKey:@"id"];
        labelNum.textColor=[UIColor whiteColor];
        labelNum.font  = [UIFont fontWithName:@"Arial" size:12.0];
        [theRedNum addSubview:labelNum];
        if([labelNum.text isEqualToString:@"0"])
            theRedNum.image=[UIImage imageNamed:@"whiteBack.png"];
        else  theRedNum.image=[UIImage imageNamed:@"redBack.png"];
        
        
        labelNum.backgroundColor=[UIColor clearColor];
        OneButton.backgroundColor=[UIColor clearColor];
        OneName.backgroundColor=[UIColor clearColor];
        
        /////动态创建按钮end
    }
   //收藏&设置
    for(int i=0;i<2;i++)
    {
        UIButton *OneButton=[UIButton buttonWithType:UIButtonTypeCustom];
        OneButton.frame=CGRectMake(0,330+height/2+i*45, 320, 44);
        [OneButton setImage:[UIImage imageNamed:@"selectOne@2X"] forState:UIControlStateNormal];
        OneButton.backgroundColor=[UIColor clearColor];
        [myView addSubview:OneButton ];
        UILabel *OneName=[[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 320, 44)]autorelease];
        OneName.textColor=[UIColor whiteColor];
        [OneButton addSubview:OneName];
        [OneButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        UIImageView *pictureOneName=[[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,25 , 25)] autorelease];
        if(i==0)
        {
            OneName.text=@"收藏";
            pictureOneName.image=[UIImage imageNamed:@"Save@2X.png"];
            OneButton.tag=101;
        }
        else
        {
            OneName.text=@"设置";
            pictureOneName.image=[UIImage imageNamed:@"Set@2X.png"];
            OneButton.tag=102;
        }
        [OneButton  addSubview:pictureOneName];
          [OneButton addTarget:self action:@selector(PessSwitch_Tag:) forControlEvents:UIControlEventTouchUpInside];
        OneName.backgroundColor=[UIColor clearColor];
    }
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slideLeft_Back@2X.png"]];
    imgView.frame = CGRectMake(0, 330+height/2, 320,568 );
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:imgView atIndex:0];
    [imgView release];
    
    
    [scrollView addSubview:myView];
     scrollView.contentSize = myView.frame.size;
    [self.view addSubview:scrollView];
    

}
-(void)PessSwitch_Tag:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%d",btn.tag);
    if(btn.tag<6&&btn.tag!=2&&btn.tag!=3)
    {
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            NewsController *apiVC = [[[NewsController alloc] init] autorelease];
            apiVC.NewsName=[arrName objectAtIndex:btn.tag-1];
            apiVC.target=btn.tag;
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];
        [self.navigationController setNavigationBarHidden:YES ];
    }else if (btn.tag==2)
    {
         NSLog(@"%d",btn.tag);
    }
    else if(btn.tag==3)
    {
        
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            LifeViewController *apiVC = [[[LifeViewController alloc] init] autorelease];
            apiVC.target=3;
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];
        [self.navigationController setNavigationBarHidden:YES ];
    }
    else if(btn.tag==101)//收藏
    {
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            StoreUpViewController *apiVC = [[[StoreUpViewController alloc] init] autorelease];
            //  apiVC.title = @"XXXXXX";
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];

    }
    else if(btn.tag==102)//设置
    {
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            SettingViewController *apiVC = [[[SettingViewController alloc] init] autorelease];
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];
        
    }else if(btn.tag==103)//首页
    {
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            ViewController *apiVC = [[[ViewController alloc] init] autorelease];
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
