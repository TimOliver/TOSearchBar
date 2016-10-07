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
@property (nonatomic, strong) UIButton *clearButton;
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

/* State Management */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

/* Feedback Events */
- (void)textFieldDidChange:(UITextField *)textField;
- (void)clearButtonTapped:(id)sender;
- (void)cancelButttonTapped:(id)sender;

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
    self.clipsToBounds = YES;
    
    [self setUpBackgroundViews];
    [self setUpPlaceholderViews];
    [self setUpButtons];
    [self setUpTextField];
    [self setUpGestureRecognizers];
}

- (void)setUpBackgroundViews
{
    if (self.barBackgroundView == nil) {
        self.barBackgroundView = [[UIImageView alloc] initWithImage:[TOSearchBar sharedSearchBarBackground]];
    }
    self.barBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.barBackgroundView.tintColor = self.barBackgroundTintColor;
    [self addSubview:self.barBackgroundView];
    
    if (self.containerView == nil) {
        self.containerView = [[UIView alloc] initWithFrame:self.barBackgroundView.frame];
    }
    self.containerView.autoresizingMask = self.barBackgroundView.autoresizingMask;
    [self addSubview:self.containerView];
}

- (void)setUpPlaceholderViews
{
    // Set up the placeholder label view
    if (self.placeholderLabel == nil) {
        self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    self.placeholderLabel.font = [UIFont systemFontOfSize:15.0f];
    self.placeholderLabel.text = @"Search";
    self.placeholderLabel.textColor = [UIColor grayColor];
    [self.placeholderLabel sizeToFit];
    [self.containerView addSubview:self.placeholderLabel];

    // Set up the accessory icon view
    if (self.iconView == nil) {
        self.iconView = [[UIImageView alloc] initWithImage:[TOSearchBar sharedSearchIcon]];
    }
    self.iconView.tintColor = [UIColor grayColor];
    [self.containerView addSubview:self.iconView];
}

- (void)setUpTextField
{
    if (self.searchTextField == nil) {
        self.searchTextField = [[UITextField alloc] initWithFrame:self.containerView.bounds];
    }
    
    self.searchTextField.font = [UIFont systemFontOfSize:15.0f];
    self.searchTextField.textColor = [UIColor blackColor];
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.containerView addSubview:self.searchTextField];
}

- (void)setUpButtons
{
    if (self.showsCancelButton && self.cancelButton == nil) {
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    [self.cancelButton setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.cancelButton addTarget:self action:@selector(cancelButttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton sizeToFit];
    self.cancelButton.frame = CGRectInset(self.cancelButton.frame, -kTOSearchBarIconMargin, 0.0f);
    [self addSubview:self.cancelButton];
    
    if (self.clearButton) {
        return;
    }

    UIImage *clearButtonImage = [TOSearchBar sharedClearIcon];
    self.clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.clearButton setImage:clearButtonImage forState:UIControlStateNormal];
    self.clearButton.frame = (CGRect){CGPointZero, {44.0f, 44.0f}};
    self.clearButton.enabled = NO;
    self.clearButton.tintColor = [UIColor grayColor];
    [self.clearButton addTarget:self action:@selector(clearButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.clearButton];
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
    CGSize clearImageSize = self.clearButton.imageView.image.size;
    
    if (self.cancelButton) {
        self.cancelButton.alpha = self.editing ? 1.0f : 0.0f;
        frame = self.cancelButton.frame;
        frame.origin.y = (CGRectGetHeight(self.frame) - frame.size.height) * 0.5f;
        if (self.editing) {
            frame.origin.x = (CGRectGetWidth(self.frame) - (frame.size.width + self.horizontalInset));
        }
        else {
            frame.origin.x = CGRectGetWidth(self.frame);
        }
        self.cancelButton.frame = frame;
    }
    
    // Layout the background view (and content container)
    frame = self.barBackgroundView.frame;
    frame.size.width = (self.frame.size.width) - (self.horizontalInset * 2.0f);
    if (self.editing && self.cancelButton) { frame.size.width -= self.cancelButton.frame.size.width; }
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
    self.placeholderLabel.hidden = self.hasSearchText;
    
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
    frame.size.width = CGRectGetWidth(frame) - (self.placeholderLabel.frame.origin.x + kTOSearchBarIconMargin + clearImageSize.width);
    frame.origin.x = self.placeholderLabel.frame.origin.x;
    frame.origin.y = 0.0f;
    self.searchTextField.frame = frame;
    
    // layout the clear button
    CGPoint center = CGPointZero;
    center.x = (CGRectGetWidth(self.containerView.frame) - (kTOSearchBarInset + (clearImageSize.width * 0.5f)));
    center.y = (CGRectGetHeight(self.containerView.frame) * 0.5f);
    self.clearButton.center = center;
    
    if (self.hasSearchText || self.editing) {
        self.clearButton.transform = CGAffineTransformIdentity;
        self.clearButton.alpha = 1.0f;
    }
    else {
        self.clearButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01f, 0.01f);
        self.clearButton.alpha = 0.0f;
    }
}

#pragma mark - Event Handling -
- (void)tapGestureRecognized:(UITapGestureRecognizer *)recognizer
{
    [self becomeFirstResponder];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return !(self.searchTextField.isFirstResponder);
}

- (void)clearButtonTapped:(id)sender
{
    self.text = nil;
    self.clearButton.enabled = NO;
    self.placeholderLabel.hidden = NO;
    [self becomeFirstResponder];
}

- (void)cancelButttonTapped:(id)sender
{
    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    [self setEditing:YES animated:YES];
    return [self.searchTextField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [self.searchTextField resignFirstResponder];
    [self setEditing:NO animated:YES];
    return [super resignFirstResponder];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *targetView = self.clearButton;
    CGPoint pointForTargetView = [targetView convertPoint:point fromView:self];
    if (CGRectContainsPoint(targetView.bounds, pointForTargetView)) {
        return [targetView hitTest:pointForTargetView withEvent:event];
    }
    
    return [super hitTest:point withEvent:event];
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
    self.placeholderLabel.hidden = self.hasSearchText;
    self.clearButton.enabled     = self.hasSearchText;
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

- (void)setText:(NSString *)text
{
    self.searchTextField.text = text;
}

- (NSString *)text
{
    return self.searchTextField.text;
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    self.placeholderLabel.text = placeholderText ?: NSLocalizedString(@"Search", @"");
    [self.placeholderLabel sizeToFit];
    [self setNeedsLayout];
}

- (NSString *)placeholderText
{
    return self.placeholderLabel.text;
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

- (void)setShowsCancelButton:(BOOL)showsCancelButton
{
    _showsCancelButton = showsCancelButton;
    
    if (_showsCancelButton == NO) {
        [self.cancelButton removeFromSuperview];
        self.cancelButton = nil;
    }
    else {
        [self setUpButtons];
    }
    
    [self setNeedsLayout];
}

@end
