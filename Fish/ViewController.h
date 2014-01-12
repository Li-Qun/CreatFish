//
//  ViewController.h
//  Fish
//
//  Created by liqun on 12/3/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "klpView.h"
#import "AppDelegate.h"
@interface ViewController : UIViewController<FishDelegate,
UIScrollViewDelegate >
{
	klpView *klp;
	int index;
    CategoryItem *categoryItem;
    ContentRead *contentRead;
    AppDelegate *app;
    UINavigationBar *NavBar;
    CGFloat height_Momente;
    int height;
 
    BOOL Kind7;
    BOOL height5_flag;
}

@property (retain, nonatomic) IBOutlet UIScrollView *klpScrollView1;
@property (retain, nonatomic) IBOutlet UIScrollView *klpScrollView2;
@property (nonatomic,retain)NSMutableArray *klpImgArr;

@property(nonatomic,retain)CategoryItem *categoryItem;
@property(nonatomic,retain)ContentRead *contentRead;

@end
