//
//  TopicViewController.m
//  Fish
//
//  Created by DAWEI FAN on 18/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "TopicViewController.h"
#import "BookViewController.h"
#import "BigFishViewController.h"
#import "DetailViewController.h"

#import "IIViewDeckController.h"
#import <sqlite3.h>
//#import "BaiduMobStat.h"
@interface TopicViewController ()

@end

@implementation TopicViewController
@synthesize klpImgArr;
@synthesize klpScrollView1;
@synthesize labelText=labelText;
@synthesize CenterIB=CenterIB;
@synthesize topicID=topicID;
@synthesize topicName=topicName;
@synthesize target=target;
@synthesize targetRight=targetRight;
@synthesize textView=textView;
@synthesize leftSwipeGestureRecognizer,rightSwipeGestureRecognizer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGSize size = rect.size;
 
        height_Momente = size.height;
        if(height_Momente==480){
            height=20;
            height5_flag=NO;
        }
        else  height5_flag=YES;
        // 判断设备的iOS 版本号
        float  version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if(version==7.0)
        {
            Kind7=YES;
        }
        else Kind7=NO;

        
            }
    return self;
}
//百度页面统计
-(void)viewDidAppear:(BOOL)animated
{
//    NSString *cName=[NSString stringWithFormat:@"Topic&%@",topicName];
//    [[BaiduMobStat defaultStat]pageviewStartWithName:cName ];
}
-(void)viewDidDisappear:(BOOL)animated
{
//     NSString *cName=[NSString stringWithFormat:@"Topic&%@",topicName];
//    [[BaiduMobStat defaultStat]pageviewEndWithName:cName ];
}

-(void)viewWillAppear:(BOOL)animated
{
    textView.backgroundColor=[UIColor clearColor];
}
-(void)buildToolBar
{
    float heightTooBar;
    float buttonHeight;
    
    if(height5_flag&&Kind7)
    {
        heightTooBar=height_Momente-height-44;
        buttonHeight=5+height_Momente-44-height;
    }else if(height5_flag&&!Kind7)
    {
        heightTooBar=height_Momente-44-20;
        buttonHeight=5+height_Momente-44-20;
    }
    else if (!height5_flag&&Kind7)
    {
        heightTooBar=height_Momente-44;
        buttonHeight=5+height_Momente-44 ;
    }
    else {
        heightTooBar=height_Momente-height-44;
        buttonHeight=5+height_Momente-44-height;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //耗时的一些操作
        
        NSString *strJson;
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"NewsViewController"];
        //  然后建立数据库，新建数据库这个苹果做的非常好，非常方便
        sqlite3 *database;
        //新建数据库，存在则打开，不存在则创建
        if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
        {
            NSLog(@"open success");
        }
        else {
            NSLog(@"open failed");
        }
        // 对数据库建表操作：如果在些程序的过程中，发现表的字段要更改，一定要删除之前的表，如何做，就是删除程序或者换个表名，主键是自增的
        char *errorMsg;
        NSString *sql=@"CREATE TABLE IF NOT EXISTS buttonList (ID INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT)";
        //创建表
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
        {
            NSLog(@"create success");
        }else{
            NSLog(@"create error:%s",errorMsg);
            sqlite3_free(errorMsg);
        }
        // 查找数据
        sql = @"select * from buttonList";
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                const unsigned char *theName= sqlite3_column_text(stmt, 1);
                strJson= [NSString stringWithUTF8String: theName];
                break;
            }
        }
        sqlite3_finalize(stmt);
        sqlite3_close(database);
  
        dispatch_async(dispatch_get_main_queue(), ^{//主线程
            
            app.saveName=strJson;
            SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
            NSArray *jsonObj =[parser objectWithString: strJson];
            UIImageView *imgToolView=[[[UIImageView alloc]initWithFrame:CGRectMake(0,heightTooBar, 320, 44)]autorelease];
            imgToolView.image=[UIImage imageNamed:@"toolBar@2X.png"];
            imgToolView.tag=22;
            UIScrollView *scrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)]autorelease];
            scrollView.contentSize = CGSizeMake(640, 44);
            [scrollView setShowsHorizontalScrollIndicator:NO];//隐藏横向滚动条
            [imgToolView addSubview:scrollView];
            imgToolView . userInteractionEnabled = YES;
            [self.view addSubview:imgToolView];
            
            for(int i=0;i<5;i++)
            {
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                NSString* name= [[jsonObj  objectAtIndex:i+1] objectForKey:@"name"];
                button.tag=[[[jsonObj  objectAtIndex:i+1] objectForKey:@"id"]integerValue];
                
                [arrName insertObject:name atIndex:i];
                
                
                
                button.frame=CGRectMake(10+i*60, 0, 30, 40);
                button.showsTouchWhenHighlighted = YES;
                [button addTarget:self action:@selector(Press_Tag:) forControlEvents:UIControlEventTouchDown];
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
                label.text=name;
                label.font  = [UIFont fontWithName:@"Arial" size:15.0];
                label.backgroundColor=[UIColor clearColor];
                UILabel *labelNum=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 28, 25)];
                labelNum.text=[NSString stringWithFormat:@"%@", [[jsonObj  objectAtIndex:i+1] objectForKey:@"today_count"]];
                labelNum.font  = [UIFont fontWithName:@"Arial" size:12.0];
                labelNum.textColor=[UIColor whiteColor];
                labelNum.backgroundColor=[UIColor clearColor];
                UIImageView *imgViewRed=[[[UIImageView alloc]initWithFrame:CGRectMake(30, 7, 28, 25)]autorelease];
                if([labelNum.text isEqual:@"0"])
                    imgViewRed.image=[UIImage imageNamed:@"whiteBack.png"];
                else
                    imgViewRed.image=[UIImage imageNamed:@"redBack.png"];
                [imgViewRed addSubview:labelNum];
                [button addSubview:imgViewRed];
                [button addSubview:label];
                button.backgroundColor=[UIColor clearColor];
                [scrollView addSubview:button];
                [label release];
                
            }
  
        });
    });

}
-(void)reBack:(NSString *)jsonString reLoad:(NSString *)ID Offent:(NSString *)Out
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *strJson;
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *str=@"TopicViewC";
        NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:str];
        sqlite3 *database;
        
        if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
        {
            NSLog(@"open success");
        }
        else {
            NSLog(@"open failed");
        }
        
        sqlite3_stmt *stmt;
        int flag=0;
        NSString* sql =[NSString stringWithFormat:@"select pic from picture where ID='%@'",ID];
        //查找数据
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                
                if(sqlite3_column_count(stmt)==0)
                {
                    flag=1;
                    break;
                }
                const unsigned char *_id=sqlite3_column_text(stmt, 0);
                strJson=[NSString stringWithUTF8String:_id];
                break;
                
            }
        }
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        
 
        
        dispatch_async(dispatch_get_main_queue(), ^{//主线程
            
            if(flag==1)
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
                
                for (int i =0; i <data.count; i++) {
                    
                    [arr insertObject:[data objectAtIndex:i] atIndex: i];
                }
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //耗时的一些操作
            NSString *strJson;
            NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPaths=[array objectAtIndex:0];
            NSString *str=@"TopicViewC";
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
            NSString* sql=@"CREATE TABLE IF NOT EXISTS picture (ID TEXT,pic TEXT)";         //创建表
            if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
            {
                NSLog(@"create success");
            }else{
                NSLog(@"create error:%s",errorMsg);
                sqlite3_free(errorMsg);
            }
            
            // 查找数据
            sql =[NSString stringWithFormat:@"select ID from picture where ID='%@'",ID];
            sqlite3_stmt *stmt;
            //查找数据
            BOOL OK=NO;
            if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
            {
                
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    const unsigned char *_pic= sqlite3_column_text(stmt, 0);
                    strJson= [NSString stringWithUTF8String: _pic];
                    if([strJson isEqualToString:ID])
                    {
                        OK=YES;
                        break;
                    }
                }
            }
            if(!OK)
            {
                char *Sql = @"INSERT INTO 'picture' ('ID','pic') VALUES (?,?)";
                const char *insertSQL1=[Sql  UTF8String];
                if (sqlite3_prepare_v2(database, insertSQL1, -1, &stmt, nil) == SQLITE_OK) {
                    sqlite3_bind_text(stmt, 1,[ID   UTF8String], -1, NULL);
                    sqlite3_bind_text(stmt, 2,[jsonString   UTF8String], -1, NULL);
                }
                if (sqlite3_step(stmt) != SQLITE_DONE)
                    NSLog(@"Something is Wrong!");
            }
            sqlite3_finalize(stmt);
            sqlite3_close(database);
            dispatch_async(dispatch_get_main_queue(), ^{//主线程
                SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
                NSDictionary *jsonObj =[parser objectWithString: jsonString];
                NSArray *data = [jsonObj objectForKey:@"data"];
                
                for (int i =0; i <data.count; i++) {
                    
                    [arr insertObject:[data objectAtIndex:i] atIndex: i];
                }
                [self createView];
            });
        });

    }
}
- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES];
    
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.targetCenter=target;//主视图
    
    CenterIB=[NSString stringWithFormat:@"%d",target];
    if(targetRight==0)
    {
        topicID=CenterIB;
    }
    else
    {
        topicID=[NSString stringWithFormat:@"%d",targetRight];
        targetRight=0;
    }
    [super viewDidLoad];
 //   scrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)]autorelease];
   // imgToolView=[[[UIImageView alloc]init]autorelease];
    [self buildToolBar];
        arr=[[[NSMutableArray alloc]init]retain];
    
    ContentRead* contentRead =[[[ContentRead alloc]init]autorelease];
    contentRead.delegate=self;
    [contentRead fetchList:topicID isPri:@"0" Out:@"0"];
    
    
    isOpenR=NO;isOpenL=NO;
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
     NSLog(@"2======:%d",target);
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"3======:%d",target);
    if (sender.direction == UISwipeGestureRecognizerDirectionRight&&sender.view!=klpScrollView1)//na
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
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft&&sender.view!=klpScrollView1) {//bie
        
        if(!isOpenR&&!isOpenL)
        {
            app.targetCenter=3;//主视图
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
-(void)createView//:(NSMutableArray *)firstPageImage
{
    
    float heightScrollview;
    int clearImgHeight;
    if(height5_flag&&Kind7)
    {
        heightScrollview=-20;
        clearImgHeight=0;
        
    }else if(height5_flag&&!Kind7)
    {
        heightScrollview=0;
    }
    else if (!height5_flag&&Kind7)
    {
        heightScrollview=0;
        clearImgHeight=0;
    }
    else {
        heightScrollview=0;
        clearImgHeight=20;
    }
    
    //self.klpScrollView1.frame=CGRectMake(0,heightScrollview, 320, 203);

    ///UIScrollerView
    //1.labelText// frame=CGRectMake(10,211,300,146);
    labelText.text= [ [arr objectAtIndex:0] objectForKey:@"description"];
    labelText.backgroundColor=[UIColor clearColor];
    labelText.font=[UIFont systemFontOfSize:14.0f];
    labelText.numberOfLines = 0;
    [labelText sizeToFit];
    
    textView.text=[ [arr objectAtIndex:0] objectForKey:@"description"];
    textView.backgroundColor=[UIColor clearColor];
    textView.font=[UIFont systemFontOfSize:14.0f];
    [textView setEditable:NO];
    textView.scrollEnabled=YES;
    //2.image
    index = 0;
    self.klpImgArr = [[NSMutableArray alloc] initWithCapacity:arr.count];
    CGSize size = self.klpScrollView1.frame.size;
    
   
    for (int i=0; i <arr.count; i++) {
        NSDictionary* dict = [arr objectAtIndex:i];
        UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(size.width * i, 0, size.width, size.height+height)]autorelease];
        NSString *imgURL=[NSString stringWithFormat:@"%@%@",Image_Head,[dict objectForKey:@"image"] ];
        [iv setImageWithURL:[NSURL URLWithString: imgURL]
           placeholderImage:[UIImage imageNamed:@"moren.png"]
                    success:^(UIImage *image) {NSLog(@"OK");}
                    failure:^(NSError *error) {NSLog(@"NO");}];
        
        UILabel *label=[[[UILabel alloc]initWithFrame:CGRectMake(4, 0, 320, 31)]autorelease];
        label.backgroundColor=[UIColor clearColor];
        label.textColor=[UIColor whiteColor];
        label.text=[dict objectForKey:@"image_title"];
        
        UIImageView *clearBack=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 154+clearImgHeight, 320, 31)]autorelease];
        
        clearBack.image=[UIImage imageNamed:@"clearBack@2X"];
        [iv addSubview:clearBack];
        [clearBack addSubview:label];
        UIImageView *theArrow=[[[UIImageView alloc]initWithFrame:CGRectMake(301, 8,8,12)]autorelease];
        theArrow.image=[UIImage imageNamed:@"theArrow"];
        [clearBack addSubview:theArrow];
        
        
        
        UILabel *numlable=[[[UILabel alloc]initWithFrame:CGRectMake(270, 4, 30, 20)]autorelease];
        numlable.backgroundColor=[UIColor clearColor];
        numlable.textColor=[UIColor whiteColor];
        //文字居中显示
        
        numlable.textAlignment= NSTextAlignmentCenter;
        numlable.text=[NSString stringWithFormat:@"%d/%d",i+1,arr.count];
        numlable.font=[UIFont boldSystemFontOfSize:14];
        [clearBack addSubview:numlable];
        
        [self.klpScrollView1 addSubview:iv];
        iv = nil;
        
                [iv setImage:[UIImage imageNamed:[dict objectForKey:@"image"]]];
               [self.klpScrollView1 addSubview:iv];
              iv = nil;
        
        
    }
    [self.klpScrollView1 setContentSize:CGSizeMake(size.width * arr.count, 0)];//只可横向滚动～
    
    self.klpScrollView1.pagingEnabled = YES;
    self.klpScrollView1.showsHorizontalScrollIndicator = NO;
    //往数组里添加成员
    for (int i=0; i<arr.count; i++) {
         NSDictionary* dict = [arr objectAtIndex:i];
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
#pragma mark-- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{\
	//NSLog(@"scrollViewDidScroll");
	if (scrollView == self.klpScrollView1) {
		CGFloat pageWidth = scrollView.frame.size.width;
		int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		index = page;
      
        
	}else {
		
	}
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	 if(scrollView ==self.klpScrollView1)
     {
         klp.frame = ((UIImageView*)[self.klpImgArr objectAtIndex:index]).frame;
         [klp setAlpha:0];
         [UIView animateWithDuration:0.2f animations:^(void){
             [klp setAlpha:.85f];
         }];
         
         NSDictionary* dict = [arr objectAtIndex:index];
         labelText.text=[dict objectForKey:@"description"];
         textView.text=[ dict objectForKey:@"description"];
         textView.backgroundColor=[UIColor clearColor];
         textView.font=[UIFont systemFontOfSize:14.0f];
         [textView setEditable:NO];
         textView.scrollEnabled=YES;
         NSLog(@"滑动到%d",index);
         UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap1:)]autorelease];
         [singleTap setNumberOfTapsRequired:1];
         
         [self.klpScrollView1 addGestureRecognizer:singleTap];

     }
	
}

#pragma mark 手势
- (void) handleSingleTap1:(UITapGestureRecognizer *) gestureRecognizer{
	CGFloat pageWith = 320;
    
    CGPoint loc = [gestureRecognizer locationInView:self.klpScrollView1];
    NSInteger touchIndex = floor(loc.x / pageWith) ;
    if (touchIndex > arr.count) {
        return;
    }
    //进入详细阅读
    if(touchIndex>0)
    {
        NSDictionary* dict = [arr objectAtIndex:touchIndex];
        
        DetailViewController *detail=[[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil]autorelease];
        
        detail.momentID=[dict objectForKey:@"id"];
        [self.navigationController pushViewController:detail animated:YES];

    }
}
- (void) handleSingleTap:(UITapGestureRecognizer *) gestureRecognizer{
	     //进入详细阅读
    NSDictionary* dict = [arr objectAtIndex:0];
    
    DetailViewController *detail=[[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil]autorelease];
    
    detail.momentID=[dict objectForKey:@"id"];
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)Press_Tag:(id)sender
{
    
    NSString *name;
    NSString *fatherID;
    NSString *isTopic;
    NSString *isGallery;
    NSLog(@"%d",app.targetCenter);
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%d",btn.tag);
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSArray *jsonObj =[parser objectWithString: app.saveName];
    int i;
    for(i=1;i<jsonObj.count;i++)
    {
        if([[[jsonObj  objectAtIndex:i] objectForKey:@"id"] integerValue]==btn.tag)
        {
            name= [[jsonObj  objectAtIndex:i] objectForKey:@"name"];
            fatherID= [[jsonObj  objectAtIndex:i] objectForKey:@"pid"];
            isGallery =[[jsonObj  objectAtIndex:i] objectForKey:@"is_gallery"];
            isTopic =[[jsonObj  objectAtIndex:i] objectForKey:@"is_special_topic"];
            break;
        }
    }
    
    if([isGallery integerValue]==0&& [isTopic integerValue]==0)
    {
        BookViewController *newVC = [[[BookViewController alloc] initWithNibName:@"BookViewController" bundle:nil]autorelease];
        newVC.hidesBottomBarWhenPushed = YES;
        newVC.target=btn.tag;
        newVC.NewsName=name;
        newVC.NewsPid=[NSString stringWithFormat:@"%d",btn.tag];
        [self.navigationController pushViewController :newVC animated:YES];
        
    }
    else if([isTopic integerValue]==1)
    {
        TopicViewController *newVC = [[[ TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil]autorelease];
        newVC.target=btn.tag;
        
        [self.navigationController pushViewController :newVC animated:YES];
    }
    else if([isGallery integerValue]==1)
    {
        BigFishViewController *newVC = [[[ BigFishViewController alloc] initWithNibName:@"BigFishViewController" bundle:nil]autorelease];
        self.hidesBottomBarWhenPushed = YES;
        newVC.BigFishName=name;
        newVC.target=btn.tag;//游钓
        newVC.BigFishPid=[NSString stringWithFormat:@"%d",btn.tag];
        app.targetCenter=btn.tag;
        
        [self.navigationController pushViewController :newVC animated:YES];
    }
 
}


- (void)dealloc {
    [labelText release];
    [textView release];
    [super dealloc];
}
@end
