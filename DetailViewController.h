//
//  DetailViewController.h
//  Fish
//
//  Created by DAWEI FAN on 19/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "QuadCurveMenu.h"
#import "UIImageView+WebCache.h"

#import "CustomURLCache.h"
#import "MBProgressHUD.h"

#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
@interface DetailViewController : ViewController<UIWebViewDelegate ,UIGestureRecognizerDelegate,UIGestureRecognizerDelegate,SDWebImageManagerDelegate,SDWebImageDownloaderDelegate ,EGORefreshTableDelegate,UIScrollViewDelegate,QuadCurveMenuDelegate,UIAlertViewDelegate,UIScrollViewDelegate,FishDelegate>
{
    UIWebView *showWebView;
    CGFloat height_Mag;//获取webView 高度
    NSMutableDictionary *Data;
    NSMutableArray *arrIDList;
    NSMutableArray *arrIDListNew;
    int moment;
    UILabel *page_num;
    NSString *page_label;
    IBOutlet UIView *tableView;
    UIToolbar *toolBar;
    NSString *pic_url;
    //设字体
    NSString *htmlText;
    //收藏信息
    NSString *detailTotal;
    NSString *detailName;
    NSString *detailImage;
    NSString *detailID;
    //
    NSMutableString *htmlTextTotals;
    float fontSize;
    NSString *jsString;
    float line_height;
    
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
    UINavigationBar *navBar;
    BOOL isStore;
    float totalHeight;
    BOOL isSeven;
    BOOL isFive;
}
@property (nonatomic,retain) UILabel *page_num;
@property (nonatomic,retain)NSString *pic_url;
@property (nonatomic,retain)NSString *page_label;
@property (retain, nonatomic) IBOutlet UIView *tableView;
@property (retain,nonatomic)UIWebView *showWebView;
@property (readwrite, nonatomic) int yOrigin;
@property (retain, nonatomic) NSMutableDictionary *dictForData;
@property (retain, nonatomic) NSMutableDictionary *Data;
@property (retain, nonatomic) NSMutableArray *arrIDList;
@property (retain, nonatomic)NSMutableArray *arrIDListNew;
@property (nonatomic,retain)NSString *htmlText;
@property (nonatomic,retain)NSString *detailName;
@property (nonatomic,retain)NSString *detailImage;
@property (nonatomic,retain)NSString *detailID;

@property (nonatomic,retain)NSMutableString *htmlTextTotals;
@property (nonatomic,retain) NSString *jsString;
@property (nonatomic)BOOL isStore;


- (void)pressme:(id)sender;
- (void)cameraAction:(id)sender;
- (void)broomAction:(id)sender;
- (void)textAction:(id)sender;

@end

