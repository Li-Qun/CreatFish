//
//  MagDetaiViewController.m
//  Fish
//
//  Created by DAWEI FAN on 02/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "MagDetaiViewController.h"
#import "FishCore.h"
#import "InformationCell.h"
#import "DetailViewController.h"
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
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag
{
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSDictionary *jsonObj =[parser objectWithString:jsonString];
    tableView_Mag.frame=CGRectMake(0, 60, 320, 560);
    tableView_Mag.delegate=self;
    tableView_Mag.dataSource=self;//设置双重代理 很重要
    total+=[[jsonObj objectForKey:@"total"]intValue];
     NSDictionary *data = [jsonObj objectForKey:@"data"];
    newCount_Mag+=arr_Mag.count;
    for(int i=0;i<data.count;i++)
    {
         [arr_Mag insertObject:[data objectAtIndex:i] atIndex:newCount_Mag];
        [arrID_Mag insertObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i]objectForKey:@"id"]]  atIndex:newCount_Mag];
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
- (void)viewDidLoad
{
    tableView_Mag=[[[UITableView alloc]init]retain];
    arr_Mag=[[[NSMutableArray alloc]init]retain];
    contentDtail =[[[ContentRead alloc]init]autorelease];
    [contentDtail setDelegate:self];//设置代理
    [contentDtail Magazine:Id isPri:@"0" WeeklyId:weeklyId Out:@"0"];
    [super viewDidLoad];
}
-(void)backMagazine
{
    [self.navigationController popViewControllerAnimated:YES];
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
    detail.arrIDListNew= arrID_Mag;
    detail.yOrigin=cellFrameInSuperview.origin.y;
    [self.navigationController pushViewController:detail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
