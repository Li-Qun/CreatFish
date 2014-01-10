//
//  SettingViewController.h
//  Fish
//
//  Created by DAWEI FAN on 04/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "ViewController.h"

@interface SettingViewController : ViewController<UIScrollViewDelegate,UIScrollViewAccessibilityDelegate,FishDelegate
>
{
    UINavigationBar *navBar;
    IBOutlet UIScrollView *scrollView;
    UIView *myView;
    int Height;
}
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@end
