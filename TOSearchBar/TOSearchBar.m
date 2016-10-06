//
//  TOSearchBar.m
//  TOSearchBarExample
//
//  Created by Tim Oliver on 29/9/16.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import "TOSearchBar.h"
#import "TOSearchBar+Assets.h"

static const CGFloat kTOSearchBarInset = 8.0f; // inset from inside the bar
static const CGFloat kTOSearchBarIconMargin = 5.0f; // spacing between icon and placeholder

@interface TOSearchBar () <UIGestureRecognizerDelegate, UITextFieldDelegate>

// UI components
@property (nonatomic, strong) UIImageView *barBackgroundView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIImageView *iconView;

// Interaction */
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

/* View Set-up */
- (void)setUpViews;
- (void)setUpBackgroundViews;
- (void)setUpPlaceholderViews;
- (void)setUpButtons;
- (void)setUpTextField;
- (void)setUpGestureRecognizers;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

- (void)textFieldDidChange:(UITextField *)textField;

@end

@implementation TOSearchBar

@synthesize barBackgroundTintColor = _barBackgroundTintColor;

#pragma mark - View Lifecycle -
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview != nil) {
        [self setUpViews];
    }
}

#pragma mark - View Set-up -
- (void)setUpViews
{
    [self setUpBackgroundViews];
    [self setUpPlaceholderViews];
    [self setUpButtons];
    [self setUpTextField];
    [self setUpGestureRecognizers];
}

- (void)setUpBackgroundViews
{
    if (self.barBackgroundView) {
        return;
    }
    
    self.barBackgroundView = [[UIImageView alloc] initWithImage:[TOSearchBar sharedSearchBarBackground]];
    self.barBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.barBackgroundView.tintColor = self.barBackgroundTintColor;
    [self addSubview:self.barBackgroundView];
    
    if (self.containerView) {
        return;
    }
    
    self.containerView = [[UIView alloc] initWithFrame:self.barBackgroundView.frame];
    self.containerView.autoresizingMask = self.barBackgroundView.autoresizingMask;
    [self addSubview:self.containerView];
}

- (void)setUpPlaceholderViews
{
    // Set up the placeholder label view
    if (self.placeholderLabel) {
        return;
    }
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.placeholderLabel.font = [UIFont systemFontOfSize:15.0f];
    self.placeholderLabel.text = @"Search";
    self.placeholderLabel.textColor = [UIColor grayColor];
    [self.placeholderLabel sizeToFit];
    [self.containerView addSubview:self.placeholderLabel];

    // Set up the accessory icon view
    if (self.iconView) {
        return;
    }

    self.iconView = [[UIImageView alloc] initWithImage:[TOSearchBar sharedSearchIcon]];
    self.iconView.tintColor = [UIColor grayColor];
    [self.containerView addSubview:self.iconView];
}

- (void)setUpTextField
{
    if (self.searchTextField) {
        return;
    }
    
    self.searchTextField = [[UITextField alloc] initWithFrame:self.containerView.bounds];
    self.searchTextField.font = [UIFont systemFontOfSize:15.0f];
    self.searchTextField.textColor = [UIColor blackColor];
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    [self.containerView addSubview:self.searchTextField];
    
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setUpButtons
{
    
}

- (void)setUpGestureRecognizers
{
    if (self.tapGestureRecognizer) {
        return;
    }
    
    // A long-press recognizer is used in order to detect when the user initially touches the glass
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    self.tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.tapGestureRecognizer];
}


#pragma mark - View Management -
- (void)layoutSubviews
{
    CGRect frame;
    
    // Layout the background view (and content container)
    frame = self.barBackgroundView.frame;
    frame.size.width = (self.frame.size.width) - (self.horizontalInset * 2.0f);
    frame.origin.x = self.horizontalInset;
    frame.origin.y = floorf((self.frame.size.height - frame.size.height) * 0.5f);
    self.barBackgroundView.frame = frame;
    self.containerView.frame = frame;
    
    // layout the place holder label
    frame = self.placeholderLabel.frame;
    if (self.editing || self.hasSearchText) {
        frame.origin.x = (kTOSearchBarIconMargin + kTOSearchBarInset) + self.iconView.frame.size.width;
    }
    else {
        frame.origin.x = floorf((CGRectGetWidth(self.containerView.frame) - CGRectGetWidth(frame)) * 0.5f);
    }
    frame.origin.y = floorf((CGRectGetHeight(self.containerView.frame) - CGRectGetHeight(frame)) * 0.5f);
    self.placeholderLabel.frame = frame;
    
    // layout the icon
    frame = self.iconView.frame;
    if (self.editing || self.hasSearchText) {
        frame.origin.x = kTOSearchBarInset;
    }
    else {
        frame.origin.x = CGRectGetMinX(self.placeholderLabel.frame) - (CGRectGetWidth(self.iconView.frame) + kTOSearchBarIconMargin);
    }
    frame.origin.y = CGRectGetMidY(self.placeholderLabel.frame) - (CGRectGetHeight(self.iconView.frame) * 0.5f);
    self.iconView.frame = frame;
    
    // lay out the text field
    frame = self.searchTextField.frame;
    frame.size = self.containerView.frame.size;
    frame.size.width = CGRectGetWidth(frame) - self.placeholderLabel.frame.origin.x;
    frame.origin.x = self.placeholderLabel.frame.origin.x;
    frame.origin.y = 0.0f;
    self.searchTextField.frame = frame;
}

#pragma mark - Event Handling -
- (void)tapGestureRecognized:(UITapGestureRecognizer *)recognizer
{
    [self.searchTextField becomeFirstResponder];
    [self setEditing:YES animated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return !(self.searchTextField.isFirstResponder);
}

- (BOOL)resignFirstResponder
{
    [self.searchTextField resignFirstResponder];
    [self setEditing:NO animated:YES];
    return [super resignFirstResponder];
}

#pragma mark - Editing -
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    self.editing = editing;
    
    if (animated == NO) {
        return;
    }
    
    [UIView animateWithDuration:0.4f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.1f
                        options:0
                     animations:
     ^{
        [self layoutIfNeeded];
     } completion:nil];
}

#pragma mark - Text Field Delegate -
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setEditing:YES animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField layoutIfNeeded]; // Necessary to stop bouncing animation glitch
    [self setEditing:NO animated:YES];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    self.placeholderLabel.hidden = textField.text.length > 0;
}

#pragma mark - Accessors -
- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    [self setNeedsLayout];
}

- (BOOL)hasSearchText
{
    return self.searchTextField.text.length > 0;
}

- (UIColor *)barBackgroundTintColor
{
    if (_barBackgroundTintColor == nil) {
        _barBackgroundTintColor = [UIColor colorWithRed:0.0f green:0.05f blue:0.13f alpha:0.083f];
    }
    
    return _barBackgroundTintColor;
}

- (void)setBarBackgroundTintColor:(UIColor *)barBackgroundTintColor
{
    _barBackgroundTintColor = barBackgroundTintColor;
    self.barBackgroundView.tintColor = _barBackgroundTintColor;
}

- (void)setHorizontalInset:(CGFloat)horizontalInset
{
    if (_horizontalInset == horizontalInset) {
        return;
    }
    
    _horizontalInset = horizontalInset;
    [self setNeedsLayout];
}

@end
