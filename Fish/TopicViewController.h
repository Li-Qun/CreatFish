//
//  TopicViewController.h
//  Fish
//
//  Created by DAWEI FAN on 18/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "ViewController.h"
#import "klpView.h"
@interface TopicViewController : UIViewController<UIScrollViewDelegate,FishDelegate>
{
    UIScrollView *scrollView;
    UIImageView *imgToolView;
    CGFloat height_Momente;
    int height;
    BOOL Kind7;
    BOOL height5_flag;
    
    klpView *klp;
    
    

    AppDelegate *app;
    ContentRead *contentRead;
    NSMutableArray *arrName;
    NSMutableArray *arr;
    int index;
    IBOutlet UILabel *labelText;
    BOOL isOpenL;
    BOOL isOpenR;
    
}
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@property (retain, nonatomic) IBOutlet UIScrollView *klpScrollView1;
@property (retain, nonatomic) IBOutlet UILabel *labelText;
@property (nonatomic,retain)NSMutableArray *klpImgArr;
@end
