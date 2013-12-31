//
//  OneCell.m
//  Fish
//
//  Created by DAWEI FAN on 28/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "OneCell.h"
@class AsyncImageView;
@implementation OneCell
@synthesize imageView=imageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [ imageView release];
    [_label release];
    [super dealloc];
}
@end
