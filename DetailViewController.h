//
//  DetailViewController.h
//  Fish
//
//  Created by DAWEI FAN on 19/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

#import "CustomURLCache.h"
#import "MBProgressHUD.h"

#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
@interface DetailViewController : UIViewController<UIWebViewDelegate ,UIGestureRecognizerDelegate,UIGestureRecognizerDelegate,SDWebImageManagerDelegate,SDWebImageDownloaderDelegate ,EGORefreshTableDelegate,UIScrollViewDelegate, UIAlertViewDelegate,UIScrollViewDelegate,FishDelegate,ISSShareViewDelegate>
{
    
    UIWebView *showWebView;
    BOOL isImage_scrollView;
    int timeCount;
 
    UIImageView *topBarView;
    CGFloat height_Mag;//获取webView 高度
    NSMutableDictionary *Data;
    int moment;
    UILabel *page_num;
    NSString *page_label;
    IBOutlet UIView *tableView;
    UIToolbar *toolBar;
    //设字体
    NSString *htmlText;
    //收藏信息
//    NSString *detailName;
//    NSString *detailImage;
    NSString *detailID;
    //
    NSMutableString *htmlTextTotals;
    float fontSize;
    NSString *jsString;
    float line_height;
    UIButton *saveBtn;
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
 
    float totalHeight;
    BOOL isSeven;
    BOOL isFive;
    
    NSString *pre_Page;
    NSString *next_Page;
    
    AppDelegate *app;
    NSString *momentID;
    NSString *fatherID;
    
    BOOL isOpenL;
    BOOL isOpenR;
    //是否分享了
    BOOL isShare;
}
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;



@property (nonatomic,retain) UILabel *page_num;
@property (nonatomic,retain)NSString *page_label;
@property (retain, nonatomic) IBOutlet UIView *tableView;
@property (retain,nonatomic)UIWebView *showWebView;
@property (readwrite, nonatomic) int yOrigin;

@property (retain, nonatomic) NSMutableDictionary *Data;

@property (nonatomic,retain)NSString *htmlText;

@property (nonatomic,retain)NSMutableString *htmlTextTotals;
@property (nonatomic,retain) NSString *jsString;

@property (nonatomic,retain)NSString *next_Page;
@property (nonatomic,retain)NSString *pre_Page;
@property (retain, nonatomic)NSString *momentID;
@property (retain, nonatomic)NSString *fatherID;


@end

