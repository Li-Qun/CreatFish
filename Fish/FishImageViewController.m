//
//  FishImageViewController.m
//  Fish
//
//  Created by DAWEI FAN on 20/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "FishImageViewController.h"

#import "MBProgressHUD.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import <sqlite3.h>
//#import "BaiduMobStat.h"
@interface FishImageViewController ()

@end

@implementation FishImageViewController
@synthesize FishImageID=FishImageID;
@synthesize klpImgArr;
@synthesize klpScrollView1;
@synthesize detailName=detailName;
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
//百度页面统计
-(void)viewDidAppear:(BOOL)animated
{
//    NSString *cName=[NSString stringWithFormat:@"FishItem&%@",detailName];
//    [[BaiduMobStat defaultStat]pageviewStartWithName:cName ];
}
-(void)viewDidDisappear:(BOOL)animated
{
//     NSString *cName=[NSString stringWithFormat:@"FishItem&%@",detailName];
//    [[BaiduMobStat defaultStat]pageviewEndWithName:cName ];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat height1 = size.height;
    
    Fish_arr=[[[NSMutableArray alloc]init]retain];
    shareImage=[[[NSString alloc]init]retain];
    if(height1==480)
    {
        isFive=NO;
    }else isFive=YES;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version <7.0)
        isSeven=NO;
    else isSeven=YES;
    
    int bottom;
    if(isSeven&&isFive)
    {
        heightTopbar=65;
        littleHeinght=20;
        bottom=405;
    }
    else if(isSeven&&!isFive)
    {
        heightTopbar=58;
        littleHeinght=20;
        bottom=370;
    }else if(!isSeven&&isFive)//
    {
        heightTopbar=45;
        littleHeinght=10;
        bottom=405;
    }else {
        heightTopbar=45;
        littleHeinght=10;
        bottom=405;
    }
    
    klpScrollView1.frame=CGRectMake(0, 81, 320,bottom);//klpScrollView1.frame=CGRectMake(0, 486, 320,bottom);

    
    UIImageView *topBarView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, heightTopbar)]autorelease];
    topBarView.image=[UIImage imageNamed:@"topBarRed"];
    [self.view addSubview:topBarView];
    
    UILabel *name=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, heightTopbar)]autorelease];
    name.textColor=[UIColor whiteColor];
    name.text=detailName;
    name.textAlignment = NSTextAlignmentCenter;
    name.font =[UIFont boldSystemFontOfSize:21];
    name.shadowColor = [UIColor grayColor];
    name.shadowOffset = CGSizeMake(0.0,0.5);
    name.backgroundColor=[UIColor clearColor];
    [topBarView addSubview:name];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *backView=[[[UIImageView alloc]initWithFrame:CGRectMake(270, littleHeinght, 30, 25)]autorelease];
    backView.image=[UIImage imageNamed:@"theGoBack@2X"];
    
    leftBtn.frame=CGRectMake(10, littleHeinght, 30, 25);
    leftBtn.tag=10;
    [leftBtn setImage:backView.image forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(FishItemSwitch_BtnTag:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(270, littleHeinght, 37, 30);
    [rightBtn setImage:[UIImage imageNamed:@"BigFishListShare@2X"] forState:UIControlStateNormal];
    [self.view addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(FishItemSwitch_BtnTag:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag=20;

    
     NSLog(@"%@ %d",self.FishImageID,app.targetCenter);
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ContentRead* contentRead =[[[ContentRead alloc]init]autorelease];
    contentRead.delegate=self;
    [contentRead  gallery:FishImageID];

}
-(void)reBack:(NSString *)jsonString reLoad:(NSString *)ID Offent:(NSString *)Out
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *strJson;
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *str=[NSString stringWithFormat:@"FishItem_Database"];
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
        BOOL flag=NO;
        sql =[NSString stringWithFormat:@"select pic from picture where ID='%@'",ID];
        sqlite3_stmt *stmt;
        //查找数据
        
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            int i=0;
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                i=1;
                if(sqlite3_column_count(stmt)==0)
                {
                    flag=YES;
                    break;
                }
                const unsigned char *_id= sqlite3_column_text(stmt, 0);
                strJson= [NSString stringWithUTF8String: _id];
                //const unsigned char *_pic= sqlite3_column_text(stmt, 1);
                //strJson= [NSString stringWithUTF8String: _pic];
                break;
            }
            if(i==0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"该缓存为空，请连接网络使用"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
                [alert release];

                sqlite3_finalize(stmt);
                sqlite3_close(database);
                return ;
            }
        }
        sqlite3_finalize(stmt);
        sqlite3_close(database);

        dispatch_async(dispatch_get_main_queue(), ^{//主线程
            if(flag||[self isBlankString:strJson])
            {
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
                SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
                NSDictionary *jsonObj =[parser objectWithString: strJson];
                NSArray *data = [jsonObj objectForKey:@"data"];
                app.share_String=[jsonObj objectForKey:@"name"];
                NSMutableArray *arr=[[[NSMutableArray alloc]init]autorelease];
                
                for (int i =0; i <data.count; i++) {
                    [arr insertObject:[data objectAtIndex:i] atIndex: i];
                    //[Fish_arr insertObject:[data objectAtIndex:i] atIndex: i];
                }
                Fish_arr=arr;
                [self createView];
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
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"暂无加载内容～"
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles: @"确定",nil]autorelease];
            [alert show];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"正在加载图片~~";//加载提示语言
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //耗时的一些操作
                //NSString *strJson;
                NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPaths=[array objectAtIndex:0];
                NSString *str=[NSString stringWithFormat:@"FishItem_Database"];
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
                        //                const unsigned char *_pic= sqlite3_column_text(stmt, 1);
                        //                // strJson= [NSString stringWithUTF8String: _pic];
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
                    
                    app.share_String=[jsonObj objectForKey:@"name"];
                    NSArray *data = [jsonObj objectForKey:@"data"];
                    
                    for (int i =0; i <data.count; i++) {
                        
                        [Fish_arr  insertObject:[data objectAtIndex:i] atIndex: i];
                    }
                   
                    [self createView];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            });
            
        }

    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   

}
-(void)FishItemSwitch_BtnTag:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    if(btn.tag==10)//zuo
        [self.navigationController popViewControllerAnimated:YES];
    else
    {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
        //构造分享内容
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:NO
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:self
                                                   authManagerViewDelegate:self];
        
        id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"
                                                                  oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                   qqButtonHidden:YES
                                                            wxSessionButtonHidden:YES
                                                           wxTimelineButtonHidden:YES
                                                             showKeyboardOnAppear:NO
                                                                shareViewDelegate:self
                                                              friendsViewDelegate:self
                                                            picViewerViewDelegate:nil];
        
         NSString *string=[NSString stringWithFormat:@"%@浏览图片%@",shareContent1,shareContent2];
        id<ISSContent> publishContent = [ShareSDK content:string
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
                           authOptions:authOptions
                          shareOptions: shareOptions
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
    int bottom;
    int width=0;
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
    app.firstPageImage=Fish_arr;
    ///UIScrollerView
    //2.image
    index = 0;
    self.klpImgArr = [[NSMutableArray alloc] initWithCapacity:Fish_arr.count];
    CGSize size = self.klpScrollView1.frame.size;
    if(height_Momente==480)  height=60;
    for (int i=0; i <Fish_arr.count; i++) {
        NSDictionary* dict = [Fish_arr objectAtIndex:i];
        UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(width+20+size.width * i, 0, size.width-40-width*2, size.height+height)]autorelease];
        NSString *imgURL=[NSString stringWithFormat:@"%@%@",Image_Head,[dict objectForKey:@"image"] ];
        [iv setImageWithURL:[NSURL URLWithString: imgURL]
           placeholderImage:[UIImage imageNamed:@"moren.png"]
                    success:^(UIImage *image) {NSLog(@"OK");}
                    failure:^(NSError *error) {NSLog(@"NO");}];
        
        UIImageView *red=[[[UIImageView alloc]init]autorelease];
        red.frame=CGRectMake(210-width*16/9, 5, 72, 30);
        red.image=[UIImage imageNamed:@"imageLabel"];
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 72, 30)];
        lable.backgroundColor=[UIColor clearColor];
        lable.textColor=[UIColor whiteColor];
        //文字居中显示
        
        lable.textAlignment= NSTextAlignmentCenter;
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
    if (touchIndex > app.firstPageImage.count) {
        return;
    }
    //进入详细阅读
    NSLog(@"touch index %d",touchIndex);
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
