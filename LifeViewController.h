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
    id<myLifeDelegate>delegate;
    UIButton *left;
    UIButton *right;
    UIView *view1;
    UIView *view2;
    AppDelegate * app;
    //单元属性
    NSString *MagId;
    NSString *MagName;
    NSString *MagImage;
    NSString *MagPid;
    NSString *MagLevel;
    NSString *MagFlag;
    
    ContentRead *contentRead;
    int total;//杂志树目；
    NSMutableArray *arry_Mag_category_id;
    NSMutableArray *arry_Mag_description;
    NSMutableArray *arry_Mag_image;
 
    BOOL isSeven;
    BOOL isFive;
    float heightTopbar;
    float littleHeinght;
}
@property (nonatomic, retain)IBOutlet iCarousel *carousel;
@property (nonatomic,assign) BOOL wrap;
@property(assign,nonatomic)id<myLifeDelegate> delegate;
@property(nonatomic)int target;
@property(nonatomic,retain) NSString *MagId;
@property(nonatomic,retain)NSString *MagName;
@property(nonatomic,retain)NSString *NewsImage;
@property(nonatomic,retain) NSString *MagImage;
@property(nonatomic,retain) NSString *MagPid;
@property(nonatomic,retain) NSString *MagFlag;
@property(nonatomic,retain) ContentRead *contentRead;;
@property(nonatomic,retain)NSMutableArray *arry_Mag_category_id;
@property(nonatomic,retain)NSMutableArray *arry_Mag_description;
@property(nonatomic,retain)NSMutableArray *arry_Mag_image;



@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;


@end
