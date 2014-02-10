
#import "skyCell.h"
#import "AppDelegate.h"
#import "OneCell.h"
#import "DetailViewController.h"
#import "NewsController.h"

@implementation skyCell
@synthesize dataLabel=dataLabel;
@synthesize dataPic=dataPic;
@synthesize jsonObjCell=jsonObjCell;
@synthesize dataArray1;
@synthesize lblHead;
@synthesize delegate;
- (void)dealloc
{
    [dataArray1 release];
    [lblHead release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        table = [[UITableView alloc]initWithFrame:CGRectMake(75,-75,170,320) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.showsHorizontalScrollIndicator=NO;
        table.showsVerticalScrollIndicator=NO;
        [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];//hidden the lines
        table.transform = CGAffineTransformMakeRotation(M_PI / 2 *3);
        dataArray1=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",nil];
        
        app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        dataPic=[[[NSMutableArray alloc]init]retain];
        dataLabel=[[[NSMutableArray alloc]init]retain];
        //  NSLog(@"%@",app.jsonStringOne);
        SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
        jsonObj =[parser objectWithString:app.jsonStringOne];
        for(int i=0;i<jsonObj.count ;i++)
        {
            [dataPic insertObject:[NSString stringWithFormat:@"http://42.96.192.186/ifish/server/upload/%@",[[jsonObj objectAtIndex:i] objectForKey:@"image"]] atIndex:i];
            [dataLabel insertObject:[NSString stringWithFormat:@"%@",[[jsonObj objectAtIndex:i]objectForKey:@"name"]]  atIndex:i];
        }
        
        
		[self addSubview:table];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [dataPic count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OneCell *cellOne=(OneCell *)[tableView dequeueReusableCellWithIdentifier:@"OneCell"];
    if(cellOne==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OneCell" owner:[OneCell class] options:nil];
        cellOne = (OneCell *)[nib objectAtIndex:0];
        cellOne.contentView.backgroundColor = [UIColor whiteColor];
        
        [cellOne.imageView setImageWithURL:[NSURL URLWithString: [dataPic objectAtIndex:indexPath.row]]
           placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                    success:^(UIImage *image) {NSLog(@"资讯置顶图片显示成功OK");}
                    failure:^(NSError *error) {NSLog(@"资讯置顶图片显示失败NO");}];
        
        UIImageView *clearBack=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 143, 340, 31)]autorelease];
        clearBack.image=[UIImage imageNamed:@"clearBack@2X"];
        [cellOne.imageView addSubview:clearBack];
        [clearBack addSubview:cellOne.label];
        UIImageView *theArrow=[[[UIImageView alloc]initWithFrame:CGRectMake(310, 8,8,12)]autorelease];
        theArrow.image=[UIImage imageNamed:@"theArrow"];
        [clearBack addSubview:theArrow];
        
        
        //文字居中显示
        
        cellOne.numLabel.text=[NSString stringWithFormat:@"%d/%d",indexPath.row+1,dataPic.count];
        cellOne.numLabel.textColor=[UIColor whiteColor];
        cellOne.numLabel.backgroundColor=[UIColor clearColor];
        cellOne.numLabel.font=[UIFont boldSystemFontOfSize:14];
        
        
        
        cellOne.label.backgroundColor=[UIColor clearColor];
        
        cellOne.label.text= [dataLabel objectAtIndex:indexPath.row];
 
        cellOne.transform=CGAffineTransformMakeRotation(M_PI/2);
        cellOne.label.textColor=[UIColor whiteColor];
       
    }
    return cellOne;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"第一行点击%d",[indexPath row]);

    app.next_Page=@"3";
//    NewsController *new=[[[NewsController alloc]init]autorelease];
//    new.Delegate =self;
//    [new theFirstCell_Transport:[[jsonObj objectAtIndex:indexPath.row]objectForKey:@"id"]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)action
{
    
    NSLog(@"XXXX%@",app.next_Page);
    [delegate translate:@"2"];
}
//-(void)translate:(NSString *)ID_Num
//{
//   
//}
@end
