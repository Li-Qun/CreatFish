//
//  SampleCell.h
//  NewDemo
//
//  Created by liqun on 12/1/13.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AsyncImageView;
@interface SampleCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *labelForPlace;
@property (retain, nonatomic) IBOutlet UILabel *labelForCountry;
@property (retain, nonatomic) IBOutlet UIImageView *imageview;

@end