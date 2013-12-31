//
//  TViewController.m
//  Fish
//
//  Created by DAWEI FAN on 17/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "TViewController.h"
#import "FishCore.h"
#import "AppDelegate.h"
#import "JSONKit.h"

#import "UIMenuItem+CXAImageSupport.h"
@interface TViewController ()
{
    
    UIButton *_button;
    UILabel *_label;
}

- (void)pressme:(id)sender;
- (void)cameraAction:(id)sender;
- (void)broomAction:(id)sender;
- (void)textAction:(id)sender;

@end

@implementation TViewController

- (id)init
{
    if (self = [super initWithNibName:nil bundle:nil]){
        
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    UIButton *life=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    life.frame=CGRectMake(20, 169, 101, 34);
    life.hidden=NO;
    //[bigPicButton setImage:[UIImage imageNamed:@"face"]forState:UIControlStateNormal ];
    [life setTitle:@"生活" forState:UIControlStateNormal];
    [life addTarget:self action:@selector(pressme:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:life];

    
    
    UIMenuItem *cameraItem = [[UIMenuItem alloc] initWithTitle:nil action:@selector(cameraAction:)];
    [cameraItem cxa_setImage:[UIImage imageNamed:@"camera"] hidesShadow:NO forTitle:NSLocalizedString(@"Camera", nil)];
    UIMenuItem *cameraItem2 = [[UIMenuItem alloc] initWithTitle:nil action:@selector(cameraAction:)];
    [cameraItem cxa_setImage:[UIImage imageNamed:@"camera"] hidesShadow:NO forTitle:NSLocalizedString(@"Camera", nil)];
    
    UIMenuItem *broomItem = [[UIMenuItem alloc] cxa_initWithTitle:NSLocalizedString(@"Broom", nil) action:@selector(broomAction:) image:[UIImage imageNamed:@"broom"]];
    UIMenuItem *textItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"No Image", nil) action:@selector(textAction:)];
    [UIMenuController sharedMenuController].menuItems = @[cameraItem, broomItem, textItem,cameraItem2];
}
- (void)viewWillLayoutSubviews
{
}

#pragma mark -
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender
{
    if (action == @selector(cameraAction:) ||
        action == @selector(broomAction:) ||
        action == @selector(textAction:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
}

#pragma mark - privates
- (void)pressme:(id)sender
{
    [[UIMenuController sharedMenuController] setTargetRect:[sender frame] inView:self.view];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)cameraAction:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera Item Pressed", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil] show];
}

- (void)broomAction:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Broom Item Pressed", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil] show];
}

- (void)textAction:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Text Item Pressed", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil] show];
}

@end
