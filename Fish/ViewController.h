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
	NSArray *klpArr;
	klpView *klp;
	int index;
     NSArray *momentData;
    
    CategoryItem *categoryItem;
    ContentRead *contentRead;
    AppDelegate *app;
}

@property (retain, nonatomic) IBOutlet UIScrollView *klpScrollView1;
@property (retain, nonatomic) IBOutlet UIScrollView *klpScrollView2;
@property (nonatomic,retain)NSMutableArray *klpImgArr;

@property(nonatomic,retain)NSArray *momentData;
@property(nonatomic,retain)CategoryItem *categoryItem;
@property(nonatomic,retain)ContentRead *contentRead;

@end
