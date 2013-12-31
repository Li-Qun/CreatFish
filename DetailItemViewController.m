//
//  DetailItemViewController.m
//  NewDemo
//
//  Created by liqun on 12/1/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//
#import "IIViewDeckController.h"
#import "DetailItemViewController.h"
#import "NewViewController.h"

//#import "BigPicViewController.h"
@interface DetailItemViewController ()

@end

@implementation DetailItemViewController
@synthesize img=img;
@synthesize bigPicButton=bigPicButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
     return self;
}

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewDidLoad];
     ////点击图片全屏
    UIButton *photo=[UIButton buttonWithType:UIButtonTypeCustom];
    photo.frame=CGRectMake(0, 20, 326, 166);
    [photo setImage:self.imageView.image forState:UIControlStateNormal ];
    
    [photo addTarget:self action:@selector(PressBig) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:photo];
    //赋值
    self.labelForPlace.text = [NSString stringWithFormat:@"%@",[self.dictForData objectForKey:@"Place"]];
    self.labelForCountry.text = [NSString stringWithFormat:@"%@",[self.dictForData objectForKey:@"Country"]];
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.dictForData objectForKey:@"Image"]]];
    
    [self animateOnEntry];
    self.textviewForDetail.text=@"XX";
    self.textviewForDetail.scrollEnabled=YES;
   /********************List_buttons************************/
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    // Camera MenuItem.
    QuadCurveMenuItem *cameraMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                         highlightedContentImage:nil];
    // People MenuItem.
    QuadCurveMenuItem *peopleMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                         highlightedContentImage:nil];
    // Place MenuItem.
    QuadCurveMenuItem *placeMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                        highlightedContentImage:nil];
    // Music MenuItem.
    QuadCurveMenuItem *musicMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                        highlightedContentImage:nil];
    // Thought MenuItem.
    QuadCurveMenuItem *thoughtMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                 highlightedImage:storyMenuItemImagePressed
                                                                     ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                          highlightedContentImage:nil];
    // Sleep MenuItem.
    QuadCurveMenuItem *sleepMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                        highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:cameraMenuItem, peopleMenuItem, placeMenuItem, musicMenuItem, thoughtMenuItem, sleepMenuItem, nil];
    [cameraMenuItem release];
    [peopleMenuItem release];
    [placeMenuItem release];
    [musicMenuItem release];
    [thoughtMenuItem release];
    [sleepMenuItem release];
    QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds menus:menus];
    menu.delegate = self;
    [self.view addSubview:menu];
    [menu release];
    
    
    /********************List_buttons************************/

    
    
}
////list_button
- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [_labelForPlace release];
    [_labelForCountry release];
    [_imageView release];
    [_textviewForDetail release];
    [_backgroundImageView release];
    [super dealloc];
}
-(void)PressBig
{
    //放大
    img=[[[UIImageView alloc]init]autorelease];
    img.frame=[[UIScreen mainScreen] bounds];
    img.image=self.imageView.image;
    [self.view addSubview:img];
    
    //恢复相应
    bigPicButton=[UIButton buttonWithType:UIButtonTypeCustom];
    bigPicButton.frame=CGRectMake(0, 500, 44, 44);
    bigPicButton.hidden=NO;
    [bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
    
    [bigPicButton addTarget:self action:@selector(PressBack) forControlEvents:UIControlEventTouchDown];
    [img addSubview:bigPicButton];
   
}
-(void)PressBack
{
    img.frame=self.imageView.frame;
    bigPicButton.hidden=YES;
}

@end
