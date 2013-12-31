//
//  ViewController.m
//  Fish
//
//  Created by liqun on 12/3/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "ViewController.h"
#import "IIViewDeckController.h"
#import "NewViewController.h"

#import "MagazineViewController.h"
#import "SaveViewController.h"



#import "NewsController.h"
#import "LifeViewController.h"


#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize momentData=momentData;
@synthesize categoryItem=categoryItem;
@synthesize contentRead=contentRead;
@synthesize klpImgArr;
@synthesize klpScrollView1,klpScrollView2;
- (void)viewWillAppear:(BOOL)animated
{//视图即将可见时调用。默认情况下不执行任何操作
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES ];//把后面的antimated=YES 去掉 就不会过渡出现问题了

    
}
-(void)getJsonString:(NSString *)jsonString
{
    app.jsonString=jsonString;
    
  //  NSLog(@"XX%@",app.jsonString);
}
-(void)_init
{
    contentRead =[[ContentRead alloc]init];
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app build ];
   //通过KEY找到value
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
     [self.navigationController setNavigationBarHidden:YES ];
    self.navigationController.navigationBarHidden=YES;
    [self _init];
    /******************toolBar************************/
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 460-44, 320, 44) ];
   
    UIBarButtonItem *New=[[UIBarButtonItem alloc]initWithTitle:@"资讯" style:UIBarButtonItemStyleBordered target:self action:@selector(pressNew)];
    
    UIBarButtonItem * Life = [[UIBarButtonItem  alloc]initWithTitle:@"生活" style: UIBarButtonItemStyleBordered target:self action:@selector(pressLife)];
    UIBarButtonItem *Style=[[UIBarButtonItem alloc]initWithTitle:@"潮流" style:UIBarButtonItemStyleBordered target:self action:@selector(pressStyle)];
    UIBarButtonItem *Paper=[[UIBarButtonItem alloc]initWithTitle:@"周刊" style:UIBarButtonItemStyleBordered target:self action:@selector(pressPaper)];
    UIBarButtonItem *Save=[[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStyleBordered target:self action:@selector(pressSave)];
    
    UIBarButtonItem * flexibleItem =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    self.view.backgroundColor=[UIColor whiteColor];
    NSArray *itemsArry=[NSArray arrayWithObjects:New,flexibleItem, Life,flexibleItem,Style ,flexibleItem,Paper,flexibleItem,Save,nil];
    [self setToolbarItems:itemsArry animated:YES ];
    [toolBar setItems:itemsArry];
    toolBar.barStyle =[UIColor blackColor];
    [self.navigationController  setToolbarHidden:NO ];//animated:YES
    //   [self.view addSubview:toolBar];
    
    [New release];
    [flexibleItem release];
    [Life release];
    [Style release];
    [Paper release];
    [Save release];
    [toolBar release];
    
    
    /******************toolBar************************/
    
    ///UIScrollerView
    index = 0;
	klpArr = [NSArray arrayWithObjects:@"images-1.jpeg",@"images-2.jpeg",@"images-3.jpeg",@"images-4.jpeg",@"images-5.jpeg",@"images-6.jpeg",@"images-1.jpeg"
              ,@"images-2.jpeg",@"images-3.jpeg",@"images-4.jpeg",@"images-5.jpeg",@"images-6.jpeg",nil];
	self.klpImgArr = [[NSMutableArray alloc] initWithCapacity:12];
    CGSize size = self.klpScrollView1.frame.size;
	for (int i=0; i < [klpArr count]; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(size.width * i, 0, size.width, size.height)];
        [iv setImage:[UIImage imageNamed:[klpArr objectAtIndex:i]]];
        [self.klpScrollView1 addSubview:iv];
        iv = nil;
    }
	[self.klpScrollView1 setContentSize:CGSizeMake(size.width * 12, size.height)];
	
	self.klpScrollView1.pagingEnabled = YES;
    self.klpScrollView1.showsHorizontalScrollIndicator = NO;
	
	CGSize size2 = self.klpScrollView2.frame.size;
	for (int i=0; i<12; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(100*i + 5*i,0,100,70)];
        [iv setImage:[UIImage imageNamed:[klpArr objectAtIndex:i]]];
		[self.klpScrollView2 addSubview:iv];
        [self.klpImgArr addObject:iv];
        iv = nil;
    }
    [self.klpScrollView2 setContentSize:CGSizeMake(100 * 12 + 60, size2.height)];
	
    klp = [[klpView alloc] initWithFrame:((UIImageView*)[self.klpImgArr objectAtIndex:index]).frame];
	[self.klpScrollView2 addSubview:klp];
	
	//self.klpScrollView2.pagingEnabled = YES;
    
    
   self.klpScrollView2.showsHorizontalScrollIndicator = NO;

	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    
    [self.klpScrollView1 addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *smallImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
    [smallImageTap setNumberOfTapsRequired:1];
    [self.klpScrollView2 addGestureRecognizer:smallImageTap];
    ///UIScrollerView

}
//-(void)dealloc{
//	[klpScrollView1 release];
//	[klpScrollView2 release];
//	
//	[klpImgArr release];
//    [klpScrollView1 release];
//    [klpScrollView2 release];
//	[super dealloc];
//}
#pragma mark-- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{\
	//NSLog(@"scrollViewDidScroll");
	if (scrollView == self.klpScrollView1) {
		CGFloat pageWidth = scrollView.frame.size.width;
		int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		index = page;
	}else {
		
	}
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //	NSLog(@"scrollViewWillBeginDragging");
	if (scrollView == self.klpScrollView1) {
		
	}else {
		
	}
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	//NSLog(@"scrollViewDidEndDecelerating");
	if (scrollView == self.klpScrollView1) {
		klp.frame = ((UIImageView*)[self.klpImgArr objectAtIndex:index]).frame;
		[klp setAlpha:0];
		[UIView animateWithDuration:0.2f animations:^(void){
			[klp setAlpha:.85f];
		}];
		[self.klpScrollView2 setContentOffset:CGPointMake(klp.frame.origin.x, 0) animated:YES];
	}else {
		
	}
}

#pragma mark 手势
- (void) handleSingleTap:(UITapGestureRecognizer *) gestureRecognizer{
	CGFloat pageWith = 320;
    
    CGPoint loc = [gestureRecognizer locationInView:self.klpScrollView1];
    NSInteger touchIndex = floor(loc.x / pageWith) ;
    if (touchIndex > 11) {
        return;
    }
    NSLog(@"touch index %d",touchIndex);
}
- (void) handleImageTap:(UITapGestureRecognizer *) gestureRecognizer{
	CGFloat rowHeight = 70;
    CGFloat columeWith = 100;
    CGFloat gap = 5;
    
    CGPoint loc = [gestureRecognizer locationInView:self.klpScrollView2];
    NSInteger touchIndex = floor(loc.x / (columeWith + gap)) + 3 * floor(loc.y / (rowHeight + gap)) ;
    if (touchIndex > 11) {
        return;
    }
    index = touchIndex;
    CGRect frame = self.klpScrollView1.frame;
    frame.origin.x = frame.size.width * touchIndex;
    frame.origin.y = 0;
    [self.klpScrollView1 scrollRectToVisible:frame animated:NO];
    
    klp.frame = ((UIImageView*)[self.klpImgArr objectAtIndex:index]).frame;
    [klp setAlpha:0];
    [UIView animateWithDuration:0.2f animations:^(void){
        [klp setAlpha:.85f];
    }];
	[self.klpScrollView2 setContentOffset:CGPointMake(klp.frame.origin.x, 0) animated:YES];
    NSLog(@"small image touch index %d",touchIndex);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/******Button Press*******/

-(void)clickLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickRightButton
{
     [self.viewDeckController toggleRightViewAnimated:YES];
}

-(void)pressNew
{
    NewsController *newVC = [[[NewsController alloc] initWithNibName:@"NewsController" bundle:nil]autorelease];
    //newVC.hidesBottomBarWhenPushed = YES;
    newVC.target=1;
    [self.navigationController pushViewController :newVC animated:YES];
    //[self.navigationController setToolbarHidden:YES animated:YES];
}
-(void)pressLife
{
    NewsController *newVC = [[[NewsController alloc] initWithNibName:@"NewsController" bundle:nil]autorelease];
    //newVC.hidesBottomBarWhenPushed = YES;
    newVC.target=2;
    [self.navigationController pushViewController :newVC animated:YES];
 
}
-(void)pressStyle
{
    NewsController *newVC = [[[NewsController alloc] initWithNibName:@"NewsController" bundle:nil]autorelease];
    //newVC.hidesBottomBarWhenPushed = YES;
    newVC.target=3;
    [self.navigationController pushViewController :newVC animated:YES];
}
-(void)pressPaper
{
    LifeViewController *newVC = [[[LifeViewController alloc] initWithNibName:@"LifeViewController" bundle:nil]autorelease];
     newVC.target=4;
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController :newVC animated:YES];
}
-(void)pressSave
{
    SaveViewController *newVC = [[[SaveViewController alloc] initWithNibName:@"SaveViewController" bundle:nil]autorelease];
    self.hidesBottomBarWhenPushed = YES;//OK~
    [self.navigationController pushViewController :newVC animated:YES];

}
/******Button Press*******/
@end
