//
//  SettingViewController.m
//  Fish
//
//  Created by DAWEI FAN on 04/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "SettingViewController.h"
#import "AdviceViewController.h"
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
    


    
//    UIButton *fash=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    fash.frame=CGRectMake(20, 226, 101, 34);
//    fash.hidden=NO;
//    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
//    [fash setTitle:@"潮流" forState:UIControlStateNormal];
//    [fash addTarget:self action:@selector(Press_set) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:fash];
}
-(void)Press_allRead
{
    NSLog(@"XXXX");
}
-(void)Press_set
{
    AdviceViewController *newVC = [[[AdviceViewController alloc] initWithNibName:@"AdviceViewController" bundle:nil]autorelease];
    //newVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController :newVC animated:YES];

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

    navBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 55)]autorelease];//(0, 17, 320, 44)
    [navBar setBackgroundImage:[UIImage imageNamed:@"set_Nav@2x.png"] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navigationItem = [[[UINavigationItem alloc] init ]autorelease];
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"路亚中国"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    navigationItem.titleView = customLab;
    [navBar pushNavigationItem:navigationItem animated:YES];
    [myView addSubview:navBar];
    [customLab release];
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
    labelNormal_Set.text=@"  通用设置";
    labelNormal_Set.textColor=[UIColor whiteColor];
    [imageView addSubview:labelNormal_Set];
    [labelNormal_Set release];
    [imageView release];
    //全部标记为已读
    UIButton *readed=[UIButton buttonWithType:UIButtonTypeCustom];
    readed.frame=CGRectMake(0, 91, 320, 70);
    readed.showsTouchWhenHighlighted = YES;
    [myView addSubview:readed];
    UILabel *allRead=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
    allRead.text=@"  全部标记为已读";
    allRead.textColor=[UIColor whiteColor];
    [readed addSubview:allRead];
    [readed addTarget:self action:@selector(Press_allRead) forControlEvents:UIControlEventTouchDown];
    [allRead release];
    //分割线
    UIImageView *imgLineTwo=[[UIImageView alloc]initWithFrame:CGRectMake(0, 161, 320, 2)];
    imgLineTwo.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineTwo];
    [imgLineTwo release];
    //清除所有缓存
    UIButton *clear=[UIButton buttonWithType:UIButtonTypeCustom];
    clear.showsTouchWhenHighlighted = YES;
    clear.frame=CGRectMake(0, 163, 320, 70);
    UILabel *clearAll=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 70)]autorelease];
    clearAll.textColor=[UIColor whiteColor];
    clearAll.text=@"  清除所有缓存";
    [clear addSubview:clearAll];
    [clear addTarget:self action:nil forControlEvents:UIControlEventTouchDown];
    [myView addSubview:clear];
    //分割线
    UIImageView *imgLineThree=[[UIImageView alloc]initWithFrame:CGRectMake(0, 233, 320, 2)];
    imgLineThree.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineThree];
    [imgLineThree release];
    //关于
    UIImageView *about=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 235, 320, 34)]autorelease];
    about.image=[UIImage imageNamed:@"labelNormal_Set"];
    [myView addSubview:about];
    UILabel *aboutLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 34)]autorelease];
    aboutLabel.text=@"  关于";
    aboutLabel.textColor=[UIColor whiteColor];
    [about  addSubview:aboutLabel];
    //意见反馈
    UIButton *advice=[UIButton buttonWithType:UIButtonTypeCustom];
    advice.showsTouchWhenHighlighted = YES;
    advice.frame=CGRectMake(0, 269, 320, 70);
    UILabel *adviceLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 70)]autorelease];
    adviceLabel.textColor=[UIColor whiteColor];
    adviceLabel.text=@"  意见反馈";
    [advice addTarget:self action:@selector(Press_set) forControlEvents:UIControlEventTouchDown];
    [advice addSubview:adviceLabel];
    [myView addSubview:advice];
    //分割线
    UIImageView *imgLineFour=[[UIImageView alloc]initWithFrame:CGRectMake(0, 339, 320, 2)];
    imgLineFour.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineFour];
    [imgLineFour release];
    //向朋友推荐本应用
    UIButton *share=[UIButton buttonWithType:UIButtonTypeCustom];
    share.frame=CGRectMake(0, 341, 320, 70);
    [share addTarget:self action:nil forControlEvents:UIControlEventTouchDown];
    share.showsTouchWhenHighlighted = YES;
    UILabel *shareLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 70)]autorelease];
    shareLabel.text=@"  向朋友推荐本应用";
    shareLabel.textColor=[UIColor whiteColor];
    [share addSubview:shareLabel];
    [myView addSubview:share];
    //分割线
    UIImageView *imgLineFive=[[UIImageView alloc]initWithFrame:CGRectMake(0, 411, 320, 2)];
    imgLineFive.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineFive];
    [imgLineFive release];
    //程序版本
    UILabel *Kind=[[[UILabel alloc]initWithFrame:CGRectMake(0, 413, 320, 70)]autorelease];
    Kind.textColor=[UIColor whiteColor];
    Kind.text=@"  程序版本    1.1";
    [myView addSubview:Kind];
    //分割线
    UIImageView *imgLineSix=[[UIImageView alloc]initWithFrame:CGRectMake(0, 483, 320, 2)];
    imgLineSix.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineSix];
    [imgLineSix release];
    //特别推荐
    UIImageView *honored=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 485, 320, 34)]autorelease];
    honored.image=[UIImage imageNamed:@"labelNormal_Set"];
    [myView addSubview:honored];
    UILabel *honoredLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 34)]autorelease];
    honoredLabel.text=@"  特别推荐";
    honoredLabel.textColor=[UIColor whiteColor];
    [honored  addSubview:honoredLabel];
    // 几个应用
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(10, 530, 42, 42);
    [btn1 setImage:[UIImage imageNamed:@"xinlang.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:btn1];

    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(62, 530, 42, 42);
    [btn2 setImage:[UIImage imageNamed:@"weixin.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:btn2];
    
    //分割线
    UIImageView *imgLineSeven=[[UIImageView alloc]initWithFrame:CGRectMake(0, 589, 320, 2)];
    imgLineSeven.image=[UIImage imageNamed:@"theLineSet.png"];
    [myView addSubview:imgLineSeven];
    [imgLineSeven release];
    //分割线
    UIImageView *imgLineEight=[[UIImageView alloc]initWithFrame:CGRectMake(0, 697, 320, 2)];
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
