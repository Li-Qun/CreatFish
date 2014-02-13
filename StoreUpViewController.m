//
//  StoreUpViewController.m
//  Fish
//
//  Created by DAWEI FAN on 03/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "StoreUpViewController.h"
#import "Singleton.h"
#import "InformationCell.h"
#import "DetailViewController.h"
#import "sqlite3.h"
#import "BaiduMobStat.h"
@interface StoreUpViewController ()

@end

@implementation StoreUpViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
//百度页面统计
-(void)viewDidAppear:(BOOL)animated
{
    NSString *cName=[NSString stringWithFormat:@"StoreUp&收藏"];
    [[BaiduMobStat defaultStat]pageviewStartWithName:cName ];
}
-(void)viewDidDisappear:(BOOL)animated
{
   NSString *cName=[NSString stringWithFormat:@"StoreUp&收藏"];
    [[BaiduMobStat defaultStat]pageviewEndWithName:cName ];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
}


-(void)PessTheStoreBack
{
    [self.viewDeckController toggleLeftViewAnimated:YES];

}
- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES];

    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    heightStore = size.height;
    if( heightStore==480)
    {
        isFive=NO;
    }else isFive=YES;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version <7.0)
        isSeven=NO;
    else isSeven=YES;
    if(isSeven&&isFive)
    {
        heightTopbar=65;
        littleHeinght=20;
    }
    else if(isSeven&&!isFive)
    {
        heightTopbar=58;
        littleHeinght=20;
    }else if(!isSeven&&isFive)//
    {
        heightTopbar=45;
        littleHeinght=10;
    }else {
        heightTopbar=45;
        littleHeinght=10;
    }
    
    
    self.navigationController.toolbarHidden = YES;
    
    
    UIImageView *topBarView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, heightTopbar )]autorelease];
    topBarView.image=[UIImage imageNamed:@"topBarRed"];
    [self.view addSubview:topBarView];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(10, littleHeinght, 37, 30);
    leftBtn.tag=10;
    [leftBtn setImage:[UIImage imageNamed:@"LeftBtn@2X"] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(PessTheStoreBack) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *name=[[[UILabel alloc]initWithFrame:CGRectMake(105, littleHeinght, 100, 25)]autorelease];
    name.textColor=[UIColor whiteColor];
    name.text=@"收藏";
    name.textAlignment = UITextAlignmentCenter;
    name.font =[UIFont boldSystemFontOfSize:22];
    name.shadowColor = [UIColor grayColor];
    name.shadowOffset = CGSizeMake(0.0,0.5);
    [topBarView addSubview:name];
    name.backgroundColor=[UIColor clearColor];
    [super viewDidLoad];
    tableView_Store=[[UITableView alloc]init];
    tableView_Store.frame=CGRectMake(0, heightTopbar, 320, heightStore);
    tableView_Store.delegate=self;
    tableView_Store.dataSource=self;//设置双重代理 很重要
    tableView_Store.separatorStyle = NO;
   
    
    if([Singleton sharedInstance].single_Data.count==0)
    {
        NSLog(@"暂无收藏内容");
    }
    else
    {
         [self buildTheLongTime];
    }
   
    
}
-(void)buildTheLongTime
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        
        dispatch_async(dispatch_get_main_queue(), ^{//主线程
            
            SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
            
            for(int i=0;i<app.saveNum;i++)
            {
                NSDictionary *jsonObj =[parser objectWithString: [[Singleton sharedInstance].single_Data objectAtIndex:i]];
                [arrSave_ID insertObject:[jsonObj objectForKey:@"category_id"] atIndex:i];
            }[
              self.view addSubview:tableView_Store];
            
        });
    });

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return app.saveNum ;
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
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSDictionary *jsonObj =[parser objectWithString: [[Singleton sharedInstance].single_Data objectAtIndex:indexPath.row]];
    cell.labelForCategory_id.text= [jsonObj objectForKey:@"category_id"];
    
    cell.labelForName.text=[jsonObj objectForKey:@"name"];
    cell.labelForName.textColor =[UIColor redColor ];
    cell.labelForName.font=[UIFont systemFontOfSize:15.0f];
        
    cell.labelForID.text=[jsonObj objectForKey:@"description"];
    cell.labelForID.font=[UIFont systemFontOfSize:12.0f];
    cell.labelForID.textColor=[UIColor grayColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *imgURL=[NSString stringWithFormat:@"http://42.96.192.186/ifish/server/upload/%@",[jsonObj objectForKey:@"image"]];
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
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSDictionary *jsonObj =[parser objectWithString: [[Singleton sharedInstance].single_Data objectAtIndex:indexPath.row]];

     NSDictionary* dict =jsonObj;
    detail.momentID=[dict objectForKey:@"id"];
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
