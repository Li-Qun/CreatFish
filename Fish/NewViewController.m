//
//  NewViewController.m
//  Fish
//
//  Created by DAWEI FAN on 03/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "NewViewController.h"
#import "IIViewDeckController.h"

#import "ViewController.h"

#import "SampleCell.h"
#import "DetailItemViewController.h"

#import "ASIFormDataRequest.h"
#import "FishCore.h"
#import "AppDelegate.h"
#define TABLE_HEIGHT 80


@interface NewViewController ()

@end

@implementation NewViewController
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{//视图即将可见时调用。默认情况下不执行任何操作
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES ];//把后面的antimated=YES 去掉 就不会过渡出现问题了
     app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
     ContentRead *contentRead=[[ContentRead alloc]init];
    
   // [contentRead fetchList:@"1" isPri:@"0" Out:@"0"];
    
    [contentRead ContentDetail:@"1"];
   //  NSLog(@"content:  %@",app.content);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
 
    //侧边栏按钮
    UIButton *Left=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [Left  setFrame:CGRectMake(20, 509, 60, 35) ];
   
    [Left addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchDown];
    [Left setTitle:@"侧左栏" forState:UIControlStateNormal];
     [self.view addSubview:Left];
    
    UIButton *Right=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [Right  setFrame:CGRectMake(239, 509, 60, 35) ];
    
    [Right addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchDown];
    [Right setTitle:@"侧右栏" forState:UIControlStateNormal];
    [self.view addSubview:Right];
    //侧边栏按钮
    
    //tableView
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"SampleData" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.arrayForPlaces = [plistDict objectForKey:@"Data"];
    ///////Pic
    
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
    
    /**********tableView***********/
 
}

//tableView
#pragma mark -
#pragma mark tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayForPlaces count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SampleCell *cell = (SampleCell*) [tableView dequeueReusableCellWithIdentifier:@"SampleCell"];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SampleCell" owner:[SampleCell class] options:nil];
        cell = (SampleCell *)[nib objectAtIndex:0];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary* dict = [self.arrayForPlaces objectAtIndex:indexPath.row];
    
    cell.labelForPlace.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Place"]];
    cell.labelForCountry.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Country"]];
    cell.imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[dict objectForKey:@"Image"]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect cellFrameInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect cellFrameInSuperview = [tableView convertRect:cellFrameInTableView toView:[tableView superview]];
    
    DetailItemViewController* detailViewController = [[[DetailItemViewController alloc] initWithNibName:@"DetailItemViewController" bundle:nil]autorelease];
    
    NSMutableDictionary* dict = [self.arrayForPlaces objectAtIndex:indexPath.row];
    detailViewController.dictForData = dict;
    detailViewController.yOrigin = cellFrameInSuperview.origin.y;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    //  [self presentModalViewController:detailViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)clickLeftButton
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
    
}
-(void)clickRightButton
{
    [self.viewDeckController toggleRightViewAnimated:YES];
}

- (void)dealloc {
   
    [super dealloc];
}
@end
