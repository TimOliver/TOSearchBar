//
//  TOSearchBar.h
//  TOSearchBarExample
//
//  Created by Tim Oliver on 29/9/16.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface TOSearchBar : UIView

/** How many points on each side the search bar is inset */
@property (nonatomic, assign) IBInspectable CGFloat horizontalInset;

/** The tint color of the rounded background */
@property (nonatomic, strong) IBInspectable UIColor *barBackgroundTintColor;

@end
