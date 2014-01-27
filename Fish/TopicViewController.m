//
//  TopicViewController.m
//  Fish
//
//  Created by DAWEI FAN on 18/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "TopicViewController.h"
#import "NewsController.h"
#import "LifeViewController.h"
#import "DetailViewController.h"

#import "IIViewDeckController.h"
#import <sqlite3.h>
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
        heightTooBar=height_Momente-44;
        buttonHeight=5+height_Momente-44-20;
    }
    else if (!height5_flag&&Kind7)
    {
        heightTooBar=height_Momente-44;
        buttonHeight=5+height_Momente-44 ;
    }
    else {
        heightTooBar=height_Momente-height-44 ;
        buttonHeight=5+height_Momente-44-height;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //耗时的一些操作
        
        NSString *strJson;
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"test_DB_toolBar7"];
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
            NSDictionary *jsonObj =[parser objectWithString: strJson];
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
-(void)reBack:(NSString *)jsonString reLoad:(NSString *)ID
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
        
       sqlite3_stmt *stmt;
        BOOL flag=NO;
       NSString* sql =[NSString stringWithFormat:@"select pic from picture where ID='%@'",ID];
        //查找数据
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK)
        {
            
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                
                if(sqlite3_column_count(stmt)==0)
                {
                    flag=YES;
                    break;
                }
                const unsigned char *_id=sqlite3_column_text(stmt, 0);
                strJson=[NSString stringWithUTF8String:_id];
                break;
                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{//主线程
            
            if(flag)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"该缓存为空，请连接网络使用"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];

            }
            else
            {
                SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
                NSDictionary *jsonObj =[parser objectWithString: strJson];
                NSDictionary *data = [jsonObj objectForKey:@"data"];
                
                for (int i =0; i <data.count; i++) {
                    
                    [arr insertObject:[data objectAtIndex:i] atIndex: i];
                }
                [self createView];
            }
            
        });
    });
    
    /*
   
     */
}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag isID:(NSString *)ID
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
            NSDictionary *data = [jsonObj objectForKey:@"data"];
            
            for (int i =0; i <data.count; i++) {
                
                [arr insertObject:[data objectAtIndex:i] atIndex: i];
            }
            [self createView];
        });
    });
    

    
 /*
    NSString *strJson;
    NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPaths=[array objectAtIndex:0];
    NSString *str=[NSString stringWithFormat:@"Topic_DB%@",ID];
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
        SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
        NSDictionary *jsonObj =[parser objectWithString: strJson];
        NSDictionary *data = [jsonObj objectForKey:@"data"];
        
        for (int i =0; i <data.count; i++) {
            
            [arr insertObject:[data objectAtIndex:i] atIndex: i];
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
    ////////
 */
    
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
    scrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)]autorelease];
    imgToolView=[[[UIImageView alloc]init]autorelease];
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
    if (sender.direction == UISwipeGestureRecognizerDirectionRight&&sender.view!=scrollView)//na
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
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft&&sender.view!=scrollView) {//bie
        
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
    
    self.klpScrollView1.frame=CGRectMake(0,heightScrollview, 320, 203);

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
        NSString *imgURL=[NSString stringWithFormat:@"http://42.96.192.186/ifish/server/upload/%@",[dict objectForKey:@"image"] ];
        [iv setImageWithURL:[NSURL URLWithString: imgURL]
           placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                    success:^(UIImage *image) {NSLog(@"OK");}
                    failure:^(NSError *error) {NSLog(@"NO");}];
        
        UILabel *label=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 31)]autorelease];
        label.backgroundColor=[UIColor clearColor];
        label.textColor=[UIColor whiteColor];
        label.text=[dict objectForKey:@"image_title"];
        
        UIImageView *clearBack=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 154+clearImgHeight, 320, 31)]autorelease];
        
        clearBack.image=[UIImage imageNamed:@"clearBack@2X"];
        [iv addSubview:clearBack];
        [clearBack addSubview:label];
        UIImageView *theArrow=[[[UIImageView alloc]initWithFrame:CGRectMake(300, 8,8,12)]autorelease];
        theArrow.image=[UIImage imageNamed:@"theArrow"];
        [clearBack addSubview:theArrow];
        
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
    //	NSLog(@"scrollViewWillBeginDragging");
	if (scrollView == self.klpScrollView1) {
        
	}else {
		
	}
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	//NSLog(@"scrollViewDidEndDecelerating");
	if (scrollView == self.klpScrollView1) {
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
        
	}else {
		
	}
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
    NSDictionary* dict = [arr objectAtIndex:touchIndex];
 
    DetailViewController *detail=[[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil]autorelease];
    [detail.arrIDListNew insertObject:@"9" atIndex:0 ];
    [detail.arrIDListNew insertObject:@"10" atIndex:1 ];
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
    UIButton *btn = (UIButton *)sender;
    
    NSLog(@"%d",btn.tag);
    //    for (UIView *subviews in [self.view subviews]) {
    //        if (subviews.tag==22) {
    //            [subviews removeFromSuperview];
    //        }
    //    }//必须从self.view中移除，不能从gpsClickView中移除
    if(btn.tag==2||btn.tag==5||btn.tag==6)
    {
        NewsController *newVC = [[[NewsController alloc] initWithNibName:@"NewsController" bundle:nil]autorelease];
        newVC.hidesBottomBarWhenPushed = YES;
        newVC.target=btn.tag;
        if(btn.tag==2)newVC.NewsName=@"资讯";
        else if (btn.tag==5)newVC.NewsName=@"攻略";
        else newVC.NewsName=@"装备";
        [self.navigationController pushViewController :newVC animated:YES];
    }
    else if(btn.tag==4)
    {
        LifeViewController *newVC = [[[LifeViewController alloc] initWithNibName:@"LifeViewController" bundle:nil]autorelease];
        self.hidesBottomBarWhenPushed = YES;
        
        newVC.target=4;//游钓
        [self.navigationController pushViewController :newVC animated:YES];
        
    }
    else if(btn.tag==3)//专题
    {
        TopicViewController *newVC = [[[ TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil]autorelease];
        newVC.target=3;
        //self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController :newVC animated:YES];
        
    }
}


- (void)dealloc {
    [labelText release];
    [textView release];
    [super dealloc];
}
@end
