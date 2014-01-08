//
//  MagDetaiViewController.h
//  Fish
//
//  Created by DAWEI FAN on 02/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "ViewController.h"
#import "FishCore.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
@interface MagDetaiViewController : ViewController<FishDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>
{
    UINavigationBar *navBar;
    NSString *Id;
    NSString *weeklyId;
    NSString *name_Mag;
    UITableView *tableView_Mag;
    int total;
    int newCount_Mag;
    NSMutableArray *arr_Mag;
    NSMutableArray *arrID_Mag;
    
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
}
@property(nonatomic,retain) UINavigationBar *navBar;
@property(nonatomic,retain)NSString *Id;
@property(nonatomic,retain)NSString *weeklyId;
@property(nonatomic,retain)NSString *name_Mag;
@property(nonatomic,retain)ContentRead *contentDtail;
@property(nonatomic,retain)UITableView *tableView_Mag;
@property(nonatomic,retain)NSMutableArray *arr_Mag;
@property(nonatomic,retain)NSMutableArray *arrID_Mag;
@end
