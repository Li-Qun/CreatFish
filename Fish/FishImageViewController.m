//
//  FishImageViewController.m
//  Fish
//
//  Created by DAWEI FAN on 20/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "FishImageViewController.h"


#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#import <ShareSDKCoreService/ShareSDKCoreService.h>

@interface FishImageViewController ()

@end

@implementation FishImageViewController
@synthesize FishImageID=FishImageID;
@synthesize klpImgArr;
@synthesize klpScrollView1;
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

     NSLog(@"%@ %d",self.FishImageID,app.targetCenter);
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ContentRead* contentRead =[[[ContentRead alloc]init]autorelease];
    contentRead.delegate=self;
    [contentRead  gallery:FishImageID];

}
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag isID:(NSString *)ID
{
    SBJsonParser *parser = [[[SBJsonParser alloc] init]autorelease];
    NSDictionary *jsonObj =[parser objectWithString: jsonString];
    
    NSDictionary *data = [jsonObj objectForKey:@"data"];
    
    for (int i =0; i <data.count; i++) {
        
        [Fish_arr insertObject:[data objectAtIndex:i] atIndex: i];
    }
    [self createView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    klpScrollView1.frame=CGRectMake(0, 486, 320,bottom);
    
    UIImageView *topBarView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, heightTopbar)]autorelease];
    topBarView.image=[UIImage imageNamed:@"topBarRed"];
    [self.view addSubview:topBarView];
    
    UIImageView *wordView=[[[UIImageView alloc]initWithFrame:CGRectMake(128, littleHeinght+2, 50, 23)]autorelease];
    wordView.image=[UIImage imageNamed:@"BigFishList"];
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
    ///UIScrollerView
    //2.image
    index = 0;
    self.klpImgArr = [[NSMutableArray alloc] initWithCapacity:Fish_arr.count];
    CGSize size = self.klpScrollView1.frame.size;
    if(height_Momente==480)  height=60;
    for (int i=0; i <Fish_arr.count; i++) {
        NSDictionary* dict = [Fish_arr objectAtIndex:i];
        UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(width+20+size.width * i, 0, size.width-40-width*2, size.height+height)]autorelease];
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
    if (touchIndex > app.firstPageImage.count) {
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
