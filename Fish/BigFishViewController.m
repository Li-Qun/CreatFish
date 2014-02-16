//
//  BigFishViewController.m
//  Fish
//
//  Created by DAWEI FAN on 20/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "BigFishViewController.h"
#import "FishImageViewController.h"
#import "MBProgressHUD.h"
#import <sqlite3.h>
#import "BaiduMobStat.h"

#define ITEM_SPACING 200
@interface BigFishViewController ()

@end

@implementation BigFishViewController
@synthesize target=target;
@synthesize carousel;
@synthesize labelText=labelText;
@synthesize wrap;
@synthesize BigFishName=BigFishName;
@synthesize BigFishPid=BigFishPid;
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
//百度页面统计
-(void)viewDidAppear:(BOOL)animated
{
    NSString *cName=[NSString stringWithFormat:@"BigFish&%@",BigFishName];
    [[BaiduMobStat defaultStat]pageviewStartWithName:cName ];
}
-(void)viewDidDisappear:(BOOL)animated
{
    NSString *cName=[NSString stringWithFormat:@"BigFish&%@",BigFishName];
    [[BaiduMobStat defaultStat]pageviewEndWithName:cName ];
}
- (void)dealloc
{
    [carousel release];
    [labelText release];
    [super dealloc];
}
-(void)buildTheNewTopBar
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
    
    UILabel *name=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, heightTopbar)]autorelease];
    name.textColor=[UIColor whiteColor];
    name.text=BigFishName;
    name.textAlignment = UITextAlignmentCenter;
    name.font =[UIFont boldSystemFontOfSize:21];
    name.shadowColor = [UIColor grayColor];
    name.shadowOffset = CGSizeMake(0.0,0.5);
    name.backgroundColor=[UIColor clearColor];
    [topBarView addSubview:name];
    
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
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [self buildTheNewTopBar];
    
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    app.targetCenter=[BigFishPid intValue];
    
    if(!isFirstOpen)
    {
        ContentRead* contentRead =[[[ContentRead alloc]init]autorelease];
        NSString *str=[NSString stringWithFormat:@"%d",target];
        
        [contentRead setDelegate:self];//设置代理
        sum=0;
        [contentRead fetchList:str isPri:@"0" Out:@"0"];
        isFirstOpen=YES;
    }
}
-(void)reBack:(NSString *)jsonString reLoad:(NSString *)ID Offent:(NSString *)Out
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
    NSLog(@"%@",ID);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //耗时的一些操作
        NSString *strJson;
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *str=[NSString stringWithFormat:@"BigFishViewController_DataBase"];
        NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:str];
        sqlite3 *database;
        
        if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
        {
            NSLog(@"open success");
        }
        else {
            NSLog(@"open failed");
        }
        BOOL flag=NO;
        //初始查询该条记录是否存在 不存在 提示 存在 读取并 加载
        NSString* sql =[NSString stringWithFormat:@"select  count(*) from picture where ID='%@' and Offent='%@'",ID,Out];
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                
                const unsigned char *_id= sqlite3_column_text(stmt, 0);
                strJson= [NSString stringWithUTF8String: _id];
                if([strJson isEqualToString:@"0"])//count ==0 记录不存在
                {
                    flag=YES;
                }
            }
        }
        
        sql =[NSString stringWithFormat:@"select pic from picture where ID='%@' and Offent='%@'",ID,Out];
 
        //查找数据
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                //  int i=sqlite3_column_int(stmt, 0)-1;
                
                if(sqlite3_column_count(stmt)==0)
                {
                    flag=YES;
                    break;
                }
                const unsigned char *_pic= sqlite3_column_text(stmt, 0);
                strJson= [NSString stringWithUTF8String: _pic];
                
            }
            
        }
        sqlite3_finalize(stmt);
        
        //  最后，关闭数据库：
        sqlite3_close(database);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{//主线程
            
            if(flag||[self isBlankString:strJson])
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"该缓存为空，请连接网络使用"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
            else
            {
                //设置索引标识
                
                SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
                NSDictionary *jsonObj =[parser objectWithString:strJson];
              
                NSArray *data = [jsonObj objectForKey:@"data"];
                sum=app.BigFish_Description.count;
                total+=data.count;
                for(int i=0;i<data.count;i++)
                {
                    [app.BigFish_Description insertObject:[data objectAtIndex:i] atIndex: sum++];
                }
               
                
                carousel.delegate = self;
                [self.carousel reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                carousel.dataSource = self;
                
                carousel.type = iCarouselTypeCoverFlow;
                for (UIView *view in carousel.visibleItemViews)
                {
                    view.alpha = 1.0;
                }
                
                labelText.text=[[app.BigFish_Description objectAtIndex:0] objectForKey:@"description"];
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
           
            
            
        });
    });
}
- (BOOL) isBlankString:(NSString *)string {//判断字符串是否为空 方法
    
    if (string == nil || string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag isID:(NSString *)ID Offent:(NSString *)Out
{
    
    if([self isBlankString:jsonString])
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"网络不佳，请重新操作试试看～"
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles: @"确定",nil]autorelease];
        [alert show];
        
    }
    else
    {
        SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
        NSDictionary *jsonObj =[parser objectWithString:jsonString];
        NSArray *data = [jsonObj objectForKey:@"data"];
        if(data.count==0)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"暂无加载内容～"
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles: @"确定",nil]autorelease];
            [alert show];
            
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPaths=[array objectAtIndex:0];
                NSString *str=[NSString stringWithFormat:@"BigFishViewController_DataBase"];
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
                // 删除所有数据 并进行更新数据库操作
                //删除所有数据，条件为1>0永真
                //            const char *deleteAllSql="delete from picture where 1>0";
                //            //执行删除语句
                //            if(sqlite3_exec(database, deleteAllSql, NULL, NULL, &errorMsg)==SQLITE_OK){
                //                NSLog(@"删除所有数据成功");
                //            }
                //            else NSLog(@"delect failde!!!!");
                
                NSString* sql ;
                sql=@"CREATE TABLE IF NOT EXISTS picture (ID TEXT,Offent TEXT,pic TEXT)";
                //创建表
                if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
                {
                    NSLog(@"create success");
                }else{
                    NSLog(@"create error:%s",errorMsg);
                    sqlite3_free(errorMsg);
                }
                //查找数据
                sql=[NSString stringWithFormat:@"select ID from picture where ID='%@'and Offent='%@'",ID,Out];
                sqlite3_stmt *stmt;
                //查找数据
                BOOL OK=NO;
                
                if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
                {
                    
                    while (sqlite3_step(stmt)==SQLITE_ROW) {
                        
                        
                        const unsigned char *_id= sqlite3_column_text(stmt, 0);
                        NSString *Id= [NSString stringWithUTF8String: _id];
                        if([ID isEqualToString:Id])
                        {
                            OK=YES;
                            break;
                        }
                    }
                }
                if(!OK)
                {
                    NSString *insertSQLStr1 =[NSString stringWithFormat:
                                              @"INSERT INTO 'picture' ('ID','Offent','pic' ) VALUES ('%@','%@','%@')", ID,Out,jsonString];
                    const char *insertSQL1=[insertSQLStr1 UTF8String];
                    //插入数据 进行更新操作
                    if (sqlite3_exec(database, insertSQL1 , NULL, NULL, &errorMsg)==SQLITE_OK) {
                        NSLog(@"insert operation is ok.");
                    }
                    else{
                        NSLog(@"insert error:%s",errorMsg);
                        sqlite3_free(errorMsg);
                    }
                }
                sqlite3_finalize(stmt);
                //  最后，关闭数据库：
                sqlite3_close(database);
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{//主线程
                    
                    
                    //设置索引标识
                    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
                    NSDictionary *jsonObj =[parser objectWithString:jsonString];
                   
                    NSArray *data = [jsonObj objectForKey:@"data"];
                    sum=app.BigFish_Description.count;
                    total+=data.count;
                    for(int i=0;i<data.count;i++)
                    {
                        [app.BigFish_Description insertObject:[data objectAtIndex:i] atIndex: sum++];
                    }
 
                    
                    carousel.delegate = self;
                    [self.carousel reloadData];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    carousel.dataSource = self;
                    
                    carousel.type = iCarouselTypeCoverFlow;
                    for (UIView *view in carousel.visibleItemViews)
                    {
                        view.alpha = 1.0;
                    }
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
                    
                    labelText.text=[[app.BigFish_Description objectAtIndex:0] objectForKey:@"description"];
                    labelText.textColor=[UIColor whiteColor];
                    labelText.backgroundColor=[UIColor clearColor];
                    labelText.font=[UIFont systemFontOfSize:14.0f];
                    labelText.numberOfLines = 0;
                    [labelText sizeToFit];
                    labelText.frame=CGRectMake(59, 462-lab_height, 230, 99);
                    
                    
                    [UIView beginAnimations:nil context:nil];
                    carousel.type=5;
                    [UIView commitAnimations];
                    
                });
            });
            
        }
   
    }
}
- (void)viewDidLoad
{//@"直线"0, @"圆圈"1, @"反向圆圈"2, @"圆桶"3, @"反向圆桶"4, @"封面展示5", @"封面展示2"6, @"纸牌"7
    [self.navigationController setNavigationBarHidden:YES];
    [super viewDidLoad];
    isFirstOpen=NO;
    
    
    
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
                //app.targetCenter=1;
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
    if(btn.tag==10)//左按钮
    {
        
        [self.viewDeckController toggleLeftViewAnimated:YES];
    }
    else
    {
      //  app.targetCenter=target;
        [self.viewDeckController toggleRightViewAnimated:YES];
    }
    
}
#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return  total+1;
}

- (UIView *)carousel:(iCarousel *)carousel1 viewForItemAtIndex:(NSUInteger)index1
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
    
    carousel1.frame=CGRectMake(24, 30+img_height, 220, 289);
    UIView* view = [[[UIImageView alloc] init ] autorelease];
    if(index1==total)
    {
        UIImageView *imageView_LoadMore=[[[UIImageView alloc]initWithFrame:carousel1.frame]autorelease];
        imageView_LoadMore.image=[UIImage imageNamed:@"moren.png"];
        [view addSubview:imageView_LoadMore];
    }
    else
    {
        NSDictionary* dict = [app.BigFish_Description objectAtIndex:(index1)];
        NSString *imgURL=[NSString stringWithFormat:@"%@%@",Image_Head,[dict objectForKey:@"image"]];
        UIImageView *ImageView=[[[UIImageView alloc]initWithFrame:carousel1.frame ]autorelease];
        [ImageView  setImageWithURL:[NSURL URLWithString: imgURL]
                   placeholderImage:[UIImage imageNamed:@"moren.png"]
                            success:^(UIImage *image) {NSLog(@"OK");}
                            failure:^(NSError *error) {NSLog(@"NO");}];
        [view addSubview:ImageView];
        
    }
    view.frame =CGRectMake(0, 0, 220, 289); //CGRectMake(0, -littleHeinght*6, 280, 400-littleHeinght*6);
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 1.0;
    view.layer.shadowRadius = 5.0;
    view.layer.shadowOffset = CGSizeMake(1, 1);
    view.clipsToBounds = NO;
    labelText.frame=CGRectMake(59, 462-lab_height, 230, 99);
    
    [self.view  reloadInputViews];
    
    return view;
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel1 {
    
    NSLog(@"%f",carousel1.scrollOffset);
    index=carousel1.scrollOffset/200;
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
  
    if(index>=0&&index<carousel1.indexesForVisibleItems.count-1)
    {
        labelText.text=[[app.BigFish_Description objectAtIndex:index] objectForKey:@"description"];
        labelText.textColor=[UIColor whiteColor];
        labelText.backgroundColor=[UIColor clearColor];
        labelText.font=[UIFont systemFontOfSize:14.0f];
        labelText.numberOfLines = 0;
        [labelText sizeToFit];
        labelText.frame=CGRectMake(59, 462-lab_height, 230, 99);
    }
    else
    {
        labelText.text=@"点击默认图片加载更多...";
        labelText.textColor=[UIColor whiteColor];
        labelText.backgroundColor=[UIColor clearColor];
        labelText.font=[UIFont systemFontOfSize:18.0f];
        labelText.numberOfLines = 0;
        [labelText sizeToFit];
        labelText.frame=CGRectMake(59, 462-lab_height, 230, 99);
    }
    
    
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return total+1;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = _carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * _carousel.itemWidth);
}
 
- (void)carousel:(iCarousel *)carousel1 didSelectItemAtIndex:(NSInteger)index1;
{
    NSLog(@"选中第%d张游钓/大鱼榜图片",index1);
    if(index1==total)
    {
        NSLog(@"点击加载更多...");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"正在加载图片~~";//加载提示语言
        ContentRead* contentRead =[[[ContentRead alloc]init]autorelease];
        NSString *str=[NSString stringWithFormat:@"%d",target];
        
        [contentRead setDelegate:self];//设置代理
        NSString *str1=[NSString stringWithFormat:@"%d",total];
        
        [contentRead fetchList:str isPri:@"0" Out:str1];
        
        
    }
    else
    {
        NSDictionary* dict = [app.BigFish_Description objectAtIndex:index1];
        FishImageViewController *detail=[[[FishImageViewController alloc]initWithNibName:@"FishImageViewController" bundle:nil]autorelease];
        detail.FishImageID=[dict objectForKey:@"id"];
        detail.detailName=BigFishName;
        NSLog(@"%@",BigFishName);
        [self.navigationController pushViewController:detail animated:YES];
    }
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