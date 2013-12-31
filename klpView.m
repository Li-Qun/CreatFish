//
//  klpView.m
//  king
//
//  Created by liqun on 11-30-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "klpView.h"

@implementation klpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRect(path, nil, self.bounds);
    CGContextAddPath(context, path);
    //[[UIColor colorWithWhite:1.0f alpha:0.0f]setFill];
    //  [[UIColor colorWithWhite:1 alpha:1.0f] setStroke];
	[[UIColor colorWithRed:1 green:0.1 blue:.1 alpha:1.0f] setStroke];
    CGContextSetLineWidth(context, 7.0f);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}


@end
