//
//  SaveViewController.h
//  Fish
//
//  Created by DAWEI FAN on 12/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TileView.h"
#import "FishCore.h"
@interface SaveViewController : UIViewController


{
    // 拖动的tile的原始center坐标
    CGPoint _dragFromPoint;
    
    // 要把tile拖往的center坐标
    CGPoint _dragToPoint;
    
    // tile拖往的rect
    CGRect _dragToFrame;
    
    // 拖拽的tile是否被其他tile包含
    BOOL _isDragTileContainedInOtherTile;
    
    // 拖拽往的目标处的tile
    TileView *_pushedTile;
    
    FishSave *fishSave;
}

@property (nonatomic, readonly) NSMutableArray *tileArray;

@property (nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic,readwrite)FishSave *fishSave;

 
@end
