//
//  TileView.m
//  IPhoneTest
//
//  Created by Lovells on 13-8-27.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "TileView.h"

#define kLabelWidth     100
#define kLabelHeight    30.f

static int counter = 0;

@interface TileView ()

@end

@implementation TileView
@synthesize label=label;
@synthesize img=img;
@synthesize dataArray=dataArray;
- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super init];
    if (self)
    {
      // self.backgroundColor = [UIColor colorWithRed:1.605 green:0.000 blue:0.007 alpha:1.000];
      //  self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"1.png"]];
      // self.frame=CGRectMake(0, 0, 140, 110);
        self.backgroundColor=[UIColor clearColor];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
        [self addGestureRecognizer:panGestureRecognizer];
        
        [self createLabelAndAddToSelf];
    }
    return self;
}

- (void)createLabelAndAddToSelf
{
    
    dataArray=[[NSMutableArray alloc]init];
    oldArray = [NSArray arrayWithObjects:
                         @"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",nil];
    for(int i = 0; i < [oldArray count]; i++)
    {
        [dataArray addObject:[oldArray objectAtIndex:i]];
    }
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 130, 110)];
    imgView.image=[UIImage imageNamed:@"1.png"];
    imgView.layer.masksToBounds=NO;
    imgView.layer.cornerRadius=8;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 80, kLabelWidth, kLabelHeight)];
    label.text = [NSString stringWithFormat:@"%i", ++counter];
    
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [imgView addSubview:label];
    img=imgView.image;

    
    
    view_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    view_btn.frame=imgView.frame;
    view_btn.hidden=NO;
    [ view_btn setImage:imgView.image  forState:UIControlStateNormal ];
    [view_btn addTarget:self action:@selector(PressChosen) forControlEvents:UIControlEventTouchDown];
    [view_btn addSubview:label];
    //[imgView addSubview:view_btn];
    view_btn.highlighted=YES;
    
    [ self  addSubview:view_btn];
   
}

-(void)PressChosen
{
    //NSLog(@"选择阅读的杂志是：%@",label.text);
    NSString *string=[NSString stringWithFormat:@"选择阅读的杂志是：%@",label.text];
    targetNum=[label.text integerValue];
    NSLog(@"***%@",label.text);
    UIActionSheet *  actionSheet = [[UIActionSheet alloc]
                   initWithTitle:string
                   delegate:self
                   cancelButtonTitle:@"取消"
                   destructiveButtonTitle:@"阅读"
                   otherButtonTitles:@"删除",nil];
    
    [actionSheet showInView:self];
    [actionSheet release];
}
#pragma mark -
#pragma mark actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if(dataArray.count>0)
            {
                NSLog(@"==%@",[dataArray objectAtIndex:targetNum]);
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"暂无收藏杂志"    message:@"您可以先收藏喜欢的杂志哦～"
                                      delegate:nil
                                      cancelButtonTitle:@"OK!"   otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            
            break;
        case 1:
        {
            if(dataArray.count>0)
            {
                [dataArray removeObjectAtIndex:targetNum];
                view_btn.hidden=YES;
            }
            break;
        }
        case 2:
            NSLog(@"click at index %d，取消操作", buttonIndex);
            break;
        default:
            NSLog(@"unknown： click at index %d", buttonIndex);
            break;
    }
}
-(void)dealloc
{
    [dataArray release];
    [super dealloc];
}

@end
