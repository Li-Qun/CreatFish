//
//  NewsController.h
//  Fish
//
//  Created by DAWEI FAN on 18/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "ViewController.h"
#import "FishCore.h"
#import "klpView.h"
#import "AppDelegate.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@protocol myDelegate
-(NSString*)PostReturn;

@end
@interface NewsController : ViewController<UITableViewDataSource,UITableViewDelegate,FishDelegate,myDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate,EGORefreshTableDelegate>
{
    int total;
    int targetNumber;//哪一层级的标引
    NSMutableArray *arr;
    NSMutableArray *arrTotal;
    NSMutableArray *arrPic;
    NSMutableArray *arrLabel;
    NSMutableArray *arrID;
    klpView *klpPic;
    id<myDelegate>delegate;
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
    
    BOOL isSeven;
    BOOL isFive;
}
@property(nonatomic,retain)NSMutableArray *arr;
@property(nonatomic,retain)NSMutableArray *arrPic;
@property(nonatomic,retain)NSMutableArray *arrLabel;
@property(nonatomic,retain)NSMutableArray *arrID;
@property(assign,nonatomic)id<myDelegate> delegate;
@property(nonatomic,retain)NSString *NewsId;
@property(nonatomic,retain)NSString *NewsName;
@property(nonatomic,retain)NSString *NewsImage;
@property(nonatomic,retain)NSString *NewsPid;
@property(nonatomic,retain)NSString *NewsLevel;
@property(nonatomic,retain)NSString *NewsFlag;
@property(readwrite,nonatomic)int target;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
