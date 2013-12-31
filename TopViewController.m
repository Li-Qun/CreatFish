//
//  TopViewController.m
//  SlideViewTest
//
//  Created by Nancy on 13-7-11.
//  Copyright (c) 2013年 Nancy. All rights reserved.
//

#import "TopViewController.h"
#import "Top_1_ViewController.h"
#import "IIViewDeckController.h"
@interface TopViewController ()

@end

@implementation TopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)goToSubView:(id)sender
{
    [self.viewDeckController closeTopViewBouncing:^(IIViewDeckController *controller)
     {
        Top_1_ViewController *apiVC = [[[Top_1_ViewController alloc] init] autorelease];
        apiVC.title = @"顶部子视图";
        UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
        self.viewDeckController.centerController = navApiVC;
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [leftBtn setTitle:@"Click Me" forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    leftBtn.frame = CGRectMake((320-100)/2, (460-30.0-44)/2, 100.0, 30.0);
    [leftBtn addTarget:self action:@selector(goToSubView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
