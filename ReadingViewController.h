//
//  ReadingViewController.h
//  Fish
//
//  Created by DAWEI FAN on 13/01/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

//#import "ViewController.h"
#import "FishCore.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
@interface ReadingViewController :UIViewController<UIWebViewDelegate,FishDelegate,UIScrollViewDelegate,EGORefreshTableDelegate>
{
    NSMutableDictionary *Data;
    NSMutableArray *arrIDList;
    NSMutableArray *arrIDListNew;
    ContentRead *contentRead;
    float totalHeight;
    BOOL isSeven;
    BOOL isFive;
    
    UIWebView *showWebView;
    NSString * htmlText;
    NSString *detailSave;//收藏
    NSString *detailSaveNow;
    //
    NSMutableString *htmlTextTotals;
    NSString *jsString;
    float fontSize;
    float line_height;
    
    
    
    
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
    
}
@property (retain, nonatomic) NSMutableDictionary *Data;
@property (retain, nonatomic) NSMutableArray *arrIDList;


@property (retain, nonatomic)NSMutableArray *arrIDListNew;
@property (readwrite, nonatomic) int yOrigin;
@property (retain, nonatomic) NSMutableDictionary *dictForData;
@property (retain, nonatomic)NSString *momentID;
@property (nonatomic,retain) NSString *jsString;
@property (nonatomic,retain)NSMutableString *htmlTextTotals;
@property (nonatomic,retain)NSString *detailSave;
@end
