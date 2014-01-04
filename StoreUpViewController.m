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
- (void)viewDidLoad
{
    [super viewDidLoad];
    tableView_Store=[[UITableView alloc]init];
    tableView_Store.frame=CGRectMake(0, 0, 320, 560);
    tableView_Store.delegate=self;
    tableView_Store.dataSource=self;//设置双重代理 很重要
    [self.view addSubview:tableView_Store];
    
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
    NSLog(@"%@",imgURL);
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
//    DetailViewController *detail=[[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil]autorelease];
//    NSMutableDictionary* dict = [arr_Mag objectAtIndex:indexPath.row];
//    detail.dictForData=dict;
//    detail.arrIDListNew= arrID_Mag;
//    detail.yOrigin=cellFrameInSuperview.origin.y;
    //[self.navigationController pushViewController:detail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
