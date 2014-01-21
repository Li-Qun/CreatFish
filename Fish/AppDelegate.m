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
#import "WeiboApi.h"
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
 
#import <TencentOpenAPI/TencentOAuth.h>
@implementation AppDelegate
@synthesize viewDeckController;

//@synthesize CategoryId=CategoryId;
//@synthesize CategoryPid=CategoryPid;
//@synthesize CategoryFlag=CategoryFlag;
//@synthesize CategoryImage=CategoryImage;
//@synthesize CategoryLevel=CategoryLevel;
//@synthesize CategoryName=CategoryName;
//@synthesize content=content;
//@synthesize total=total;
@synthesize filter_is_sticky=filter_is_sticky;
@synthesize filter_category_id=filter_category_id;
@synthesize offset=offset;
@synthesize categoryItem=categoryItem;
@synthesize array=array;
@synthesize arrayData=arrayData;
@synthesize contentRead=contentRead;
@synthesize jsonString=jsonString;
@synthesize jsonStringOne=jsonStringOne;
@synthesize targetCenter=targetCenter;
@synthesize center=centre;
@synthesize saveId=saveID;
@synthesize saveImage=saveImage;
@synthesize saveName=saveName;
@synthesize saveDataId=saveDataId;
@synthesize saveDataImage=saveDataImage;
@synthesize saveDataName=saveDataName;
@synthesize saveNum=saveNum;
@synthesize firstPageImage=firstPageImage;
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
}
-(void)Pre:(int)index
{
   
}
- (void)dealloc
{
    [_window release];
    [_viewController release];
    [array release];
    [super dealloc];
}
-(void)setShare
{
    [ShareSDK registerApp:@"1151625a6c74"];
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"3334408824"
                               appSecret:@"dd5a1fd45ed30443a8d6a805771e15dd"
                             redirectUri:@"http://www.huiztech.com"];   //回调URL
    
    //添加腾讯微博应用
      [ShareSDK connectTencentWeiboWithAppKey:@"801470547"
                                  appSecret:@"a381d8a35096c2212c68bb4e51936eb6"
                                redirectUri:@"http://www.huiztech.com"
                            wbApiCls:[WeiboApi class]];
    //添加QQ
//[ShareSDK connectQZoneWithAppKey:@"101007721"
//                           appSecret:@"50d186e81867f8f88fac3cd9269352bc"
//                   qqApiInterfaceCls:nil//[QQApiInterface class]
//                     tencentOAuthCls:nil];//[TencentOAuth class]];

    //添加微信应用
    [ShareSDK importWeChatClass:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:@"wx3a4f2774b2a663a9" wechatCls:[WXApi class]]; //此参数为申请的微信AppID
//    NSString *appId = @"wx3a4f2774b2a663a9";
//    [ShareSDK connectWeChatSessionWithAppId: appId wechatCls:[WXApi class]];
//    [ShareSDK connectWeChatTimelineWithAppId:appId wechatCls:[WXApi class]];
    
}

//先生成 再替换
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
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
