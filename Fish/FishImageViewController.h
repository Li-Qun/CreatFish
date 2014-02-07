//
//  FishImageViewController.h
//  Fish
//
//  Created by DAWEI FAN on 20/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "klpView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKCoreService/ShareSDKCoreService.h>
@interface FishImageViewController : UIViewController<FishDelegate,ISSShareViewDelegate,UIScrollViewDelegate>
{
    AppDelegate *app;
    BOOL isSeven;
    BOOL isFive;
    float heightTopbar;
    float littleHeinght;
    NSString *FishImageID;
    NSString *shareImage;
    NSMutableArray *Fish_arr;
    klpView *klp;
    
    int index;
    CGFloat height_Momente;
    int height;
    BOOL Kind7;
    BOOL height5_flag;
    NSString *detailName;
}
@property(nonatomic,strong)NSString *FishImageID;
@property (nonatomic,retain)NSMutableArray *klpImgArr;
@property (retain, nonatomic) IBOutlet UIScrollView *klpScrollView1;
@property (nonatomic,retain)NSString *detailName;
@end
