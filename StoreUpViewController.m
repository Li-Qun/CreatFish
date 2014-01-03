//
//  StoreUpViewController.m
//  Fish
//
//  Created by DAWEI FAN on 03/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "StoreUpViewController.h"

@interface StoreUpViewController ()

@end

@implementation StoreUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initData
{
      app_StoreUp = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)viewDidLoad
{
    [self initData];
    [super viewDidLoad];
    tableView_Store=[[UITableView alloc]init];
    tableView_Store.frame=CGRectMake(0, 0, 320, 560);
    tableView_Store.delegate=self;
    tableView_Store.dataSource=self;//设置双重代理 很重要
    [self.view addSubview:tableView_Store];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
