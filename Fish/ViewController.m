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
#import "StoreUpViewController.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize categoryItem=categoryItem;
@synthesize contentRead=contentRead;
@synthesize klpImgArr;
@synthesize klpScrollView1,klpScrollView2;
- (void)viewWillAppear:(BOOL)animated
{//视图即将可见时调用。默认情况下不执行任何操作
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES ];//把后面的antimated=YES 去掉 就不会过渡出现问题了
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    height_Momente = size.height;
    if(height_Momente==480){
        height=20;
        height5_flag=NO;
    }else  height5_flag=YES;
    // 判断设备的iOS 版本号
  float  version = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSLog(@"%f",version);
    if(version==7.0)
    {
 
        Kind7=YES;
    }
    else Kind7=NO;
    
}
-(void)BuildFirstPage
{
    [contentRead ContentSetting];
    [contentRead Category];
}
-(void)_init
{
    contentRead =[[ContentRead alloc]init];
    contentRead.delegate=self;
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app build];
   //通过KEY找到value
    [self BuildFirstPage];
}
-(void)reBack:(NSString *)jsonString
{
    //NSLog(@"%@",jsonString);
//    /******************toolBar************************/
//    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 460-44, 320, 44) ];
//    
//    UIBarButtonItem *New=[[UIBarButtonItem alloc]initWithTitle:@"资讯" style:UIBarButtonItemStyleBordered target:self action:@selector(pressNew)];
//    
//    UIBarButtonItem * Life = [[UIBarButtonItem  alloc]initWithTitle:@"生活" style: UIBarButtonItemStyleBordered target:self action:@selector(pressLife)];
//    UIBarButtonItem *Style=[[UIBarButtonItem alloc]initWithTitle:@"潮流" style:UIBarButtonItemStyleBordered target:self action:@selector(pressStyle)];
//    UIBarButtonItem *Paper=[[UIBarButtonItem alloc]initWithTitle:@"周刊" style:UIBarButtonItemStyleBordered target:self action:@selector(pressPaper)];
//    UIBarButtonItem *Save=[[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStyleBordered target:self action:@selector(pressSave)];
//    
//    UIBarButtonItem * flexibleItem =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    
//    self.view.backgroundColor=[UIColor whiteColor];
//    NSArray *itemsArry=[NSArray arrayWithObjects:New,flexibleItem, Life,flexibleItem,Style ,flexibleItem,Paper,flexibleItem,Save,nil];
//    [self setToolbarItems:itemsArry animated:YES ];
//    [toolBar setItems:itemsArry];
//    toolBar.barStyle =[UIColor blackColor];
//    [self.navigationController  setToolbarHidden:NO ];//animated:YES
//    //   [self.view addSubview:toolBar];
//    
//    [New release];
//    [flexibleItem release];
//    [Life release];
//    [Style release];
//    [Paper release];
//    [Save release];
//    [toolBar release];
//    
//    
//    /******************toolBar************************/

//    UIImageView *imgToolView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 524, 320, 44)]autorelease];
//    imgToolView.image=[UIImage imageNamed:@"toolBar@2X.png"];
//    [self.view addSubview:imgToolView];
//    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
//    NSDictionary *jsonObj =[parser objectWithString: jsonString];
//   // NSLog(@"%@",[jsonObj  objectAtIndex:0] );
// //  [dict objectForKey:@"category_id"];
//    
//    for(int i=0;i<5;i++)
//    {
//        NSString *name=[[[NSString alloc]init]autorelease];
//        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//        if(i<4)
//        {
//            name= [NSString stringWithFormat: [[jsonObj  objectAtIndex:i] objectForKey:@"name"]];
//            button.tag=[[[jsonObj  objectAtIndex:i] objectForKey:@"id"]integerValue];
//        }
//        else {
//            name= [NSString stringWithFormat:@"收藏"];
//            button.tag=100;
//        }
//      
//       
//        button.frame=CGRectMake(10+i*60, 5+524, 30, 40);
//        button.showsTouchWhenHighlighted = YES;
//        [button addTarget:self action:@selector(Press_Tag:) forControlEvents:UIControlEventTouchDown];
//        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
//        label.text=name;
//        label.font  = [UIFont fontWithName:@"Arial" size:15.0];
//        UILabel *labelNum=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 28, 25)];
//        labelNum.text=[NSString stringWithFormat: [[jsonObj  objectAtIndex:i] objectForKey:@"id"]];
//        labelNum.font  = [UIFont fontWithName:@"Arial" size:12.0];
//        labelNum.textColor=[UIColor whiteColor];
//        UIImageView *imgViewRed=[[[UIImageView alloc]initWithFrame:CGRectMake(30, 7, 28, 25)]autorelease];
//        imgViewRed.image=[UIImage imageNamed:@"redBack.png"];
//        [imgViewRed addSubview:labelNum];
//        [button addSubview:imgViewRed];
//        [button addSubview:label];
//      //  [imgToolView addSubview:button];
//        [self.view addSubview:button];
//        [label release];
//    }
    
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag
{
    [self theTopBar];
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSDictionary *jsonObj =[parser objectWithString: jsonString];
   

    if([flag integerValue]==0)
    {
        
        NSDictionary *data = [jsonObj objectForKey:@"home_image"];
        for (int i =0; i <data.count; i++) {
            [app.firstPageImage insertObject:[data objectAtIndex:i] atIndex: i];
        }
        ///UIScrollerView
        index = 0;
        self.klpImgArr = [[NSMutableArray alloc] initWithCapacity:app.firstPageImage.count];
        CGSize size = self.klpScrollView1.frame.size;
        if(height_Momente==480)  height=20;
        for (int i=0; i < [app.firstPageImage count]; i++) {
            UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(size.width * i, 0, size.width, size.height+height)]autorelease];
            //  [iv setImage:[UIImage imageNamed:[app.firstPageImage objectAtIndex:i]]];
            NSString *imgURL=[NSString stringWithFormat:@"http://42.96.192.186/ifish/server/upload/%@",[app.firstPageImage objectAtIndex:i]];
            [iv setImageWithURL:[NSURL URLWithString: imgURL]
               placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                        success:^(UIImage *image) {NSLog(@"OK");}
                        failure:^(NSError *error) {NSLog(@"NO");}];
            [self.klpScrollView1 addSubview:iv];
            iv = nil;
            
        }
        [self.klpScrollView1 setContentSize:CGSizeMake(size.width * app.firstPageImage.count, 0)];//只可横向滚动～
        
        self.klpScrollView1.pagingEnabled = YES;
        self.klpScrollView1.showsHorizontalScrollIndicator = NO;
        //往数组里添加成员
        for (int i=0; i<app.firstPageImage.count; i++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(100*i + 5*i,0,100,70)];
            [iv setImage:[UIImage imageNamed:[app.firstPageImage objectAtIndex:i]]];
            [self.klpImgArr addObject:iv];
            iv = nil;
        }
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        
        [self.klpScrollView1 addGestureRecognizer:singleTap];
        //[klpScrollView1 release];
       // [klpImgArr release];
      //  [app.firstPageImage release];
        ///UIScrollerView

    }
    else //==2
    {
        
        float heightTooBar;
        float buttonHeight;
        if(height5_flag&&Kind7)
        {
            heightTooBar=height_Momente-height-44;
            buttonHeight=5+height_Momente-44-height;
        }else if(height5_flag&&!Kind7)
        {
            heightTooBar=height_Momente-44;
            buttonHeight=5+height_Momente-44-20;
        }
        else if (!height5_flag&&Kind7)
        {
            heightTooBar=height_Momente-44;
            buttonHeight=5+height_Momente-44 ;
        }
        else {
            heightTooBar=height_Momente-height-44 ;
            buttonHeight=5+height_Momente-44-height;
        }
        UIImageView *imgToolView=[[[UIImageView alloc]initWithFrame:CGRectMake(0,heightTooBar, 320, 44)]autorelease];
        imgToolView.image=[UIImage imageNamed:@"toolBar@2X.png"];
        imgToolView.tag=22;
        [self.view addSubview:imgToolView];
        // NSLog(@"%@",[jsonObj  objectAtIndex:0] );
        //  [dict objectForKey:@"category_id"];
        
        for(int i=0;i<5;i++)
        {
            NSString *name=[[[NSString alloc]init]autorelease];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            if(i<4)
            {
                name= [NSString stringWithFormat: [[jsonObj  objectAtIndex:i] objectForKey:@"name"]];
                button.tag=[[[jsonObj  objectAtIndex:i] objectForKey:@"id"]integerValue];
            }
            else {
                name= [NSString stringWithFormat:@"收藏"];
                button.tag=100;
            }
            
          
            button.frame=CGRectMake(10+i*60, buttonHeight, 30, 40);
            button.showsTouchWhenHighlighted = YES;
            [button addTarget:self action:@selector(Press_Tag:) forControlEvents:UIControlEventTouchDown];
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
            label.text=name;
            label.font  = [UIFont fontWithName:@"Arial" size:15.0];
            label.backgroundColor=[UIColor clearColor];
            UILabel *labelNum=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 28, 25)];
            labelNum.text=[NSString stringWithFormat: [[jsonObj  objectAtIndex:i] objectForKey:@"id"]];
            labelNum.font  = [UIFont fontWithName:@"Arial" size:12.0];
            labelNum.textColor=[UIColor whiteColor];
            labelNum.backgroundColor=[UIColor clearColor];
            UIImageView *imgViewRed=[[[UIImageView alloc]initWithFrame:CGRectMake(30, 7, 28, 25)]autorelease];
            imgViewRed.image=[UIImage imageNamed:@"redBack.png"];
            [imgViewRed addSubview:labelNum];
            [button addSubview:imgViewRed];
            [button addSubview:label];
            button.backgroundColor=[UIColor clearColor];
            [self.view addSubview:button];
            [label release];
        }
    }
}
-(void)theTopBar
{
    UIImageView *topBarWhite=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)]autorelease];
    topBarWhite.image=[UIImage imageNamed:@"TitleWhiteBack"];
    [self.view addSubview:topBarWhite];
    UIImageView *topBarRed=[[[UIImageView alloc]initWithFrame:CGRectMake(108, 0, 110, 55)]autorelease];
    topBarRed.image=[UIImage imageNamed:@"TitleRedBack"];
    [topBarWhite addSubview:topBarRed];
    UILabel *titleBigName=[[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 50)]autorelease];
    titleBigName.text=@"路亚中国";
    titleBigName.textColor=[UIColor whiteColor];
    titleBigName.backgroundColor=[UIColor clearColor];
    titleBigName.font =[UIFont boldSystemFontOfSize:22];
    //titleBigName.font = [UIFont fontWithName:@"Courier" size:20];
    titleBigName.shadowColor = [UIColor grayColor];
    titleBigName.shadowOffset = CGSizeMake(0.0,0.5);
    [topBarRed addSubview:titleBigName];
    UILabel *smallTitle=[[[UILabel alloc]initWithFrame:CGRectMake(138, 43,110,55)]autorelease];
    smallTitle.textColor=[UIColor lightGrayColor];
    smallTitle.text=@"首页";//AppleGothic
    smallTitle.backgroundColor=[UIColor clearColor];
    [self.view addSubview:smallTitle];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
     [self.navigationController setNavigationBarHidden:YES ];
    self.navigationController.navigationBarHidden=YES;
    [self _init];
}
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
	}else {
		
	}
}

#pragma mark 手势
- (void) handleSingleTap:(UITapGestureRecognizer *) gestureRecognizer{
	CGFloat pageWith = 320;
    
    CGPoint loc = [gestureRecognizer locationInView:self.klpScrollView1];
    NSInteger touchIndex = floor(loc.x / pageWith) ;
    if (touchIndex > app.firstPageImage.count) {
        return;
    }
    NSLog(@"touch index %d",touchIndex);
}
//- (void) handleImageTap:(UITapGestureRecognizer *) gestureRecognizer{
//	CGFloat rowHeight = 70;
//    CGFloat columeWith = 100;
//    CGFloat gap = 5;
//    
//    CGPoint loc = [gestureRecognizer locationInView:self.klpScrollView2];
//    NSInteger touchIndex = floor(loc.x / (columeWith + gap)) + 3 * floor(loc.y / (rowHeight + gap)) ;
//    if (touchIndex > 11) {
//        return;
//    }
//    index = touchIndex;
//    CGRect frame = self.klpScrollView1.frame;
//    frame.origin.x = frame.size.width * touchIndex;
//    frame.origin.y = 0;
//    [self.klpScrollView1 scrollRectToVisible:frame animated:NO];
//    
//    klp.frame = ((UIImageView*)[app.firstPageImage objectAtIndex:index]).frame;
//    [klp setAlpha:0];
//    [UIView animateWithDuration:0.2f animations:^(void){
//        [klp setAlpha:.85f];
//    }];
// 
//    NSLog(@"small image touch index %d",touchIndex);
//}

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
-(void)Press_Tag:(id)sender
{
    UIButton *btn = (UIButton *)sender;
   
       NSLog(@"%d",btn.tag);
//    for (UIView *subviews in [self.view subviews]) {
//        if (subviews.tag==22) {
//            [subviews removeFromSuperview];
//        }
//    }//必须从self.view中移除，不能从gpsClickView中移除
    if(btn.tag<5&&btn.tag!=4)
    {
        NewsController *newVC = [[[NewsController alloc] initWithNibName:@"NewsController" bundle:nil]autorelease];
        newVC.hidesBottomBarWhenPushed = YES;
        newVC.target=btn.tag-1;
        [self.navigationController pushViewController :newVC animated:YES];
    }
    else if(btn.tag==4)
    {
        LifeViewController *newVC = [[[LifeViewController alloc] initWithNibName:@"LifeViewController" bundle:nil]autorelease];
        newVC.target=3;
        //self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController :newVC animated:YES];

    }
    else if(btn.tag==100)
    {
        StoreUpViewController *newVC = [[[StoreUpViewController alloc] initWithNibName:@"StoreUpViewController" bundle:nil]autorelease];
        self.hidesBottomBarWhenPushed = YES;//OK~
        [self.navigationController pushViewController :newVC animated:YES];
    }
}
@end
