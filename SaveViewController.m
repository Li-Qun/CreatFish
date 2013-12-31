//
//  SaveViewController.m
//  Fish
//
//  Created by DAWEI FAN on 12/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "SaveViewController.h"

//@interface SaveViewController ()
//
//@end
//
//@implementation SaveViewController

#import "TileView.h"
#import "MyRect.h"

#define kTileWidth  130.f
#define kTileHeight kTileWidth
#define kTileMarginLeft1 25.f
#define kTileMarginLeft2 (320.f - kTileMarginLeft1 - kTileWidth)
#define kTileMargin 10.f
@interface SaveViewController()
@end

@implementation SaveViewController

@synthesize tileArray = _tileArray, scrollView = _scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
     [self.navigationController setNavigationBarHidden:NO ];
      self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    [self createButtonAndAddToSelfView];
    
    _isDragTileContainedInOtherTile = NO;
    
    ///****添加菜单按钮
    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeItem)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 10;
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshItem)];
    
    if ([self.navigationItem respondsToSelector:@selector(leftBarButtonItems)]) {
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: removeButton, space, refreshButton, nil];
    }else {
        self.navigationItem.leftBarButtonItem =removeButton ;
    }
   ///****添加菜单按钮
}

- (void)createButtonAndAddToSelfView
{
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
    [addButton setBackgroundImage:[self createRoundPlusImageWithSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addViewButtonTouch) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:addButton];
}

- (UIImage *)createRoundPlusImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 填充黑色圆形
    [[UIColor grayColor] setFill];
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // 画白色加号
    CGContextSetLineWidth(context, 2.f);
    [[UIColor whiteColor] set];
    CGContextMoveToPoint(context, 2, size.height / 2);
    CGContextAddLineToPoint(context, size.width - 2, size.height / 2);
    CGContextMoveToPoint(context, size.width / 2, 2);
    CGContextAddLineToPoint(context, size.width / 2, size.height - 2);
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 控件点击

- (BOOL)addViewButtonTouch
{
    TileView *view = [[TileView alloc] initWithTarget:self action:@selector(dragTile:)];
    
    view.frame = [self createFrameLayoutTile];
    
    // 动态增长contectSize
    if (view.frame.origin.y + kTileHeight + kTileMargin > self.scrollView.frame.size.height) {
        self.scrollView.contentSize = CGSizeMake(320, view.frame.origin.y + kTileHeight + kTileMargin * 2);
    }
    [self.scrollView addSubview:view];
    [self.tileArray addObject:view];
    
    [self scrollToBottomWithScrollView:self.scrollView];
    return YES;
}
-(void)removeItem
{
    
    
}
- (CGRect)createFrameLayoutTile
{
    int counter = self.tileArray.count;
    
    int marginTop = (kTileHeight + kTileMargin) * (counter / 2 + 1) - 80;
    if (counter % 2 == 0) {
        return CGRectMake(kTileMarginLeft1, marginTop, kTileWidth, kTileHeight);
    } else {
        return CGRectMake(kTileMarginLeft2, marginTop, kTileWidth, kTileHeight);
    }
}

// 若使用此方法，则self.scrollView.subviews会出现UIImageView（不知道是何作用）
// 所以只能自己建立一个数组记录scrollView上的所有tileView
- (void)scrollToBottomWithScrollView:(UIScrollView *)scrollView
{
    if (scrollView.contentSize.height - 480 > 0)
    {
        [scrollView setContentOffset:CGPointMake(0, self.scrollView.contentSize.height - 480) animated:YES];
    }
}

#pragma mark - 手势操作

- (BOOL)dragTile:(UIPanGestureRecognizer *)recognizer
{
    switch ([recognizer state])
    {
        case UIGestureRecognizerStateBegan:
            [self dragTileBegan:recognizer];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragTileMoved:recognizer];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragTileEnded:recognizer];
            break;
        default: break;
    }
    return YES;
}

- (void)dragTileBegan:(UIPanGestureRecognizer *)recognizer
{
    _dragFromPoint = recognizer.view.center;
    [UIImageView  animateWithDuration:0.2f animations:^{
        recognizer.view.transform = CGAffineTransformMakeScale(1.05, 1.05);
        recognizer.view.alpha = 0.8;
    }];
}

- (void)dragTileMoved:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer.view.superview bringSubviewToFront:recognizer.view];
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    [self rollbackPushedTileIfNecessaryWithPoint:recognizer.view.center];
    [self pushedTileMoveToDragFromPointIfNecessaryWithTileView:(TileView *)recognizer.view];
}

- (void)rollbackPushedTileIfNecessaryWithPoint:(CGPoint)point
{
    if (_pushedTile && !CGRectContainsPoint(_dragToFrame, point))
    {
        [UIImageView  animateWithDuration:0.2f animations:^{
            _pushedTile.center = _dragToPoint;
        }];
        
        _dragToPoint = _dragFromPoint;
        _pushedTile = nil;
        _isDragTileContainedInOtherTile = NO;
    }
}

- (void)pushedTileMoveToDragFromPointIfNecessaryWithTileView:(TileView *)tileView
{
    for (TileView *item in self.tileArray)
    {
        if (CGRectContainsPoint(item.frame, tileView.center) && item != tileView)
        {
            _dragToPoint = item.center;
            _dragToFrame = item.frame;
            _pushedTile = item;
            _isDragTileContainedInOtherTile = YES;
            
            [UIImageView  animateWithDuration:0.2 animations:^{
                item.center = _dragFromPoint;
            }];
            break;
        }
    }
}

- (void)dragTileEnded:(UIPanGestureRecognizer *)recognizer
{
    [UIImageView  animateWithDuration:0.2f animations:^{
        recognizer.view.transform = CGAffineTransformMakeScale(1.f, 1.f);
        recognizer.view.alpha = 1.f;
    }];
    
    [UIImageView animateWithDuration:0.2f animations:^{
        if (_isDragTileContainedInOtherTile)
            recognizer.view.center = _dragToPoint;
        else
            recognizer.view.center = _dragFromPoint;
    }];
    
    _pushedTile = nil;
    _isDragTileContainedInOtherTile = NO;
}

#pragma mark - getter

- (NSMutableArray *)tileArray
{
    if (!_tileArray)
    {
        _tileArray = [[NSMutableArray alloc] init];
    }
    return _tileArray;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    }
    return _scrollView;
}
/////////////btn

-(void)refreshItem
{
    
}
@end
