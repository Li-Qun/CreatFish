//
//  ProtectViewController.h
//  Fish
//
//  Created by DAWEI FAN on 12/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GMGridView.h"
#import "OptionsViewController.h"
#import "AppDelegate.h"

@interface ProtectViewController: UIViewController <GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate,UIActionSheetDelegate>
{
    GMGridView *_gmGridView;
    UINavigationController *_optionsNav;
    UIPopoverController *_optionsPopOver;
    
    NSMutableArray *_data;
    NSMutableArray *_data2;
    NSMutableArray *_currentData;
    NSInteger _lastDeleteItemIndexAsked;
    UILabel *label;
    int targetNum;
    AppDelegate *app;
}

- (void)addMoreItem;
- (void)removeItem;
- (void)refreshItem;
//- (void)presentInfo;
- (void)presentOptions:(UIBarButtonItem *)barButton;
- (void)optionsDoneAction;
- (void)dataSetChange:(UISegmentedControl *)control;

@end

