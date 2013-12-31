//
//  RightViewController.m
//  Fish
//
//  Created by liqun on 12/3/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "RightViewController.h"
#import "NewsController.h"
#import "AppDelegate.h"
@interface RightViewController ()

@end

@implementation RightViewController

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
    UIButton *newBtnOne=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    newBtnOne.frame=CGRectMake(138, 81, 125, 34);
    newBtnOne.hidden=NO;
    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
    [newBtnOne setTitle:@"业内动态" forState:UIControlStateNormal];
    [newBtnOne addTarget:self action:@selector(PressOne) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:newBtnOne];
    
    
    UIButton *newBtnTwo=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    newBtnTwo.frame=CGRectMake(138, 159, 125, 34);
    newBtnTwo.hidden=NO;
    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
    [newBtnTwo setTitle:@"赛事报道" forState:UIControlStateNormal];
    [newBtnTwo addTarget:self action:@selector(PressTwo) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:newBtnTwo];
    
    UIButton *newBtnThree=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    newBtnThree.frame=CGRectMake(138, 233, 125, 34);
    newBtnThree.hidden=NO;
    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
    [newBtnThree setTitle:@"大鱼新闻" forState:UIControlStateNormal];
    [newBtnThree addTarget:self action:@selector(PressThree) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:newBtnThree];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)PressOne
{
    [self.viewDeckController closeRightViewBouncing:^(IIViewDeckController *controller) {
        
        NewsController *apiVC = [[[NewsController alloc] init] autorelease];
        if(app.targetCenter==1)
            apiVC.target=5;
        else if(app.targetCenter==2)
            apiVC.target=8;
        else if(app.targetCenter==3)
            apiVC.target=11;
        else apiVC=apiVC;
               UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
        self.viewDeckController.centerController = navApiVC;
        self.view.userInteractionEnabled = YES;
       [self.navigationController setNavigationBarHidden:YES ];
    }];
    

}
-(void)PressTwo
{
    [self.viewDeckController closeRightViewBouncing:^(IIViewDeckController *controller) {
        
        NewsController *apiVC = [[[NewsController alloc] init] autorelease];
        if(app.targetCenter==1)
            apiVC.target=6;
        else if(app.targetCenter==2)
            apiVC.target=9;
        else if(app.targetCenter==3)
            apiVC.target=12;
        else apiVC=apiVC;
        UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
        self.viewDeckController.centerController = navApiVC;
        self.view.userInteractionEnabled = YES;
        [self.navigationController setNavigationBarHidden:YES ];
    }];
}
-(void)PressThree
{
    [self.viewDeckController closeRightViewBouncing:^(IIViewDeckController *controller) {
        
        NewsController *apiVC = [[[NewsController alloc] init] autorelease];
        if(app.targetCenter==1)
            apiVC.target=7;
        else if(app.targetCenter==2)
            apiVC.target=10;
        else if(app.targetCenter==3)
            apiVC.target=13;
        else apiVC=apiVC;
        UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
        self.viewDeckController.centerController = navApiVC;
        self.view.userInteractionEnabled = YES;
        [self.navigationController setNavigationBarHidden:YES ];
    }];
}

@end
