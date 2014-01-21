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
#import "ReadingViewController.h"

#import "IIViewDeckController.h"
#import "RightViewController.h"

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
@synthesize targetCentre=targetCentre;
@synthesize leftSwipeGestureRecognizer,rightSwipeGestureRecognizer;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    height_Momente = size.height;
    
    if(height_Momente==480)
    {
        isFive=NO;
    }else isFive=YES;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version <7.0)
        isSeven=NO;
    else isSeven=YES;
    
    ContentRead * contentRead =[[[ContentRead alloc]init]autorelease];
    [contentRead setDelegate:self];//设置代理
    app.targetCenter=target;
    NSLog(@"%d %d",target,app.targetCenter);
    str=[NSString stringWithFormat:@"%d",target];
    [contentRead fetchList:str isPri:@"1" Out:@"0"];
    [contentRead fetchList:str isPri:@"0" Out:@"0"];
}
- (void)viewDidLoad
{
    self.view.backgroundColor=[UIColor whiteColor];
    isFirstLoad=NO;
    newSumCount=0;
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    arr=[[[NSMutableArray alloc]init]retain];
    arrPic=[[[NSMutableArray alloc]init]retain];
    arrLabel=[[[NSMutableArray alloc]init]retain];
    arrID=[[[NSMutableArray alloc]init]retain];
    
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.toolbarHidden = YES;
    
    // NSLog(@"target:======%d",target);
    //  if(target<=4)  app.targetCenter=target;
    //  if(target<1)app.targetCenter=1;
    
    app.targetCenter=target;
    NSLog(@"centre  %d",app.targetCenter);
   
    
    tabView=[[[UITableView alloc]init]retain];
    tabView.showsHorizontalScrollIndicator=NO;
    tabView.showsVerticalScrollIndicator=NO;

   
    [super viewDidLoad];
    //  [arr release];
    isOpenR=NO;isOpenL=NO;
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
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

-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag
{
      app.jsonString=jsonString;
//    NSLog(@"%d",app.array.count);
//    NSLog(@"name %@", [[app.array objectAtIndex  :target ]objectForKey:@"name"]);
//    NewsId=[[app.array objectAtIndex  :target ]objectForKey:@"id"];
//    NewsName=[[app.array objectAtIndex  :target ]objectForKey:@"name"];
//    NewsPid=[[app.array objectAtIndex  :target ]objectForKey:@"pid"];
//    NewsImage=[[app.array objectAtIndex  :target ]objectForKey:@"image"];
//    NewsLevel=[[app.array objectAtIndex  :target ]objectForKey:@"level"];
//    NewsFlag=[[app.array objectAtIndex  :target ]objectForKey:@"flag"];
    
    float heightTopbar;
    float littleHeinght;
    if(isSeven&&isFive)
    {
        heightTopbar=65;
        littleHeinght=20+5;
    }
    else if(isSeven&&!isFive)
    {
        heightTopbar=65;
        littleHeinght=20+5;
    }else if(!isSeven&&isFive)//
    {
        heightTopbar=45;
        littleHeinght=10;
    }else {
        heightTopbar=45;
        littleHeinght=10;
    }
    tabView.frame=CGRectMake(0, heightTopbar, 320, height_Momente);
    
    
    UIImageView *topBarView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, heightTopbar)]autorelease];
    topBarView.image=[UIImage imageNamed:@"topBarRed"];
    [self.view addSubview:topBarView];
    UIImageView *wordView=[[[UIImageView alloc]initWithFrame:CGRectMake(105, littleHeinght/2, 90, 23)]autorelease];
    wordView.image=[UIImage imageNamed:@"word"];
    [topBarView addSubview:wordView];
    UILabel *name=[[[UILabel alloc]initWithFrame:CGRectMake(105,littleHeinght,95,65-littleHeinght)]autorelease];
    name.textColor=[UIColor whiteColor];
    name.text=NewsName;
    name.textAlignment = UITextAlignmentCenter;
    name.font =[UIFont boldSystemFontOfSize:15];
    name.shadowColor = [UIColor grayColor];
    name.shadowOffset = CGSizeMake(0.0,0.5);
    name.backgroundColor=[UIColor clearColor];
    [topBarView addSubview:name];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(10,littleHeinght, 37, 30);
    leftBtn.tag=10;
    [leftBtn setImage:[UIImage imageNamed:@"LeftBtn@2X"] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(PessSwitch_BtnTag:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(270,littleHeinght, 37, 30);
    [rightBtn setImage:[UIImage imageNamed:@"RightBtn@2X"] forState:UIControlStateNormal];
    [self.view addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(PessSwitch_BtnTag:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag=20;
    
    
    isFistLevel=[flag intValue];
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSDictionary *jsonObj =[parser objectWithString:app.jsonString];
    
   
    
    
    if(isFistLevel==0)
    {
        total += [[jsonObj objectForKey:@"total"] intValue];
        NSLog(@"total : %d",total);
        NSDictionary *data = [jsonObj objectForKey:@"data"];
        newSumCount=arr.count;
        for (int i =0; i <data.count; i++) {
            
            [arr insertObject:[data objectAtIndex:i] atIndex: newSumCount];
            [arrID insertObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i]
                                                                  objectForKey:@"id"]]  atIndex:newSumCount];
            newSumCount++;
        }
    }
    else if (isFistLevel==1)
    {
        app.jsonStringOne=app.jsonString;
    }
    [self build_TableView];
}
-(void)build_TableView
{
    [self createHeaderView];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    [_refreshHeaderView refreshLastUpdatedDate];
 
    tabView.delegate=self;
    tabView.dataSource=self;//设置双重代理 很重要
    [tabView setBackgroundColor:[UIColor clearColor]];
    [tabView setSeparatorStyle:UITableViewCellSeparatorStyleNone];//hidden the lines
    [self.view addSubview:tabView];
    [tabView reloadData];
    //[tabView release];

}
-(void)PessSwitch_BtnTag:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag==10)
    {
        [self.viewDeckController toggleLeftViewAnimated:YES];
       
    }
    else
    {
        [self.viewDeckController toggleRightViewAnimated:YES];
    }
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
        return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",total);
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
    //  ReadingViewController *detail=[[[ReadingViewController alloc]initWithNibName:@"ReadingViewController" bundle:nil]autorelease];
        NSMutableDictionary* dict = [self.arr objectAtIndex:indexPath.row-1];
        //  detail.dictForData=dict;
        detail.arrIDListNew=arrID;
        detail.yOrigin=cellFrameInSuperview.origin.y;
        detail.momentID=[dict objectForKey:@"id"];
        [self.navigationController pushViewController:detail animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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
    NSString *str=[NSString stringWithFormat:@"%d",target];
    ContentRead * contentRead =[[[ContentRead alloc]init]autorelease];
    [contentRead setDelegate:self];
    [contentRead fetchList:str isPri:@"0" Out:@"0"];
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