//
//  ReadingViewController.m
//  Fish
//
//  Created by DAWEI FAN on 13/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//
#import "MBProgressHUD.h"
#import "Singleton.h"
#import "AppDelegate.h"
#import "ReadingViewController.h"
#import "FishCore.h"

@interface ReadingViewController ()

@end

@implementation ReadingViewController
@synthesize momentID=momentID;
@synthesize pre_Page=pre_Page;
@synthesize next_Page=next_Page;
@synthesize arrIDListNew=arrIDListNew;
@synthesize jsString=jsString;
@synthesize htmlTextTotals=htmlTextTotals;
@synthesize detailSave=detailSave;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
-(void)build
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

    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"readBack@2X.png"]];
    imgView.frame = self.view.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:imgView atIndex:0];
    [imgView release];
    //创建导航按钮start
    UIImageView *topBarView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, heightTopbar)]autorelease];
    topBarView.image=[UIImage imageNamed:@"topViewBarWhite"];
    [self.view addSubview:topBarView];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(10, littleHeinght, 26, 25);
    [backBtn setImage:[UIImage imageNamed:@"BackImg@2X"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backParentView) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:backBtn];
    
    UIButton *wordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    wordBtn.frame=CGRectMake(175, littleHeinght+3, 28, 20);
    [wordBtn setImage:[UIImage imageNamed:@"AaImg@2X"] forState:UIControlStateNormal];
    [wordBtn addTarget:self action:@selector(PressWord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:wordBtn];
    
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame=CGRectMake(280, littleHeinght, 26, 25);
    [shareBtn setImage:[UIImage imageNamed:@"shareImg@2X"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(backParentView) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:shareBtn];
    
    UIButton *saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame=CGRectMake(230, littleHeinght, 26, 25);
    [saveBtn setImage:[UIImage imageNamed:@"saveImgNormal@2X"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(SaveBook:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:saveBtn];
    [saveBtn setImage:[UIImage imageNamed:@"saveImgHighted@2X"] forState:UIControlStateHighlighted];
    
    //创建导航按钮end

}
-(void)reBack:(NSString *)jsonString
{
    NSLog(@"%@",jsonString);
    fontSize=16.0;
    line_height=18.0;
    showWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, 320, totalHeight)];
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *jsonObj =[parser objectWithString: jsonString];
    detailSave=[[NSString alloc]init];
    detailSave=jsonString;
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.saveDataId=jsonString;
 
    htmlText=[NSString stringWithFormat:[jsonObj objectForKey:@"content"]];
    htmlTextTotals=[[[NSMutableString alloc]init]retain];
    [htmlTextTotals appendFormat:[NSString stringWithFormat: htmlText]];
    jsString = [NSString stringWithFormat:@"<html> \n"
                "<head> \n"
                "<style type=\"text/css\"> \n"
                "body {font-size:%fpx; line-height:%fpx;background-color: transparent;}\n"
                "</style> \n"
                "</head> \n"
                "<body>%@</body> \n"
                "</html>",  fontSize ,line_height,htmlTextTotals];
    [showWebView loadHTMLString:jsString  baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    showWebView.delegate=self;
    showWebView.scrollView.delegate=self;
    
    self.view.backgroundColor=[UIColor clearColor];
    [showWebView setUserInteractionEnabled: YES ];
    [self.view addSubview:showWebView];
   
}
-(void)viewWillAppear:(BOOL)animated
{[self build];
    NSLog(@"%@",momentID);
    contentRead=[[[ContentRead alloc]init]autorelease];
    contentRead.delegate=self;
    [contentRead ContentDetail:@"2" ];
}
- (void)viewDidLoad
{
    
    htmlTextTotals=[[[NSMutableString alloc]init]retain];
    jsString=[[[NSString alloc]init]retain];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
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
-(void)SaveBook :(id)sender
{    
    UIButton *saveBtn = (UIButton *)sender;
    [saveBtn setImage:[UIImage imageNamed:@"saveImgHighted@2X"] forState:UIControlStateNormal];
    UIAlertView *alert =[[[UIAlertView alloc] initWithTitle:@"温情提示"
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
    {  NSLog(@"%@",app.saveDataId);
    [[Singleton sharedInstance].single_Data insertObject:app.saveDataId atIndex:app.saveNum++] ;
  
    }
    else if(buttonIndex==1)//取消
    {
        
    }
    NSLog(@"%@", [Singleton sharedInstance].single_Data);
}
#pragma mark -响应对UIWebView 文本操作start
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
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [showWebView stringByEvaluatingJavaScriptFromString:@"imageWidth(320);"];//设置网络图片统一宽度320
    [showWebView stringByEvaluatingJavaScriptFromString:@"init();"];
    //刷新设置start
    [self createHeaderView];
	[self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    [_refreshHeaderView refreshLastUpdatedDate];
    //刷新设置end

    
}
//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
