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
 
@implementation AppDelegate
@synthesize viewDeckController;

@synthesize CategoryId=CategoryId;
@synthesize CategoryPid=CategoryPid;
@synthesize CategoryFlag=CategoryFlag;
@synthesize CategoryImage=CategoryImage;
@synthesize CategoryLevel=CategoryLevel;
@synthesize CategoryName=CategoryName;
@synthesize content=content;
@synthesize total=total;
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
    for(int i=0;i<14;i++)
    {
       
       // NSArray *arrayChild=[[NSArray alloc]init];
        NSMutableDictionary * arrayChild = [NSMutableDictionary dictionaryWithCapacity:6];
               int index=i;
        if(i==0)
        {
            [arrayChild  setObject:@"1" forKey:@"id"];
            [arrayChild  setObject:@"资讯" forKey:@"name"];
            [arrayChild  setObject:@"1.png" forKey:@"iamge"];
            [arrayChild  setObject:@"0" forKey:@"pid"];
            [arrayChild  setObject:@"1" forKey:@"level"];
            [arrayChild  setObject:@"0" forKey:@"flag"];
        }
        else if(index==1)
        {
            [arrayChild  setObject:@"2" forKey:@"id"];
            [arrayChild  setObject:@"生活" forKey:@"name"];
            [arrayChild  setObject:@"1.png" forKey:@"iamge"];
            [arrayChild  setObject:@"0" forKey:@"pid"];
            [arrayChild  setObject:@"1" forKey:@"level"];
            [arrayChild  setObject:@"0" forKey:@"flag"];
            
        }
        else if(index==2)
        {
            [arrayChild  setObject:@"3" forKey:@"id"];
            [arrayChild  setObject:@"潮流" forKey:@"name"];
            [arrayChild  setObject:@"1.png" forKey:@"iamge"];
            [arrayChild  setObject:@"0" forKey:@"pid"];
            [arrayChild  setObject:@"1" forKey:@"level"];
            [arrayChild  setObject:@"0" forKey:@"flag"];
            
        }
        else if(index==3)
        {
            [arrayChild  setObject:@"4" forKey:@"id"];
            [arrayChild  setObject:@"周刊" forKey:@"name"];
            [arrayChild  setObject:@"1.png" forKey:@"iamge"];
            [arrayChild  setObject:@"0" forKey:@"pid"];
            [arrayChild  setObject:@"1" forKey:@"level"];
            [arrayChild  setObject:@"0" forKey:@"flag"];
            
        }
        else if(index==4)
        {
            [arrayChild  setObject:@"5" forKey:@"id"];
            [arrayChild  setObject:@"业内动态" forKey:@"name"];
            [arrayChild  setObject:@"1.png" forKey:@"iamge"];
            [arrayChild  setObject:@"1" forKey:@"pid"];
            [arrayChild  setObject:@"2" forKey:@"level"];
            [arrayChild  setObject:@"0" forKey:@"flag"];
            
        }
        else if(index==5)
        {
            [arrayChild  setObject:@"6" forKey:@"id"];
            [arrayChild  setObject:@"赛事报道" forKey:@"name"];
            [arrayChild  setObject:@"1.png" forKey:@"iamge"];
            [arrayChild  setObject:@"1" forKey:@"pid"];
            [arrayChild  setObject:@"2" forKey:@"level"];
            [arrayChild  setObject:@"0" forKey:@"flag"];
        }
        else if(index==6)
        {
            [arrayChild  setObject:@"7" forKey:@"id"];
            [arrayChild  setObject:@"大鱼新闻" forKey:@"name"];
            [arrayChild  setObject:@"1.png" forKey:@"iamge"];
            [arrayChild  setObject:@"1" forKey:@"pid"];
            [arrayChild  setObject:@"2" forKey:@"level"];
            [arrayChild  setObject:@"0" forKey:@"flag"];
        }
        else if(index==7)
        {
            [arrayChild  setObject:@"8" forKey:@"id"];
            [arrayChild  setObject:@"业内动态" forKey:@"name"];
            [arrayChild  setObject:@"1.png" forKey:@"iamge"];
            [arrayChild  setObject:@"2" forKey:@"pid"];
            [arrayChild  setObject:@"2" forKey:@"level"];
            [arrayChild  setObject:@"0" forKey:@"flag"];
        }
        else if(index==8)
        {
            [arrayChild  setObject:@"9" forKey:@"id"];
            [arrayChild  setObject:@"大鱼新闻" forKey:@"name"];
            [arrayChild  setObject:@"1.png" forKey:@"iamge"];
            [arrayChild  setObject:@"2" forKey:@"pid"];
            [arrayChild  setObject:@"2" forKey:@"level"];
            [arrayChild  setObject:@"0" forKey:@"flag"];
        }
        else if(index==9)
        {
            [arrayChild  setObject:@"10" forKey:@"id"];
            [arrayChild  setObject:@"赛事报道" forKey:@"name"];
            [arrayChild  setObject:@"1.png" forKey:@"iamge"];
            [arrayChild  setObject:@"2" forKey:@"pid"];
            [arrayChild  setObject:@"2" forKey:@"level"];
            [arrayChild  setObject:@"0" forKey:@"flag"];
        }
        else if(index==10)
        {
            [arrayChild  setObject:@"11" forKey:@"id"];
            [arrayChild  setObject:@"业内动态" forKey:@"name"];
            [arrayChild  setObject:@"1.png" forKey:@"iamge"];
            [arrayChild  setObject:@"3" forKey:@"pid"];
            [arrayChild  setObject:@"2" forKey:@"level"];
            [arrayChild  setObject:@"0" forKey:@"flag"];
        }
        else if(index==11)
        {
            [arrayChild  setObject:@"12" forKey:@"id"];
            [arrayChild  setObject:@"大鱼新闻" forKey:@"name"];
            [arrayChild  setObject:@"1.png" forKey:@"iamge"];
            [arrayChild  setObject:@"3" forKey:@"pid"];
            [arrayChild  setObject:@"2" forKey:@"level"];
            [arrayChild  setObject:@"0" forKey:@"flag"];
        }
        else if(index==12)
        {
            [arrayChild  setObject:@"13" forKey:@"id"];
            [arrayChild  setObject:@"赛事报道" forKey:@"name"];
            [arrayChild  setObject:@"1.png" forKey:@"iamge"];
            [arrayChild  setObject:@"3" forKey:@"pid"];
            [arrayChild  setObject:@"2" forKey:@"level"];
            [arrayChild  setObject:@"0" forKey:@"flag"];
        }
        else if(index==13)
        {
            [arrayChild  setObject:@"14" forKey:@"id"];
            [arrayChild  setObject:@"业内动态" forKey:@"name"];
            [arrayChild  setObject:@"1.png" forKey:@"iamge"];
            [arrayChild  setObject:@"4" forKey:@"pid"];
            [arrayChild  setObject:@"2" forKey:@"level"];
            [arrayChild  setObject:@"0" forKey:@"flag"];
        }
        else if(index==14)
        {
            [arrayChild  setObject:@"15" forKey:@"id"];
            [arrayChild  setObject:@"大鱼报道" forKey:@"name"];
            [arrayChild  setObject:@"1.png" forKey:@"iamge"];
            [arrayChild  setObject:@"4" forKey:@"pid"];
            [arrayChild  setObject:@"2" forKey:@"level"];
            [arrayChild  setObject:@"0" forKey:@"flag"];
        }
        [array addObject:arrayChild];
       // NSLog(@"输出所有键值＝%@",[arrayChild allKeys]);
    }
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
//先生成 再替换
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

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
    
    
//       [application setStatusBarStyle:UIStatusBarStyleLightContent];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//     
//       // self.window.clipsToBounds =YES;
//        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
//        
//        //Added on 19th Sep 2013
//        self.window.bounds = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height);
//    }
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
