//
//  BigFishViewController.h
//  Fish
//
//  Created by DAWEI FAN on 20/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FishCore.h"
#import "AppDelegate.h"
#import "iCarousel.h"
@interface BigFishViewController : UIViewController<UIScrollViewDelegate,FishDelegate,iCarouselDataSource,iCarouselDelegate>
{
    AppDelegate *app;
    BOOL isSeven;
    BOOL isFive;
    float heightTopbar;
    float littleHeinght;
    
    BOOL isOpenL;
    BOOL isOpenR;
    
    int total;
    NSMutableArray *BigFish_Description;
    UIView *view1;
    IBOutlet UILabel *labelText;
    int index;
    //图片位置
    int img_height;
    int lab_height;
    int select;
    ///标题
    NSString *BigFishName;
}
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@property (nonatomic,assign) BOOL wrap;
@property (nonatomic, retain)IBOutlet iCarousel *carousel;
@property (retain, nonatomic) IBOutlet UILabel *labelText;
@property(nonatomic)int target;
@property(nonatomic,retain) NSString *BigFishName;
@end
