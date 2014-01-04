//
//  StoreUpViewController.h
//  Fish
//
//  Created by DAWEI FAN on 03/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface StoreUpViewController : ViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableView_Store;
    NSMutableArray *arrSave_ID;
}
@end
