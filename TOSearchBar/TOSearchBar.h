//
//  TOSearchBar.h
//  TOSearchBarExample
//
//  Created by Tim Oliver on 29/9/16.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TOSearchBarStyle) {
    TOSearchBarStyleLight,
    TOSearchBarStyleDark
};

IB_DESIGNABLE
@interface TOSearchBar : UIControl

/** How many points on each side the search bar is inset */
@property (nonatomic, assign) IBInspectable CGFloat horizontalInset;

/** The contents of the placeholder text. Defaults to 'Search' */
@property (nonatomic, copy) IBInspectable NSString *placeholderString;


@property (nonatomic, assign) BOOL editing;

/** The tint color of the placeholder content (Both the icon and the text) */
@property (nonatomic, strong) IBInspectable UIColor *placeholderTintColor UI_APPEARANCE_SELECTOR;

/** The tint color of the rounded background rectangle */
@property (nonatomic, strong) IBInspectable UIColor *barBackgroundTintColor UI_APPEARANCE_SELECTOR;

/** The tint color of the background when the user is editing the text field */
@property (nonatomic, strong) IBInspectable UIColor *barBackgroundTintColorEditing UI_APPEARANCE_SELECTOR;

@end
