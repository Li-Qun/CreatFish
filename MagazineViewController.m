//
//  MagazineViewController.m
//  Fish
//
//  Created by DAWEI FAN on 08/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "MagazineViewController.h"
#import "ReadViewController.h"
@interface MagazineViewController ()

@end

@implementation MagazineViewController
@synthesize  imagView=imagView;
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
    [self.navigationController setNavigationBarHidden:YES];
    [super viewDidLoad];
    //选择按钮
    NSArray *buttonNames = [NSArray arrayWithObjects:@"爱钓鱼", @"钓鱼杂志", nil];
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:buttonNames];
    [segmentedControl setFrame:CGRectMake(10, 410, 298, 112)];
    segmentedControl.selectedSegmentIndex=1;
    //添加事件
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    [segmentedControl release];
    /******************Pic swtith************************/
    imagView=[[UIImageView alloc]init];
    imagView.frame=CGRectMake(17, 63, 286, 339);
    imagView.image=[UIImage imageNamed:[NSString stringWithFormat:@"images-1.jpeg"]];
    [self.view addSubview:imagView];
}
//事件
-(void)segmentAction:(UISegmentedControl *)Seg{
    //text swtich
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Seg.selectedSegmentIndex:%d",Index);
    // switch action
    
    
    if(Index==0)
    {
        imagView.image=[UIImage imageNamed:[NSString stringWithFormat:@"images-1.jpeg"]];
        ReadViewController *newVC = [[[ReadViewController alloc] initWithNibName:@"ReadViewController" bundle:nil]autorelease];
        self.hidesBottomBarWhenPushed = YES;//OK~
        [self.navigationController pushViewController :newVC animated:YES];
        
        
        
    }
    else
    {
        imagView.image=[UIImage imageNamed:[NSString stringWithFormat:@"images-2.jpeg"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [imagView release];
    [super dealloc];
}
@end
