//
//  MagDetaiViewController.m
//  Fish
//
//  Created by DAWEI FAN on 02/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "MagDetaiViewController.h"
#import "LifeViewController.h"
#import "FishCore.h"
#import "InformationCell.h"
#import "DetailViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
@interface MagDetaiViewController ()

@end

@implementation MagDetaiViewController
@synthesize navBar=navBar;
@synthesize Id=Id;
@synthesize weeklyId=weeklyId;
@synthesize contentDtail=contentDtail;
@synthesize tableView_Mag=tableView_Mag;
@synthesize arr_Mag=arr_Mag;
@synthesize name_Mag=name_Mag;
@synthesize arrID_Mag=arrID_Mag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)reBack:(NSString *)jsonString
{
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSDictionary *jsonObj =[parser objectWithString:jsonString];
 
    tableView_Mag .frame=CGRectMake(0, 60, 320, 560);
    [self createHeaderView];
	[self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
	[_refreshHeaderView refreshLastUpdatedDate];
    
    tableView_Mag.delegate=self;
    tableView_Mag.dataSource=self;//设置双重代理 很重要
    total+=[[jsonObj objectForKey:@"total"]intValue];
     NSDictionary *data = [jsonObj objectForKey:@"data"];
 
    newCount_Mag+=arr_Mag.count;
    for(int i=0;i<data.count;i++)
    {
         [arr_Mag insertObject:[data objectAtIndex:i] atIndex:newCount_Mag];
       // [arrID_Mag insertObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i]objectForKey:@"id"]]  atIndex:newCount_Mag];
    }
    [self.view addSubview:tableView_Mag];
}
- (void)viewWillAppear:(BOOL)animated
{//视图即将可见时调用。默认情况下不执行任何操作
    
    self.navigationController.toolbarHidden = YES;
    [super viewWillAppear:animated];
    navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"杂志目录"];
    [navBar pushNavigationItem:navigationItem animated:YES];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame=CGRectMake(3, 10, 44, 50);
    [back addTarget:self action:@selector(backMagazine) forControlEvents:UIControlEventTouchDown];
    [back setTitle:@"返回" forState:UIControlStateNormal];
     
    [navBar addSubview:back];
    
    [self.view addSubview:navBar];
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag
{
    
}
- (void)viewDidLoad
{
    tableView_Mag=[[[UITableView alloc]init]retain];
    arr_Mag=[[[NSMutableArray alloc]init]retain];
    ContentRead *contentRead1 =[[[ContentRead alloc]init]autorelease];
    contentRead1.delegate=self;
    [contentRead1 Magazine:Id isPri:@"0" WeeklyId:weeklyId Out:@"0"];
    [contentRead1 Category];
    [super viewDidLoad];
}
-(void)backMagazine
{
    //[self.navigationController popViewControllerAnimated:YES];
    LifeViewController *newVC = [[[LifeViewController alloc] initWithNibName:@"LifeViewController" bundle:nil]autorelease];
    newVC.target=4;
    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController :newVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (total);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationCell *cell=(InformationCell*)[tableView dequeueReusableCellWithIdentifier:@"InformationCell"];
    if(cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InformationCell" owner:[InformationCell class] options:nil];
        cell = (InformationCell *)[nib objectAtIndex:0];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    NSDictionary* dict = [arr_Mag objectAtIndex:(indexPath.row)];
    
    cell.labelForCategory_id.text=[dict objectForKey:@"category_id"];
    
    cell.labelForID.text=[dict objectForKey:@"id"];
    
    cell.labelForName.text=[dict objectForKey:@"name"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *imgURL=[NSString stringWithFormat:@"http://42.96.192.186/ifish/server/upload/%@",[dict objectForKey:@"image"]];
    [cell.imgView setImageWithURL:[NSURL URLWithString: imgURL]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                          success:^(UIImage *image) {NSLog(@"OK");}
                          failure:^(NSError *error) {NSLog(@"NO");}];
 
    return cell;

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect cellFrameInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect cellFrameInSuperview = [tableView convertRect:cellFrameInTableView toView:[tableView superview]];
    DetailViewController *detail=[[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil]autorelease];
    NSMutableDictionary* dict = [arr_Mag objectAtIndex:indexPath.row];
    detail.dictForData=dict;
   // detail.arrIDListNew= arrID_Mag;
    detail.yOrigin=cellFrameInSuperview.origin.y;
    [self.navigationController pushViewController:detail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
    
	[tableView_Mag addSubview:_refreshHeaderView];
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_Mag ];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_Mag];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(tableView_Mag.contentSize.height, tableView_Mag.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              tableView_Mag.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         tableView_Mag.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [tableView_Mag addSubview:_refreshFooterView];
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
    [contentDtail setDelegate:self];
    [contentDtail Magazine:Id isPri:@"0" WeeklyId:weeklyId Out:@"0"];
   // [contentRead setDelegate:self];
    //[contentRead fetchList:@"1" isPri:@"0" Out:@"0"];
   // NSLog(@"XXXX   :  %@",NewsId);
    //    [contentRead Magazine:@"1" isPri:@"0" WeeklyId:@"0" Out:@"0"];
    
    [tableView_Mag reloadData];
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
