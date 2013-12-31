//
//  ReadViewController.h
//  Fish
//
//  Created by DAWEI FAN on 08/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>
{
    UIWebView *showWebView;
    UIScrollView *scrollView;
    int pageCount;
    int momentNum;
    NSMutableArray *mulArray;
    BOOL isFirstOpen;
    NSString *string;
    UILabel *numLabel;
    NSString *pic_url;
    UIImageView *list;
    UILabel *page_Num;
    int moment;
    int total;
    
    UIButton *pic_list;
    
    BOOL isOpen;
    
}
@property (retain,nonatomic)UIWebView *showWebView;
@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain,nonatomic)NSMutableArray *mulArray;
@property (retain,nonatomic)UIImageView *list;
@property (retain,nonatomic)UILabel *page_Num;
@property (retain,nonatomic)UIButton *pic_list;


@end
