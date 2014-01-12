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
-(void)viewWillAppear:(BOOL)animated
{
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
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

    [self.navigationController setNavigationBarHidden:YES];
 
    self.navigationController.toolbarHidden = YES;
    
    self.navigationController.navigationBarHidden=YES;
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
    
    
    
    
    
    
    
    contentRead=[[[ContentRead alloc]init]autorelease];
    contentRead.delegate=self;
    [contentRead Category];
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag
{
    
}
-(void)PessTheStoreBack
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
//    ViewController *newVC = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil]autorelease];
//    self.hidesBottomBarWhenPushed = YES;//OK~
//    [self.navigationController pushViewController :newVC animated:YES];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    tableView_Store=[[UITableView alloc]init];
    tableView_Store.frame=CGRectMake(0, 65, 320, heightStore);
    tableView_Store.delegate=self;
    tableView_Store.dataSource=self;//设置双重代理 很重要
    [self.view addSubview:tableView_Store];
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
 // [jsonObj objectForKey:@"category_id"];
    for(int i=0;i<app.saveNum;i++)
    {
        NSDictionary *jsonObj =[parser objectWithString: [[Singleton sharedInstance].single_Data objectAtIndex:i]];
        [arrSave_ID insertObject:[jsonObj objectForKey:@"category_id"] atIndex:i];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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

     NSMutableDictionary* dict =jsonObj;
     detail.dictForData=dict;
     detail.yOrigin=cellFrameInSuperview.origin.y;
     detail.arrIDListNew=arrSave_ID;
    detail.isStore=YES;
    [self.navigationController pushViewController:detail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
