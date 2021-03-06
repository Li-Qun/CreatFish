//
//  SettingViewController.m
//  Fish
//
//  Created by DAWEI FAN on 04/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "SettingViewController.h"
#import "AdviceViewController.h"
#import "ViewController.h"
#import "Singleton.h"
#import "IsRead.h"

#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import  "WeiboSDK.h"
#import <Parse/Parse.h>
#import "sqlite3.h"
//#import "BaiduMobStat.h"
@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize ScrollView=ScrollView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationController setToolbarHidden:YES];
        
        
        
    }
    return self;
}
//百度页面统计
-(void)viewDidAppear:(BOOL)animated
{
//    NSString *cName=@"Setting&设置";
//    [[BaiduMobStat defaultStat]pageviewStartWithName:cName ];
}
-(void)viewDidDisappear:(BOOL)animated
{
//    NSString *cName=@"Setting&设置";
//    [[BaiduMobStat defaultStat]pageviewEndWithName:cName ];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftBackBoard@2X.png"]];
    imgView.frame = self.view.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:imgView atIndex:0];
    [imgView release];
}
-(void)Press_set:(id)sender
{
    AdviceViewController *newVC = [[[AdviceViewController alloc] initWithNibName:@"AdviceViewController" bundle:nil]autorelease];
    //newVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController :newVC animated:YES];

}
-(void)Press_allRead:(id)sender
{
    NSString *str;
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(app.isRead==NO)
    {
        str=@"已全部标记为已读";
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];

        app.isRead=YES;
    }
    else
    {
        str=@"已恢复不标记已读";
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];

        app.isRead=NO;

    }
}
-(void)cleaAllCathce:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//资讯缓存上
 
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *str=[NSString stringWithFormat:@"NewsTop_dataBases"];
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
        
        const char *deleteAllSql="delete from isReadList where 1>0";
        //执行删除语句
        if(sqlite3_exec(database, deleteAllSql, NULL, NULL, &errorMsg)==SQLITE_OK){
            NSLog(@"删除所有数据成功");
        }
        else NSLog(@"delect failde!!!!");
        deleteAllSql="delete from picture where 1>0";
        //执行删除语句
        if(sqlite3_exec(database, deleteAllSql, NULL, NULL, &errorMsg)==SQLITE_OK){
            NSLog(@"删除所有数据成功");
        }
        else NSLog(@"delect failde!!!!");
        sqlite3_close(database);//
 //资讯缓存下
        NSArray *array_listNew=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths_listNiew=[array_listNew objectAtIndex:0];
        NSString *str_listNew=[NSString stringWithFormat:@"NewsViewController"];
        NSString *databasePaths_NewList=[documentsPaths_listNiew stringByAppendingPathComponent:str_listNew];
        sqlite3 *database_ListNew;
        
        if (sqlite3_open([databasePaths_NewList UTF8String], &database_ListNew)==SQLITE_OK)
        {
            NSLog(@"open success");
        }
        else {
            NSLog(@"open failed");
        }
        char *errorMsg_listNew;
        const char *deleteListNewAllSql="delete from news_list where 1>0";
        //执行删除语句
        if(sqlite3_exec(database_ListNew, deleteListNewAllSql, NULL, NULL, &errorMsg_listNew)==SQLITE_OK){
            NSLog(@"删除所有数据成功");
        }
        else NSLog(@"delect failde!!!!");
        sqlite3_close(database_ListNew);//
//阅读页面  webView_ID/收藏
        NSArray *array_detailRead=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths_detailRead=[array_detailRead objectAtIndex:0];
        NSString *str_detailRead=[NSString stringWithFormat:@"detailRead"];
        NSString *databasePaths__detailRead=[documentsPaths_detailRead stringByAppendingPathComponent:str_detailRead];
        sqlite3 *database_detailRead;
        
        if (sqlite3_open([databasePaths__detailRead UTF8String], &database_detailRead)==SQLITE_OK)
        {
            NSLog(@"open success");
        }
        else {
            NSLog(@"open failed");
        }
        char *errorMsg_detailRead;
        const char *deleteAllSql_detailRead="delete from detailWebView_ID where 1>0";
        //执行删除语句
        if(sqlite3_exec(database_detailRead, deleteAllSql_detailRead, NULL, NULL, &errorMsg_detailRead)==SQLITE_OK){
            NSLog(@"删除所有数据成功");
        }
        else NSLog(@"delect failde!!!!");
///删除 收藏
        AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        app.saveNum=0;
        if([Singleton sharedInstance].single_Data.count!=0)
        [[Singleton sharedInstance].single_Data removeAllObjects];//清空数组
        const char *deleteAllSql_detailRead1="delete from detailIDD where 1>0";
        //执行删除语句
        if(sqlite3_exec(database_detailRead, deleteAllSql_detailRead1, NULL, NULL, &errorMsg_detailRead)==SQLITE_OK){
            NSLog(@"删除所有数据成功");
        }
        else NSLog(@"delect failde!!!!%s",errorMsg_detailRead);
        
        sqlite3_close(database_detailRead);//
////专题
        NSArray *array_Topic=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths_Topic=[array_Topic objectAtIndex:0];
        NSString *str_Topic=[NSString stringWithFormat:@"TopicViewC"];
        NSString *databasePaths_Topic=[documentsPaths_Topic stringByAppendingPathComponent:str_Topic];
        sqlite3 *database_Topic;
        
        if (sqlite3_open([databasePaths_Topic UTF8String], &database_Topic)==SQLITE_OK)
        {
            NSLog(@"open success");
        }
        else {
            NSLog(@"open failed");
        }
        char *errorMsg_Topic;
        const char *deleteAllSql_Topic="delete from picture where 1>0";
        //执行删除语句
        if(sqlite3_exec(database_Topic, deleteAllSql_Topic, NULL, NULL, &errorMsg_Topic)==SQLITE_OK){
            NSLog(@"删除所有数据成功");
        }
        else NSLog(@"delect failde!!!!");
        sqlite3_close(database_Topic);// 

        
        
///大鱼榜详细
        NSArray *array_FishItem=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths_FishItem=[array_FishItem objectAtIndex:0];
        NSString *str_FishItem=[NSString stringWithFormat:@"FishItem_Database"];
        NSString *databasePaths_FishItem=[documentsPaths_FishItem stringByAppendingPathComponent:str_FishItem];

        sqlite3 *database_FishItem;
        
        if (sqlite3_open([databasePaths_FishItem UTF8String], &database_FishItem)==SQLITE_OK)
        {
            NSLog(@"open success");
        }
        else {
            NSLog(@"open failed");
        }
        char *errorMsg_FishItem;
        const char *deleteAllSql_FishItem="delete from picture where 1>0";
        //执行删除语句
        if(sqlite3_exec(database_FishItem, deleteAllSql_FishItem, NULL, NULL, &errorMsg_FishItem)==SQLITE_OK){
            NSLog(@"删除所有数据成功");
        }
        else NSLog(@"delect failde!!!!");
        sqlite3_close(database_FishItem);//
//////大鱼榜
        NSArray *array_LifeItem=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths_LifeItem=[array_LifeItem objectAtIndex:0];
        NSString *databasePaths_LifeItem=[documentsPaths_LifeItem stringByAppendingPathComponent:@"BigFishViewController_DataBase"];
        sqlite3 *database_LifeItem;
        
        if (sqlite3_open([databasePaths_LifeItem UTF8String], &database_LifeItem)==SQLITE_OK)
        {
            NSLog(@"open success");
        }
        else {
            NSLog(@"open failed");
        }
        char *errorMsg_LifeItem;
 
        const char *deleteAllSql_LifeItem="delete from picture where 1>0";
        //执行删除语句
        if(sqlite3_exec(database_LifeItem, deleteAllSql_LifeItem, NULL, NULL, &errorMsg_LifeItem)==SQLITE_OK){
            NSLog(@"删除所有数据成功");
        }
        else NSLog(@"delect failde!!!!%s",errorMsg_LifeItem);
        sqlite3_close(database_LifeItem);//*/
///删除是否已读News_dataBases
        [[IsRead sharedInstance].single_isRead_Data removeAllObjects];
        app.isReadCount=0;
        NSArray *array_isRead=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths_isRead=[array_isRead objectAtIndex:0];
        NSString *str_isRead=[NSString stringWithFormat:@"NewsViewController"];
        NSString *databasePaths_isRead=[documentsPaths_isRead stringByAppendingPathComponent:str_isRead];
        sqlite3 *database_isRead;
        
        if (sqlite3_open([databasePaths_isRead UTF8String], &database_isRead)==SQLITE_OK)
        {
            NSLog(@"open success");
        }
        else {
            NSLog(@"open failed");
        }
        char *errorMsg_isRead;
        
        const char *deleteAllSql_isRead="delete from isReadList where 1>0";
        //执行删除语句
        if(sqlite3_exec(database_isRead, deleteAllSql_isRead, NULL, NULL, &errorMsg_isRead)==SQLITE_OK){
            NSLog(@"删除所有数据成功");
        }
        else NSLog(@"delect failde!!!!");
//        deleteAllSql_detailRead="delete from picture where 1>0";
//        //执行删除语句
//        
//        if(sqlite3_exec(database_isRead, deleteAllSql_isRead, NULL, NULL, &errorMsg_isRead)==SQLITE_OK){
//            NSLog(@"删除所有数据成功");
//        }
//        else NSLog(@"delect failde!!!!");
        sqlite3_close(database_isRead);//
        
///清除所有网络图片缓存start
        //1.
        /*
        NSFileManager *filemgr;
        
        filemgr = [NSFileManager defaultManager];
        
        if ([filemgr removeItemAtPath: [NSHomeDirectory() stringByAppendingString:@"/Library/Caches"] error: NULL]  == YES)
            NSLog (@"Remove successful");
        else
            NSLog (@"Remove failed");
        
        [filemgr createDirectoryAtPath: [NSHomeDirectory() stringByAppendingString:@"/Library/Caches"] withIntermediateDirectories:NO attributes:nil error:nil];
         */
        //2.
        [[SDImageCache sharedImageCache] clearDisk];//清除内存缓存区的图片
        [[SDImageCache sharedImageCache] clearMemory];//清除物理存储上的图片
        [[SDImageCache sharedImageCache] cleanDisk];//清除过期缓存的图片
        
///清除所有网络图片缓存end
        
        
 
        dispatch_async(dispatch_get_main_queue(), ^{//主线程
            
            
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"清除缓存操作已成功"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil]autorelease];
            [alert show];
            
            
            
        });
    });
}
-(void)shareToFriend:(id)sender
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    //构造分享内容
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:self
                                               authManagerViewDelegate:self];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:self
                                                          friendsViewDelegate:self
                                                        picViewerViewDelegate:nil];

     NSString *string=[NSString stringWithFormat:@"%@设置%@",shareContent1,shareContent2];
    id<ISSContent> publishContent = [ShareSDK content:string
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"@我的好友"
                                                  url:@"http://www.huiztech.com"
                                          description:@"我很喜欢这篇钓鱼文章！"
                                            mediaType:SSPublishContentMediaTypeNews];
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions: shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"@好友‘成功" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
                                    [alert show];
                                    [alert release];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    [error errorCode];//错误码
                                    NSString *str=[NSString stringWithFormat:@"发送失败，错误原因：%@",[error errorDescription]];
                                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message: str  delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
                                    [alert show];
                                    [alert release];
                                }
                            }];

}
-(void)pressBtn1
{
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result)
                               {
                                   PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
                                   [query whereKey:@"uid" equalTo:[userInfo uid]];
                                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                       
                                       if ([objects count] == 0)
                                       {
                                           PFObject *newUser = [PFObject objectWithClassName:@"UserInfo"];
                                           [newUser setObject:[userInfo uid] forKey:@"uid"];
                                           [newUser setObject:[userInfo nickname] forKey:@"name"];
                                           [newUser setObject:[userInfo icon] forKey:@"icon"];
                                           [newUser saveInBackground];
                                           
                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"欢迎注册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                                           [alertView show];
                                           [alertView release];
                                       }
                                       else
                                       {
                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"欢迎回来" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                                           [alertView show];
                                           [alertView release];
                                       }
                                   }];
                                   
                                }
                               
                           }];
     
}
-(void)pressBtn2
{   
    [ShareSDK getUserInfoWithType:ShareTypeTencentWeibo
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result)
                               {
                                   PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
                                   [query whereKey:@"uid" equalTo:[userInfo uid]];
                                   [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                       
                                       if ([objects count] == 0)
                                       {
                                           PFObject *newUser = [PFObject objectWithClassName:@"UserInfo"];
                                           [newUser setObject:[userInfo uid] forKey:@"uid"];
                                           [newUser setObject:[userInfo nickname] forKey:@"name"];
                                           [newUser setObject:[userInfo icon] forKey:@"icon"];
                                           [newUser saveInBackground];
                                           
                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"欢迎注册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                                           [alertView show];
                                           [alertView release];
                                       }
                                       else
                                       {
                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"欢迎回来" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                                           [alertView show];
                                           [alertView release];
                                       }
                                   }];
                                   
                               }
                               
                           }];
    
}
-(void)Back
{
        [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
 
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor=[UIColor whiteColor];
    ScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320,568)];
    ScrollView.backgroundColor=[UIColor clearColor];
    ScrollView.delegate=self;
    myView=[[[UIView alloc]init]autorelease];
    myView.backgroundColor=[UIColor clearColor];

    
    UIImageView *topBarView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 55)]autorelease];
    //topBarView.image=[UIImage imageNamed:@"set_Nav@2x.png"];LeftTitle@2X
    topBarView.image=[UIImage imageNamed:@"LeftTitle@2X"];
    [myView addSubview:topBarView];
    
    UILabel *customLab = [[[UILabel alloc] initWithFrame:CGRectMake(120, 15, 100, 30)]autorelease];
    customLab.backgroundColor=[UIColor clearColor];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"环球垂钓"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [topBarView addSubview:customLab];
    
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *backView=[[[UIImageView alloc]initWithFrame:CGRectMake(10,15, 25, 27)]autorelease];
    backView.image=[UIImage imageNamed:@"theGoBack@2X"];
    leftBtn.frame=CGRectMake(14,17,22, 25);
    leftBtn.tag=10;
    [leftBtn setImage:backView.image forState:UIControlStateNormal];
    [myView addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
 
    //分割线
    UIImageView *imgLineOne=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 55, 320, 2)]autorelease];
    imgLineOne.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView  addSubview:imgLineOne];
    
    //通用设置
    UIImageView *imageView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 57, 320, 34)]autorelease];//0 61 320 34
  //  imageView.image=[UIImage imageNamed:@"labelNormal_Set"];
    imageView.image=[UIImage imageNamed:@"selectOne@2X"];
    [myView addSubview:imageView];
    
    UILabel *labelNormal_Set=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 34)]autorelease];
    labelNormal_Set.backgroundColor=[UIColor clearColor];
    labelNormal_Set.text=@"  通用设置";
    labelNormal_Set.textColor=[UIColor whiteColor];
    [imageView addSubview:labelNormal_Set];
 
 
    //全部标记为已读
    readed=[UIButton buttonWithType:UIButtonTypeCustom];
    [readed setImage:[UIImage imageNamed:@"selectTwo@2X.png"] forState:UIControlStateHighlighted];
    readed.backgroundColor=[UIColor clearColor];
    readed.frame=CGRectMake(0, 91, 320, 50);
    [myView addSubview:readed];
    UILabel *allRead=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)]autorelease];
    allRead.backgroundColor=[UIColor clearColor];
    allRead.text=@"    全部标记为已读";
    allRead.textColor=[UIColor whiteColor];
    [readed addSubview:allRead];
    UIImageView *readImageView=[[UIImageView alloc]initWithFrame:CGRectMake(280, 15, 20, 20)];
    readImageView.image=[UIImage imageNamed:@"mentionArrow.png"];
    [readed addSubview:readImageView];
    [readed addTarget:self action:@selector(Press_allRead:) forControlEvents:UIControlEventTouchDown];
   
    //分割线
    UIImageView *imgLineTwo=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 141, 320, 2)]autorelease];
    imgLineTwo.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineTwo];
 
    //清除所有缓存
    clear=[UIButton buttonWithType:UIButtonTypeCustom];
    clear.tag=10;
    [clear  setImage:[UIImage imageNamed:@"selectTwo@2X.png"] forState:UIControlStateHighlighted];
    clear.backgroundColor=[UIColor clearColor];
    clear.frame=CGRectMake(0, 143, 320, 50);
    UILabel *clearAll=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)]autorelease];
    clearAll.textColor=[UIColor whiteColor];
    clearAll.backgroundColor=[UIColor clearColor];
    clearAll.text=@"    清除所有缓存";
    [clear addSubview:clearAll];
    [clear addTarget:self action:@selector(cleaAllCathce:) forControlEvents:UIControlEventTouchDown];
    UIImageView *clearImageView=[[UIImageView alloc]initWithFrame:CGRectMake(280, 15, 20, 20)];
    clearImageView.image=[UIImage imageNamed:@"mentionArrow.png"];
    [clear addSubview:clearImageView];
    [myView addSubview:clear];
    //分割线
    UIImageView *imgLineThree=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 193, 320, 2)]autorelease];
    imgLineThree.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineThree];
  
    //关于
    UIImageView *about=[[[UIImageView alloc]initWithFrame:CGRectMake(0,195, 320, 34)]autorelease];
   // about.image=[UIImage imageNamed:@"labelNormal_Set"];//selectOne@2X
    about.image=[UIImage imageNamed:@"selectOne@2X"];
    [myView addSubview:about];
    UILabel *aboutLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 34)]autorelease];
    aboutLabel.backgroundColor=[UIColor clearColor];
    aboutLabel.text=@"  关于";
    aboutLabel.textColor=[UIColor whiteColor];
    [about  addSubview:aboutLabel];
    //意见反馈
    advice=[UIButton buttonWithType:UIButtonTypeCustom];
    advice.tag=11;
    [advice setImage:[UIImage imageNamed:@"selectTwo@2X.png"] forState:UIControlStateSelected];
    advice.backgroundColor=[UIColor clearColor];
    advice.frame=CGRectMake(0, 230, 320, 50);
    UILabel *adviceLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)]autorelease];
    adviceLabel.textColor=[UIColor whiteColor];
    adviceLabel.backgroundColor=[UIColor clearColor];
    adviceLabel.text=@"    意见反馈";
    [advice addTarget:self action:@selector(Press_set:) forControlEvents:UIControlEventTouchDown];
    [advice addSubview:adviceLabel];
    UIImageView *adviceImageView=[[UIImageView alloc]initWithFrame:CGRectMake(280, 15, 20, 20)];
    adviceImageView.image=[UIImage imageNamed:@"mentionArrow.png"];
    [advice addSubview:adviceImageView];
    [myView addSubview:advice];
    //分割线
    UIImageView *imgLineFour=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 280, 320, 2)]autorelease];
    imgLineFour.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineFour];
    //向朋友推荐本应用
    share=[UIButton buttonWithType:UIButtonTypeCustom];
    share.tag=12;
    [share setImage:[UIImage imageNamed:@"selectTwo@2X.png"] forState:UIControlStateHighlighted];
    share.backgroundColor=[UIColor clearColor];
    share.frame=CGRectMake(0, 282, 320, 50);
    [share addTarget:self action:@selector(shareToFriend:) forControlEvents:UIControlEventTouchDown];
    UILabel *shareLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)]autorelease];
    shareLabel.backgroundColor=[UIColor clearColor];
    shareLabel.text=@"    向朋友推荐本应用";
    shareLabel.textColor=[UIColor whiteColor];
    [share addSubview:shareLabel];
    UIImageView *shareImageView=[[UIImageView alloc]initWithFrame:CGRectMake(280, 15, 20, 20)];
    shareImageView.image=[UIImage imageNamed:@"mentionArrow.png"];
    [share addSubview:shareImageView];
    [myView addSubview:share];
    //分割线
    UIImageView *imgLineFive=[[[UIImageView alloc]initWithFrame:CGRectMake(0,332, 320, 2)]autorelease];
    imgLineFive.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineFive];
    
    //程序版本
    UILabel *Kind=[[[UILabel alloc]initWithFrame:CGRectMake(0, 334, 320, 50)]autorelease];
    Kind.textColor=[UIColor whiteColor];
    Kind.backgroundColor=[UIColor clearColor];
    Kind.text=@"    程序版本    1.0";
    [myView addSubview:Kind];
    //分割线
    UIImageView *imgLineSix=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 384, 320, 2)]autorelease];
    imgLineSix.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineSix];
    //特别推荐
    UIImageView *honored=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 386, 320, 34)]autorelease];
    //honored.image=[UIImage imageNamed:@"labelNormal_Set"];
    honored.image=[UIImage imageNamed:@"selectOne@2X"];
    [myView addSubview:honored];
    UILabel *honoredLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 34)]autorelease];
    honoredLabel.backgroundColor=[UIColor clearColor];
    honoredLabel.text=@"  特别推荐";
    honoredLabel.textColor=[UIColor whiteColor];
    [honored  addSubview:honoredLabel];
    // 几个应用
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor=[UIColor clearColor];
    btn1.frame=CGRectMake(10, 425, 42, 42);
    [btn1 setImage:[UIImage imageNamed:@"xinlang@2X.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pressBtn1) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:btn1];

    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor=[UIColor clearColor];
    btn2.frame=CGRectMake(62, 425, 42, 42);
    [btn2 setImage:[UIImage imageNamed:@"weixin.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(pressBtn2) forControlEvents:UIControlEventTouchUpInside];
   // [myView addSubview: btn2];
    
    //分割线
    UIImageView *imgLineSeven=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 470, 320, 2)]autorelease];
    imgLineSeven.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineSeven];
 
    //分割线
    UIImageView *imgLineEight=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 520, 320, 2)]autorelease];
    imgLineEight.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineEight];
   
    myView.frame=CGRectMake(0, 0, 320,1000);
    myView.backgroundColor=[UIColor clearColor];
    ScrollView.contentSize = myView.frame.size;
    [ScrollView addSubview:myView];
    [self.view addSubview:ScrollView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];// Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [ScrollView release];
    [super dealloc];
}
@end
