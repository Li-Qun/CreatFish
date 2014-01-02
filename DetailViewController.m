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
@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize pic_url=pic_url;
@synthesize showWebView=showWebView;
@synthesize dictForData=dictForData;
@synthesize Data=Data;
@synthesize tableView=tableView;
@synthesize jsString=jsString;
@synthesize htmlText=htmlText;
@synthesize arrIDList=arrIDList;
@synthesize arrIDListNew=arrIDListNew;
@synthesize page_num=page_num;
@synthesize page_label=page_label;
@synthesize htmlTextTotals=htmlTextTotals;
@synthesize detailImage=detailImage;
@synthesize detailName=detailName;
@synthesize detailID=detailID;
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
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{//视图即将可见时调用。默认情况下不执行任何操作
    self.navigationController.toolbarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    fontSize=16.0;
    line_height=18.0;
    Data=[[NSMutableDictionary alloc]init];
    jsString=[[[NSString alloc]init]retain] ;
    htmlTextTotals=[[NSMutableString alloc]init];
    
    [self postURL:[self.dictForData objectForKey:@"id"]];
    showWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 55, 320, 550)];
    showWebView.delegate=self;
    showWebView.scrollView.delegate=self;
   
}
-(void)postURL:(NSString*)ID
{
      //第一步，创建url
    
    NSURL *url = [NSURL URLWithString:@"http://42.96.192.186/ifish/server/index.php/app/mgz/content/read_dtl" ];
    
    //第二步，创建请求
   
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //[request setPostValue:@"1" forKey:@"content_id"];

    [request setHTTPMethod:@"POST"];
   
    NSString *str=[[NSString stringWithFormat:@"content_id=%@",ID]retain];
    //  NSString *str = @"content_id=1";//[request setPostValue:@"1" forKey:@"content_id"]
    //NSURLRequest post
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
  
    //第三步，连接服务器
   
    NSURLConnection *connection =[[[NSURLConnection alloc]initWithRequest:request delegate:self]autorelease];
    [request  release];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   // NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    //NSLog(@"%@",[res allHeaderFields]);
    self.Data = [NSMutableData data];
}
//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.Data appendData:data];
}
//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receiveStr = [[NSString alloc]initWithData:self.Data encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *jsonObj =[parser objectWithString: receiveStr];
    moment=[[jsonObj objectForKey:@"id"]intValue];
    htmlText=[[NSString alloc]init];
    detailName=[[NSString alloc]init] ;
    detailImage=[[NSString alloc]init] ;
    detailID=[[NSString alloc]init];
    htmlText=[jsonObj objectForKey:@"content"];
    detailName=[jsonObj objectForKey:@"name"];
    detailImage=[jsonObj objectForKey:@"image"];
    detailID=[jsonObj objectForKey:@"id"];
    [htmlTextTotals appendFormat:[NSString stringWithFormat: htmlText]];
   // htmlTextTotals = [htmlTextTotals stringByAppendingString:htmlText];
  //  NSLog(@"%@",htmlTextTotals);
    jsString = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<style type=\"text/css\"> \n"
                          "body {font-size:%fpx; line-height:%fpx;}\n"
                          "</style> \n"
                          "</head> \n"
                          "<body>%@</body> \n"
                          "</html>",  fontSize ,line_height,htmlTextTotals];
    
  
   [showWebView loadHTMLString:jsString  baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
  //导航按钮start
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame=CGRectMake(3, 10, 44, 50);
    [back addTarget:self action:@selector(backParentView) forControlEvents:UIControlEventTouchDown];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    
    UIButton *word = [UIButton buttonWithType:UIButtonTypeSystem];
    word.frame=CGRectMake(100, 10, 44, 50);
    [word addTarget:self action:@selector(PressWord:) forControlEvents:UIControlEventTouchDown];
    [word setTitle:@"字体" forState:UIControlStateNormal];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeSystem];
    share.frame=CGRectMake(170, 10, 44, 50);
    [share addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchDown];
    [share setTitle:@"分享" forState:UIControlStateNormal];
    
    UIButton *save = [UIButton buttonWithType:UIButtonTypeSystem];
    save.frame=CGRectMake(240, 10, 44, 50);
    [save addTarget:self action:@selector(SaveBook) forControlEvents:UIControlEventTouchDown];
    [save setTitle:@"收藏" forState:UIControlStateNormal];
    
    [navBar addSubview:back];
    [navBar addSubview:word];
    [navBar addSubview:share];
    [navBar addSubview:save];
    [self.view addSubview:navBar];
    //导航按钮end

    [self addTapOnWebView];//调用触摸图片事件
    self.view.backgroundColor=[UIColor whiteColor];
    showWebView.delegate=self;
    [showWebView setUserInteractionEnabled: YES ];
    [self.view addSubview:showWebView];
    [self addTapOnWebView];//调用触摸图片事件
    //showWebView.

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [showWebView loadHTMLString:jsString baseURL:nil];
    [showWebView stringByEvaluatingJavaScriptFromString:jsString];
    
    //UIWebView
    //[receiveStr release];
   
//    arrIDList=[[NSMutableArray alloc]init];
//    int sum=arrIDList.count ;
//    for(int i=0;i<arrIDListNew.count;i++)
//    {
//        [arrIDList insertObject:[NSString stringWithFormat:@"%@",[arrIDListNew objectAtIndex:i]]  atIndex:sum++];
//    }
//     page_num=[[UILabel alloc]initWithFrame:CGRectMake(130, 13, 55,27 )];
//     [toolBar addSubview:page_num];
//     page_num.text=[[NSString stringWithFormat:@"%d/%@",moment,[arrIDList objectAtIndex:arrIDList.count-1] ]retain];
//    
//    
    
    
    
    [self createHeaderView];
	[self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    [_refreshHeaderView refreshLastUpdatedDate];
    //[jsString release];
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
    pic_url=url;
    
    UIImageView *showView = [[UIImageView alloc] initWithFrame:self.view.frame  ];
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
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:pic_url];
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
    
   // [self.view addSubview:showWebView];
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
-(void)cameraSaveAction:(id)sender
{
    
}
///收藏提示对话框
-(void)SaveBook
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
    if(buttonIndex==0)//确定
    {
        app.saveId=detailID;
        app.saveName=detailName;
        app.saveImage=detailImage;
        [app.saveDataId insertObject:app.saveId atIndex:app.saveNum];
        [app.saveDataImage insertObject:app.saveImage atIndex:app.saveNum];
        [app.saveDataName insertObject:app.saveName atIndex:app.saveNum];

    }
    else if(buttonIndex==1)//取消
    {
        
    }
    
}
#pragma mark -响应对UIWebView 文本操作start
- (void)pressme:(id)sender
{
    [[UIMenuController sharedMenuController] setTargetRect:[sender frame] inView:self.view];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)cameraAction:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera Item Pressed", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil] show];
}

- (void)broomAction:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Broom Item Pressed", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil] show];
}

- (void)textAction:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Text Item Pressed", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil] show];
}
//菜单按钮响应end
//实现翻页响应start
-(void)PressGo
{
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.8f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
    if(moment>=[[arrIDList objectAtIndex:arrIDList.count-1]intValue])
        moment=[[arrIDList objectAtIndex:arrIDList.count-1]intValue];
    else moment+=1;
    [self postURL:[NSString stringWithFormat:@"%d",moment]];
     [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:0];
	[UIView commitAnimations];
}
-(void)Pressleft
{
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.8f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
    if(moment<=[[arrIDList objectAtIndex:0]intValue])
         moment=[[arrIDList objectAtIndex:0]intValue];
    else moment-=1;
    [self postURL:[NSString stringWithFormat:@"%d",moment]];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:0];
	[UIView commitAnimations];
}

////实现翻页响应end
//- (void)dealloc {
//  //  [showWebView release];
//    [super dealloc];
//}
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
    [[UIMenuController sharedMenuController] setTargetRect:CGRectMake(100, 10, 44, 50) inView:self.view];
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
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
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
	NSLog(@"刷新完成");
    [self testFinishedLoadData];
	
}
//加载调用的方法
-(void)getNextPageView
{
//	for(int i = 0; i < 10; i++) {
//		[_images addObject:[NSString stringWithFormat:@"%d.jpeg", i % 10 + 1]];
//	}
	//[self reloadData];
    //[];
    [self postURL:[self.dictForData objectForKey:@"id"]];
    [showWebView reload];
    [self removeFooterView];
    [self testFinishedLoadData];
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



@end
