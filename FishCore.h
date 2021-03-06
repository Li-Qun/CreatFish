//
//  FishCore.h
//  Fish
//
//  Created by DAWEI FAN on 13/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
 
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"

#include "JSON.h"

//@interface FishSave : NSObject
//{
//    //收藏模块
//    NSMutableArray *tileArray;
//}
//@property (nonatomic, readonly) NSMutableArray *tileArray;
//@end





@protocol FishDelegate
@optional
-(void)getJsonString:(NSString *)jsonString isPri:(NSString *)flag isID :(NSString*)ID Offent:(NSString*)Out;
-(void)reBack:(NSString *)jsonString reLoad :(NSString *)ID Offent:(NSString *)Out;

@end
@interface ContentRead:NSObject<ASIHTTPRequestDelegate,FishDelegate >
{
    //查询 - 列表 [content/read_lst]
    NSString *filter_category_id;
    NSString *filter_is_sticky;
    NSString * offset;
    NSString *total;
    NSString *content;
    id<FishDelegate>delegate;
}


@property(nonatomic,retain )NSString *filter_category_id;
@property(nonatomic ,retain)NSString * offset;
@property(nonatomic ,retain)NSString *filter_is_sticky;
@property(nonatomic,retain)NSString *total;
@property(nonatomic,retain)NSString *content;
//@property(nonatomic,retain)CategoryItem *categoryItem;
@property(assign,nonatomic)id<FishDelegate> delegate;

-(void)fetchList: (NSString  * )ID isPri:(NSString*)flag  Out:(NSString *) Offset;
//-(void)Magazine:(NSString*)ID isPri:(NSString *)flag WeeklyId:(NSString *) Id Out:(NSString *)Offset;
//-(void)Magazine:(NSString *)ID Out:(NSString *)Offent;
-(void)ContentDetail:(NSString*) content_id;
-(void)Category;
-(void)ContentSetting;
-(void)reLoad;
-(void)Submmit:(NSString *)contact typeBack:(NSString *)feedback_category content:(NSString *)feedback_content;
-(void)gallery:(NSString *)content_id;
-(void)Content:(NSString *)current_category_id  Detail:(NSString*)content_id;
-(void)mention:(int)succuess;
@end









