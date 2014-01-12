//
//  LeftViewController.m
//  Fish
//

//  Created by liqun on 12/3/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "LeftViewController.h"
#import "IIViewDeckController.h"
#import "NewsController.h"
#import "ViewController.h"
#import "AppDelegate.h"

#import "LifeViewController.h"
#import "StoreUpViewController.h"
#import "SettingViewController.h"
#import "TViewController.h"
#import "NewsController.h"
@interface LeftViewController ()

@end

@implementation LeftViewController

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
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version <7.0)
        isSeven=NO;
    else isSeven=YES;
    contentRead =[[[ContentRead alloc]init]autorelease];
    contentRead.delegate=self;
    [contentRead Category];
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag
{
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSDictionary *jsonObj =[parser objectWithString: jsonString];
    int height;
    if(isSeven) height=60;
    else height=45;
    
    UIScrollView *scrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)]autorelease];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.delegate=self;
    UIView *myView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)]autorelease];
    myView.backgroundColor=[UIColor clearColor];
    UIImageView *imageViewTitle=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
    imageViewTitle.image=[UIImage imageNamed:@"LeftTitle@2X"];
    [myView addSubview:imageViewTitle];
    UILabel *mainTitle=[[[UILabel alloc]initWithFrame:CGRectMake(105, 0, 320, height)]autorelease];
    mainTitle.text=@"阅钓";
    mainTitle.backgroundColor=[UIColor clearColor];
    mainTitle.font = [UIFont boldSystemFontOfSize:20];
    mainTitle.textColor=[UIColor whiteColor];
    [imageViewTitle addSubview:mainTitle];
     //首页
    UIButton *firstBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    firstBtn.frame=CGRectMake(0, height+2, 320, 44);
    [firstBtn setImage:[UIImage imageNamed:@"selectOne@2X"] forState:UIControlStateNormal];
    [myView addSubview:firstBtn ];
    UILabel *firstPageName=[[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 320, 44)]autorelease];
    firstPageName.textColor=[UIColor whiteColor];
    firstPageName.text=@"首页";
    [firstBtn  addSubview:firstPageName];
    UIImageView *pictureFistPage=[[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,25 , 25)] autorelease];
    pictureFistPage.image=[UIImage imageNamed:@"firstPage@2X.png"];
    [firstBtn  addSubview:pictureFistPage];
    firstBtn.tag=103;
    [firstBtn addTarget:self action:@selector(PessSwitch_Tag:) forControlEvents:UIControlEventTouchUpInside];
    firstPageName.backgroundColor=[UIColor clearColor];
    for (int i=0; i<4;i++)
    {
        UIButton *OneButton=[UIButton buttonWithType:UIButtonTypeCustom];
        OneButton.frame=CGRectMake(0, height+44+5+i*45, 320, 44);
        [OneButton setImage:[UIImage imageNamed:@"selectOne@2X"] forState:UIControlStateNormal];
        [myView addSubview:OneButton ];
        UILabel *OneName=[[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 320, 44)]autorelease];
        OneName.textColor=[UIColor whiteColor];
        OneName.text=[NSString stringWithFormat: [[jsonObj  objectAtIndex:i] objectForKey:@"name"]];
        [OneButton addSubview:OneName];
        [OneButton addTarget:self action:@selector(PessSwitch_Tag:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *pictureOneName=[[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,25 , 25)] autorelease];
        pictureOneName.image=[UIImage imageNamed:@"News@2X.png"];
        [OneButton  addSubview:pictureOneName];
        OneButton.tag=[[NSString stringWithFormat: [[jsonObj  objectAtIndex:i] objectForKey:@"id"]]integerValue];
        UIImageView *theRedNum=[[[UIImageView alloc]initWithFrame:CGRectMake(200, 10, 28, 22)]autorelease];
        theRedNum.image=[UIImage imageNamed:@"redBack.png"];
        [OneButton addSubview:theRedNum];
        UILabel *labelNum=[[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 28, 22)]autorelease];
        labelNum.text=[[jsonObj  objectAtIndex:i] objectForKey:@"id"];
        labelNum.textColor=[UIColor whiteColor];
        labelNum.font  = [UIFont fontWithName:@"Arial" size:12.0];
        [theRedNum addSubview:labelNum];
        labelNum.backgroundColor=[UIColor clearColor];
        OneButton.backgroundColor=[UIColor clearColor];
        OneName.backgroundColor=[UIColor clearColor];
        
    }
   //收藏&设置
    for(int i=0;i<2;i++)
    {
        UIButton *OneButton=[UIButton buttonWithType:UIButtonTypeCustom];
        OneButton.frame=CGRectMake(0,280+height/2+i*45, 320, 44);
        [OneButton setImage:[UIImage imageNamed:@"selectOne@2X"] forState:UIControlStateNormal];
        OneButton.backgroundColor=[UIColor clearColor];
        [myView addSubview:OneButton ];
        UILabel *OneName=[[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 320, 44)]autorelease];
        OneName.textColor=[UIColor whiteColor];
        [OneButton addSubview:OneName];
        [OneButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        UIImageView *pictureOneName=[[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,25 , 25)] autorelease];
        if(i==0)
        {
            OneName.text=@"收藏";
            pictureOneName.image=[UIImage imageNamed:@"Save@2X.png"];
            OneButton.tag=101;
        }
        else
        {
            OneName.text=@"设置";
            pictureOneName.image=[UIImage imageNamed:@"Set@2X.png"];
            OneButton.tag=102;
        }
        [OneButton  addSubview:pictureOneName];
          [OneButton addTarget:self action:@selector(PessSwitch_Tag:) forControlEvents:UIControlEventTouchUpInside];
        OneName.backgroundColor=[UIColor clearColor];
    }
    
    
    [scrollView addSubview:myView];
     scrollView.contentSize = myView.frame.size;
    [self.view addSubview:scrollView];
    

}
-(void)PessSwitch_Tag:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%d",btn.tag);
    if(btn.tag<4)
    {
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            NewsController *apiVC = [[[NewsController alloc] init] autorelease];
            apiVC.target=btn.tag-1;
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];
        [self.navigationController setNavigationBarHidden:YES ];
    }else if(btn.tag==4)
    {
        
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            LifeViewController *apiVC = [[[LifeViewController alloc] init] autorelease];
            apiVC.target=1;
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];
        [self.navigationController setNavigationBarHidden:YES ];
    }
    else if(btn.tag==101)//收藏
    {
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            StoreUpViewController *apiVC = [[[StoreUpViewController alloc] init] autorelease];
            //  apiVC.title = @"XXXXXX";
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];

    }
    else if(btn.tag==102)//设置
    {
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            SettingViewController *apiVC = [[[SettingViewController alloc] init] autorelease];
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];
        
    }else if(btn.tag==103)//首页
    {
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            ViewController *apiVC = [[[ViewController alloc] init] autorelease];
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
            self.viewDeckController.centerController = navApiVC;
            self.view.userInteractionEnabled = YES;
        }];
    }
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

@end
