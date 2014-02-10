//
//  NewCell.m
//  Fish
//
//  Created by DAWEI FAN on 10/02/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "NewCell.h"

@implementation NewCell

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
   // [_parent_View release];
//    [_littleTitle release];
//    [_label_Num release];
    [super dealloc];
}
@end
