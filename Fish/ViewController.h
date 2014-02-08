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
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKCoreService/ShareSDKCoreService.h>
@interface ViewController : UIViewController<FishDelegate,ISSShareViewDelegate,
UIScrollViewDelegate >
{
   // UIScrollView *scrollView;
	klpView *klp;
	int index;
   // CategoryItem *categoryItem;
    ContentRead *contentRead;
    AppDelegate *app;
    UINavigationBar *NavBar;
    CGFloat height_Momente;
    int height;
 
    BOOL Kind7;
    BOOL height5_flag;
    BOOL isSeven;
    BOOL isFive;
    NSMutableArray *arrName;
    NSMutableArray *arr;
    IBOutlet UILabel *labelDay;
    IBOutlet UILabel *labelText;
    IBOutlet UITextView *textView;
}

@property (retain, nonatomic) IBOutlet UILabel *labelDay;
@property (retain, nonatomic) IBOutlet UIScrollView *klpScrollView1;
@property (retain, nonatomic) IBOutlet UILabel *labelText;
@property (retain, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic,retain)NSMutableArray *klpImgArr;

//@property(nonatomic,retain)CategoryItem *categoryItem;
@property(nonatomic,retain)ContentRead *contentRead;

@end
