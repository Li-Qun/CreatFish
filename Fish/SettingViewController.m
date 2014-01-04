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
    [self.navigationController setToolbarHidden:YES];
    self.view.backgroundColor=[UIColor grayColor];
    navBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 17, 320, 44)]autorelease];
    [navBar setBackgroundImage:[UIImage imageNamed:@"set_Nav@2x.png"] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navigationItem = [[[UINavigationItem alloc] init ]autorelease];
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"路亚中国"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    navigationItem.titleView = customLab;
    [navBar pushNavigationItem:navigationItem animated:YES];
    [self.view addSubview:navBar];
    [customLab release];
    
    
    UIButton *fash=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    fash.frame=CGRectMake(20, 226, 101, 34);
    fash.hidden=NO;
    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
    [fash setTitle:@"潮流" forState:UIControlStateNormal];
    [fash addTarget:self action:@selector(Press_set) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:fash];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];// Dispose of any resources that can be recreated.
}

@end
