//
//  LifeViewController.h
//  Fish
//
//  Created by DAWEI FAN on 23/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "ViewController.h"
#import "iCarousel.h"
#import "AppDelegate.h"
#import "FishCore.h"
@protocol myLifeDelegate
-(void)Life:(BOOL)flag;

@end
@interface LifeViewController : UIViewController <iCarouselDataSource,iCarouselDelegate,UIActionSheetDelegate,myLifeDelegate,FishDelegate>
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
    
    IBOutlet UILabel *labelText;
    int index;
    //图片位置
    int img_height;
    int lab_height;
    int select;
    
    int isNation;
    NSString *BigFishName;
}
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@property (nonatomic,assign) BOOL wrap;
@property (nonatomic, retain)IBOutlet iCarousel *carousel;
@property (retain, nonatomic) IBOutlet UILabel *labelText;
@property(readwrite,nonatomic)int target;
@property(nonatomic,retain) NSString *BigFishName;

@end
