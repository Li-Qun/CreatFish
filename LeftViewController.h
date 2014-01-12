//
//  LeftViewController.h
//  Fish
//
//  Created by liqun on 12/3/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface LeftViewController : UIViewController<FishDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate>
{
    AppDelegate *app;
    ContentRead *contentRead;
    BOOL isSeven;
}
@end
