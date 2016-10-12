//
//  TOSearchBar.h
//  TOSearchBarExample
//
//  Created by Tim Oliver on 29/9/16.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TOSearchBarStyle) {
    TOSearchBarStyleLight = 0,
    TOSearchBarStyleDark = 1
};

@class TOSearchBar;

@protocol TOSearchBarDelegate <NSObject>

@optional
- (BOOL)searchBarShouldBeginEditing:(TOSearchBar *)searchBar;
- (void)searchBarDidBeginEditing:(TOSearchBar *)searchBar;

- (BOOL)searchBarShouldEndEditing:(TOSearchBar *)searchBar;
- (void)searchBarDidEndEditing:(TOSearchBar *)searchBar;

- (void)searchBarDidChange:(TOSearchBar *)searchBar;
- (BOOL)searchBar:(TOSearchBar *)searchBar shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

- (BOOL)searchBarShouldClear:(TOSearchBar *)searchBar;
- (BOOL)searchBarShouldReturn:(TOSearchBar *)searchBar;

@end

IB_DESIGNABLE
@interface TOSearchBar : UIControl

/** The color style of this view. Setting this will set a series of default color values to each subview.
 The individual views can then further be custom configured if desired.
 */
@property (nonatomic, assign) IBInspectable TOSearchBarStyle style;

/** The delegate object for responding to events */
@property (nullable, nonatomic, weak) id<TOSearchBarDelegate> delegate;

/** The search text, entered by the user */
@property (nullable, nonatomic, copy) IBInspectable NSString *text;

/** The contents of the placeholder text. Defaults to 'Search' */
@property (null_resettable, nonatomic, copy) IBInspectable NSString *placeholderText;

/** How many points on each side the search bar is inset */
@property (nonatomic, assign) IBInspectable CGFloat horizontalInset;

/** Whether the text field is currently presenting the keyboard */
@property (nonatomic, assign) BOOL editing;

/** Whether the text field contains any text or not */
@property (nonatomic, readonly) BOOL hasSearchText;

/** Shows a 'Cancel' button while editing */
@property (nonatomic, assign) IBInspectable BOOL showsCancelButton;

/** The tint color of the placeholder content (Both the icon and the text) */
@property (nullable, nonatomic, strong) IBInspectable UIColor *placeholderTintColor UI_APPEARANCE_SELECTOR;

/** The tint color of the rounded background rectangle */
@property (null_resettable, nonatomic, strong) IBInspectable UIColor *barBackgroundTintColor UI_APPEARANCE_SELECTOR;

/** The tint color of the background when the text field is currently, or has content */
@property (nullable, nonatomic, strong) IBInspectable UIColor *highlightedBarBackgroundTintColor UI_APPEARANCE_SELECTOR;

/** The main text field that the user will input search text */
@property (nonatomic, readonly) UITextField *searchTextField;

/** The auxiliary icon view to the left of the text field text */
@property (nullable, nonatomic, readonly) UIImageView *iconView;

/** The initial 'Search' text label displayed when the search field is empty. */
@property (nonatomic, strong, readonly) UILabel *placeholderLabel;

/** If specified, the 'Cancel' button that can cancel out of text input */
@property (nullable, nonatomic, readonly) UIButton *cancelButton;

/** The 'clear' button that will clear any text in the text field */
@property (nonatomic, strong, readonly) UIButton *clearButton;

/** 
 Create a new instance of this class, specifying the frame and style. 
 
 @param frame The entire frame for this view (Ideally of a height of 44 points)
 @param style The color style of the view (light or dark)
 */
- (instancetype)initWithFrame:(CGRect)frame style:(TOSearchBarStyle)style;

/**
 Create a new instance of this class, specifying the style.
 
 @param style The color style of the view (light or dark)
 */
- (instancetype)initWithStyle:(TOSearchBarStyle)style;

@end

NS_ASSUME_NONNULL_END
