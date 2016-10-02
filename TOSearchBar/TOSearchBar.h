//
//  TOSearchBar.h
//  TOSearchBarExample
//
//  Created by Tim Oliver on 29/9/16.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TOSearchBar : UIView

/** How many points on each side the search bar is inset */
@property (nonatomic, assign) CGFloat horizontalInset;

/** The tint color of the rounded background */
@property (nonatomic, strong) UIColor *barBackgroundTintColor;

@end
