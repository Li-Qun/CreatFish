//
//  SettingViewController.h
//  Fish
//
//  Created by DAWEI FAN on 04/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "ViewController.h"

@interface SettingViewController : ViewController<UIScrollViewDelegate,UIScrollViewAccessibilityDelegate
>
{
    UINavigationBar *navBar;
    IBOutlet UIScrollView *scrollView;
    UIView *myView;
}
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@end
