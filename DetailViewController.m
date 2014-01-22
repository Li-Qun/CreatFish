//
//  DetailViewController.m
//  Fish
//
//  Created by DAWEI FAN on 19/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "DetailViewController.h"
#import "QuadCurveMenu.h"
#import "UIImageView+WebCache.h"

#import "CustomURLCache.h"
#import "MBProgressHUD.h"


#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
#import "UIMenuItem+CXAImageSupport.h"


#import "Singleton.h"



#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#import <ShareSDKCoreService/ShareSDKCoreService.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize showWebView=showWebView;
//@synthesize dictForData=dictForData;
@synthesize Data=Data;
@synthesize tableView=tableView;
@synthesize jsString=jsString;
@synthesize htmlText=htmlText;
@synthesize arrIDList=arrIDList;
@synthesize arrIDListNew=arrIDListNew;
@synthesize page_num=page_num;
@synthesize page_label=page_label;
@synthesize htmlTextTotals=htmlTextTotals;
@synthesize momentID=momentID;
@synthesize fatherID=fatherID;
@synthesize pre_Page=pre_Page;
@synthesize next_Page=next_Page;
@synthesize leftSwipeGestureRecognizer,rightSwipeGestureRecognizer;
//@synthesize detailImage=detailImage;
//@synthesize detailName=detailName;
//@synthesize detailID=detailID;
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
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGSize size = rect.size;
        CGFloat width = size.width;
        totalHeight = size.height;

        if(totalHeight==480)
        {
            isFive=NO;
        }else isFive=YES;
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version <7.0)
            isSeven=NO;
        else isSeven=YES;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{//视图即将可见时调用。默认情况下不执行任何操作
     self.navigationController.toolbarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
    
    [super viewWillAppear:animated];
    self.view.backgroundColor=[UIColor whiteColor];
    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    for (UIView *subviews in [self.view subviews])
    {
        [subviews removeFromSuperview];
    }
    
    
    [super viewDidLoad];
    

    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"readBack@2X.png"]];
    imgView.frame = self.view.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:imgView atIndex:0];
    [imgView release];
    
    [self buildTheTopBar];
    app.topBarView.userInteractionEnabled = YES;//使添加的按钮可选
    fontSize=16.0;
    line_height=18.0;
    Data=[[NSMutableDictionary alloc]init];
    jsString=[[[NSString alloc]init]retain] ;
    htmlTextTotals=[[NSMutableString alloc]init];
    
    NSLog(@" fa :%@  child :%@",fatherID,momentID);
    FatherID=[fatherID integerValue];
    
    ContentRead * contentRead =[[[ContentRead alloc]init]autorelease];
    [contentRead setDelegate:self];//设置代理
    
    [contentRead Content:fatherID Detail:momentID];
    
    
    
    showWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, 320, totalHeight)];
    showWebView.delegate=self;
    showWebView.scrollView.delegate=self;
    showWebView.backgroundColor=[UIColor clearColor];
    showWebView.opaque = NO;
    
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
}
-(void)buildTheTopBar
{
    float heightTopbar;
    float littleHeinght;
    if(isSeven&&isFive)
    {
        heightTopbar=60;
        littleHeinght=23;
    }
    else if(isSeven&&!isFive)
    {
        heightTopbar=60;
        littleHeinght=23;
    }else if(!isSeven&&isFive)//
    {
        heightTopbar=60;
        littleHeinght=20;
    }else {
        heightTopbar=45;
        littleHeinght=10;
    }

    //创建导航按钮start
    app. topBarView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, heightTopbar)];
    app. topBarView.image=[UIImage imageNamed:@"topViewBarWhite"];
    [self.view addSubview:app.topBarView];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(10, littleHeinght, 26, 25);
    [backBtn setImage:[UIImage imageNamed:@"BackImg@2X"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backParentView) forControlEvents:UIControlEventTouchUpInside];
    [app.topBarView  addSubview:backBtn];
    
    UIButton *wordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    wordBtn.frame=CGRectMake(175, littleHeinght+3, 28, 20);
    [wordBtn setImage:[UIImage imageNamed:@"AaImg@2X"] forState:UIControlStateNormal];
    [wordBtn addTarget:self action:@selector(PressWord:) forControlEvents:UIControlEventTouchUpInside];
    [app.topBarView  addSubview:wordBtn];
    
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame=CGRectMake(280, littleHeinght, 26, 25);
    [shareBtn setImage:[UIImage imageNamed:@"shareImg@2X"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
    [app.topBarView  addSubview:shareBtn];
    
    saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame=CGRectMake(230, littleHeinght, 26, 25);
    [saveBtn setImage:[UIImage imageNamed:@"saveImgNormal@2X"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(SaveBook:) forControlEvents:UIControlEventTouchUpInside];
    [app.topBarView  addSubview:saveBtn];
    [saveBtn setImage:[UIImage imageNamed:@"saveImgHighted@2X"] forState:UIControlStateHighlighted];
    
    app.topBarView.userInteractionEnabled = YES;//使添加的按钮可选
    
    //创建导航按钮end
    
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight)//na
    {
        if(!isOpenL&&!isOpenR)
        {
            [self.viewDeckController toggleLeftViewAnimated:YES];
            isOpenL=YES;
        }
        if(!isOpenL&&isOpenR)
        {
            [self.viewDeckController toggleRightViewAnimated:YES];
            isOpenR=NO;
        }
        
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {//bie
        
        if(!isOpenR&&!isOpenL)
        {
            [self.viewDeckController toggleRightViewAnimated:YES];
            isOpenR=YES;
        }
        if(isOpenL&&!isOpenR)
        {
            [self.viewDeckController toggleLeftViewAnimated:YES];
            isOpenL=NO;
        }
    }
}

- (void)viewDidLoad
{
    
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag isID:(NSString *)ID
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *jsonObj =[parser objectWithString: jsonString];
    NSLog(@"%@",jsonObj);
    moment=[[jsonObj objectForKey:@"id"]intValue];
    detailTotal=[[NSString alloc]init];
    htmlText=[[NSString alloc]init];
    
    detailTotal=jsonString;
    htmlText=[jsonObj objectForKey:@"content"];
    app.next_Page=[jsonObj objectForKey:@"next_id"];
    app.pre_Page=[jsonObj objectForKey:@"prev_id"];
    NSLog(@"next:%@  pre:%@",app.next_Page,app.pre_Page);
    //[htmlTextTotals appendFormat:[NSString stringWithFormat: htmlText]];
    //<body style="background-color: transparent">//设置网页背景透明
    
    jsString = [NSString stringWithFormat:@"<html> \n"
                "<head> \n"
                "<style type=\"text/css\"> \n"
                "body {font-size:%fpx; line-height:%fpx;background-color: transparent;}\n"
                "</style> \n"
                "</head> \n"
                "<body>%@</body> \n"
                "</html>",  fontSize ,line_height,htmlText];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
    [showWebView loadHTMLString:jsString  baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    showWebView.delegate=self;
    showWebView.scrollView.delegate=self;
    
    self.view.backgroundColor=[UIColor clearColor];
    
    [showWebView setUserInteractionEnabled: YES ];
    //UIWebView
    //[receiveStr release];
    
    arrIDList=[[NSMutableArray alloc]init];
    //       //获取web文本高度start
    //    if ([showWebView subviews]) {
    //        UIScrollView* scrollView = [[showWebView subviews] objectAtIndex:0];
    //        [scrollView setContentOffset:CGPointMake(0, height_Mag*2+100) animated:YES];
    //
    //
    //        height_Mag=scrollView.contentOffset.y;
    //        NSLog(@"%f",scrollView.contentOffset.y);   //scrollView.contentOffset.y
    //    }
    //    height_Mag = [[showWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    //    showWebView.scrollView.contentSize = CGSizeMake(320, height_Mag++);
    //
    //    //获取web文本高度end
    
    
    [self.view addSubview:showWebView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //  [showWebView loadHTMLString:jsString baseURL:nil];
    // [showWebView stringByEvaluatingJavaScriptFromString:jsString];
    //showWebView.
    

}
#pragma mark - webview
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";//加载提示语言
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    showWebView.scrollView.delegate=self;
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [showWebView stringByEvaluatingJavaScriptFromString:@"imageWidth(320);"];//设置网络图片统一宽度320
    [showWebView stringByEvaluatingJavaScriptFromString:@"init();"];
    //刷新设置
    [self createHeaderView];
	[self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    [_refreshHeaderView refreshLastUpdatedDate];
    //刷新设置end
    [self addTapOnWebView];//调用触摸图片事件
}
//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection
didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
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
    app.pic_URL=url;
    
    UIImageView *showView = [[UIImageView alloc] initWithFrame:self.view.frame  ];
    showView.center = point;
    [UIView animateWithDuration:0.5f animations:^{
        CGPoint newPoint = self.view.center;
        newPoint.y += 20;
        showView.center = newPoint;
    }];
    showView.backgroundColor = [UIColor clearColor];
    showView.alpha = 0.9;
    showView.userInteractionEnabled = YES;
    [self.view addSubview:showView];
    UIImageView * bottomBackBar=[[[UIImageView alloc]initWithFrame:CGRectMake(0, showView.frame.size.height-70, 320,70 )]autorelease];
    bottomBackBar.image=[UIImage imageNamed:@"BottomBar_webImage"];
    [showView addSubview:bottomBackBar];
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame=CGRectMake(280, 10, 20, 30);
    [shareBtn setImage:[UIImage imageNamed:@"Share_webImage"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareThewebImage) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackBar  addSubview:shareBtn];
    
    UIButton *isCloseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    isCloseBtn.frame=CGRectMake(235, 12, 20, 30);
    [isCloseBtn setImage:[UIImage imageNamed:@"Close_webImage"] forState:UIControlStateNormal];
    [isCloseBtn addTarget:self action:@selector(isCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackBar addSubview:isCloseBtn];
    bottomBackBar.userInteractionEnabled=YES;

    [showView setImageWithURL:[NSURL URLWithString:url]];
//    
//    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleViewTap:)];
//    [showView addGestureRecognizer:singleTap];
//    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(SEL)shareThewebImage
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:app.pic_URL
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.huiztech.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];

}
//移除图片查看视图
-(void)isCancelBtn//-(void)handleSingleViewTap:(UITapGestureRecognizer *)sender
{
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            [obj removeFromSuperview];
        }
    }
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"readBack@2X.png"]];
    imgView.frame = self.view.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:imgView atIndex:0];
    [imgView release];
}
//////查看web图片  end
#pragma mark-  scrollviewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;//滑动隐藏toolbar
{
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    app.topBarView.hidden=YES;
    showWebView.scrollView.delegate=self;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    app.topBarView.hidden=NO;
    
    //[self buildTheTopBar];
    showWebView.scrollView.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:app.pic_URL];
    imageView.image = [UIImage imageWithData:data];
    [self.view addSubview:imageView];
}
//////存储网页图片end
//菜单按钮响应start
- (void)viewWillLayoutSubviews
{
    
}

#pragma mark -
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender
{
    if (action == @selector(cameraAction:) ||
        action == @selector(broomAction:) ||
        action == @selector(textAction:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
}
#pragma mark -响应对UIWebView 文本操作start
-(void)wordBigAction:(id)sender
{
    fontSize+=5.0;
    if(fontSize>=40.0)fontSize=40.0;
    jsString = [NSString stringWithFormat:@"<html> \n"
                "<head> \n"
                "<style type=\"text/css\"> \n"
                "body {font-size:%fpx; line-height:%fpx;}\n"
                "</style> \n"
                "</head> \n"
                "<body>%@</body> \n"
                "</html>",  fontSize ,line_height, htmlTextTotals];
    
    
    [showWebView loadHTMLString:jsString  baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [showWebView loadHTMLString:jsString baseURL:nil];
    [showWebView stringByEvaluatingJavaScriptFromString:jsString];

}
-(void)wordSmallAction:(id)sender
{
    fontSize-=5.0;
    if(fontSize<=16)fontSize=16;
    jsString = [NSString stringWithFormat:@"<html> \n"
                "<head> \n"
                "<style type=\"text/css\"> \n"
                "body {font-size:%fpx; line-height:%fpx;}\n"
                "</style> \n"
                "</head> \n"
                "<body>%@</body> \n"
                "</html>",  fontSize ,line_height, htmlTextTotals];
    
    
    [showWebView loadHTMLString:jsString  baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    
    // [self.view addSubview:showWebView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [showWebView loadHTMLString:jsString baseURL:nil];
    [showWebView stringByEvaluatingJavaScriptFromString:jsString];
}

-(void)lineSmallAction:(id)sender
{
    line_height-=5.0;
    if(line_height<=18)line_height=18;
    jsString = [NSString stringWithFormat:@"<html> \n"
                "<head> \n"
                "<style type=\"text/css\"> \n"
                "body {font-size:%fpx; line-height:%fpx;}\n"
                "</style> \n"
                "</head> \n"
                "<body>%@</body> \n"
                "</html>",  fontSize ,line_height, htmlTextTotals];
    
    
    [showWebView loadHTMLString:jsString  baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    
    // [self.view addSubview:showWebView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [showWebView loadHTMLString:jsString baseURL:nil];
    [showWebView stringByEvaluatingJavaScriptFromString:jsString];
    
}
-(void)lineBigAction:(id)sender
{
    line_height+=5.0;
    if(line_height>=48)fontSize=48;
    jsString = [NSString stringWithFormat:@"<html> \n"
                "<head> \n"
                "<style type=\"text/css\"> \n"
                "body {font-size:%fpx; line-height:%fpx;}\n"
                "</style> \n"
                "</head> \n"
                "<body>%@</body> \n"
                "</html>",  fontSize ,line_height, htmlTextTotals];
    
    
    [showWebView loadHTMLString:jsString  baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    
    // [self.view addSubview:showWebView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [showWebView loadHTMLString:jsString baseURL:nil];
    [showWebView stringByEvaluatingJavaScriptFromString:jsString];

}
-(void)shareBtn
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.huiztech.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];

    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
    
}
///收藏提示对话框
-(void)SaveBook :(id)sender
{
    UIAlertView *alert =[[[UIAlertView alloc] initWithTitle:@"hello"
                                                   message:@"收藏当前阅读内容"
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:@"取消",nil ]autorelease];
   [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if(buttonIndex==0)//确定
    {
    [saveBtn setImage:[UIImage imageNamed:@"saveImgHighted@2X"] forState:UIControlStateNormal];

      [[Singleton sharedInstance].single_Data insertObject:detailTotal atIndex:app.saveNum++] ;
    }
    else if(buttonIndex==1)//取消
    {
        [saveBtn setImage:[UIImage imageNamed:@"saveImgNormal@2X"] forState:UIControlStateNormal];
    }
}
#pragma mark -响应对UIWebView 文本操作start
-(void)PressWord:(id)sender
{
    [[UIMenuController sharedMenuController] setTargetRect:[sender frame] inView:self.view];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    
    UIMenuItem *wordBig = [[[UIMenuItem alloc] initWithTitle:nil action:@selector(wordBigAction:)]autorelease];
    [wordBig  setTitle:@"字体大"];
    UIMenuItem *wordSmall = [[[UIMenuItem alloc] initWithTitle:nil action:@selector(wordSmallAction:)]autorelease];
    [wordSmall setTitle:@"字体小"];
    
    UIMenuItem *lineSmall = [[[UIMenuItem alloc] initWithTitle:@"间距窄" action:@selector(lineSmallAction:)]autorelease];
    
    UIMenuItem *lineBig = [[[UIMenuItem alloc] initWithTitle: @"间距宽" action:@selector(lineBigAction:)]autorelease];
    [UIMenuController sharedMenuController].menuItems = @[wordBig,wordSmall,lineSmall,lineBig ];
    //菜单按钮选项
    [[UIMenuController sharedMenuController] setTargetRect:CGRectMake(175, 23, 28, 20) inView:self.view];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];

}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[showWebView.scrollView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}
-(void)testFinishedLoadData{
	
    [self finishReloadingData];
    [self setFooterView];
}
#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:showWebView.scrollView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:showWebView.scrollView];
        [self setFooterView];
    }
}

-(void)setFooterView{

    CGFloat height = MAX(showWebView.scrollView.contentSize.height, showWebView.scrollView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              showWebView.scrollView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         showWebView.scrollView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [showWebView.scrollView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
	{
        [_refreshFooterView refreshLastUpdatedDate];
    }
}


-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        [_refreshFooterView removeFromSuperview];
    }
     _refreshFooterView = nil;
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
	{
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
	
	// overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
   
    [self testFinishedLoadData];
	 NSLog(@"刷新完成");
    if(app.pre_Page.length!=0)
    {
       
         [self Pressleft];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"没有更多了，去返回查看其它精彩游钓资讯吧!", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil] show];
    }
   
}
//加载调用的方法
-(void)getNextPageView
{

    [self removeFooterView];
    [self testFinishedLoadData];

    if(app.next_Page.length!=0)
    {
        [self PressGo];
       
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"没有更多了，去返回查看其它精彩游钓资讯吧!", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil] show];
        
    }
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	
	return [NSDate date]; // should return date data source was last changed
	
}
-(void)backParentView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)PressGo
{
    
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.8f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
   // NSLog(@"Fa %d    next:%@  pre： %@",FatherID,app.next_Page,app.pre_Page);
    
    ContentRead * contentRead =[[[ContentRead alloc]init]autorelease];
    [contentRead setDelegate:self];//设置代理
    
    [contentRead Content:[NSString stringWithFormat:@"%d",FatherID ] Detail:app.next_Page];
    
    [showWebView reload];
    
    
    [self buildTheTopBar];
   
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
    
  //  NSLog(@"Fa %d    next:%@  pre： %@",FatherID,app.next_Page,app.pre_Page);
    
    ContentRead * contentRead =[[[ContentRead alloc]init]autorelease];
    [contentRead setDelegate:self];//设置代理
    
    [contentRead Content:[NSString stringWithFormat:@"%d",FatherID ] Detail:app.pre_Page];
    [showWebView reload];
    
    [self buildTheTopBar];
    app.topBarView.userInteractionEnabled = YES;//使添加的按钮可选
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
	[UIView commitAnimations];
}


@end
