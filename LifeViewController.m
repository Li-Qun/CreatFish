//
//  LifeViewController.m
//  Fish
//
//  Created by DAWEI FAN on 23/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "LifeViewController.h"
#import "AppDelegate.h"
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       wrap = YES;
       isTheLeft=1;
    }
    return self;
}
- (void)dealloc
{
    [carousel release];
    [super dealloc];
}
- (void)viewDidLoad
{//@"直线", @"圆圈", @"反向圆圈", @"圆桶", @"反向圆桶", @"封面展示", @"封面展示2", @"纸牌"

    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    //[self.navigationController setToolbarHidden:YES animated:YES];//好使了
    
    
    //设置索引标识
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   // app.jsonString=jsonString;
   // NSLog(@"name %@", [[app.array objectAtIndex  :target ]objectForKey:@"name"]);
    MagId=[[app.array objectAtIndex  :target ]objectForKey:@"id"];
    MagName=[[app.array objectAtIndex  :target ]objectForKey:@"name"];
    MagPid=[[app.array objectAtIndex  :target ]objectForKey:@"pid"];
    MagImage=[[app.array objectAtIndex  :target ]objectForKey:@"image"];
    MagLevel=[[app.array objectAtIndex  :target ]objectForKey:@"level"];
    MagFlag=[[app.array objectAtIndex  :target ]objectForKey:@"flag"];
    
    
    
    UIBarButtonItem *Left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style: UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem * flexibleItem =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    NSArray *itemsArry=[[NSArray arrayWithObjects: Left,flexibleItem,nil]retain];//此处如果不retain
    [self setToolbarItems:itemsArry animated:YES ];
    
    [self.tabBarController setItems:itemsArry];
    [self.view addSubview:self.tabBarController];
    [Left release];
    [flexibleItem release];
    [itemsArry release];
    
    
    
    
    
    
    
    //设置按钮start
    left=[UIButton buttonWithType:UIButtonTypeCustom];
    left.frame=CGRectMake(20, 433, 129, 34);
    
    [left setBackgroundImage:[UIImage imageNamed:@"selectButtonNormal.png"]  forState:UIControlStateNormal];
    [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     [left setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [left setTitle:@"路亚中国" forState:UIControlStateNormal];
    [left setTitle:@"路亚中国" forState:UIControlStateHighlighted];
    [left addTarget:self action:@selector(Pressleft) forControlEvents:UIControlEventTouchDown];
    [left setBackgroundImage:[UIImage imageNamed:@"selectedButton.png"] forState:UIControlStateHighlighted ];
    [self.view addSubview:left];
    
    //////
    
    right=[UIButton buttonWithType:UIButtonTypeCustom];
    right.frame=CGRectMake(157, 433, 129, 34);
 
    [right setBackgroundImage:[UIImage imageNamed:@"selectButtonNormal.png"]  forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [right setTitle:@"钓鱼" forState:UIControlStateNormal];
    [right setTitle:@"钓鱼" forState:UIControlStateHighlighted];
    [right addTarget:self action:@selector(Pressright) forControlEvents:UIControlEventTouchDown];
    [right setBackgroundImage:[UIImage imageNamed:@"selectedButton.png"] forState:UIControlStateHighlighted ];
    [self.view addSubview:right];
    //设置按钮end
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

 
}
-(void)Pressleft
{
    isTheLeft=0;
    left.frame=CGRectMake(20, 433, 129, 34);
    [left setBackgroundImage:[UIImage imageNamed:@"selectedButton.png"]  forState:UIControlStateNormal];
    right.frame=CGRectMake(157, 433, 129, 34);
    [right setBackgroundImage:[UIImage imageNamed:@"selectButtonNormal.png"]  forState:UIControlStateNormal];
  //  [self re];
    
    [self.carousel reloadData];
}
-(void)Pressright
{
    isTheLeft=1;
    left.frame=CGRectMake(20, 433, 129, 34);
    [left setBackgroundImage:[UIImage imageNamed:@"selectButtonNormal.png"]  forState:UIControlStateNormal];
    right.frame=CGRectMake(157, 433, 129, 34);
    [right setBackgroundImage:[UIImage imageNamed:@"selectedButton.png"]  forState:UIControlStateNormal];
    [self.carousel reloadData];
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
    return 30;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    NSLog(@"%d",isTheLeft);
    if(isTheLeft==0)
    {
        view1 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",index ]]] autorelease];
        view1.frame = CGRectMake(70, 80, 280, 346);
        view1.layer.shadowColor = [UIColor blackColor].CGColor;
        view1.layer.shadowOpacity = 1.0;
        view1.layer.shadowRadius = 5.0;
        view1.layer.shadowOffset = CGSizeMake(1, 1);
        view1.clipsToBounds = NO;
        return view1;
    }
    else //if(isTheLeft==1)
    {
        view2 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"face.png" ]]] autorelease];
        view2.frame = CGRectMake(70, 80, 280, 346);
        view2.layer.shadowColor = [UIColor blackColor].CGColor;
        view2.layer.shadowOpacity = 1.0;
        view2.layer.shadowRadius = 5.0;
        view2.layer.shadowOffset = CGSizeMake(1, 1);
        view2.clipsToBounds = NO;
        return view2;
    }
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return 30;
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
    NSLog(@"%d",index);
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
