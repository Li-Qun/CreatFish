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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       wrap = YES;
    }
    return self;
}
- (void)dealloc
{
    [carousel release];
    [super dealloc];
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag
{
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
    //[self.navigationController setToolbarHidden:YES animated:YES];//好使了
    
    UIBarButtonItem *Left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style: UIBarButtonItemStylePlain target:self action:@selector(pressBack_Mag)];
    
    UIBarButtonItem * flexibleItem =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    NSArray *itemsArry=[[NSArray arrayWithObjects: Left,flexibleItem,nil]retain];//此处如果不retain
    [self setToolbarItems:itemsArry animated:YES ];
    
    [self.tabBarController setItems:itemsArry];
    [self.view addSubview:self.tabBarController];
    [Left release];
    [flexibleItem release];
    [itemsArry release];
}
-(void)pressBack_Mag
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSDictionary* dict = [arry_Mag_description objectAtIndex:(index)];
    view1 = [[[UIImageView alloc] init ] autorelease];
    NSString *imgURL=[NSString stringWithFormat:@"http://42.96.192.186/ifish/server/upload/%@",[dict objectForKey:@"image"]];
    [view1 setImageWithURL:[NSURL URLWithString: imgURL]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                          success:^(UIImage *image) {NSLog(@"OK");}
                          failure:^(NSError *error) {NSLog(@"NO");}];
    UILabel *label=[[[UILabel alloc]initWithFrame:CGRectMake(0, 300, 280, 55)]autorelease];
    label.text=[dict objectForKey:@"description"];
    label.textColor=[UIColor blueColor];
    label.backgroundColor=[UIColor whiteColor];
    label.layer.shadowColor = [UIColor blackColor].CGColor;
    label.layer.shadowOpacity = 1.0;
    label.layer.shadowRadius = 5.0;
    label.layer.shadowOffset = CGSizeMake(1, 1);
    label.clipsToBounds = NO;

    [view1 addSubview:label];
    view1.frame = CGRectMake(70, 80, 280, 346);
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
