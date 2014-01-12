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
    UIImageView *imageViewTitle=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    imageViewTitle.image=[UIImage imageNamed:@"LeftTitle@2X"];
    [myView addSubview:imageViewTitle];
    UILabel *mainTitle=[[[UILabel alloc]initWithFrame:CGRectMake(145, 0, 320, 45)]autorelease];
    mainTitle.text=@"最新";
    mainTitle.font = [UIFont boldSystemFontOfSize:17];
    mainTitle.textColor=[UIColor whiteColor];
    [imageViewTitle addSubview:mainTitle];
    UIImageView *pictureName=[[[UIImageView alloc]initWithFrame:CGRectMake(90, 45/3,20 , 20)] autorelease];
    pictureName.image=[UIImage imageNamed:@"Set.png"];
    [imageViewTitle addSubview:pictureName];
    mainTitle.backgroundColor=[UIColor clearColor];
    //三个 二级按钮
    for(int i=0;i<3;i++)
    {
        UIButton *OneButton=[UIButton buttonWithType:UIButtonTypeCustom];
        OneButton.frame=CGRectMake(0, 45+i*45, 320, 44);
        [OneButton setImage:[UIImage imageNamed:@"selectOne@2X"] forState:UIControlStateNormal];
        [myView addSubview:OneButton ];
        UILabel *OneName=[[[UILabel alloc]initWithFrame:CGRectMake(145, 0, 320, 44)]autorelease];
        OneName.textColor=[UIColor whiteColor];
        OneName.text=[NSString stringWithFormat: [[jsonObj  objectAtIndex:i+4] objectForKey:@"name"]];
        [OneButton addSubview:OneName];
        [OneButton addTarget:self action:@selector(PessSwitchRight_Tag:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *pictureOneName=[[[UIImageView alloc]initWithFrame:CGRectMake(90, 10,25 , 25)] autorelease];
        pictureOneName.image=[UIImage imageNamed:@"News@2X.png"];
        [OneButton  addSubview:pictureOneName];
        OneButton.tag=[[NSString stringWithFormat: [[jsonObj  objectAtIndex:i+4] objectForKey:@"id"]]integerValue];
        OneName.backgroundColor=[UIColor clearColor];
        OneButton.backgroundColor=[UIColor clearColor];
//        UIImageView *theRedNum=[[[UIImageView alloc]initWithFrame:CGRectMake(270, 10, 28, 22)]autorelease];
//        theRedNum.image=[UIImage imageNamed:@"redBack.png"];
//        [OneButton addSubview:theRedNum];
//        UILabel *labelNum=[[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 28, 22)]autorelease];
//        labelNum.text=[[jsonObj  objectAtIndex:i] objectForKey:@"id"];
//        labelNum.textColor=[UIColor whiteColor];
//        labelNum.font  = [UIFont fontWithName:@"Arial" size:12.0];
//        [theRedNum addSubview:labelNum];
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
    [self.viewDeckController closeRightViewBouncing:^(IIViewDeckController *controller) {
        NewsController *apiVC = [[[NewsController alloc] init] autorelease];
        apiVC.target=btn.tag;
        UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:apiVC] autorelease];
        self.viewDeckController.centerController = navApiVC;
        self.view.userInteractionEnabled = YES;
    }];
    

    
    
    
        
        
        
 }
 
@end
