//
//  RightViewController.h
//  Fish
//
//  Created by liqun on 12/3/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface RightViewController : UIViewController<FishDelegate,UIScrollViewDelegate>
{
    AppDelegate *app;
    int target_centerView;
    NSString *strJson;
}
@property(nonatomic)int target_centerView;
@end
