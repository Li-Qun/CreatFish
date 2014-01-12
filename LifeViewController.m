//
//  LifeViewController.m
//  Fish
//
//  Created by DAWEI FAN on 23/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "LifeViewController.h"
#import "AppDelegate.h"
#import "FishCore.h"
#import "MagDetaiViewController.h"
#define ITEM_SPACING 200
@interface LifeViewController ()

@end

@implementation LifeViewController
@synthesize MagFlag=MagFlag;
@synthesize MagId=MagId;
@synthesize MagImage=MagImage;
@synthesize MagPid=MagPid;
@synthesize MagName=MagName;
@synthesize target=target;
@synthesize carousel;
@synthesize wrap;
@synthesize contentRead=contentRead;
@synthesize arry_Mag_category_id=arry_Mag_category_id;
@synthesize arry_Mag_description=arry_Mag_description;
@synthesize arry_Mag_image=arry_Mag_image;
@synthesize leftSwipeGestureRecognizer,rightSwipeGestureRecognizer;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       wrap = YES;
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SwimFish@2X.png"]];
        imgView.frame = self.view.bounds;
        imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view insertSubview:imgView atIndex:0];
        [imgView release];
        
        self.navigationController.toolbarHidden = YES;
        self.navigationController.navigationBarHidden=YES;
        
       
    }
    return self;
}
- (void)dealloc
{
    [carousel release];
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat height = size.height;
    
    
    if(height==480)
    {
        isFive=NO;
    }else isFive=YES;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version <7.0)
        isSeven=NO;
    else isSeven=YES;
    

    if(isSeven&&isFive)
    {
        heightTopbar=65;
        littleHeinght=20;
    }
    else if(isSeven&&!isFive)
    {
        heightTopbar=58;
        littleHeinght=20;
    }else if(!isSeven&&isFive)//
    {
        heightTopbar=45;
        littleHeinght=10;
    }else {
        heightTopbar=45;
        littleHeinght=10;
    }
    
    UIImageView *topBarView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, heightTopbar)]autorelease];
    topBarView.image=[UIImage imageNamed:@"topBarRed"];
    [self.view addSubview:topBarView];
    
    UIImageView *wordView=[[[UIImageView alloc]initWithFrame:CGRectMake(135, littleHeinght+2, 40, 20)]autorelease];
    wordView.image=[UIImage imageNamed:@"swimWordLabel"];
    [topBarView addSubview:wordView];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(10, littleHeinght, 37, 30);
    leftBtn.tag=10;
    [leftBtn setImage:[UIImage imageNamed:@"LeftBtn@2X"] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(SwimSwitch_BtnTag:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(270, littleHeinght, 37, 30);
    [rightBtn setImage:[UIImage imageNamed:@"RightBtn@2X"] forState:UIControlStateNormal];
    [self.view addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(SwimSwitch_BtnTag:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag=20;
    
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag
{
    self.navigationController.navigationBarHidden=YES;

    //设置索引标识
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    MagId=[[app.array objectAtIndex  :target ]objectForKey:@"id"];
    MagName=[[app.array objectAtIndex  :target ]objectForKey:@"name"];
    MagPid=[[app.array objectAtIndex  :target ]objectForKey:@"pid"];
    MagImage=[[app.array objectAtIndex  :target ]objectForKey:@"image"];
    MagLevel=[[app.array objectAtIndex  :target ]objectForKey:@"level"];
    MagFlag=[[app.array objectAtIndex  :target ]objectForKey:@"flag"];
    
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSDictionary *jsonObj =[parser objectWithString:jsonString];
    total = [[jsonObj objectForKey:@"total"] intValue];
    NSLog(@"total : %d",total);
    NSDictionary *data = [jsonObj objectForKey:@"data"];
    for(int i=0;i<data.count;i++)
    {
        [arry_Mag_description insertObject:[data objectAtIndex:i] atIndex: i];
        [arry_Mag_category_id insertObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i]objectForKey:@"id"]] atIndex:i];
      //  [arry_Mag_description insertObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i]objectForKey:@"description"]] atIndex:i];
        [arry_Mag_image insertObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i]objectForKey:@"image"]] atIndex:i];
    }
    carousel.delegate = self;
    carousel.dataSource = self;
    
    carousel.type = iCarouselTypeCoverFlow;
    for (UIView *view in carousel.visibleItemViews)
    {
        view.alpha = 1.0;
    }
    [UIView beginAnimations:nil context:nil];
    carousel.type=5;
    [UIView commitAnimations];
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self.viewDeckController toggleRightViewAnimated:YES];

            }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.viewDeckController toggleLeftViewAnimated:YES];

           }
}
- (void)viewDidLoad
{//@"直线", @"圆圈", @"反向圆圈", @"圆桶", @"反向圆桶", @"封面展示", @"封面展示2", @"纸牌"
    
    arry_Mag_image=[[NSMutableArray alloc]init];
    arry_Mag_category_id=[[NSMutableArray alloc]init];
    arry_Mag_description=[[NSMutableArray alloc]init];
    contentRead =[[[ContentRead alloc]init]autorelease];
    [contentRead setDelegate:self];//设置代理
    [contentRead Magazine:@"14" Out:@"0"];
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    
  
}
-(void)SwimSwitch_BtnTag:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag==10)
        [self.viewDeckController toggleLeftViewAnimated:YES];
    else [self.viewDeckController toggleRightViewAnimated:YES];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.carousel = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return  total;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    view1 = [[[UIImageView alloc] init ] autorelease];
    NSDictionary* dict = [arry_Mag_description objectAtIndex:(index)];
     NSString *imgURL=[NSString stringWithFormat:@"http://42.96.192.186/ifish/server/upload/%@",[dict objectForKey:@"image"]];
    UIImageView *ImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, -littleHeinght*4, 280, 350-littleHeinght*4)]autorelease];
    [ImageView  setImageWithURL:[NSURL URLWithString: imgURL]
               placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                        success:^(UIImage *image) {NSLog(@"OK");}
                        failure:^(NSError *error) {NSLog(@"NO");}];

    
    [view1 addSubview:ImageView];
    UILabel *label=[[[UILabel alloc]initWithFrame:CGRectMake(0, 350-littleHeinght*8, 280, 150)]autorelease];
    label.text=[dict objectForKey:@"description"];
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];

    label.layer.shadowColor = [UIColor whiteColor].CGColor;
//    label.layer.shadowOpacity = 1.0;
//    label.layer.shadowRadius = 5.0;
//    label.layer.shadowOffset = CGSizeMake(1, 1);
//    label.clipsToBounds = NO;
//    
    [view1 addSubview:label];
    view1.frame = CGRectMake(0, -littleHeinght*6, 280, 400-littleHeinght*6);
    view1.layer.shadowColor = [UIColor blackColor].CGColor;
    view1.layer.shadowOpacity = 1.0;
    view1.layer.shadowRadius = 5.0;
    view1.layer.shadowOffset = CGSizeMake(1, 1);
    view1.clipsToBounds = NO;
    return view1;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return total;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index;
{
    MagDetaiViewController *detail=[[MagDetaiViewController alloc]initWithNibName:@"MagDetaiViewController" bundle:nil];
    NSDictionary* dict = [arry_Mag_description objectAtIndex:(index)];
    detail.Id=[dict objectForKey:@"category_id"];
    detail.weeklyId=[dict objectForKey:@"id"];
    detail.name_Mag=[dict objectForKey:@"name"];
    [self.navigationController pushViewController:detail animated:YES];
    
}
- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return wrap;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
