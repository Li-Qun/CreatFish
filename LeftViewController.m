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

#import "MagazineViewController.h"
#import "SaveViewController.h"
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
        // Custom initialization
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    contentRead =[[[ContentRead alloc]init]autorelease];
    contentRead.delegate=self;
    [contentRead Category];
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag
{
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSDictionary *jsonObj =[parser objectWithString: jsonString];
    
    UIScrollView *scrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 500)]autorelease];
    scrollView.backgroundColor=[UIColor whiteColor];
    scrollView.delegate=self;
    UIView *myView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1000)]autorelease];
    myView.backgroundColor=[UIColor grayColor];
    UIImageView *imageViewTitle=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    imageViewTitle.image=[UIImage imageNamed:@"LeftTitle@2X"];
    [myView addSubview:imageViewTitle];
    UILabel *mainTitle=[[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 320, 60)]autorelease];
    mainTitle.text=@"环球垂钓";
    mainTitle.font = [UIFont boldSystemFontOfSize:20];
    mainTitle.textColor=[UIColor whiteColor];
    [imageViewTitle addSubview:mainTitle];
     //首页
    UIButton *firstBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    firstBtn.frame=CGRectMake(0, 62, 320, 44);
    [firstBtn setImage:[UIImage imageNamed:@"selectOne@2X"] forState:UIControlStateNormal];
    [myView addSubview:firstBtn ];
    UILabel *firstPageName=[[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 320, 44)]autorelease];
    firstPageName.textColor=[UIColor whiteColor];
    firstPageName.text=@"首页";
    [firstBtn  addSubview:firstPageName];
    [firstBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    UIImageView *pictureFistPage=[[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,25 , 25)] autorelease];
    pictureFistPage.image=[UIImage imageNamed:@"firstPage@2X.png"];
    [firstBtn  addSubview:pictureFistPage];
    
    for (int i=0; i<4;i++)
    {
        UIButton *OneButton=[UIButton buttonWithType:UIButtonTypeCustom];
        OneButton.frame=CGRectMake(0, 115+i*45, 320, 44);
        [OneButton setImage:[UIImage imageNamed:@"selectOne@2X"] forState:UIControlStateNormal];
        [myView addSubview:OneButton ];
        UILabel *OneName=[[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 320, 44)]autorelease];
        OneName.textColor=[UIColor whiteColor];
        OneName.text=[NSString stringWithFormat: [[jsonObj  objectAtIndex:i] objectForKey:@"name"]];
        [OneButton addSubview:OneName];
        [OneButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        UIImageView *pictureOneName=[[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,25 , 25)] autorelease];
        pictureOneName.image=[UIImage imageNamed:@"News@2X.png"];
        [OneButton  addSubview:pictureOneName];
        OneButton.tag=[[NSString stringWithFormat: [[jsonObj  objectAtIndex:i] objectForKey:@"id"]]integerValue];
        UIImageView *theRedNum=[[[UIImageView alloc]initWithFrame:CGRectMake(200, 10, 28, 22)]autorelease];
        theRedNum.image=[UIImage imageNamed:@"redBack"];
        [OneButton addSubview:theRedNum];
        UILabel *labelNum=[[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 28, 22)]autorelease];
        labelNum.text=[[jsonObj  objectAtIndex:i] objectForKey:@"id"];
        labelNum.textColor=[UIColor whiteColor];
        labelNum.font  = [UIFont fontWithName:@"Arial" size:12.0];
        [theRedNum addSubview:labelNum];
    }
   //收藏&设置
    for(int i=0;i<2;i++)
    {
        UIButton *OneButton=[UIButton buttonWithType:UIButtonTypeCustom];
        OneButton.frame=CGRectMake(0, 320+i*45, 320, 44);
        [OneButton setImage:[UIImage imageNamed:@"selectOne@2X"] forState:UIControlStateNormal];
        [myView addSubview:OneButton ];
        UILabel *OneName=[[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 320, 44)]autorelease];
        OneName.textColor=[UIColor whiteColor];
        [OneButton addSubview:OneName];
        [OneButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        UIImageView *pictureOneName=[[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,25 , 25)] autorelease];
        if(i==0)
        {
            OneName.text=@"收藏";
            pictureOneName.image=[UIImage imageNamed:@"News@2X.png"];
            OneButton.tag=100;
        }
        else
        {
            OneName.text=@"设置";
            pictureOneName.image=[UIImage imageNamed:@"News@2X.png"];
            OneButton.tag=100;
        }
        [OneButton  addSubview:pictureOneName];
      
    }
    
    
    
    
    
    
    
    
    [scrollView addSubview:myView];
     scrollView.contentSize = myView.frame.size;
    [self.view addSubview:scrollView];
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIButton *main=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    main.frame=CGRectMake(20, 76, 101, 34);
//    main.hidden=NO;
//    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
//    [main setTitle:@"首页" forState:UIControlStateNormal];
//    [main addTarget:self action:@selector(PressMain) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:main];
//    
//    
//    UIButton *news=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    news.frame=CGRectMake(20, 127, 101, 34);
//    news.hidden=NO;
//    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
//    [news setTitle:@"新闻" forState:UIControlStateNormal];
//    [news addTarget:self action:@selector(PressNews) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:news];
//    
//    
//    UIButton *life=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    life.frame=CGRectMake(20, 169, 101, 34);
//    life.hidden=NO;
//    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
//    [life setTitle:@"生活" forState:UIControlStateNormal];
//    [life addTarget:self action:@selector(PressLife) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:life];
//    
//    
//    UIButton *fash=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    fash.frame=CGRectMake(20, 226, 101, 34);
//    fash.hidden=NO;
//    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
//    [fash setTitle:@"潮流" forState:UIControlStateNormal];
//    [fash addTarget:self action:@selector(PressFash) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:fash];
//    
//    UIButton *magazine=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    magazine.frame=CGRectMake(20, 277, 101, 34);
//    magazine.hidden=NO;
//    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
//    [magazine setTitle:@"周刊" forState:UIControlStateNormal];
//    [magazine addTarget:self action:@selector(PressMagazine) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:magazine];
//    
//    UIButton *save=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    save.frame=CGRectMake(20, 326, 101, 34);
//    save.hidden=NO;
//    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
//    [save setTitle:@"收藏" forState:UIControlStateNormal];
//    [save addTarget:self action:@selector(PressSave) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:save];
//    
//    UIButton *set=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    set.frame=CGRectMake(20, 377, 101, 34);
//    set.hidden=NO;
//    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
//    [set setTitle:@"设置" forState:UIControlStateNormal];
//    [set addTarget:self action:@selector(PressSet) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:set];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)PressNews
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        NewsController *apiVC = [[[NewsController alloc] init] autorelease];
        apiVC.target=1;
        UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
        self.viewDeckController.centerController = navApiVC;
        self.view.userInteractionEnabled = YES;
    }];
     [self.navigationController setNavigationBarHidden:YES ];
     

}
-(void)PressMain
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        ViewController *apiVC = [[[ViewController alloc] init] autorelease];
        
        UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
        self.viewDeckController.centerController = navApiVC;
        self.view.userInteractionEnabled = YES;
    }];
}
-(void)PressLife
{
   
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        NewsController *apiVC = [[[NewsController alloc] init] autorelease];
        apiVC.target=1;
        UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
        self.viewDeckController.centerController = navApiVC;
        self.view.userInteractionEnabled = YES;
    }];

}
-(void)PressFash
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        NewsController *apiVC = [[[NewsController alloc] init] autorelease];
        apiVC.target=1;
        UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
        self.viewDeckController.centerController = navApiVC;
        self.view.userInteractionEnabled = YES;
    }];
}
-(void)PressSave
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        SaveViewController *apiVC = [[[SaveViewController alloc] init] autorelease];
        //  apiVC.title = @"XXXXXX";
        UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
        self.viewDeckController.centerController = navApiVC;
        self.view.userInteractionEnabled = YES;
    }];
}
-(void)PressMagazine
{
//    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
//        ProtectViewController *apiVC = [[[ProtectViewController alloc] init] autorelease];
//        apiVC.title = @"收藏杂志";
//        UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
//        self.viewDeckController.centerController = navApiVC;
//        self.view.userInteractionEnabled = YES;
//    }];
//
}
-(void)PressSet
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
       SettingViewController *apiVC = [[[SettingViewController alloc] init] autorelease];
        //  apiVC.title = @"XXXXXX";
        UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
        self.viewDeckController.centerController = navApiVC;
        self.view.userInteractionEnabled = YES;
    }];

}
@end
