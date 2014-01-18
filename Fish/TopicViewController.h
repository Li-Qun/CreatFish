//
//  TopicViewController.h
//  Fish
//
//  Created by DAWEI FAN on 18/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "ViewController.h"
#import "klpView.h"
@interface TopicViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UIImageView *imgToolView;
    CGFloat height_Momente;
    int height;
    BOOL Kind7;
    BOOL height5_flag;
    
    klpView *klp;
    
    

    AppDelegate *app;
    NSMutableArray *arrName;

}
@property (retain, nonatomic) IBOutlet UIScrollView *klpScrollView1;
@property (nonatomic,retain)NSMutableArray *klpImgArr;
@end
