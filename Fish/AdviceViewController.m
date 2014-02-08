//
//  AdviceViewController.m
//  Fish
//
//  Created by DAWEI FAN on 04/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "AdviceViewController.h"
#import "FishCore.h"
@interface AdviceViewController ()

@end

@implementation AdviceViewController
@synthesize someWords=someWords;
@synthesize callNumber=callNumber;
@synthesize textView=textView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor=[UIColor grayColor];
        textViewStyle=YES;
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"advice_back@2X.png"]];
        imgView.frame = self.view.bounds;
        imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view insertSubview:imgView atIndex:0];
        [imgView release];
    }
    return self;
}
-(void)build_Tool
{
    ///“使用反馈”
    someWordsTitle.textColor=[UIColor whiteColor];
    [someWordsTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];//加粗
    ///
    someWords.text=@"    感谢您使用阅钓杂志App,如果您在使用过程中遇到任何不便,或有意见及建议,欢迎您反馈给我们。";
    someWords.font=[UIFont systemFontOfSize:14.0f];
    someWords.textColor=[UIColor whiteColor];
    //  someWords.lineBreakMode = UILineBreakModeWordWrap;
    someWords.numberOfLines = 0;
    someWords.backgroundColor=[UIColor clearColor];
    [someWords sizeToFit];
    //“联系方式”
    CallTitle.textColor=[UIColor whiteColor];
    [CallTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    //“textField”
    callNumber.delegate=self;
    callNumber.layer.borderColor=[[UIColor blackColor] CGColor];
    callNumber.layer.borderWidth =2.0;
    callNumber.layer.cornerRadius =6.0;

    //"反馈类型"
    reBackType.textColor=[UIColor whiteColor];
    [reBackType setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    //"反馈内容"
    content.textColor=[UIColor whiteColor];
    [content setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    //设置边框：UITextView
    textView.layer.borderColor = [UIColor blackColor].CGColor;
    textView.layer.borderWidth =2.0;
    textView.layer.cornerRadius =5.0;
    textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    textView.font = [UIFont fontWithName:@"Arial" size:18.0];
    textView.backgroundColor = [UIColor whiteColor];
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    textView.delegate = self;
}
-(void)viewWillAppear:(BOOL)animated
{
    textView.text=@"";
    callNumber.text=@"";
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    int height_Momente = size.height;
    
    if(height_Momente==480)
    {
        isFive=NO;
    }else isFive=YES;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version <7.0)
        isSeven=NO;
    else isSeven=YES;
    
    int submmit_Height=0;
    if(isSeven&&isFive)
    {
        submmit_Height=10;

    }
    else if(isSeven&&!isFive)
    {
        submmit_Height=20 ;
    }else if(!isSeven&&isFive)//
    {
        Height=0;
        submmit_Height=10;
        
    }else {
        Height=20;
        submmit_Height=20;
    }
    
    UIImageView *topBarView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50-Height)]autorelease];
    topBarView.image=[UIImage imageNamed:@"topBarRed"];
    [self.view addSubview:topBarView];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(10, 20-Height/2-2, 25, 27);
    leftBtn.tag=10;
    [leftBtn setImage:[UIImage imageNamed:@"theGoBack"] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(backSet) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *name=[[[UILabel alloc]initWithFrame:CGRectMake(100, 20-Height/2, 120, 21)]autorelease];
    name.textColor=[UIColor whiteColor];
    name.text=@"意见反馈";
    name.textAlignment = UITextAlignmentCenter;
    name.font =[UIFont boldSystemFontOfSize:21];
    name.shadowColor = [UIColor grayColor];
    name.shadowOffset = CGSizeMake(0.0,0.5);
    name.backgroundColor=[UIColor clearColor];
    [topBarView addSubview:name];
    
    
    textView.frame=CGRectMake(15, 300, 285,100);
    [super viewDidLoad];
    
    submmit=[UIButton buttonWithType:UIButtonTypeCustom];
    submmit.frame=CGRectMake(15,470-submmit_Height*3, 75, 25);
    [submmit setImage:[UIImage imageNamed:@"submmit.png"] forState:UIControlStateNormal];
    [submmit addTarget:self action:@selector(pressSubmmit) forControlEvents:UIControlEventTouchUpInside];
    UILabel *submmitName=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 72, 25)]autorelease];
    submmitName.backgroundColor=[UIColor clearColor];
    submmitName.text=@"    提交";
    submmitName.textColor=[UIColor whiteColor];
    [submmit addSubview:submmitName];
    [self build_Tool];
    
    Type=[UIButton buttonWithType:UIButtonTypeCustom];
    Type.frame=CGRectMake(115,236,79,33);
    [Type setImage:[UIImage imageNamed:@"TypeNormal@2X.png"] forState:UIControlStateNormal];
    [Type setImage:[UIImage imageNamed:@"TypeSelect@2X.png"] forState: UIControlStateHighlighted];
    [Type setImage:[UIImage imageNamed:@"TypeNormal@2X.png"] forState:UIControlStateNormal];
    [Type addTarget:self action:@selector(pressTheType) forControlEvents:UIControlEventTouchUpInside];
    labelType=[[UILabel alloc]initWithFrame:CGRectMake(2,2, 40, 32)];
    labelType.backgroundColor=[UIColor clearColor];
    labelType.text=@" 建议";
    [Type addSubview:labelType];
    [self.view addSubview:Type];
    [self.view addSubview:submmit];
    content_Read=[[ContentRead alloc]init];
    content_Read.delegate=self;

    [self build_Tool];
 
}
- (void)viewDidLoad
{

    
}
-(void)backSet
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)pressSubmmit
{
    if([callNumber.text  isEqualToString: @""])
    {
        [self lockAnimationForView:callNumber];
    }
    if([textView.text isEqualToString: @""])
    {
        [self lockAnimationForView:textView];
    }
    if(![callNumber.text  isEqualToString: @""]&&![textView.text isEqualToString: @""])
    {
        //NSLog(@"%@  %@ %@",callNumber.text,labelType.text,textView.text);
        [content_Read Submmit:callNumber.text typeBack:labelType.text content:textView.text];
    }
//    callNumber.text=@"15204071438";
//    labelType.text=@"建议";
//    textView.text=@"dnjfsdnkadsmlka";
//    [content_Read Submmit:callNumber.text typeBack:labelType.text content:textView.text];
 }
-(void)reBack:(NSString *)jsonString reLoad :(NSString *)ID
{
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSDictionary *jsonObj =[parser objectWithString: jsonString];
    NSLog(@"%@",[jsonObj objectForKey:@"msg"]);
    if([[jsonObj objectForKey:@"msg"] isEqualToString:@"反馈提交成功"])
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"反馈提交成功"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil]autorelease];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"反馈提交失败"
                                                         message:@"请稍后再试"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles: nil]autorelease];
        [alert show];
    }
}
-(void)pressTheType
{
    NSString *string=[NSString stringWithFormat:@"反馈类型如下:" ];
    UIActionSheet *  actionSheet = [[UIActionSheet alloc]
                                    initWithTitle:string
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:@"建议"
                                    otherButtonTitles:@"意见",@"Bug",@"树洞",@"其他",nil];
    
    
    [actionSheet showInView:self.view];
    [actionSheet release];
    
}
#pragma mark -
#pragma mark actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
           
        case 0:
        {
            labelType.text=@" 建议";
            break;
        }
        case 1:
        {
            labelType.text=@" 意见";
            break;
        }
        case 2:
            labelType.text=@" Bug";
            break;
        case 3:
        {
            labelType.text=@" 树洞";
            break;
        }
        case 4:
            labelType.text=@" 其他";
            break;
        default:
            break;
    }
    [Type addSubview:labelType];
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
 - (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [callNumber resignFirstResponder];
    return YES;
}
#pragma mark - UITextView Delegate Methods

-(BOOL)textView:(UITextView *)textView1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        textView.frame=CGRectMake(15, 300, 285, 100);
        [self.view addSubview:textView];
        textViewStyle = YES;
        return NO;
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView1
{
    if (textViewStyle)
    {
        textView.frame=CGRectMake(0, 62-Height, 320, 292);
        textView.text = @"";
    }
    [self.view addSubview:textView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [navBar release];
    [someWords release];
    [someWordsTitle release];
    [CallTitle release];
    [callNumber release];
    [reBackType release];
    [labelType release];
    [content release];
    [textView release];
    [super dealloc];
}
@end
