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
@protocol myLifeDelegate
-(void)Life:(BOOL)flag;

@end
@interface LifeViewController : UIViewController <iCarouselDataSource,iCarouselDelegate,UIActionSheetDelegate,myLifeDelegate>
{
    BOOL  isTheLeft;
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
@end
