//
//  NewViewController.h
//  Fish
//
//  Created by DAWEI FAN on 04/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "klpView.h"
#import "FishCore.h"
#import "AppDelegate.h"
@interface NewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *klpArr;
	klpView *klp;
	int index;
    ContentRead *contentRead;
    AppDelegate *app;
}
@property (nonatomic, retain) NSMutableArray* arrayForPlaces;
@property (retain, nonatomic) IBOutlet UIScrollView *klpScrollView1;


@property (nonatomic,retain)NSMutableArray *klpImgArr;
@end