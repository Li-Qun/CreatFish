//
//  LifeItemViewController.m
//  Fish
//
//  Created by DAWEI FAN on 21/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "LifeItemViewController.h"


#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#import <ShareSDKCoreService/ShareSDKCoreService.h>

#import <sqlite3.h>
@interface LifeItemViewController ()

@end

@implementation LifeItemViewController
@synthesize FishImageID=FishImageID;
@synthesize klpImgArr;
@synthesize klpScrollView1;
@synthesize isNationID=isNationID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SwimFish@2X.png"]];
        imgView.frame = self.view.bounds;
        imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view insertSubview:imgView atIndex:0];
        [imgView release];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    NSLog(@"===%@ %d",self.FishImageID,app.targetCenter);
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ContentRead* contentRead =[[[ContentRead alloc]init]autorelease];
    contentRead.delegate=self;
    [contentRead  gallery:@"9"];//@"9"
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat height = size.height;
    
    Fish_arr=[[[NSMutableArray alloc]init]retain];
    shareImage=[[[NSString alloc]init]retain];
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
    topBarView.image=[UIImage imageNamed:@"topBarRed"];
    [self.view addSubview:topBarView];
    
    
    UIImageView *wordView=[[[UIImageView alloc]initWithFrame:CGRectMake(135, littleHeinght+2, 40, 20)]autorelease];
    if([isNationID integerValue]==12)
        wordView.image=[UIImage imageNamed:@"nation"];
    else
    wordView.image=[UIImage imageNamed:@"aboard"];
    [topBarView addSubview:wordView];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(10, littleHeinght, 37, 30);
    leftBtn.tag=10;
    [leftBtn setImage:[UIImage imageNamed:@"theGoBack"] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(SwimSwitch_BtnTag:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(270, littleHeinght, 37, 30);
    [rightBtn setImage:[UIImage imageNamed:@"BigFishListShare@2X"] forState:UIControlStateNormal];
    [self.view addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(SwimSwitch_BtnTag:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag=20;
}
-(void)reBack:(NSString *)jsonString reLoad:(NSString *)ID
{
    NSString *strJson;
    NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPaths=[array objectAtIndex:0];
    NSString *str=[NSString stringWithFormat:@"LifeItem_Database3"];
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
    NSString *sql=@"CREATE TABLE IF NOT EXISTS picture (ID TEXT,pic TEXT)"; //创建表
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
    {
        NSLog(@"create success");
    }else{
        NSLog(@"create error:%s",errorMsg);
        sqlite3_free(errorMsg);
    }
    sql =[NSString stringWithFormat:@"select pic from picture where ID='%@'",ID];
    sqlite3_stmt *stmt;
    //查找数据
    
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
    {
        
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            
            
            const unsigned char *_id= sqlite3_column_text(stmt, 0);
            strJson= [NSString stringWithUTF8String: _id];
            const unsigned char *_pic= sqlite3_column_text(stmt, 1);
            //strJson= [NSString stringWithUTF8String: _pic];
            break;
        }
    }
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSDictionary *jsonObj =[parser objectWithString: strJson];
    
    NSDictionary *data = [jsonObj objectForKey:@"data"];
     NSMutableArray *arr=[[[NSMutableArray alloc]init]autorelease];
    for (int i =0; i <data.count; i++) {
        [arr insertObject:[data objectAtIndex:i] atIndex: i];
        //[Fish_arr insertObject:[data objectAtIndex:i] atIndex: i];
    }
    Fish_arr=arr;
    [self createView];
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag isID:(NSString *)ID
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //耗时的一些操作
        
        
        NSString *strJson;
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *str=[NSString stringWithFormat:@"LifeItem_Database3"];
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
        NSString *sql=@"CREATE TABLE IF NOT EXISTS picture (ID TEXT,pic TEXT)"; //创建表
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
        {
            NSLog(@"create success");
        }else{
            NSLog(@"create error:%s",errorMsg);
            sqlite3_free(errorMsg);
        }
        sql =[NSString stringWithFormat:@"select ID from picture where ID='%@'",ID];
        sqlite3_stmt *stmt;
        //查找数据
        BOOL OK=NO;
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                
                
                const unsigned char *_id= sqlite3_column_text(stmt, 0);
                NSString *Id= [NSString stringWithUTF8String: _id];
                const unsigned char *_pic= sqlite3_column_text(stmt, 1);
                // strJson= [NSString stringWithUTF8String: _pic];
                if([ID isEqualToString:Id])
                {
                    OK=YES;
                    break;
                }
            }
        }
        if(!OK)
        {
            NSString *insertSQLStr = [NSString stringWithFormat:
                                      @"INSERT INTO 'picture' ('ID','pic' ) VALUES ('%@','%@')", ID,jsonString];
            const char *insertSQL=[insertSQLStr UTF8String];
            //插入数据 进行更新操作
            if (sqlite3_exec(database, insertSQL , NULL, NULL, &errorMsg)==SQLITE_OK) {
                NSLog(@"insert operation is ok.");
            }
            else{
                NSLog(@"insert error:%s",errorMsg);
                sqlite3_free(errorMsg);
            }
        }
        //  最后，关闭数据库：
        sqlite3_close(database);

        dispatch_async(dispatch_get_main_queue(), ^{//主线程
            
            SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
            NSDictionary *jsonObj =[parser objectWithString:jsonString];
            
            NSDictionary *data = [jsonObj objectForKey:@"data"];
            
            for (int i =0; i <data.count; i++) {
                
                [Fish_arr  insertObject:[data objectAtIndex:i] atIndex: i];
            }
            [self createView];
        });
    });
    
    
    
  /*
    
    
    
    NSString *strJson;
    NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPaths=[array objectAtIndex:0];
    NSString *str=[NSString stringWithFormat:@"LifeItem_Database3"];
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
    NSString *sql=@"CREATE TABLE IF NOT EXISTS picture (ID TEXT,pic TEXT)"; //创建表
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
    {
        NSLog(@"create success");
    }else{
        NSLog(@"create error:%s",errorMsg);
        sqlite3_free(errorMsg);
    }
    sql =[NSString stringWithFormat:@"select pic from picture where ID='%@'",ID];
    sqlite3_stmt *stmt;
    //查找数据
    
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
    {
        
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            
            
            const unsigned char *_id= sqlite3_column_text(stmt, 0);
            NSString *Id= [NSString stringWithUTF8String: _id];
            const unsigned char *_pic= sqlite3_column_text(stmt, 1);
           // strJson= [NSString stringWithUTF8String: _pic];
            
            
            
        }
    }
    NSString *insertSQLStr = [NSString stringWithFormat:
                              @"INSERT INTO 'picture' ('ID','pic' ) VALUES ('%@','%@')", ID,jsonString];
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
    sql = @"select * from picture";
  //  sqlite3_stmt *stmt;
    //查找数据
    
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
    {
        
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            const unsigned char *_id= sqlite3_column_text(stmt, 0);
            NSString *Id= [NSString stringWithUTF8String: _id];
            const unsigned char *_pic= sqlite3_column_text(stmt, 1);
            strJson= [NSString stringWithUTF8String: _pic];
            
            
            break;
        }
    }
    sqlite3_finalize(stmt);
    
    //  最后，关闭数据库：
    sqlite3_close(database);
///////////////*/
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)SwimSwitch_BtnTag:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    if(btn.tag==10)//zuo
        [self.navigationController popViewControllerAnimated:YES];
    else
    {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                           defaultContent:@"分享一下你的心情吧"
                                                    image:[ShareSDK imageWithPath:imagePath]
                                                    title:@"ShareSDK"
                                                      url:@"http://www.huiztech.com"
                                              description:@"这是一条测试信息"
                                                mediaType:SSPublishContentMediaTypeNews];
        
        [ShareSDK showShareActionSheet:nil
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions: nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSResponseStateSuccess)
                                    {
                                        NSLog(@"分享成功");
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                    }
                                }];
        
        
    }
}
-(void)createView//:(NSMutableArray *)firstPageImage
{
    ///UIScrollerView
    //2.image
    int bottom;
    int width;
    if(isSeven&&isFive)
    {
        bottom=405;
    }
    else if(isSeven&&!isFive)
    {
        bottom=370;
    }else if(!isSeven&&isFive)//
    {
        bottom=405;
    }else {
        width=5;
        bottom=360;
    }
    
    klpScrollView1.frame=CGRectMake(0, 81, 320,bottom);

    index = 0;
    self.klpImgArr = [[NSMutableArray alloc] initWithCapacity:Fish_arr.count];
    CGSize size = self.klpScrollView1.frame.size;
    if(height_Momente==480)  height=60;
    for (int i=0; i <Fish_arr.count; i++) {
        NSDictionary* dict = [Fish_arr objectAtIndex:i];
        UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(width+ 20+size.width * i, 0, size.width-40-width*2, size.height+height)]autorelease];
        NSString *imgURL=[NSString stringWithFormat:@"http://42.96.192.186/ifish/server/upload/%@",[dict objectForKey:@"image"] ];
        [iv setImageWithURL:[NSURL URLWithString: imgURL]
           placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                    success:^(UIImage *image) {NSLog(@"OK");}
                    failure:^(NSError *error) {NSLog(@"NO");}];
        
        
        
        UIImageView *red=[[[UIImageView alloc]init]autorelease];
        red.frame=CGRectMake(210-width*16/9, 5, 72, 30);
        red.image=[UIImage imageNamed:@"imageLabel"];
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 72, 30)];
        lable.backgroundColor=[UIColor clearColor];
        lable.textColor=[UIColor whiteColor];
        //文字居中显示
        
        lable.textAlignment= UITextAlignmentCenter;
        lable.text=[NSString stringWithFormat:@"%d/%d",i+1,Fish_arr.count];
        [red addSubview:lable];
        [iv addSubview:red];
        [self.klpScrollView1 addSubview:iv];
        iv = nil;
        
        [iv setImage:[UIImage imageNamed:[dict objectForKey:@"image"]]];
        [self.klpScrollView1 addSubview:iv];
        iv = nil;
        
        
    }
    
    
    [self.klpScrollView1 setContentSize:CGSizeMake(size.width * Fish_arr.count, 0)];//只可横向滚动～
    
    self.klpScrollView1.pagingEnabled = YES;
    self.klpScrollView1.showsHorizontalScrollIndicator = NO;
    //往数组里添加成员
    for (int i=0; i<Fish_arr.count; i++) {
        NSDictionary* dict = [Fish_arr objectAtIndex:i];
        UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(100*i + 5*i,0,size.height+height,70)]autorelease];
        [iv setImage:[UIImage imageNamed:[dict objectForKey:@"image"]]];
        [self.klpImgArr addObject:iv];
        iv = nil;
    }
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    
    [self.klpScrollView1 addGestureRecognizer:singleTap];
    
    //[klpScrollView1 release];
    // [klpImgArr release];
    //  [app.firstPageImage release];
    ///UIScrollerView
    
    
}
#pragma mark 手势
- (void) handleSingleTap:(UITapGestureRecognizer *) gestureRecognizer{
	CGFloat pageWith = 320;
    
    CGPoint loc = [gestureRecognizer locationInView:self.klpScrollView1];
    NSInteger touchIndex = floor(loc.x / pageWith) ;
    if (touchIndex > app.firstPageImage.count+1) {
        return;
    }
    //进入详细阅读
    NSLog(@"touch index %d",touchIndex);
    NSDictionary* dict = [Fish_arr objectAtIndex:touchIndex];
    
    shareImage=[NSString stringWithFormat:@"http://42.96.192.186/ifish/server/upload/%@",[dict objectForKey:@"image"]];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareImage
                                       defaultContent:@"分享一下你的心情吧"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.huiztech.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

#pragma mark-- UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	//NSLog(@"scrollViewDidEndDecelerating");
	if (scrollView == self.klpScrollView1) {
		klp.frame = ((UIImageView*)[self.klpImgArr objectAtIndex:index]).frame;
		[klp setAlpha:0];
		[UIView animateWithDuration:0.2f animations:^(void){
			[klp setAlpha:.85f];
		}];
        
    }else {
		
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
