//
//  BigFishViewController.m
//  Fish
//
//  Created by DAWEI FAN on 20/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "BigFishViewController.h"
#import "FishImageViewController.h"

#import <sqlite3.h>

#define ITEM_SPACING 200
@interface BigFishViewController ()

@end

@implementation BigFishViewController
@synthesize target=target;
@synthesize carousel;
@synthesize labelText=labelText;
@synthesize wrap;
@synthesize leftSwipeGestureRecognizer,rightSwipeGestureRecognizer;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        wrap = YES;
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SwimFish@2X.png"]];
        imgView.frame = self.view.bounds;
        imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view insertSubview:imgView atIndex:0];
        [imgView release];
    }
    return self;
}
- (void)dealloc
{
    [carousel release];
    [labelText release];
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat height = size.height;
    
    
    if(height==480)
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
    
    UIImageView *topBarView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, heightTopbar)]autorelease];
    topBarView.image=[UIImage imageNamed:@"topBarRed"];//CGRectMake(135, littleHeinght+2, 40, 20)
    [self.view addSubview:topBarView];
    
    UIImageView *wordView=[[[UIImageView alloc]initWithFrame:CGRectMake(128, littleHeinght+2, 50, 23)]autorelease];
    wordView.image=[UIImage imageNamed:@"BigFishList"];
    [topBarView addSubview:wordView];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(10, littleHeinght, 37, 30);
    leftBtn.tag=10;
    [leftBtn setImage:[UIImage imageNamed:@"LeftBtn@2X"] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(SwimSwitch_BtnTag:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(270, littleHeinght, 37, 30);
    [rightBtn setImage:[UIImage imageNamed:@"RightBtn@2X"] forState:UIControlStateNormal];
    [self.view addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(SwimSwitch_BtnTag:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag=20;
    
}
-(void)reBack:(NSString *)jsonString reLoad:(NSString *)ID
{
    if(isSeven&&isFive)
    {
        img_height=20;
        lab_height=80;
    }
    else if(isSeven&&!isFive)
    {
        lab_height=100;
    }else if(!isSeven&&isFive)//
    {
        img_height=20;
        lab_height=20;
    }else {
        
        lab_height=100;
    }
    
    NSString *strJson;
    NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPaths=[array objectAtIndex:0];
    NSString *str=[NSString stringWithFormat:@"BigFishView_DB%@",ID];
    NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:str];
    sqlite3 *database;
    
    if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
    {
        NSLog(@"open success");
    }
    else {
        NSLog(@"open failed");
    }
    char *errorMsg;
    // 查找数据
    NSString* sql = @"select * from picture";
    sqlite3_stmt *stmt;
    //查找数据
    
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
    {
        
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            int i=sqlite3_column_int(stmt, 0)-1;
            
            
            const unsigned char *_pic= sqlite3_column_text(stmt, 1);
            strJson= [NSString stringWithUTF8String: _pic];
            NSLog(@"********%d",i);
            
            
            
        }
        //设置索引标识
        SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
        NSDictionary *jsonObj =[parser objectWithString:strJson];
        total = [[jsonObj objectForKey:@"total"] intValue];
        NSDictionary *data = [jsonObj objectForKey:@"data"];
        for(int i=0;i<data.count;i++)
        {
            [BigFish_Description insertObject:[data objectAtIndex:i] atIndex: i];
        }
    }
    sqlite3_finalize(stmt);
    
    //  最后，关闭数据库：
    sqlite3_close(database);
    carousel.delegate = self;
    carousel.dataSource = self;
    
    carousel.type = iCarouselTypeCoverFlow;
    for (UIView *view in carousel.visibleItemViews)
    {
        view.alpha = 1.0;
    }
    labelText.text=[[BigFish_Description objectAtIndex:0] objectForKey:@"description"];
    labelText.textColor=[UIColor whiteColor];
    labelText.backgroundColor=[UIColor clearColor];
    labelText.font=[UIFont systemFontOfSize:14.0f];
    labelText.numberOfLines = 0;
    [labelText sizeToFit];
    labelText.frame=CGRectMake(59, 462-lab_height, 230, 99);
    
    
    
    [UIView beginAnimations:nil context:nil];
    carousel.type=5;
    [UIView commitAnimations];
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag isID:(NSString *)ID
{
    
    if(isSeven&&isFive)
    {
        img_height=20;
        lab_height=80;
    }
    else if(isSeven&&!isFive)
    {
        lab_height=100;
    }else if(!isSeven&&isFive)//
    {
        img_height=20;
        lab_height=20;
    }else {
        
        lab_height=100;
    }

    NSString *strJson;
    NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPaths=[array objectAtIndex:0];
    NSString *str=[NSString stringWithFormat:@"BigFishView_DB%@",ID];
    NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:str];
    sqlite3 *database;
    
    if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
    {
        NSLog(@"open success");
    }
    else {
        NSLog(@"open failed");
    }
    char *errorMsg;
    NSString *insertSQLStr = [NSString stringWithFormat:
                              @"INSERT INTO 'picture' ('pic' ) VALUES ('%@')", jsonString];
    const char *insertSQL=[insertSQLStr UTF8String];
    //插入数据 进行更新操作
    if (sqlite3_exec(database, insertSQL , NULL, NULL, &errorMsg)==SQLITE_OK) {
        NSLog(@"insert operation is ok.");
    }
    else{
        NSLog(@"insert error:%s",errorMsg);
        sqlite3_free(errorMsg);
    }
    
    // 查找数据
    NSString* sql = @"select * from picture";
    sqlite3_stmt *stmt;
    //查找数据
    
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
    {
        
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            int i=sqlite3_column_int(stmt, 0)-1;
            
            
            const unsigned char *_pic= sqlite3_column_text(stmt, 1);
            strJson= [NSString stringWithUTF8String: _pic];
            NSLog(@"********%d",i);
            
            
            
        }
        //设置索引标识
        SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
        NSDictionary *jsonObj =[parser objectWithString:strJson];
        total = [[jsonObj objectForKey:@"total"] intValue];
        NSDictionary *data = [jsonObj objectForKey:@"data"];
        for(int i=0;i<data.count;i++)
        {
            [BigFish_Description insertObject:[data objectAtIndex:i] atIndex: i];
        }
    }
    // 删除所有数据 并进行更新数据库操作
    //删除所有数据，条件为1>0永真
    const char *deleteAllSql="delete from picture where 1>0";
    //执行删除语句
    if(sqlite3_exec(database, deleteAllSql, NULL, NULL, &errorMsg)==SQLITE_OK){
        NSLog(@"删除所有数据成功");
    }
    else NSLog(@"delect failde!!!!");
    
    
    sql=@"CREATE TABLE IF NOT EXISTS picture (ID INTEGER PRIMARY KEY AUTOINCREMENT,pic TEXT)";         //创建表
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
    {
        NSLog(@"create success");
    }else{
        NSLog(@"create error:%s",errorMsg);
        sqlite3_free(errorMsg);
    }
    NSString *insertSQLStr1 = [NSString stringWithFormat:
                               @"INSERT INTO 'picture' ('pic' ) VALUES ('%@')", jsonString];
    const char *insertSQL1=[insertSQLStr1 UTF8String];
    //插入数据 进行更新操作
    if (sqlite3_exec(database, insertSQL1 , NULL, NULL, &errorMsg)==SQLITE_OK) {
        NSLog(@"insert operation is ok.");
    }
    else{
        NSLog(@"insert error:%s",errorMsg);
        sqlite3_free(errorMsg);
    }
    sqlite3_finalize(stmt);
    
    //  最后，关闭数据库：
    sqlite3_close(database);
    
    
    carousel.delegate = self;
    carousel.dataSource = self;
    
    carousel.type = iCarouselTypeCoverFlow;
    for (UIView *view in carousel.visibleItemViews)
    {
        view.alpha = 1.0;
    }
    labelText.text=[[BigFish_Description objectAtIndex:0] objectForKey:@"description"];
    labelText.textColor=[UIColor whiteColor];
    labelText.backgroundColor=[UIColor clearColor];
    labelText.font=[UIFont systemFontOfSize:14.0f];
    labelText.numberOfLines = 0;
    [labelText sizeToFit];
    labelText.frame=CGRectMake(59, 462-lab_height, 230, 99);
    
    
    
    [UIView beginAnimations:nil context:nil];
    carousel.type=5;
    [UIView commitAnimations];
}

- (void)viewDidLoad
{//@"直线", @"圆圈", @"反向圆圈", @"圆桶", @"反向圆桶", @"封面展示", @"封面展示2", @"纸牌"
    [self.navigationController setNavigationBarHidden:YES];
    [super viewDidLoad];
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    target=app.targetCenter;
    BigFish_Description=   [[[NSMutableArray alloc]init]retain];
    
    ContentRead* contentRead =[[[ContentRead alloc]init]autorelease];
    NSString *str=[NSString stringWithFormat:@"%d",target];
    NSLog(@"%d",target);
    [contentRead setDelegate:self];//设置代理
    [contentRead fetchList:str isPri:@"0" Out:@"0"];
    [super viewDidLoad];
    

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
    if(sender.view!=carousel)
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
                app.targetCenter=1;
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
}

-(void)SwimSwitch_BtnTag:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag==10)//zuo
    {
        app.targetCenter=1;
        [self.viewDeckController toggleLeftViewAnimated:YES];
    }
    else [self.viewDeckController toggleRightViewAnimated:YES];
    
}
#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return  total;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat height = size.height;
    
    
    if(height==480)
    {
        isFive=NO;
    }else isFive=YES;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version <7.0)
        isSeven=NO;
    else isSeven=YES;
    
    
    if(isSeven&&isFive)
    {
        img_height=20;
        lab_height=80;
    }
    else if(isSeven&&!isFive)
    {
        lab_height=100;
    }else if(!isSeven&&isFive)//
    {
        img_height=20;
        lab_height=20;
    }else {
        img_height=20;
        lab_height=100;
    }
    
    carousel.frame=CGRectMake(24, 30+img_height, 220, 289);
    view1 = [[[UIImageView alloc] init ] autorelease];
    NSDictionary* dict = [BigFish_Description objectAtIndex:(index)];
    NSString *imgURL=[NSString stringWithFormat:@"http://42.96.192.186/ifish/server/upload/%@",[dict objectForKey:@"image"]];
    UIImageView *ImageView=[[[UIImageView alloc]initWithFrame:carousel.frame ]autorelease];
    [ImageView  setImageWithURL:[NSURL URLWithString: imgURL]
               placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                        success:^(UIImage *image) {NSLog(@"OK");}
                        failure:^(NSError *error) {NSLog(@"NO");}];
    [view1 addSubview:ImageView];
    view1.frame =CGRectMake(0, 0, 220, 289); //CGRectMake(0, -littleHeinght*6, 280, 400-littleHeinght*6);
    view1.layer.shadowColor = [UIColor blackColor].CGColor;
    view1.layer.shadowOpacity = 1.0;
    view1.layer.shadowRadius = 5.0;
    view1.layer.shadowOffset = CGSizeMake(1, 1);
    view1.clipsToBounds = NO;
    labelText.frame=CGRectMake(59, 462-lab_height, 230, 99);
    
    [self.view  reloadInputViews];
    return view1;
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat height = size.height;
    
    
    if(height==480)
    {
        isFive=NO;
    }else isFive=YES;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version <7.0)
        isSeven=NO;
    else isSeven=YES;
    
    
    if(isSeven&&isFive)
    {
        img_height=20;
        lab_height=80;
    }
    else if(isSeven&&!isFive)
    {
        lab_height=100;
    }else if(!isSeven&&isFive)//
    {
        img_height=20;
        lab_height=20;
    }else {
        
    }

    if(index>=0&&index<carousel.indexesForVisibleItems.count)
    {
        
    }
    else
    {
        index=0;
    }
    labelText.text=[[BigFish_Description objectAtIndex:index] objectForKey:@"description"];
    index++;
    labelText.textColor=[UIColor whiteColor];
    labelText.backgroundColor=[UIColor clearColor];
    labelText.font=[UIFont systemFontOfSize:14.0f];
    labelText.numberOfLines = 0;
    [labelText sizeToFit];
     labelText.frame=CGRectMake(59, 462-lab_height, 230, 99);
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return total;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    
    
    
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index;
{
    NSLog(@"%d",index);
     NSDictionary* dict = [BigFish_Description objectAtIndex:index];
    FishImageViewController *detail=[[[FishImageViewController alloc]initWithNibName:@"FishImageViewController" bundle:nil]autorelease];
    detail.FishImageID=[dict objectForKey:@"id"];
        [self.navigationController pushViewController:detail animated:YES];

}
- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return wrap;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end