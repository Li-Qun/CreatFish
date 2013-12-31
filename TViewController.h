//
//  TViewController.h
//  Fish
//
//  Created by DAWEI FAN on 17/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

#import "FishCore.h"
#import "AppDelegate.h"
@interface TViewController : UIViewController<NIDropDownDelegate,UITableViewDelegate, UITableViewDataSource>
{
   CategoryItem *categoryItem;
   AppDelegate *app ;
   NIDropDown *dropDown;
    int selectNum;
}

@property (strong,nonatomic) ContentRead *contentRead;
@property (strong,nonatomic)  CategoryItem *categoryItem;


- (void)pressme:(id)sender;
- (void)cameraAction:(id)sender;
- (void)broomAction:(id)sender;
- (void)textAction:(id)sender;
@end
