//
//  TOSearchBar+ImageAssets.m
//
//  Copyright 2015-2016 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TOSearchBar+Assets.h"
@import UIKit;

/* A statically held map table that holds one instance of every image generated. */
/* Once all images are released, the map table is also cleaned up */
static NSMapTable *imageTable = nil;

static NSString * const kSharedBackgroundKey = @"SharedSearchBackground";
static NSString * const kSharedSearchIconKey = @"SharedSearchIcon";
static NSString * const kSharedClearIconKey = @"SharedClearIcon";

@implementation TOSearchBar (ImageAssets)

+ (void)setSharedImage:(UIImage *)image forKey:(NSString *)key
{
    if (imageTable == nil) {
        imageTable = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsWeakMemory capacity:3];
    }
    
    [imageTable setObject:image forKey:key];
}

+ (void)cleanUpSharedAssets
{
    if (imageTable.count > 0) {
        return;
    }
    
    imageTable = nil;
}

+ (UIImage *)sharedSearchBarBackground
{
    UIImage *image = [imageTable objectForKey:kSharedBackgroundKey];
    if (image) {
        return image;
    }
    
    CGRect frame = (CGRect){0,0,15,28};
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0f);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:4.5f];
    [[UIColor blackColor] set];
    [path fill];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7.0f, 0, 7.0f)];
    
    [TOSearchBar setSharedImage:image forKey:kSharedBackgroundKey];
    
    return image;
}

+ (UIImage *)sharedSearchIcon
{
    UIImage *image = [imageTable objectForKey:kSharedSearchIconKey];
    if (image) {
        return image;
    }

    UIGraphicsBeginImageContextWithOptions((CGSize){15,15}, NO, 0.0f);
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(1, 1, 10, 10)];
    [UIColor.grayColor setStroke];
    ovalPath.lineWidth = 1.3;
    [ovalPath stroke];
    
    
    //// Rectangle Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 8.8, 9.87);
    CGContextRotateCTM(context, -45 * M_PI / 180);
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 1.4, 6.55)];
    [UIColor.grayColor setFill];
    [rectanglePath fill];
    
    CGContextRestoreGState(context);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    return image;
}

+ (UIImage *)sharedClearIcon
{
    UIImage *image = [imageTable objectForKey:kSharedClearIconKey];
    if (image) {
        return image;
    }

    UIGraphicsBeginImageContextWithOptions((CGSize){14,14}, NO, 0.0f);
    
    //// ClearIcon Drawing
    UIBezierPath* clearIconPath = [UIBezierPath bezierPath];
    [clearIconPath moveToPoint: CGPointMake(4.13, 4.12)];
    [clearIconPath addCurveToPoint: CGPointMake(4.08, 5.23) controlPoint1: CGPointMake(3.79, 4.46) controlPoint2: CGPointMake(3.79, 4.94)];
    [clearIconPath addCurveToPoint: CGPointMake(5.85, 7) controlPoint1: CGPointMake(4.08, 5.23) controlPoint2: CGPointMake(4.08, 5.23)];
    [clearIconPath addLineToPoint: CGPointMake(4.08, 8.77)];
    [clearIconPath addCurveToPoint: CGPointMake(4.08, 9.83) controlPoint1: CGPointMake(3.79, 9.06) controlPoint2: CGPointMake(3.79, 9.54)];
    [clearIconPath addCurveToPoint: CGPointMake(5.14, 9.83) controlPoint1: CGPointMake(4.37, 10.12) controlPoint2: CGPointMake(4.85, 10.12)];
    [clearIconPath addLineToPoint: CGPointMake(6.91, 8.06)];
    [clearIconPath addCurveToPoint: CGPointMake(8.67, 9.83) controlPoint1: CGPointMake(7.59, 8.74) controlPoint2: CGPointMake(8.67, 9.83)];
    [clearIconPath addCurveToPoint: CGPointMake(9.74, 9.83) controlPoint1: CGPointMake(8.97, 10.12) controlPoint2: CGPointMake(9.44, 10.12)];
    [clearIconPath addCurveToPoint: CGPointMake(9.74, 8.77) controlPoint1: CGPointMake(10.03, 9.54) controlPoint2: CGPointMake(10.03, 9.06)];
    [clearIconPath addCurveToPoint: CGPointMake(7.97, 7) controlPoint1: CGPointMake(9.74, 8.77) controlPoint2: CGPointMake(9.74, 8.77)];
    [clearIconPath addLineToPoint: CGPointMake(9.74, 5.23)];
    [clearIconPath addCurveToPoint: CGPointMake(9.74, 4.17) controlPoint1: CGPointMake(10.03, 4.94) controlPoint2: CGPointMake(10.03, 4.46)];
    [clearIconPath addCurveToPoint: CGPointMake(8.67, 4.17) controlPoint1: CGPointMake(9.44, 3.88) controlPoint2: CGPointMake(8.97, 3.88)];
    [clearIconPath addLineToPoint: CGPointMake(6.91, 5.94)];
    [clearIconPath addCurveToPoint: CGPointMake(5.14, 4.17) controlPoint1: CGPointMake(6.23, 5.26) controlPoint2: CGPointMake(5.14, 4.17)];
    [clearIconPath addCurveToPoint: CGPointMake(4.11, 4.14) controlPoint1: CGPointMake(4.85, 3.88) controlPoint2: CGPointMake(4.37, 3.88)];
    [clearIconPath addLineToPoint: CGPointMake(4.13, 4.12)];
    [clearIconPath closePath];
    [clearIconPath moveToPoint: CGPointMake(14, 7)];
    [clearIconPath addCurveToPoint: CGPointMake(7, 14) controlPoint1: CGPointMake(14, 10.87) controlPoint2: CGPointMake(10.87, 14)];
    [clearIconPath addCurveToPoint: CGPointMake(0, 7) controlPoint1: CGPointMake(3.13, 14) controlPoint2: CGPointMake(0, 10.87)];
    [clearIconPath addCurveToPoint: CGPointMake(2.74, 1.44) controlPoint1: CGPointMake(0, 4.74) controlPoint2: CGPointMake(1.08, 2.72)];
    [clearIconPath addCurveToPoint: CGPointMake(7, 0) controlPoint1: CGPointMake(3.92, 0.54) controlPoint2: CGPointMake(5.4, -0)];
    [clearIconPath addCurveToPoint: CGPointMake(14, 7) controlPoint1: CGPointMake(10.87, 0) controlPoint2: CGPointMake(14, 3.13)];
    [clearIconPath closePath];
    [UIColor.grayColor setFill];
    [clearIconPath fill];

    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    return image;
}

@end
