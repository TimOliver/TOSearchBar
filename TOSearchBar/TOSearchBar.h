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

/** The search text, entered by the user */
@property (nonatomic, copy) IBInspectable NSString *text;

/** The contents of the placeholder text. Defaults to 'Search' */
@property (nonatomic, copy) IBInspectable NSString *placeholderText;

/** How many points on each side the search bar is inset */
@property (nonatomic, assign) IBInspectable CGFloat horizontalInset;

/** Whether the text field is currently presenting the keyboard */
@property (nonatomic, assign) BOOL editing;

/** Whether the text field contains any text or not */
@property (nonatomic, readonly) BOOL hasSearchText;

/** The tint color of the placeholder content (Both the icon and the text) */
@property (nonatomic, strong) IBInspectable UIColor *placeholderTintColor UI_APPEARANCE_SELECTOR;

/** The tint color of the rounded background rectangle */
@property (nonatomic, strong) IBInspectable UIColor *barBackgroundTintColor UI_APPEARANCE_SELECTOR;

/** The tint color of the background when the text field is selected */
@property (nonatomic, strong) IBInspectable UIColor *barBackgroundTintColorHighlighted UI_APPEARANCE_SELECTOR;

@end
