//
//  NewsController.m
//  Fish
//
//  Created by DAWEI FAN on 18/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "NewsController.h"
#import "FishCore.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "JSONKit.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "InformationCell.h"
#import "OneCell.h"
#import "LoadMoreCell.h"
#import "skyCell.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"

#import "IIViewDeckController.h"

 
@interface NewsController ()

@end

@implementation NewsController
@synthesize delegate=delegate;
@synthesize arr=arr;
@synthesize arrPic=arrPic;
@synthesize arrLabel=arrLabel;
@synthesize arrID=arrID;
@synthesize NewsId=NewsId;
@synthesize NewsImage=NewsImage;
@synthesize NewsFlag=NewsFlag;
@synthesize NewsLevel=NewsLevel;
@synthesize NewsName=NewsName;
@synthesize NewsPid=NewsPid;
@synthesize target=target;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(NSString *)PostReturn
{
    return @"1";
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO  ];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO  ];
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag
{
    app.jsonString=jsonString;
    NSLog(@"name %@", [[app.array objectAtIndex  :target ]objectForKey:@"name"]);
    NewsId=[[app.array objectAtIndex  :target ]objectForKey:@"id"];
    NewsName=[[app.array objectAtIndex  :target ]objectForKey:@"name"];
    NewsPid=[[app.array objectAtIndex  :target ]objectForKey:@"pid"];
    NewsImage=[[app.array objectAtIndex  :target ]objectForKey:@"image"];
    NewsLevel=[[app.array objectAtIndex  :target ]objectForKey:@"level"];
    NewsFlag=[[app.array objectAtIndex  :target ]objectForKey:@"flag"];
    
    
     NSLog(@"target:======%d",target);
    if(target<=4)
        app.targetCenter=target;
    if(target<1)
        app.targetCenter=1;
    
    NSLog(@"centre  %d",app.targetCenter);

    
    
    [self postJSON:flag];
}
- (void)viewDidLoad
{
    isFirstLoad=NO;
    newSumCount=0;
    arr=[[[NSMutableArray alloc]init]retain];///[self.arr objectAtIndex:indexPath.row];
    arrPic=[[[NSMutableArray alloc]init]retain];
    arrLabel=[[[NSMutableArray alloc]init]retain];
    arrID=[[[NSMutableArray alloc]init]retain];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:YES ];
    self.navigationController.toolbarHidden = YES;
    //    [self.navigationController.toolbar setTranslucent:YES];
    self.navigationController.navigationBarHidden=NO;
     tabView=[[[UITableView alloc]init]retain];
    contentRead =[[[ContentRead alloc]init]autorelease];
    [contentRead setDelegate:self];//设置代理
    [contentRead fetchList:@"1" isPri:@"1" Out:@"0"];
    [contentRead fetchList:@"1" isPri:@"0" Out:@"0"];
    [super viewDidLoad];
    //  [arr release];
}
-(void)postJSON:(NSString *)flag
{
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self   action:@selector(pressLeftSlide)];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.hidesBackButton =YES;
    
    
    [leftButton release];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                    UIBarButtonSystemItemFastForward                                                                   target:self
                                    action:@selector (pressRightSlide)];//(SettingPress)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    isFistLevel=[flag intValue];
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSDictionary *jsonObj =[parser objectWithString:app.jsonString];
  
    tabView.frame=CGRectMake(0, 60, 320, 560);
    tabView.delegate=self;
    tabView.dataSource=self;//设置双重代理 很重要
    [self createHeaderView];
	[self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
	[_refreshHeaderView refreshLastUpdatedDate];
    
    
    if(isFistLevel==0)
    {
        total += [[jsonObj objectForKey:@"total"] intValue];
        NSLog(@"total : %d",total);
        NSDictionary *data = [jsonObj objectForKey:@"data"];
        
        //[NSString stringWithFormat:@"http://42.96.192.186/ifish/server/upload/%@",[[arr objectAtIndex:i] objectForKey:@"image"]];
        newSumCount+=arr.count;
        for (int i =0; i <data.count; i++) {
           // NSString *str = [NSString stringWithFormat:@"%d",i];
            [arr insertObject:[data objectAtIndex:i] atIndex: newSumCount];
            [arrID insertObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i]objectForKey:@"id"]]  atIndex:newSumCount];
        }
        // NSLog(@"%@",arrID);
    }
    else if (isFistLevel==1)
    {
        app.jsonStringOne=app.jsonString;
        
    }
   [self.view addSubview:tabView];
   [tabView reloadData];
   //[tabView release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
        return  170;
    else
        return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (total+1);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationCell *cell=(InformationCell*)[tableView dequeueReusableCellWithIdentifier:@"InformationCell"];
   
 
    if(indexPath.row==0)
    {
     
        static NSString *identity = @"cell";
        skyCell *cellSky = (skyCell *)[tableView dequeueReusableCellWithIdentifier:identity];
        if(cellSky==nil)
        {
           cellSky = [[[skyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity]autorelease];
        }
        else{
         
        }return cellSky;
    }
    else
    {
        if(cell==nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InformationCell" owner:[InformationCell class] options:nil];
            cell = (InformationCell *)[nib objectAtIndex:0];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        NSDictionary* dict = [arr objectAtIndex:(indexPath.row-1)];
        
        cell.labelForCategory_id.text=[dict objectForKey:@"category_id"];
        
        cell.labelForID.text=[dict objectForKey:@"id"];
        
        cell.labelForName.text=[dict objectForKey:@"name"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *imgURL=[NSString stringWithFormat:@"http://42.96.192.186/ifish/server/upload/%@",[dict objectForKey:@"image"]];
        //#import "UIImageView+WebCache.h" 加载网络图片方法start
        [cell.imgView setImageWithURL:[NSURL URLWithString: imgURL]
                     placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                              success:^(UIImage *image) {NSLog(@"OK");}
                              failure:^(NSError *error) {NSLog(@"NO");}];
        //#import "UIImageView+WebCache.h" 加载网络图片方法end
        // NSLog(@"%@",imgURL);
      return cell;
    }  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row>0)
    {
        CGRect cellFrameInTableView = [tableView rectForRowAtIndexPath:indexPath];
        CGRect cellFrameInSuperview = [tableView convertRect:cellFrameInTableView toView:[tableView superview]];
        DetailViewController *detail=[[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil]autorelease];
        NSMutableDictionary* dict = [self.arr objectAtIndex:indexPath.row];
        detail.dictForData=dict;
        detail.arrIDListNew=arrID;
        detail.yOrigin=cellFrameInSuperview.origin.y;
        [self.navigationController pushViewController:detail animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
}
-(void)loadMore
{
    [contentRead setDelegate:self];
   // [contentRead fetchList:@"1" isPri:@"0" Out:@"1"];
    [contentRead Magazine:@"1" isPri:@"0" WeeklyId:@"14" Out:@"1"];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;//滑动隐藏toolbar
{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;//不滑动 显示toolbar
{
    
}
///ScrollView end
-(void)pressLeftSlide
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO ];//把后面的antimated=YES 去掉 就不会过渡出现问题了
    
}
-(void)pressRightSlide
{
    [self.viewDeckController toggleRightViewAnimated:YES];
}
//- (void)dealloc {
//
//    [super dealloc];
//}
//加载瀑布流start
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
    
	[tabView addSubview:_refreshHeaderView];
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading: tabView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading: tabView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(tabView.contentSize.height, tabView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                             tabView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         tabView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [tabView addSubview:_refreshFooterView];
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
    [contentRead setDelegate:self];
    [contentRead fetchList:@"1" isPri:@"0" Out:@"0"];
    [tabView reloadData];
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


 
//加载瀑布流end
@end
