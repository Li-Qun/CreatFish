//
//  AppDelegate.h
//  Fish
//
//  Created by liqun on 12/3/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IIViewDeckController.h"
#import "FishCore.h"
#import "WeiboSDK.h"
@class ViewController;
@class MainViewController;

typedef enum
{
    onlyShowLeftView = 0,
    onlyShowRigtView ,
    ShowLeftViewAndRightView
    
} showType;

@interface AppDelegate : UIResponder <UIApplicationDelegate,FishDelegate,WeiboSDKDelegate >
{
    ContentRead *contentRead;
    
    NSMutableArray  *array;
    NSMutableArray  *arrayData;

    NSString *jsonString;
    NSString *jsonStringOne;
 
    //收藏name\image\id 数量、容器
    NSString *fatherID;
    NSString *momentID;
    NSString *saveID;
    NSString *saveName;
    NSString *saveImage;
    NSMutableArray *saveDataId;
    NSMutableArray  *saveDataImage;
    NSMutableArray  *saveDataName;
    //首页幻灯片
    NSMutableArray *firstPageImage;
    int height_First;
    
    NSString *pre_Page;
    NSString *next_Page;
    //设置
    BOOL isRead;//全部标记为已读；
    NSMutableArray *isRead_arr;
    //游钓
    NSMutableArray *BigFish_Description;
 
    
}
@property (nonatomic, retain)NSMutableArray  *array;
@property (nonatomic,retain)NSMutableArray *arrayData;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) MainViewController *mainviewController;
@property (nonatomic , strong) IIViewDeckController  *viewDeckController;

@property(nonatomic,retain )NSString *filter_category_id;
@property(nonatomic ,retain)NSString * offset;
@property(nonatomic ,retain)NSString *filter_is_sticky;


@property(nonatomic,retain)ContentRead *contentRead;

@property(nonatomic,retain)NSString *jsonString;
@property(nonatomic,retain)NSString *jsonStringOne;
@property(nonatomic)int targetCenter;

@property (nonatomic)int  center;
//收藏杂志start
@property(nonatomic,retain)NSString *fatherID;
@property(nonatomic,retain)NSString *saveId;
@property(nonatomic,retain)NSString *momentID;
@property(nonatomic,retain)NSString *saveName;
@property(nonatomic,retain)NSString *saveImage;
@property(nonatomic,retain) NSMutableArray  *saveDataId;
@property(nonatomic,retain) NSMutableArray  *saveDataImage;
@property(nonatomic,retain)NSMutableArray  *saveDataName;
@property(nonatomic)int saveNum;
//收藏杂志end
@property(nonatomic,retain)NSMutableArray *firstPageImage;
//翻页
@property (nonatomic,retain)NSString *next_Page;
@property (nonatomic,retain)NSString *pre_Page;
//阅读查看图片
@property (nonatomic,retain)NSString *pic_URL;
//阅读详细 的最上边bar
@property (nonatomic,retain)UIImageView *topBarView;
@property (nonatomic)BOOL isRead;//全部标记为已读；
@property (nonatomic,retain)NSMutableArray *isRead_arr;
@property(nonatomic)int isReadCount;
//分享好友
//游钓
@property (nonatomic,retain)NSMutableArray *BigFish_Description;

@end



