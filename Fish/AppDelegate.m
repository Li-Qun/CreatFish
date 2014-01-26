//
//  AppDelegate.m
//  Fish
//
//  Created by liqun on 12/3/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//
#import "AppDelegate.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "ViewController.h"

#import "TopViewController.h"

#import "FishCore.h"
#import <ShareSDK/ShareSDK.h>
#import <Parse/Parse.h>

#import "WeiboApi.h"
#import "WeiboSDK.h"
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>


#import <sqlite3.h>
#import "Singleton.h"
#import "IsRead.h"
@implementation AppDelegate
@synthesize viewDeckController;

@synthesize filter_is_sticky=filter_is_sticky;
@synthesize filter_category_id=filter_category_id;
@synthesize offset=offset;
@synthesize array=array;
@synthesize arrayData=arrayData;
@synthesize contentRead=contentRead;
@synthesize jsonString=jsonString;
@synthesize jsonStringOne=jsonStringOne;
@synthesize targetCenter=targetCenter;
@synthesize center=centre;
@synthesize fatherID=fatherID;
@synthesize saveId=saveID;
@synthesize momentID=momentID;
@synthesize saveImage=saveImage;
@synthesize saveName=saveName;
@synthesize saveDataId=saveDataId;
@synthesize saveDataImage=saveDataImage;
@synthesize saveDataName=saveDataName;
@synthesize saveNum=saveNum;
@synthesize isReadCount=isReadCount;
@synthesize next_Page=next_Page;
@synthesize pre_Page=pre_Page;
@synthesize firstPageImage=firstPageImage;
@synthesize pic_URL;
@synthesize topBarView;
@synthesize isRead=isRead;
@synthesize isRead_arr=isRead_arr;
-(void)build
{
   // AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    array=[[NSMutableArray  alloc]init];
    arrayData=[[NSMutableArray alloc]init];
    saveDataId=[[NSMutableArray  alloc]init];
    saveDataName=[[NSMutableArray  alloc]init];
    saveDataImage=[[NSMutableArray  alloc]init];
    firstPageImage=[[NSMutableArray  alloc]init];
    
    next_Page=@"11";
    pre_Page=@"11";
}
-(void)Pre:(int)index
{
   
}
- (void)dealloc
{
    [_window release];
    [_viewController release];
    [array release];
    [arrayData release ];
    [saveDataId release];
    [saveDataName release];
    [saveDataImage release];
    [firstPageImage release];
    [isRead_arr release];
    
    [super dealloc];
}
-(void)setShare
{
    [ShareSDK registerApp:@"1151625a6c74"];
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"3334408824"
                               appSecret:@"dd5a1fd45ed30443a8d6a805771e15dd"
                             redirectUri:@"http://www.huiztech.com"];   //回调URL
    
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"3334408824"];
    //添加腾讯微博应用
      [ShareSDK connectTencentWeiboWithAppKey:@"801470547"
                                  appSecret:@"a381d8a35096c2212c68bb4e51936eb6"
                                redirectUri:@"http://www.huiztech.com"
                            wbApiCls:[WeiboApi class]];
    
//    //添加微信应用
//    [ShareSDK importWeChatClass:[WXApi class]];
//    [ShareSDK connectWeChatWithAppId:@"wx3a4f2774b2a663a9" wechatCls:[WXApi class]]; //此参数为申请的微信AppID
    
    
    [Parse setApplicationId:@"vrg7swgpHbG9xt9ziSliylHkxLeQX2rwgtdNdWjt"
                  clientKey:@"cPCuhXPQKHBzv0ucOFfm0TmuYhMKcQyMEH0LxZJG"];

}

//先生成 再替换
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //耗时的一些操作
        
        //打开判断可读数据库
        NSString *strID;
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *str=[NSString stringWithFormat:@"News_dataBases"];
        NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:str];
        sqlite3 *database;
        
        if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
        {
            NSLog(@"open success");
        }
        else {
            NSLog(@"open failed");
        }
        
        char *errorMsg;
        NSString *sql=@"CREATE TABLE IF NOT EXISTS isReadList(ID TEXT)"; //创建表
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
        {
            NSLog(@"create success");
        }else{
            NSLog(@"create error:%s",errorMsg);
            sqlite3_free(errorMsg);
        }
        sql= @"select ID from isReadList";
        sqlite3_stmt *stmt;
        //查找数据
        isRead_arr=[[NSMutableArray  alloc]init];
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            int i=0;
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                
                
                const unsigned char *_id= sqlite3_column_text(stmt, 0);
                strID= [NSString stringWithUTF8String: _id];
                [[IsRead sharedInstance].single_isRead_Data insertObject:strID atIndex:isReadCount++] ;
                
            }
        }
        sqlite3_finalize(stmt);
        sqlite3_close(database);
//打开判断可读数据库end
//打开 判断收藏数据库start
        NSString * strJsonID;
        NSArray *array1=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths1=[array1 objectAtIndex:0];
        NSString *databasePaths1=[documentsPaths1 stringByAppendingPathComponent:[NSString stringWithFormat:@"detailRead"]];
        
        sqlite3 *database1;
        
        if (sqlite3_open([databasePaths1 UTF8String], &database1)==SQLITE_OK)
        {
            NSLog(@"open success");
        }
        else {
            NSLog(@"open failed");
        }
        char *error_Msg;
        sqlite3_stmt *stmt1;
        // 查找数据
        NSString* Sql =[NSString stringWithFormat: @"select pic from detailIDD"];
        
        //查找数据
        int OK=0;
        if(sqlite3_prepare_v2(database1, [Sql UTF8String], -1, &stmt1, nil)==SQLITE_OK)
        {
            while (sqlite3_step(stmt1)==SQLITE_ROW) {
                const unsigned char *_id=sqlite3_column_text(stmt1, 0);
                // const unsigned char *_pic= sqlite3_column_text(stmt, 1);
                NSString *str= [NSString stringWithUTF8String:_id];
                [[Singleton sharedInstance].single_Data insertObject:str atIndex:saveNum++] ;
                
            }
        }
        sqlite3_finalize(stmt1);//  最后，关闭数据库：
        sqlite3_close(database1);//创建数据库end
//打开 判断收藏数据库end
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

            [self setShare];
            self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
            
            UIViewController  *centerView = [[[ViewController alloc] init] autorelease];
            
            centerView.title = @"中心视图";
            UINavigationController  *centerNav = [[[UINavigationController alloc] initWithRootViewController:centerView] autorelease];
            
            LeftViewController *leftView = [[[LeftViewController alloc] init] autorelease];
            RightViewController *rightView=[[[RightViewController alloc]init]autorelease];
            //  TopViewController *topView = [[[TopViewController alloc] init] autorelease];
            
            IIViewDeckController *vc =[[IIViewDeckController alloc]initWithCenterViewController:centerNav leftViewController:leftView rightViewController:rightView  ];
            vc.leftSize =  (320 - 244.0);  // 这里的size可以根据你的需求去设置,我这里是为了测试,设置比较大 这里也可以不设置size
            vc.rightSize = 320.0-244.0;
            vc.topSize = 460+44;
            self.viewDeckController = vc;
            
            CGRect rect = [[UIScreen mainScreen] bounds];
            CGSize size = rect.size;
            CGFloat width = size.width;
            CGFloat height = size.height;
            if(height==480)height_First=100;
            
            //先生成 再替换
            self.window.rootViewController = self.viewDeckController;
            self.window.backgroundColor=[UIColor whiteColor];
            [self.window makeKeyAndVisible];
            
            UIImageView *splashScreen = [[[UIImageView alloc] initWithFrame:CGRectMake(-40, 0, 360, height)]autorelease];
            splashScreen.image = [UIImage imageNamed:@"welcome@2X"];
            [self.window addSubview:splashScreen];
            
            UIImageView *splashScreen2 = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 400-height_First, 270, 80)]autorelease];
            splashScreen2.image = [UIImage imageNamed:@"clearbar@2X"];
            [self.window addSubview:splashScreen2];
            
            UIImageView *splashScreen3 = [[[UIImageView alloc] initWithFrame:CGRectMake(280, 400-height_First,40, 80)]autorelease];
            splashScreen3.image = [UIImage imageNamed:@"clearArrow@2X"];
            [self.window addSubview:splashScreen3];
            
            [UIView animateWithDuration:4.0 animations:^{
                CATransform3D transform = CATransform3DMakeTranslation(30, 0, 0);
                splashScreen.layer.transform = transform;
                splashScreen.alpha = 0.0;
            } completion:^(BOOL finished) {
                [splashScreen removeFromSuperview];
                [splashScreen2 removeFromSuperview];
                [splashScreen3 removeFromSuperview];
            }];
 
            
        });
    });
    
    return YES;
}

- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    //TODO: 3. 实现handleOpenUrl相关的两个方法，用来处理微信的回调信息
    return [ShareSDK handleOpenURL:url wxDelegate:self];
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
