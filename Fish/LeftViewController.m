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

#import "BigFishViewController.h"
#import "StoreUpViewController.h"
#import "SettingViewController.h"
#import "NewsController.h"
#import "TopicViewController.h"

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    //arrName=[[[NSMutableArray alloc]init]autorelease];
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version <7.0)
        isSeven=NO;
    else isSeven=YES;
    [self visitDataBase];
    
}
-(void)visitDataBase
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *strJson;
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"test_DB_toolBar7"];
        //  然后建立数据库，新建数据库这个苹果做的非常好，非常方便
        sqlite3 *database;
        //新建数据库，存在则打开，不存在则创建
        if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
        {
            NSLog(@"打开toolbar表");
        }
        else {
            NSLog(@"open failed");
        }
        // 查找数据
        NSString* sql = @"select * from buttonList";
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
        sqlite3_close(database);
 
        dispatch_async(dispatch_get_main_queue(), ^{//主线程
            
            
           app.saveName=strJson;
  //  app.saveName=[whole sharedInstance].wholeString;
            int height;
            if(isSeven) height=60;
            else height=45;
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
            
            SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
            NSMutableArray *jsonObj =[parser objectWithString: strJson ];
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
            
            int j=0;
            for(int i=1;i<jsonObj.count;i++)
            {
                if([[[jsonObj  objectAtIndex:i] objectForKey:@"pid"] integerValue]==0)
                {
                    //////创建动态按钮start
                    NSString *key=[NSString stringWithFormat:@"%d",i];
                    UIButton *OneButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    OneButton.frame=CGRectMake(0, height+44+5+j*45, 320, 44);
                    [OneButton setImage:[UIImage imageNamed:@"selectOne@2X"] forState:UIControlStateNormal];
                    [myView addSubview:OneButton ];
                    UILabel *OneName=[[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 320, 44)]autorelease];
                    OneName.textColor=[UIColor whiteColor];
                    OneName.text=[[jsonObj  objectAtIndex:i] objectForKey:@"name"];
                    [OneButton addSubview:OneName];
                    [OneButton addTarget:self action:@selector(PessSwitch_Tag:) forControlEvents:UIControlEventTouchUpInside];
                    UIImageView *pictureOneName=[[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,25 , 25)] autorelease];
                    NSString *imgURL=[NSString stringWithFormat:@"http://42.96.192.186/ifish/server/upload/%@",[[jsonObj  objectAtIndex:i] objectForKey:@"image"] ];
                    [pictureOneName setImageWithURL:[NSURL URLWithString: imgURL]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                success:^(UIImage *image) {NSLog(@"OK");}
                                failure:^(NSError *error) {NSLog(@"NO");}];
                    
                    
                    [OneButton  addSubview:pictureOneName];
                    OneButton.tag=[[[jsonObj  objectAtIndex:i] objectForKey:@"id"]integerValue];
                    UIImageView *theRedNum=[[[UIImageView alloc]initWithFrame:CGRectMake(200, 10, 28, 22)]autorelease];
                    [OneButton addSubview:theRedNum];
                    UILabel *labelNum=[[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 28, 22)]autorelease];
                    labelNum.text=[NSString stringWithFormat:@"%@", [[jsonObj  objectAtIndex:i] objectForKey:@"today_count"]];
                    labelNum.textColor=[UIColor whiteColor];
                    labelNum.font  = [UIFont fontWithName:@"Arial" size:12.0];
                    [theRedNum addSubview:labelNum];
                    if([labelNum.text isEqualToString:@"0"])
                        theRedNum.image=[UIImage imageNamed:@"whiteBack.png"];
                    else  theRedNum.image=[UIImage imageNamed:@"redBack.png"];
                    
                    
                    labelNum.backgroundColor=[UIColor clearColor];
                    OneButton.backgroundColor=[UIColor clearColor];
                    OneName.backgroundColor=[UIColor clearColor];
                    j++;
                    /////动态创建按钮end
                }
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
 
            
        });
    });
   // */
    

    
    //创建数据库end
}
-(void)PessSwitch_Tag:(id)sender
{
   
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%d",btn.tag);
    NSString *name;
    NSString *fatherID;
    NSString *isTopic;
    NSString *isGallery;
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
    
    if(btn.tag==101)//收藏
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
    else if(btn.tag<100)
    {
        if([isGallery integerValue]==0&& [isTopic integerValue]==0)
        {
            [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                NewsController *apiVC = [[[NewsController alloc] init] autorelease];
                apiVC.NewsName=name;
                apiVC.target=btn.tag;
                apiVC.NewsPid=[NSString stringWithFormat:@"%d",btn.tag];
                UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
                self.viewDeckController.centerController = navApiVC;
                self.view.userInteractionEnabled = YES;
            }];

            
        }
        else if([isTopic integerValue]==1)
        {
            [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                TopicViewController *apiVC = [[[TopicViewController alloc] init] autorelease];
                apiVC.target=btn.tag;
                UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
                self.viewDeckController.centerController = navApiVC;
                self.view.userInteractionEnabled = YES;
            }];

        }
        else if([isGallery integerValue]==1)
        {
            [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                BigFishViewController *apiVC = [[[BigFishViewController alloc] init] autorelease];
                apiVC.target=btn.tag;
                apiVC.BigFishName=name;
                apiVC.BigFishPid=[NSString stringWithFormat:@"%d",btn.tag];
                UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
                self.viewDeckController.centerController = navApiVC;
                self.view.userInteractionEnabled = YES;
            }];
        }

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
