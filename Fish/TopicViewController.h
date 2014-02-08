//
//  TopicViewController.h
//  Fish
//
//  Created by DAWEI FAN on 18/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "ViewController.h"
#import "klpView.h"
@interface TopicViewController : UIViewController<UIScrollViewDelegate,FishDelegate,UITextViewDelegate>
{
   // UIScrollView *scrollView;
   //UIImageView *imgToolView;
    CGFloat height_Momente;
    int height;
    BOOL Kind7;
    BOOL height5_flag;
    
    klpView *klp;
    
    

    AppDelegate *app;
   // ContentRead *contentRead;
    NSMutableArray *arrName;
    NSMutableArray *arr;
    int index;
    IBOutlet UILabel *labelText;
    IBOutlet UITextView *textView;
    BOOL isOpenL;
    BOOL isOpenR;
    //基本信息
    NSString *CenterIB;
    NSString *topicName;
    NSString *topicID;
    
    
}
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@property (retain, nonatomic) IBOutlet UIScrollView *klpScrollView1;
@property (retain, nonatomic) IBOutlet UILabel *labelText;
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,retain)NSMutableArray *klpImgArr;
@property (nonatomic,retain) NSString *CenterIB;
@property (nonatomic,retain) NSString *topicName;
@property (nonatomic,retain) NSString *topicID;
@property(readwrite,nonatomic)int target;
@property(readwrite,nonatomic)int targetRight;
@end
