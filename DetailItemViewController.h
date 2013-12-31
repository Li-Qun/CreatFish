//
//  DetailItemViewController.h
//  NewDemo
//
//  Created by liqun on 12/1/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuadCurveMenu.h"



#define MAIN_LABEL_Y_ORIGIN 0
#define IMAGEVIEW_Y_ORIGIN 15
@interface DetailItemViewController : UIViewController<QuadCurveMenuDelegate>
{
    UIImageView *img;
    UIButton *bigPicButton;
}
@property (retain, nonatomic) IBOutlet UILabel *labelForPlace;
@property (retain, nonatomic) IBOutlet UILabel *labelForCountry;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UITextView *textviewForDetail;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (retain, nonatomic) UIImageView *img;

@property (readwrite, nonatomic) int yOrigin;
@property (retain, nonatomic) NSMutableDictionary *dictForData;

@property (retain,nonatomic)UIButton *bigPicButton;



@end
