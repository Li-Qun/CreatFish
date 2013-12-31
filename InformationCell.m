//
//  InformationCell.m
//  Fish
//
//  Created by DAWEI FAN on 18/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "InformationCell.h"
@class AsyncImageView;
@implementation InformationCell

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
    [_labelForCategory_id release];
    [_labelForName release];
    [_imgView release];
    [super dealloc];
}
@end
