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
    
    CGFloat cornerRadius = 4.5f;
    
    if (@available(iOS 11.0, *)) {
        cornerRadius = 15.0f;
    }
    
    CGRect frame = (CGRect){0, 0, (cornerRadius*2.0f) + 1, (cornerRadius*2.0f) + 1};
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0f);
    UIBezierPath *path = [TOSearchBar bezierPathWithIOS7RoundedRect:frame cornerRadius:cornerRadius];
    [[UIColor blackColor] set];
    [path fill];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
    
    [TOSearchBar setSharedImage:image forKey:kSharedBackgroundKey];
    
    return image;
}

+ (UIImage *)sharedSearchIcon
{
    UIImage *image = [imageTable objectForKey:kSharedSearchIconKey];
    if (image) {
        return image;
    }

    if (@available(iOS 11.0, *)) {
        UIGraphicsBeginImageContextWithOptions((CGSize){14,14}, NO, 0.0f);

        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Circle Drawing
        UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0.55, 0.55, 9.95, 9.95)];
        CGContextSaveGState(context);
        [circlePath addClip];
        CGContextTranslateCTM(context, 1, 86);
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -image.size.height);
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
        CGContextRestoreGState(context);
        [UIColor.blackColor setStroke];
        circlePath.lineWidth = 1.1;
        [circlePath stroke];
        
        
        //// Handle Drawing
        UIBezierPath* handlePath = [UIBezierPath bezierPath];
        [handlePath moveToPoint: CGPointMake(13.21, 12.2)];
        [handlePath addLineToPoint: CGPointMake(13.21, 12.2)];
        [handlePath addCurveToPoint: CGPointMake(13.74, 12.73) controlPoint1: CGPointMake(13.74, 12.73) controlPoint2: CGPointMake(13.74, 12.73)];
        [handlePath addLineToPoint: CGPointMake(13.74, 12.73)];
        [handlePath addCurveToPoint: CGPointMake(13.74, 13.78) controlPoint1: CGPointMake(14.03, 13.02) controlPoint2: CGPointMake(14.03, 13.49)];
        [handlePath addLineToPoint: CGPointMake(13.74, 13.78)];
        [handlePath addLineToPoint: CGPointMake(13.74, 13.78)];
        [handlePath addLineToPoint: CGPointMake(13.74, 13.78)];
        [handlePath addLineToPoint: CGPointMake(13.74, 13.78)];
        [handlePath addLineToPoint: CGPointMake(13.74, 13.78)];
        [handlePath addCurveToPoint: CGPointMake(12.68, 13.78) controlPoint1: CGPointMake(13.45, 14.07) controlPoint2: CGPointMake(12.97, 14.07)];
        [handlePath addLineToPoint: CGPointMake(12.68, 13.78)];
        [handlePath addLineToPoint: CGPointMake(12.68, 13.78)];
        [handlePath addLineToPoint: CGPointMake(8.33, 9.46)];
        [handlePath addLineToPoint: CGPointMake(9.38, 8.41)];
        [handlePath addLineToPoint: CGPointMake(13.21, 12.2)];
        [handlePath closePath];
        [UIColor.blackColor setFill];
        [handlePath fill];

        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else { // iOS 10 and down
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
    }

    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    return image;
}

+ (UIImage *)sharedClearIcon
{
    UIImage *image = [imageTable objectForKey:kSharedClearIconKey];
    if (image) {
        return image;
    }

    if (@available(iOS 11.0, *)) {
        UIGraphicsBeginImageContextWithOptions((CGSize){16,16}, NO, 0.0f);
        
        //// Bezier 2 Drawing
        UIBezierPath* deletePath = [UIBezierPath bezierPath];
        [deletePath moveToPoint: CGPointMake(10.96, 4.31)];
        [deletePath addCurveToPoint: CGPointMake(10.47, 4.53) controlPoint1: CGPointMake(10.76, 4.33) controlPoint2: CGPointMake(10.6, 4.4)];
        [deletePath addCurveToPoint: CGPointMake(8, 7) controlPoint1: CGPointMake(10.47, 4.53) controlPoint2: CGPointMake(10.47, 4.53)];
        [deletePath addCurveToPoint: CGPointMake(5.53, 4.53) controlPoint1: CGPointMake(7.15, 6.15) controlPoint2: CGPointMake(5.53, 4.53)];
        [deletePath addCurveToPoint: CGPointMake(4.89, 4.32) controlPoint1: CGPointMake(5.35, 4.35) controlPoint2: CGPointMake(5.11, 4.28)];
        [deletePath addCurveToPoint: CGPointMake(4.47, 4.53) controlPoint1: CGPointMake(4.73, 4.34) controlPoint2: CGPointMake(4.59, 4.41)];
        [deletePath addCurveToPoint: CGPointMake(4.47, 5.59) controlPoint1: CGPointMake(4.18, 4.82) controlPoint2: CGPointMake(4.18, 5.3)];
        [deletePath addCurveToPoint: CGPointMake(6.94, 8.06) controlPoint1: CGPointMake(4.47, 5.59) controlPoint2: CGPointMake(4.47, 5.59)];
        [deletePath addCurveToPoint: CGPointMake(5.85, 9.15) controlPoint1: CGPointMake(6.63, 8.37) controlPoint2: CGPointMake(6.23, 8.77)];
        [deletePath addCurveToPoint: CGPointMake(4.53, 10.47) controlPoint1: CGPointMake(5.17, 9.83) controlPoint2: CGPointMake(4.53, 10.47)];
        [deletePath addCurveToPoint: CGPointMake(4.53, 11.53) controlPoint1: CGPointMake(4.24, 10.76) controlPoint2: CGPointMake(4.24, 11.24)];
        [deletePath addCurveToPoint: CGPointMake(5.59, 11.53) controlPoint1: CGPointMake(4.82, 11.82) controlPoint2: CGPointMake(5.3, 11.82)];
        [deletePath addCurveToPoint: CGPointMake(8, 9.12) controlPoint1: CGPointMake(5.59, 11.53) controlPoint2: CGPointMake(5.59, 11.53)];
        [deletePath addCurveToPoint: CGPointMake(8.43, 9.55) controlPoint1: CGPointMake(8.13, 9.25) controlPoint2: CGPointMake(8.28, 9.4)];
        [deletePath addCurveToPoint: CGPointMake(10.41, 11.53) controlPoint1: CGPointMake(9.29, 10.41) controlPoint2: CGPointMake(10.41, 11.53)];
        [deletePath addCurveToPoint: CGPointMake(11.47, 11.53) controlPoint1: CGPointMake(10.7, 11.82) controlPoint2: CGPointMake(11.18, 11.82)];
        [deletePath addCurveToPoint: CGPointMake(11.47, 10.47) controlPoint1: CGPointMake(11.76, 11.24) controlPoint2: CGPointMake(11.76, 10.76)];
        [deletePath addCurveToPoint: CGPointMake(9.06, 8.06) controlPoint1: CGPointMake(11.47, 10.47) controlPoint2: CGPointMake(11.47, 10.47)];
        [deletePath addCurveToPoint: CGPointMake(11.53, 5.59) controlPoint1: CGPointMake(9.91, 7.21) controlPoint2: CGPointMake(11.53, 5.59)];
        [deletePath addCurveToPoint: CGPointMake(11.53, 4.53) controlPoint1: CGPointMake(11.81, 5.31) controlPoint2: CGPointMake(11.82, 4.85)];
        [deletePath addCurveToPoint: CGPointMake(10.92, 4.31) controlPoint1: CGPointMake(11.34, 4.36) controlPoint2: CGPointMake(11.13, 4.29)];
        [deletePath addLineToPoint: CGPointMake(10.96, 4.31)];
        [deletePath closePath];
        [deletePath moveToPoint: CGPointMake(16, 8)];
        [deletePath addCurveToPoint: CGPointMake(8, 16) controlPoint1: CGPointMake(16, 12.42) controlPoint2: CGPointMake(12.42, 16)];
        [deletePath addCurveToPoint: CGPointMake(0, 8) controlPoint1: CGPointMake(3.58, 16) controlPoint2: CGPointMake(0, 12.42)];
        [deletePath addCurveToPoint: CGPointMake(3.13, 1.65) controlPoint1: CGPointMake(0, 5.41) controlPoint2: CGPointMake(1.23, 3.11)];
        [deletePath addCurveToPoint: CGPointMake(8, 0) controlPoint1: CGPointMake(4.48, 0.61) controlPoint2: CGPointMake(6.17, 0)];
        [deletePath addCurveToPoint: CGPointMake(16, 8) controlPoint1: CGPointMake(12.42, 0) controlPoint2: CGPointMake(16, 3.58)];
        [deletePath closePath];
        [UIColor.blackColor setFill];
        [deletePath fill];

        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    else {
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
    }
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    return image;
}

// https://www.paintcodeapp.com/blogpost/code-for-ios-7-rounded-rectangles

#define TOP_LEFT(X, Y)\
CGPointMake(rect.origin.x + X * limitedRadius,\
rect.origin.y + Y * limitedRadius)
#define TOP_RIGHT(X, Y)\
CGPointMake(rect.origin.x + rect.size.width - X * limitedRadius,\
rect.origin.y + Y * limitedRadius)
#define BOTTOM_RIGHT(X, Y)\
CGPointMake(rect.origin.x + rect.size.width - X * limitedRadius,\
rect.origin.y + rect.size.height - Y * limitedRadius)
#define BOTTOM_LEFT(X, Y)\
CGPointMake(rect.origin.x + X * limitedRadius,\
rect.origin.y + rect.size.height - Y * limitedRadius)


+ (UIBezierPath*)bezierPathWithIOS7RoundedRect: (CGRect)rect
                                  cornerRadius: (CGFloat)radius
{
    UIBezierPath* path = UIBezierPath.bezierPath;
    CGFloat limit = MIN(rect.size.width, rect.size.height) / 2 / 1.52866483;
    CGFloat limitedRadius = MIN(radius, limit);
    
    [path moveToPoint: TOP_LEFT(1.52866483, 0.00000000)];
    [path addLineToPoint: TOP_RIGHT(1.52866471, 0.00000000)];
    [path addCurveToPoint: TOP_RIGHT(0.66993427, 0.06549600)
            controlPoint1: TOP_RIGHT(1.08849323, 0.00000000)
            controlPoint2: TOP_RIGHT(0.86840689, 0.00000000)];
    [path addLineToPoint: TOP_RIGHT(0.63149399, 0.07491100)];
    [path addCurveToPoint: TOP_RIGHT(0.07491176, 0.63149399)
            controlPoint1: TOP_RIGHT(0.37282392, 0.16905899)
            controlPoint2: TOP_RIGHT(0.16906013, 0.37282401)];
    [path addCurveToPoint: TOP_RIGHT(0.00000000, 1.52866483)
            controlPoint1: TOP_RIGHT(0.00000000, 0.86840701)
            controlPoint2: TOP_RIGHT(0.00000000, 1.08849299)];
    [path addLineToPoint: BOTTOM_RIGHT(0.00000000, 1.52866471)];
    [path addCurveToPoint: BOTTOM_RIGHT(0.06549569, 0.66993493)
            controlPoint1: BOTTOM_RIGHT(0.00000000, 1.08849323)
            controlPoint2: BOTTOM_RIGHT(0.00000000, 0.86840689)];
    [path addLineToPoint: BOTTOM_RIGHT(0.07491111, 0.63149399)];
    [path addCurveToPoint: BOTTOM_RIGHT(0.63149399, 0.07491111)
            controlPoint1: BOTTOM_RIGHT(0.16905883, 0.37282392)
            controlPoint2: BOTTOM_RIGHT(0.37282392, 0.16905883)];
    [path addCurveToPoint: BOTTOM_RIGHT(1.52866471, 0.00000000)
            controlPoint1: BOTTOM_RIGHT(0.86840689, 0.00000000)
            controlPoint2: BOTTOM_RIGHT(1.08849323, 0.00000000)];
    [path addLineToPoint: BOTTOM_LEFT(1.52866483, 0.00000000)];
    [path addCurveToPoint: BOTTOM_LEFT(0.66993397, 0.06549569)
            controlPoint1: BOTTOM_LEFT(1.08849299, 0.00000000)
            controlPoint2: BOTTOM_LEFT(0.86840701, 0.00000000)];
    [path addLineToPoint: BOTTOM_LEFT(0.63149399, 0.07491111)];
    [path addCurveToPoint: BOTTOM_LEFT(0.07491100, 0.63149399)
            controlPoint1: BOTTOM_LEFT(0.37282401, 0.16905883)
            controlPoint2: BOTTOM_LEFT(0.16906001, 0.37282392)];
    [path addCurveToPoint: BOTTOM_LEFT(0.00000000, 1.52866471)
            controlPoint1: BOTTOM_LEFT(0.00000000, 0.86840689)
            controlPoint2: BOTTOM_LEFT(0.00000000, 1.08849323)];
    [path addLineToPoint: TOP_LEFT(0.00000000, 1.52866483)];
    [path addCurveToPoint: TOP_LEFT(0.06549600, 0.66993397)
            controlPoint1: TOP_LEFT(0.00000000, 1.08849299)
            controlPoint2: TOP_LEFT(0.00000000, 0.86840701)];
    [path addLineToPoint: TOP_LEFT(0.07491100, 0.63149399)];
    [path addCurveToPoint: TOP_LEFT(0.63149399, 0.07491100)
            controlPoint1: TOP_LEFT(0.16906001, 0.37282401)
            controlPoint2: TOP_LEFT(0.37282401, 0.16906001)];
    [path addCurveToPoint: TOP_LEFT(1.52866483, 0.00000000)
            controlPoint1: TOP_LEFT(0.86840701, 0.00000000)
            controlPoint2: TOP_LEFT(1.08849299, 0.00000000)];
    [path closePath];
    return path;
}

@end
