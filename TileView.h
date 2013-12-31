//
//  TileView.h
//  IPhoneTest
//
//  Created by Lovells on 13-8-27.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FishCore.h"
@interface TileView :  UIView<UIActionSheetDelegate>
{
    UILabel *label;
    UIImage *img;
    int targetNum;
    NSArray *oldArray ;
    UIButton *view_btn;
    FishSave *fishSave;
}
@property(strong,nonatomic)UILabel *label;
@property(strong,nonatomic)UIImage *img;
@property (nonatomic, readonly) NSMutableArray *dataArray;
- (id)initWithTarget:(id)target action:(SEL)action;

@end
