//
//  CutImage.m
//  Fish
//
//  Created by Liqun on 07/03/2014.
//  Copyright (c) 2014 liqun. All rights reserved.
//

#import "CutImage.h"

@implementation CutImage
+ (CGRect )scaleImage:(UIImage *)image toSize:(CGRect)newSize
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = newSize.size.width/newSize.size.height;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = newSize.size.height/ actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = newSize.size.height;
        }
        else{
            imgRatio = newSize.size.width / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = newSize.size.width;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    return rect;
}
 @end
