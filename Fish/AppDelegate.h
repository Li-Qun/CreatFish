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
@class ViewController;
@class MainViewController;
typedef enum
{
    onlyShowLeftView = 0,
    onlyShowRigtView ,
    ShowLeftViewAndRightView
    
} showType;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    //类别目录 层级
    NSString *CategoryId;
    NSString *CategoryName;
    NSString *CategoryImage;
    NSString *CategoryLevel;
    NSString *CategoryFlag;
    NSString *CategoryPid;
    NSString *filter_category_id;
    NSString *filter_is_sticky;
    NSString * offset;
    NSString *total;
    NSString *content;
    CategoryItem *categoryItem;
    ContentRead *contentRead;
    
    NSMutableArray  *array;
    NSMutableArray  *arrayData;

    NSString *jsonString;
    NSString *jsonStringOne;
 
    //收藏name\image\id 数量、容器
    NSString *saveID;
    NSString *saveName;
    NSString *saveImage;
    NSMutableArray *saveDataId;
    NSMutableArray  *saveDataImage;
    NSMutableArray  *saveDataName;
    //首页幻灯片
    NSMutableArray *firstPageImage;
    int height_First;
}
@property (nonatomic, retain)NSMutableArray  *array;
@property (nonatomic,retain)NSMutableArray *arrayData;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) MainViewController *mainviewController;
@property (nonatomic , strong) IIViewDeckController  *viewDeckController;

@property(nonatomic,retain) NSString *CategoryId;
@property(nonatomic,retain) NSString *CategoryName;
@property(nonatomic,retain) NSString *CategoryImage;
@property(nonatomic,retain) NSString *CategoryLevel;
@property(nonatomic,retain) NSString *CategoryFlag;
@property(nonatomic,retain) NSString *CategoryPid;

@property(nonatomic,retain )NSString *filter_category_id;
@property(nonatomic ,retain)NSString * offset;
@property(nonatomic ,retain)NSString *filter_is_sticky;
@property(nonatomic,retain)NSString *total;
@property(nonatomic,retain)NSString *content;

@property(nonatomic,retain) CategoryItem *categoryItem;
@property(nonatomic,retain)ContentRead *contentRead;

@property(nonatomic,retain)NSString *jsonString;
@property(nonatomic,retain)NSString *jsonStringOne;
@property(nonatomic)int targetCenter;

@property (readwrite,retain)NSString * center;
//收藏杂志start
@property(nonatomic,retain)NSString *saveId;
@property(nonatomic,retain)NSString *saveName;
@property(nonatomic,retain)NSString *saveImage;
@property(nonatomic) NSMutableArray  *saveDataId;
@property(nonatomic) NSMutableArray  *saveDataImage;
@property(nonatomic,retain)NSMutableArray  *saveDataName;
@property(nonatomic)int saveNum;
//收藏杂志end
@property(nonatomic,retain)NSMutableArray *firstPageImage;


@end



