//
//  AdviceViewController.h
//  Fish
//
//  Created by DAWEI FAN on 04/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "ViewController.h"

@interface AdviceViewController : ViewController<UITextFieldDelegate>{
    UINavigationBar *navBar;
    IBOutlet UILabel *someWordsTitle;
    IBOutlet UILabel *someWords;
    IBOutlet UILabel *CallTitle;
    IBOutlet UITextField *callNumber;
}

@property (retain, nonatomic) IBOutlet UILabel *someWords;
@property (retain, nonatomic) IBOutlet UITextField *callNumber;
-(IBAction) textFieldDone:(id) sender;

@end
