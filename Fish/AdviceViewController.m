//
//  AdviceViewController.m
//  Fish
//
//  Created by DAWEI FAN on 04/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "AdviceViewController.h"

@interface AdviceViewController ()

@end

@implementation AdviceViewController
@synthesize someWords=someWords;
@synthesize callNumber=callNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor=[UIColor grayColor];
    }
    return self;
}
-(void)build_Tool
{
    ///1
    someWordsTitle.textColor=[UIColor whiteColor];
    [someWordsTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];//加粗
    ///2
    someWords.text=@"    感谢您使用路亚中国App,如果您在使用过程中遇到任何不便,或有意见及建议,欢迎您反馈给我们。";
    someWords.font=[UIFont systemFontOfSize:14.0f];
    someWords.textColor=[UIColor whiteColor];
    someWords.lineBreakMode = UILineBreakModeWordWrap;
        someWords.numberOfLines = 0;
    someWords.backgroundColor=[UIColor clearColor];
    [someWords sizeToFit];
    //3
    CallTitle.textColor=[UIColor whiteColor];
    [CallTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];

}
- (void)viewDidLoad
{
    navBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 17, 320, 44)]autorelease];
    [navBar setBackgroundImage:[UIImage imageNamed:@"advice_nav_red@2x.png"] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navigationItem = [[[UINavigationItem alloc] init ]autorelease];
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"意见反馈"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    navigationItem.titleView = customLab;
    [navBar pushNavigationItem:navigationItem animated:YES];
    [self.view addSubview:navBar];
    [customLab release];
    [super viewDidLoad];
    [self build_Tool];
}
-(void)lockAnimationForView:(UIView*)view
{
    CALayer *lbl = [view layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-5, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+5, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [lbl addAnimation:animation forKey:nil];
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string//判断range.length的值来判断输入的是回格还是其它字符
//{
//    if (1 == range.length) {//按下回格键
//        return YES;
//    }
//    if ([callNumber.text isEqualToString:@"\n"]) {//按下return键
//        //这里隐藏键盘，不做任何处理
//        [callNumber.text resignFirstResponder];
//        return NO;
//    }else {
//        if ([callNumber.text length] < 140) {//判断字符个数
//            return YES;
//        }
//    }
//    return NO;
//}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//     [callNumber resignFirstResponder];
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [callNumber resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [someWords release];
    [someWordsTitle release];
    [CallTitle release];
    [callNumber release];
    [super dealloc];
}
@end
