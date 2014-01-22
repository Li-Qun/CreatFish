//
//  LifeItemViewController.h
//  Fish
//
//  Created by DAWEI FAN on 21/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "klpView.h"
@interface LifeItemViewController : UIViewController<FishDelegate,UIScrollViewDelegate>
{
    AppDelegate *app;
    BOOL isSeven;
    BOOL isFive;
    float heightTopbar;
    float littleHeinght;
    NSString *FishImageID;
    NSString *isNationID;
    NSString *shareImage;
    NSMutableArray *Fish_arr;
    klpView *klp;
    
    int index;
    CGFloat height_Momente;
    int height;
    BOOL Kind7;
    BOOL height5_flag;
    
}
@property(nonatomic,strong)NSString *FishImageID;
@property(nonatomic,strong)NSString *isNationID;
@property (nonatomic,retain)NSMutableArray *klpImgArr;
@property (retain, nonatomic) IBOutlet UIScrollView *klpScrollView1;

@end
