//
//  BookViewController.h
//  Fish
//
//  Created by DAWEI FAN on 10/02/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//
 

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "FishCore.h"
#import "klpView.h"
#import "AppDelegate.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"


@interface BookViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FishDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate,EGORefreshTableDelegate>
{
    int total;
    int targetNumber;//哪一层级的标引
    NSMutableArray *arr;
    NSMutableArray *arrTotal;
    NSMutableArray *arrPic;
    NSMutableArray *arrLabel;
    NSMutableArray *arrID;
    klpView *klpPic;
    //单元属性
    NSString *NewsId;
    NSString *NewsName;
    NSString *NewsImage;
    NSString *NewsPid;
    NSString *NewsLevel;
    NSString *NewsFlag;
    BOOL isFistLevel;
    UITableView *tabView;
    //瀑布流
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
    BOOL isFirstLoad;
    //
    int newSumCount;
    int NewsID;
    
    BOOL isSeven;
    BOOL isFive;
    
    BOOL isOpenL;
    BOOL isOpenR;
    
    int height_Momente;
    AppDelegate *app;
    NSString *str;//请求参数ID
    
    ///////滚动置顶
    UIScrollView *scrollView_Book ;
    int page;
    NSMutableArray *arrTopId;

    
}
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@property(nonatomic,retain)NSMutableArray *arr;
@property(nonatomic,retain)NSMutableArray *arrPic;
@property(nonatomic,retain)NSMutableArray *arrLabel;
@property(nonatomic,retain)NSMutableArray *arrID;
@property(nonatomic,retain)NSString *NewsId;
@property(nonatomic,retain)NSString *NewsName;
@property(nonatomic,retain)NSString *NewsImage;
@property(nonatomic,retain)NSString *NewsPid;
@property(nonatomic,retain)NSString *NewsLevel;
@property(nonatomic,retain)NSString *NewsFlag;
@property(readwrite,nonatomic)int target;
@property(readwrite,nonatomic)int targetCentre;
 
-(void)theFirstCell_Transport:(NSString *)ID_Num;
@end