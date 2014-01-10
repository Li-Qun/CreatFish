//
//  SettingViewController.m
//  Fish
//
//  Created by DAWEI FAN on 04/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "SettingViewController.h"
#import "AdviceViewController.h"
#import "ViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize scrollView=scrollView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationController setToolbarHidden:YES];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    contentRead =[[[ContentRead alloc]init]autorelease];
    contentRead.delegate=self;
    [contentRead Category];
}

-(void)Press_set
{
    AdviceViewController *newVC = [[[AdviceViewController alloc] initWithNibName:@"AdviceViewController" bundle:nil]autorelease];
    //newVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController :newVC animated:YES];

}
-(void)Press_allRead
{
    
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag
{
//页面重置作用
}
-(void)Back
{
        [self.viewDeckController toggleLeftViewAnimated:YES];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    
    [self.navigationController setToolbarHidden:YES];
    self.view.backgroundColor=[UIColor whiteColor];
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320,568)];
    scrollView.backgroundColor=[UIColor blackColor];
    scrollView.delegate=self;
    myView=[[UIView alloc]init];
    myView.backgroundColor=[UIColor blackColor];

    
    UIImageView *topBarView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 55)]autorelease];
    topBarView.image=[UIImage imageNamed:@"set_Nav@2x.png"];
    [myView addSubview:topBarView];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(120, 15, 100, 30)];
    customLab.backgroundColor=[UIColor clearColor];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"路亚中国"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [topBarView addSubview:customLab];
    
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(10,15, 25, 27);
    leftBtn.tag=10;
    [leftBtn setImage:[UIImage imageNamed:@"theGoBack"] forState:UIControlStateNormal];
    [myView addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
 

    
    //分割线
    UIImageView *imgLineOne=[[UIImageView alloc]initWithFrame:CGRectMake(0, 55, 320, 2)];
    imgLineOne.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView  addSubview:imgLineOne];
    [imgLineOne release];
    //通用设置
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 57, 320, 34)];//0 61 320 34
    imageView.image=[UIImage imageNamed:@"labelNormal_Set"];
    [myView addSubview:imageView];
    
    UILabel *labelNormal_Set=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 34)];
    labelNormal_Set.backgroundColor=[UIColor clearColor];
    labelNormal_Set.text=@"  通用设置";
    labelNormal_Set.textColor=[UIColor whiteColor];
    [imageView addSubview:labelNormal_Set];
    [labelNormal_Set release];
    [imageView release];
    //全部标记为已读
    UIButton *readed=[UIButton buttonWithType:UIButtonTypeCustom];
    [readed setImage:[UIImage imageNamed:@"selectedNow"] forState:UIControlStateHighlighted];
    readed.backgroundColor=[UIColor clearColor];
    readed.frame=CGRectMake(0, 91, 320, 50);
    [myView addSubview:readed];
    UILabel *allRead=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    allRead.backgroundColor=[UIColor clearColor];
    allRead.text=@"  全部标记为已读";
    allRead.textColor=[UIColor whiteColor];
    [readed addSubview:allRead];
    [readed addTarget:self action:@selector(Press_allRead) forControlEvents:UIControlEventTouchDown];
    [allRead release];
    //分割线
    UIImageView *imgLineTwo=[[UIImageView alloc]initWithFrame:CGRectMake(0, 141, 320, 2)];
    imgLineTwo.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineTwo];
    [imgLineTwo release];
    //清除所有缓存
    UIButton *clear=[UIButton buttonWithType:UIButtonTypeCustom];
    [clear  setImage:[UIImage imageNamed:@"selectedNow"] forState:UIControlStateHighlighted];
    clear.backgroundColor=[UIColor clearColor];
    clear.frame=CGRectMake(0, 143, 320, 50);
    UILabel *clearAll=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)]autorelease];
    clearAll.textColor=[UIColor whiteColor];
    clearAll.backgroundColor=[UIColor clearColor];
    clearAll.text=@"  清除所有缓存";
    [clear addSubview:clearAll];
    [clear addTarget:self action:nil forControlEvents:UIControlEventTouchDown];
    [myView addSubview:clear];
    //分割线
    UIImageView *imgLineThree=[[UIImageView alloc]initWithFrame:CGRectMake(0, 193, 320, 2)];
    imgLineThree.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineThree];
    [imgLineThree release];
    //关于
    UIImageView *about=[[[UIImageView alloc]initWithFrame:CGRectMake(0,195, 320, 34)]autorelease];
    about.image=[UIImage imageNamed:@"labelNormal_Set"];
    [myView addSubview:about];
    UILabel *aboutLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 34)]autorelease];
    aboutLabel.backgroundColor=[UIColor clearColor];
    aboutLabel.text=@"  关于";
    aboutLabel.textColor=[UIColor whiteColor];
    [about  addSubview:aboutLabel];
    //意见反馈
    UIButton *advice=[UIButton buttonWithType:UIButtonTypeCustom];
    [advice setImage:[UIImage imageNamed:@"selectedNow"] forState:UIControlStateSelected];
    advice.backgroundColor=[UIColor clearColor];
    advice.frame=CGRectMake(0, 230, 320, 50);
    UILabel *adviceLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)]autorelease];
    adviceLabel.textColor=[UIColor whiteColor];
    adviceLabel.backgroundColor=[UIColor clearColor];
    adviceLabel.text=@"  意见反馈";
    [advice addTarget:self action:@selector(Press_set) forControlEvents:UIControlEventTouchDown];
    [advice addSubview:adviceLabel];
    [myView addSubview:advice];
    //分割线
    UIImageView *imgLineFour=[[UIImageView alloc]initWithFrame:CGRectMake(0, 280, 320, 2)];
    imgLineFour.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineFour];
    [imgLineFour release];
    //向朋友推荐本应用
    UIButton *share=[UIButton buttonWithType:UIButtonTypeCustom];
    [share setImage:[UIImage imageNamed:@"selectedNow"] forState:UIControlStateHighlighted];
    share.backgroundColor=[UIColor clearColor];
    share.frame=CGRectMake(0, 282, 320, 50);
    [share addTarget:self action:nil forControlEvents:UIControlEventTouchDown];
    UILabel *shareLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)]autorelease];
    shareLabel.backgroundColor=[UIColor clearColor];
    shareLabel.text=@"  向朋友推荐本应用";
    shareLabel.textColor=[UIColor whiteColor];
    [share addSubview:shareLabel];
    [myView addSubview:share];
    //分割线
    UIImageView *imgLineFive=[[UIImageView alloc]initWithFrame:CGRectMake(0,332, 320, 2)];
    imgLineFive.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineFive];
    [imgLineFive release];
    //程序版本
    UILabel *Kind=[[[UILabel alloc]initWithFrame:CGRectMake(0, 334, 320, 50)]autorelease];
    Kind.textColor=[UIColor whiteColor];
    Kind.backgroundColor=[UIColor clearColor];
    Kind.text=@"  程序版本    1.1";
    [myView addSubview:Kind];
    //分割线
    UIImageView *imgLineSix=[[UIImageView alloc]initWithFrame:CGRectMake(0, 384, 320, 2)];
    imgLineSix.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineSix];
    [imgLineSix release];
    //特别推荐
    UIImageView *honored=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 386, 320, 34)]autorelease];
    honored.image=[UIImage imageNamed:@"labelNormal_Set"];
    [myView addSubview:honored];
    UILabel *honoredLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 34)]autorelease];
    honoredLabel.backgroundColor=[UIColor clearColor];
    honoredLabel.text=@"  特别推荐";
    honoredLabel.textColor=[UIColor whiteColor];
    [honored  addSubview:honoredLabel];
    // 几个应用
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor=[UIColor clearColor];
    btn1.frame=CGRectMake(10, 425, 42, 42);
    [btn1 setImage:[UIImage imageNamed:@"xinlang.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:btn1];

    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor=[UIColor clearColor];
    btn2.frame=CGRectMake(62, 425, 42, 42);
    [btn2 setImage:[UIImage imageNamed:@"weixin.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:btn2];
    
    //分割线
    UIImageView *imgLineSeven=[[UIImageView alloc]initWithFrame:CGRectMake(0, 470, 320, 2)];
    imgLineSeven.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineSeven];
    [imgLineSeven release];
    //分割线
    UIImageView *imgLineEight=[[UIImageView alloc]initWithFrame:CGRectMake(0, 520, 320, 2)];
    imgLineEight.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineEight];
    [imgLineEight release];
    
    myView.frame=CGRectMake(0, 0, 320,1000);
    myView.backgroundColor=[UIColor blackColor];
    scrollView.contentSize = myView.frame.size;
    [scrollView addSubview:myView];
    [self.view addSubview:scrollView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];// Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [scrollView release];
    [super dealloc];
}
@end
