
//
//  LoadMoreCell.m
//  Fish
//
//  Created by DAWEI FAN on 30/12/2013.
//  Copyright (c) 2013 liqun. All rights reserved.
//

#import "LoadMoreCell.h"

@implementation LoadMoreCell

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
    [_label release];
    [_date release];
    [super dealloc];
}
@end
