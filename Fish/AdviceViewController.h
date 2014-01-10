//
//  AdviceViewController.h
//  Fish
//
//  Created by DAWEI FAN on 04/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "ViewController.h"
#import "FishCore.h"
@interface AdviceViewController : ViewController<UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,FishDelegate>{
    UINavigationBar *navBar;
    IBOutlet UILabel *someWordsTitle;
    IBOutlet UILabel *someWords;
    IBOutlet UILabel *CallTitle;
    IBOutlet UITextField *callNumber;
    IBOutlet UILabel *reBackType;
    UIButton *Type;
    //UIImageView *TypeImg;
    UILabel *labelType;
    IBOutlet UILabel *content;
    BOOL  textViewStyle;
    IBOutlet UITextView *textView;
    UIButton *submmit;
    ContentRead *content_Read;
    int Height;
}

@property (retain, nonatomic) IBOutlet UILabel *someWords;
@property (retain, nonatomic) IBOutlet UITextField *callNumber;
@property (retain, nonatomic) IBOutlet UITextView *textView;

@end
