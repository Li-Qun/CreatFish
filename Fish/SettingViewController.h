//
//  SettingViewController.h
//  Fish
//
//  Created by DAWEI FAN on 04/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "ViewController.h"
#import "WeiboSDK.h"
@interface SettingViewController : UIViewController<UIScrollViewDelegate,UIScrollViewAccessibilityDelegate,FishDelegate,WeiboSDKJSONDelegate,ISSShareViewDelegate
>
{
    UINavigationBar *navBar;
    IBOutlet UIScrollView *ScrollView;
    UIView *myView;
    int Height;
}
@property (retain, nonatomic) IBOutlet UIScrollView *ScrollView;

@end
