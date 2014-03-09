//
//  CutImage.h
//  Fish
//
//  Created by Liqun on 07/03/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CutImage : NSObject
//to scale images without changing aspect ratio
+ (CGRect)scaleImage:(UIImage *)image toSize:(CGRect)newSize;
@end
