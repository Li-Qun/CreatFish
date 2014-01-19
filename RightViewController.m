//
//  RightViewController.m
//  Fish
//
//  Created by liqun on 12/3/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "RightViewController.h"
#import "NewsController.h"
#import "TopicViewController.h"
#import "LifeViewController.h"
#import "AppDelegate.h"
@interface RightViewController ()

@end

@implementation RightViewController
@synthesize target_centerView=target_centerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slideLeft_Back@2X.png"]];
        imgView.frame = self.view.bounds;
        imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view insertSubview:imgView atIndex:0];
        [imgView release];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ContentRead * contentRead =[[[ContentRead alloc]init]autorelease];
    contentRead.delegate=self;
    [contentRead Category];
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag
{
 
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSDictionary *jsonObj =[parser objectWithString: jsonString];
    
    UIScrollView *scrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)]autorelease];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.delegate=self;
    UIView *myView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)]autorelease];
    myView.backgroundColor=[UIColor clearColor];
//    UIImageView *imageViewTitle=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
//    imageViewTitle.image=[UIImage imageNamed:@"LeftTitle@2X"];
//    [myView addSubview:imageViewTitle];
//    UILabel *mainTitle=[[[UILabel alloc]initWithFrame:CGRectMake(145, 0, 320, 45)]autorelease];
//    mainTitle.text=@"最新";
//    mainTitle.font = [UIFont boldSystemFontOfSize:17];
//    mainTitle.textColor=[UIColor whiteColor];
//    [imageViewTitle addSubview:mainTitle];
//    UIImageView *pictureName=[[[UIImageView alloc]initWithFrame:CGRectMake(90, 45/3,20 , 20)] autorelease];
//    pictureName.image=[UIImage imageNamed:@"Set.png"];
//    [imageViewTitle addSubview:pictureName];
//    mainTitle.backgroundColor=[UIColor clearColor];
    //三个 二级按钮
    
    
 
    
    NSLog(@"==%d",app.targetCenter);
    NSLog(@"centre:%d",target_centerView );
    
    target_centerView=app.targetCenter;
    int total,start;
    if(target_centerView==1)
    {
        total=3;
        start=5;
    }
    else if(target_centerView==2)
    {
        total=2;
        start=8;
    }
    else if(target_centerView==3)
    {
        total=2;
        start=10;
    }
    else if(target_centerView==4)
    {
        total=3;
        start=12;
    }
    else {
        total=3;
        start=15;
    }
    
    
    
    for(int i=0;i<total;i++)
    {
        UIButton *OneButton=[UIButton buttonWithType:UIButtonTypeCustom];
        OneButton.frame=CGRectMake(0, 20+i*45, 320, 44);
        [OneButton setImage:[UIImage imageNamed:@"selectOne@2X"] forState:UIControlStateNormal];
        [myView addSubview:OneButton ];
        UILabel *OneName=[[[UILabel alloc]initWithFrame:CGRectMake(145, 0, 320, 44)]autorelease];
        OneName.textColor=[UIColor whiteColor];
        OneName.text=[NSString stringWithFormat: [[jsonObj  objectAtIndex: start+i] objectForKey:@"name"]];
        [OneButton addSubview:OneName];
        [OneButton addTarget:self action:@selector(PessSwitchRight_Tag:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *pictureOneName=[[[UIImageView alloc]initWithFrame:CGRectMake(90, 10,25 , 25)] autorelease];
        pictureOneName.image=[UIImage imageNamed:@"News@2X.png"];
        [OneButton  addSubview:pictureOneName];
        OneButton.tag=[[NSString stringWithFormat: [[jsonObj  objectAtIndex:start+i] objectForKey:@"id"]]integerValue];
        OneName.backgroundColor=[UIColor clearColor];
        OneButton.backgroundColor=[UIColor clearColor];
    }
    
    
    [scrollView addSubview:myView];
    scrollView.contentSize = myView.frame.size;
    [self.view addSubview:scrollView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)PessSwitchRight_Tag:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%d",btn.tag);
    if(btn.tag<6&&btn.tag!=2&&btn.tag!=3)
    {
        [self.viewDeckController closeRightViewBouncing:^(IIViewDeckController *controller) {
            NewsController *apiVC = [[[NewsController alloc] init] autorelease];
            apiVC.target=btn.tag;
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];

    }
    else if (btn.tag==3)
    {
        [self.viewDeckController closeRightViewBouncing:^(IIViewDeckController *controller) {
            LifeViewController *apiVC = [[[LifeViewController alloc] init] autorelease];
            apiVC.target=btn.tag;
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];
    }
    else if(btn.tag==9||btn.tag==10)
    {
        [self.viewDeckController closeRightViewBouncing:^(IIViewDeckController *controller) {
            TopicViewController *apiVC = [[[TopicViewController alloc] init] autorelease];
            apiVC.targetRight=btn.tag;
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];

    }
}
 
@end
