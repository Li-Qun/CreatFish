//
//  ReadViewController.m
//  Fish
//
//  Created by DAWEI FAN on 08/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//
#import "QuadCurveMenu.h"
#import "ReadViewController.h"
#import "UIImageView+WebCache.h"

#import "CustomURLCache.h"
#import "MBProgressHUD.h"


#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
@interface ReadViewController ()<UIGestureRecognizerDelegate,SDWebImageManagerDelegate,SDWebImageDownloaderDelegate ,QuadCurveMenuDelegate>

@end

@implementation ReadViewController

@synthesize showWebView=showWebView;
@synthesize scrollView=scrollView;
@synthesize mulArray=mulArray;
@synthesize list=list;
@synthesize pic_list=pic_list;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
                                                                     diskCapacity:200 * 1024 * 1024
                                                                         diskPath:nil
                                                                        cacheTime:0];
        [CustomURLCache setSharedURLCache:urlCache];
        [urlCache release];
        momentNum=0;
        isFirstOpen=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /***********设置请求网址**************/
    pageCount=20;
    mulArray =[[NSMutableArray alloc] init];
    
    for(int i=0;i<pageCount;i++)
    {
        NSString  * url = [NSString stringWithFormat:@"http://www.baidu.com/s?wd=a&pn=%d&ie=utf-8&usm=2",i*10];//initWithContentsOfUrl/
        [mulArray addObject:url];
    }
    showWebView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if(isFirstOpen)
    {
        [showWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[mulArray objectAtIndex:0]]]];
        isFirstOpen=NO;
        [self.view addSubview:showWebView];
    }//NSLog(@"%@",[mulArray objectAtIndex:5]);
    //翻页按钮
    UIButton *right=[UIButton buttonWithType:UIButtonTypeCustom];
    right.frame=CGRectMake(191, 10, 44,44);//(108, 25, 44, 44);
    right.hidden=NO;
    [ right setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
    [right addTarget:self action:@selector(PressGo) forControlEvents:UIControlEventTouchDown];
    
    UIButton *left=[UIButton buttonWithType:UIButtonTypeCustom];
    left.frame=CGRectMake(72, 10, 44,44);//(180, 25, 44, 44);
    left.hidden=NO;
    [ left setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
    
    [left addTarget:self action:@selector(Pressleft) forControlEvents:UIControlEventTouchDown];
    [self addTapOnWebView];//调用触摸图片事件
    
    [showWebView addSubview: right];
    [showWebView  addSubview:left];
    //页数label
    numLabel=[[UILabel alloc]initWithFrame:CGRectMake(130, 15, 55,27 )];
    numLabel.backgroundColor=[UIColor clearColor];
    numLabel.textColor=[UIColor blackColor];
    string=[NSString stringWithFormat:@"%d/%d",momentNum+1,pageCount];
    numLabel.text=string;
    [self.view addSubview:numLabel];
    
    
    /***********设置请求网址**************/
  /*  showWebView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com/"]];
    showWebView.delegate=self;
    [showWebView scalesPageToFit];
    // showWebView.detectsPhoneNumbers = YES;
    // [showWebView ];
    [self.view addSubview:showWebView];
    [showWebView loadRequest:urlRequest];
    
    [self addTapOnWebView];//调用触摸图片事件
    pic_url=[[[NSString alloc]init]autorelease];
   */
    /********************List_buttons************************/
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    // Camera MenuItem.
    QuadCurveMenuItem *cameraMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                         highlightedContentImage:nil];
    // People MenuItem.
    QuadCurveMenuItem *peopleMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                         highlightedContentImage:nil];
    // Place MenuItem.
    QuadCurveMenuItem *placeMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                        highlightedContentImage:nil];
    // Music MenuItem.
    QuadCurveMenuItem *musicMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                        highlightedContentImage:nil];
    // Thought MenuItem.
    QuadCurveMenuItem *thoughtMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                 highlightedImage:storyMenuItemImagePressed
                                                                     ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                          highlightedContentImage:nil];
    // Sleep MenuItem.
    QuadCurveMenuItem *sleepMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                        highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:cameraMenuItem, peopleMenuItem, placeMenuItem, musicMenuItem, thoughtMenuItem, sleepMenuItem, nil];
    [cameraMenuItem release];
    [peopleMenuItem release];
    [placeMenuItem release];
    [musicMenuItem release];
    [thoughtMenuItem release];
    [sleepMenuItem release];
    QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds menus:menus];
    menu.delegate = self;
    [showWebView addSubview:menu];
    [menu release];
    
    
    /********************List_buttons************************/
    //显示透明指示栏  显示页数 前进 后退按钮
    
//    list=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//    list.backgroundColor=[UIColor clearColor];
//    [self  PressClearList];
    
    
    //显示透明指示栏  显示页数 前进 后退按钮
    
}
/////查看web 图片
-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.showWebView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

#pragma mark- TapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:self.showWebView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [self.showWebView stringByEvaluatingJavaScriptFromString:imgURL];
    NSLog(@"image url=%@", urlToSave);
    if (urlToSave.length > 0) {
        [self showImageURL:urlToSave point:pt];
    }
}

//呈现图片
-(void)showImageURL:(NSString *)url point:(CGPoint)point
{
    pic_url=url;
    UIImageView *showView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 470)];
    showView.center = point;
    [UIView animateWithDuration:0.5f animations:^{
        CGPoint newPoint = self.view.center;
        newPoint.y += 20;
        showView.center = newPoint;
    }];
    
    showView.backgroundColor = [UIColor blackColor];
    showView.alpha = 0.9;
    showView.userInteractionEnabled = YES;
    [self.view addSubview:showView];
    [showView setImageWithURL:[NSURL URLWithString:url]];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleViewTap:)];
    [showView addGestureRecognizer:singleTap];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//移除图片查看视图
-(void)handleSingleViewTap:(UITapGestureRecognizer *)sender
{
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            [obj removeFromSuperview];
        }
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
//////查看web图片  end
#pragma mark - webview

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";//加载提示语言
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    CustomURLCache *urlCache = (CustomURLCache *)[NSURLCache sharedURLCache];
    [urlCache removeAllCachedResponses];
    
    // Dispose of any resources that can be recreated.
}
//////存储网页图片start
-(void)storePic:(id )url
{
    //  CustomURLCache *mainUrl=(CustomURLCache *)[NSURLCache sharedURLCache];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *URL=[NSURL URLWithString:url];
    UIImage *cachedImage = [manager imageWithURL:URL]; // 将需要缓存的图片加载进来
    if (cachedImage) {
        // 如果Cache命中，则直接利用缓存的图片进行有关操作
        
        NSLog(@"SSSS");
        NSLog(@"=====%@",url );//OK
        [self performSelectorInBackground:@selector(loadImageFromUrl:) withObject:url];
        
    } else {
        // 如果Cache没有命中，则去下载指定网络位置的图片，并且给出一个委托方法
        // Start an async download
        [manager downloadWithURL:url delegate:self];
        NSLog(@"%@",url );//ok
    }
}
//开辟线程来解决图片加载方式阻塞了main线程
-(void)loadImageFromUrl: (NSString*)url {
    NSURL  *imageUrl = [NSURL URLWithString:url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    //  [self performSelectorOnMainThread:@selector(updateImageView:) withObject:imageData waitUntilDone:NO];
}
//更新显示下载的图片
-(void) updateImageView:(NSData*) data {
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:pic_url];
    imageView.image = [UIImage imageWithData:data];
    [self.view addSubview:imageView];
}


//////存储网页图片end

////list_button
- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
    if(idx==0)
    {
        [self storePic:pic_url];
    }
    else if(idx==1)
    {
        [showWebView goBack];
        NSLog(@"11111");
    }
    else if (idx==2)
    {
        [showWebView goForward];
    }
}
////////处理滑动操作
-(void)handleSwipe:(UISwipeGestureRecognizer*)recognizer
{
    //处理滑动操作
    NSLog(@"滑动，快速移动");
    CGPoint translation = [recognizer locationInView:self.view];
    NSLog(@"Swipe - start location: %f,%f", translation.x, translation.y);
    //    recognizer.view.transform = CGAffineTransformMakeTranslation(translation.x, translation.y);
  
}

-(void)PressGo
{
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.8f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];

    if(momentNum>=pageCount-1)
        momentNum=pageCount-1;
    else momentNum+=1;
    string=[NSString stringWithFormat:@"%d/%d",momentNum+1,pageCount];
    numLabel.text=string;
    [showWebView addSubview:numLabel];
    [showWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[mulArray objectAtIndex:momentNum]]]];
    [self.view addSubview:showWebView];
    NSLog(@"%@",[mulArray objectAtIndex:momentNum]);
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
	[UIView commitAnimations];
}
-(void)Pressleft
{
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.8f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
    if(momentNum<=0)
        momentNum=0;
    else momentNum-=1;
    string=[NSString stringWithFormat:@"%d/%d",momentNum+1,pageCount];
    numLabel.text=string;
    [showWebView addSubview:numLabel];
    [showWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[mulArray objectAtIndex:momentNum]]]];
    [self.view addSubview:showWebView];
    NSLog(@"%@",[mulArray objectAtIndex:momentNum]);
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
	[UIView commitAnimations];
}

@end
