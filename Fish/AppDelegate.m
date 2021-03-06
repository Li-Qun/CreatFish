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

#import "FishCore.h"
#import <ShareSDK/ShareSDK.h>
#import <Parse/Parse.h>

#import "WeiboApi.h"
#import "WeiboSDK.h"
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
//#import "BaiduMobStat.h"

#import <sqlite3.h>
#import "Singleton.h"
#import "IsRead.h"
#import "todayCount.h"

#define IosAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
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
@synthesize share_String=share_String;
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
@synthesize BigFish_Description=BigFish_Description;
@synthesize toolbar_js=toolbar_js;
@synthesize showView=showView;
@synthesize array_btID=array_btID;


-(void)build
{
   // AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    array=[[NSMutableArray  alloc]init];
    arrayData=[[NSMutableArray alloc]init];
    saveDataId=[[NSMutableArray  alloc]init];
    saveDataName=[[NSMutableArray  alloc]init];
    saveDataImage=[[NSMutableArray  alloc]init];
    firstPageImage=[[NSMutableArray  alloc]init];
    BigFish_Description=[[NSMutableArray  alloc]init];
    array_btID=[[NSMutableArray alloc]init];
    next_Page=@"11";
    pre_Page=@"11";
    jsonStringOne=[[NSString alloc]init];
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
    [BigFish_Description release];
    [array_btID release];
    [jsonStringOne release];
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

//新浪登录
    [Parse setApplicationId:@"vrg7swgpHbG9xt9ziSliylHkxLeQX2rwgtdNdWjt"
                  clientKey:@"cPCuhXPQKHBzv0ucOFfm0TmuYhMKcQyMEH0LxZJG"];

}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
}
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}
//先生成 再替换
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //耗时的一些操作
//    //打开百度移动统计start事件统计
//        BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
//        statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
//        //statTracker.channelId = @"ReplaceMeWithYourChannel";//设置您的app的发布渠道
//        statTracker.logStrategy = BaiduMobStatLogStrategyCustom;//根据开发者设定的时间间隔接口发送 也可以使用启动时发送策略
//        statTracker.logSendInterval = 1;  //为1时表示发送日志的时间间隔为1小时
//        statTracker.logSendWifiOnly = NO; //是否仅在WIfi情况下发送日志数据
//        statTracker.sessionResumeInterval = 35;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
//        statTracker.shortAppVersion  = IosAppVersion; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
//        statTracker.enableDebugOn = YES; //打开sdk调试接口，会有log打印
//        [statTracker startWithAppId:@"856f2f81b0"];//设置您在mtj网站上添加的app的appkey 。
//        
//    //打开百度移动统计end事件统计
        
//打开判断可读数据库
        NSString *strID;
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *str=[NSString stringWithFormat:@"NewsViewController"];
        NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:str];
        sqlite3 *database;
        
        if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
        {
            NSLog(@"后台打开可读数据库");
        }
        else {
            NSLog(@"open failed");
        }
        
        //char *errorMsg;
        NSString *sql=@"CREATE TABLE IF NOT EXISTS isReadList(ID TEXT)"; //创建表
//        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
//        {
//            NSLog(@"create success");
//        }else{
//            NSLog(@"create error:%s",errorMsg);
//            sqlite3_free(errorMsg);
//        }
         sql= @"select ID from isReadList";
        sqlite3_stmt *stmt;
        //查找数据
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                if(sqlite3_column_count(stmt)==0)
                break;
                const unsigned char *_id= sqlite3_column_text(stmt, 0);
                if(_id==NULL)break;//字符串为空
                strID= [NSString stringWithUTF8String: _id];
                [[IsRead sharedInstance].single_isRead_Data insertObject:strID atIndex:isReadCount++] ;
                
            }
        }
//        ///今天新闻条数 数据库start
//       sql= @"select ID from today_count";
//        //查找数据
//        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
//        {
//            int j=0;
//            while (sqlite3_step(stmt)==SQLITE_ROW) {
//                if(sqlite3_column_count(stmt)==0)
//                    break;
//                const unsigned char *_id= sqlite3_column_text(stmt, 0);
//                if(_id==NULL)break;//字符串为空
//                strID= [NSString stringWithUTF8String: _id];
//                 [[todayCount sharedInstance].todayCount_Data insertObject:strID atIndex:j];
//                j++;
//            }
//        }
//
//        
//        ///今天新闻条数 end
        sqlite3_finalize(stmt);
        sqlite3_close(database);
//打开判断可读数据库end
        
//打开 判断收藏数据库start
        
        NSArray *array1=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths1=[array1 objectAtIndex:0];
        NSString *databasePaths1=[documentsPaths1 stringByAppendingPathComponent:[NSString stringWithFormat:@"detailRead"]];
        
        sqlite3 *database1;
        
        if (sqlite3_open([databasePaths1 UTF8String], &database1)==SQLITE_OK)
        {
            NSLog(@"后台打开收藏数据库");
        }
        else {
            NSLog(@"open failed");
        }
        
        sqlite3_stmt *stmt1;
        // 查找数据
        NSString* Sql =[NSString stringWithFormat: @"select pic from detailIDD"];
        
        //查找数据
        if(sqlite3_prepare_v2(database1, [Sql UTF8String], -1, &stmt1, nil)==SQLITE_OK)
        {
            while (sqlite3_step(stmt1)==SQLITE_ROW) {
                if(sqlite3_column_count(stmt)==0)
                {
                    break;
                }
                const unsigned char *_id=sqlite3_column_text(stmt1, 0);
                if(_id==NULL)break;//字符串为空
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
            
            CGFloat height = size.height;
            if(height==480)height_First=100;
            
            //先生成 再替换
            self.window.rootViewController = self.viewDeckController;
            self.window.backgroundColor=[UIColor whiteColor];
            [self.window makeKeyAndVisible];
            
            UIImageView *splashScreen = [[[UIImageView alloc] initWithFrame:CGRectMake(-40, 0, 360, height)]autorelease];
            splashScreen.image = [UIImage imageNamed:@"moveFirstImage.jpg"];
            [self.window addSubview:splashScreen];
            
            UIImageView *splashScreen2 = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 400-height_First, 320, 80)]autorelease];
            splashScreen2.image = [UIImage imageNamed:@"welcome_title"];
            [self.window addSubview:splashScreen2];
            
             
            
            [UIView animateWithDuration:4.0 animations:^{
                CATransform3D transform = CATransform3DMakeTranslation(30, 0, 0);
                splashScreen.layer.transform = transform;
                splashScreen.alpha = 0.0;
            } completion:^(BOOL finished) {
                [splashScreen removeFromSuperview];
                [splashScreen2 removeFromSuperview];
              
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
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;//保持竖屏
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
