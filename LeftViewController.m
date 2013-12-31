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
#import "ProtectViewController.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIButton *main=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    main.frame=CGRectMake(20, 76, 101, 34);
    main.hidden=NO;
    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
    [main setTitle:@"首页" forState:UIControlStateNormal];
    [main addTarget:self action:@selector(PressMain) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:main];

    
    UIButton *news=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    news.frame=CGRectMake(20, 127, 101, 34);
    news.hidden=NO;
    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
    [news setTitle:@"新闻" forState:UIControlStateNormal];
    [news addTarget:self action:@selector(PressNews) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:news];
    
    
    UIButton *life=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    life.frame=CGRectMake(20, 169, 101, 34);
    life.hidden=NO;
    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
    [life setTitle:@"生活" forState:UIControlStateNormal];
    [life addTarget:self action:@selector(PressLife) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:life];

    
    UIButton *fash=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    fash.frame=CGRectMake(20, 226, 101, 34);
    fash.hidden=NO;
    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
    [fash setTitle:@"潮流" forState:UIControlStateNormal];
    [fash addTarget:self action:@selector(PressFash) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:fash];

    UIButton *magazine=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    magazine.frame=CGRectMake(20, 277, 101, 34);
    magazine.hidden=NO;
    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
    [magazine setTitle:@"周刊" forState:UIControlStateNormal];
    [magazine addTarget:self action:@selector(PressMagazine) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:magazine];

    UIButton *save=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    save.frame=CGRectMake(20, 326, 101, 34);
    save.hidden=NO;
    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
    [save setTitle:@"收藏" forState:UIControlStateNormal];
    [save addTarget:self action:@selector(PressSave) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:save];
    
    UIButton *set=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    set.frame=CGRectMake(20, 377, 101, 34);
    set.hidden=NO;
    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
    [set setTitle:@"设置" forState:UIControlStateNormal];
    [set addTarget:self action:@selector(PressSet) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:set];
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
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        ProtectViewController *apiVC = [[[ProtectViewController alloc] init] autorelease];
        apiVC.title = @"收藏杂志";
        UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
        self.viewDeckController.centerController = navApiVC;
        self.view.userInteractionEnabled = YES;
    }];

}
-(void)PressSet
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
       ProtectViewController *apiVC = [[[ProtectViewController alloc] init] autorelease];
        //  apiVC.title = @"XXXXXX";
        UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
        self.viewDeckController.centerController = navApiVC;
        self.view.userInteractionEnabled = YES;
    }];

}
@end
