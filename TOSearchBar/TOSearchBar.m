//
//  TOSearchBar.m
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

#import "TOSearchBar.h"
#import "TOSearchBar+Assets.h"

static const CGFloat kTOSearchBarInset = 8.0f; // inset from inside the bar

// iOS 10 and down
static const CGFloat kTOSearchBarIconMarginClassic = 5.0f; // spacing between icon and placeholder
static const CGFloat kTOSearchBarFontSizeClassic = 15.0f;
static const CGFloat kTOSearchBarBackgroundHeightClassic = 28.0f;

// iOS 11 style constants
static const CGFloat kTOSearchBarIconMarginModern = 7.0f;
static const CGFloat kTOSearchBarFontSizeModern = 17.0f;
static const CGFloat kTOSearchBarBackgroundHeightModern = 36.0f;

@interface TOSearchBar () <UIGestureRecognizerDelegate, UITextFieldDelegate>

// UI components
@property (nonatomic, strong, readwrite) UIImageView *barBackgroundView;
@property (nonatomic, strong, readwrite) UIView *containerView;
@property (nonatomic, strong, readwrite) UILabel *placeholderLabel;
@property (nonatomic, strong, readwrite) UITextField *searchTextField;
@property (nonatomic, strong, readwrite) UIButton *cancelButton;
@property (nonatomic, strong, readwrite) UIButton *clearButton;
@property (nonatomic, strong, readwrite) UIImageView *iconView;

// State
@property (nonatomic, readonly) BOOL centerTextLabel;

@end

@implementation TOSearchBar

@synthesize barBackgroundTintColor = _barBackgroundTintColor;

- (instancetype)initWithFrame:(CGRect)frame style:(TOSearchBarStyle)style
{
    if (self = [super initWithFrame:frame]) {
        _style = style;
    }
    
    return self;
}

- (instancetype)initWithStyle:(TOSearchBarStyle)style
{
    if (self = [super initWithFrame:CGRectZero]) {
        _style = style;
    }
    
    return self;
}

- (void)dealloc
{
    [TOSearchBar cleanUpSharedAssets];
}

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
    self.userInteractionEnabled = YES;
    
    [self setUpBackgroundViews];
    [self setUpPlaceholderViews];
    [self setUpButtons];
    [self setUpTextField];
    [self setUpGestureRecognizers];
    
    [self configureThemeForCurrentStyle];
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
    
    CGFloat fontSize = kTOSearchBarFontSizeClassic;
    if (@available(iOS 11.0, *)) {
        fontSize = kTOSearchBarFontSizeModern;
    }
    self.placeholderLabel.font = [UIFont systemFontOfSize:fontSize];
    self.placeholderLabel.text = NSLocalizedStringFromTableInBundle(@"Search",
                                                                    @"TOSearchBarLocalizable",
                                                                    [TOSearchBar bundle],
                                                                    nil);
    [self.placeholderLabel sizeToFit];
    [self.containerView addSubview:self.placeholderLabel];

    // Set up the accessory icon view
    if (self.iconView == nil) {
        self.iconView = [[UIImageView alloc] initWithImage:[TOSearchBar sharedSearchIcon]];
    }
    [self.containerView addSubview:self.iconView];
}

- (void)setUpTextField
{
    if (self.searchTextField == nil) {
        self.searchTextField = [[UITextField alloc] initWithFrame:self.containerView.bounds];
    }
    
    CGFloat fontSize = kTOSearchBarFontSizeClassic;
    if (@available(iOS 11.0, *)) {
        fontSize = kTOSearchBarFontSizeModern;
    }
    self.searchTextField.userInteractionEnabled = YES;
    self.searchTextField.font = [UIFont systemFontOfSize:fontSize];
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.containerView addSubview:self.searchTextField];
}

- (void)setUpButtons
{
    CGFloat iconMargin = kTOSearchBarIconMarginClassic;
    if (@available(iOS 11.0, *)) {
        iconMargin = kTOSearchBarIconMarginModern;
    }
    
    if (self.showsCancelButton && self.cancelButton == nil) {
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    [self.cancelButton setTitle:NSLocalizedStringFromTableInBundle(@"Cancel",
                                                                   @"TOSearchBarLocalizable",
                                                                   [TOSearchBar bundle],
                                                                   nil) forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.cancelButton addTarget:self action:@selector(cancelButttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton sizeToFit];
    self.cancelButton.frame = CGRectInset(self.cancelButton.frame, -iconMargin, 0.0f);
    [self addSubview:self.cancelButton];
    
    if (self.clearButton) {
        return;
    }

    UIImage *clearButtonImage = [TOSearchBar sharedClearIcon];
    self.clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.clearButton setImage:clearButtonImage forState:UIControlStateNormal];
    self.clearButton.frame = (CGRect){CGPointZero, {44.0f, 44.0f}};
    self.clearButton.enabled = NO;
    self.clearButton.hidden = YES;
    [self.clearButton addTarget:self action:@selector(clearButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.clearButton];
}

- (void)setUpGestureRecognizers
{
    [self.searchTextField addTarget:self action:@selector(didTapDown:) forControlEvents:UIControlEventTouchDown];
    [self.searchTextField addTarget:self action:@selector(didTapUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchTextField addTarget:self action:@selector(didTapCancel:) forControlEvents:UIControlEventTouchCancel];
    
//    if (self.tapGestureRecognizer) {
//        return;
//    }
    
    // A long-press recognizer is used in order to detect when the user initially touches the glass
//    self.tapGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
//    self.tapGestureRecognizer.minimumPressDuration = 0.0001f;
//    self.tapGestureRecognizer.delegate = self;
//    [self addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark - View Management -
- (void)layoutSubviews
{
    CGRect frame;
    CGSize clearImageSize = self.clearButton.imageView.image.size;
    
    CGFloat iconMargin = kTOSearchBarIconMarginClassic;
    if (@available(iOS 11.0, *)) {
        iconMargin = kTOSearchBarIconMarginModern;
    }
    
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
    frame.size.height = kTOSearchBarBackgroundHeightClassic;
    if (@available(iOS 11.0, *)) {
        frame.size.height = kTOSearchBarBackgroundHeightModern;
    }
    
    if (self.editing && self.cancelButton) { frame.size.width -= self.cancelButton.frame.size.width; }
    frame.origin.x = self.horizontalInset;
    frame.origin.y = floorf((self.frame.size.height - frame.size.height) * 0.5f);
    self.barBackgroundView.frame = frame;
    self.containerView.frame = frame;
    
    // layout the place holder label
    frame = self.placeholderLabel.frame;
    if (self.centerTextLabel == NO) {
        frame.origin.x = (kTOSearchBarInset) + self.iconView.frame.size.width;
        if (@available(iOS 11.0, *)) {
            frame.origin.x += kTOSearchBarIconMarginModern;
        }
        else {
            frame.origin.x += kTOSearchBarIconMarginClassic;
        }
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
        frame.origin.x = CGRectGetMinX(self.placeholderLabel.frame) - (CGRectGetWidth(self.iconView.frame) + iconMargin);
    }
    frame.origin.y = floorf(CGRectGetMidY(self.placeholderLabel.frame) - (CGRectGetHeight(self.iconView.frame) * 0.5f));
    self.iconView.frame = frame;
    
    // lay out the text field
    frame = self.searchTextField.frame;
    frame.size = self.containerView.frame.size;
    frame.size.width = CGRectGetWidth(frame) - (self.placeholderLabel.frame.origin.x + iconMargin + clearImageSize.width);
    frame.origin.x = self.placeholderLabel.frame.origin.x;
    frame.origin.y = 0.0f;
    self.searchTextField.frame = frame;
    
    // layout the clear button
    CGPoint center = CGPointZero;
    center.x = (CGRectGetWidth(self.containerView.frame) - (kTOSearchBarInset + (clearImageSize.width * 0.5f)));
    center.y = (CGRectGetHeight(self.containerView.frame) * 0.5f);
    self.clearButton.center = center;
}

#pragma mark - Theme Management -
- (void)configureThemeForCurrentStyle
{
    BOOL darkMode = (self.style == TOSearchBarStyleDark);
    
    if (darkMode) {
        self.barBackgroundTintColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.065f];
        self.placeholderTintColor = [UIColor colorWithWhite:0.4f alpha:1.0f];
        self.searchTextField.textColor = [UIColor whiteColor];
        self.clearButton.tintColor = [UIColor colorWithWhite:0.45f alpha:1.0f];
        self.searchTextField.keyboardAppearance = UIKeyboardAppearanceDark;
        return;
    }
    
    self.searchTextField.textColor = [UIColor blackColor];
    
    self.placeholderTintColor = [UIColor colorWithRed:0.556863f green:0.556863f blue:0.576471f alpha:1.0f];
    self.clearButton.tintColor = [UIColor colorWithRed:0.556863f green:0.556863f blue:0.576471f alpha:1.0f];
    
    if (@available(iOS 11.0, *)) {
        self.barBackgroundTintColor = [UIColor colorWithRed:0.0f green:0.00f blue:0.02352f alpha:0.055f];
        self.selectedBarBackgroundTintColor = [UIColor colorWithRed:0.0f green:0.00f blue:0.02352f alpha:0.1f];
    }
    else {
        self.barBackgroundTintColor = [UIColor colorWithRed:0.0f green:0.05f blue:0.13f alpha:0.083f];
        self.selectedBarBackgroundTintColor = [UIColor colorWithRed:0.0f green:0.05f blue:0.13f alpha:0.09f];
    }
    self.searchTextField.keyboardAppearance = UIKeyboardAppearanceLight;
}

#pragma mark - Event Handling -

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return !(self.searchTextField.isFirstResponder);
}

- (void)clearButtonTapped:(id)sender
{
    self.text = nil;
    self.clearButton.enabled = NO;
    self.placeholderLabel.hidden = NO;
    [self setClearButtonHidden:YES animated:YES];
    [self becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(searchBarClearButtonTapped:)]) {
        [self.delegate searchBarClearButtonTapped:self];
    }
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

- (BOOL)isFirstResponder
{
    return self.searchTextField.isFirstResponder;
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

- (void)didTapDown:(id)sender
{
    if (self.searchTextField.isFirstResponder) { return; }
    [self setSelected:YES animated:YES];
}

- (void)didTapCancel:(id)sender
{
    if (self.searchTextField.isFirstResponder) { return; }
    [self setSelected:NO animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
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
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:
     ^{
        [self layoutIfNeeded];
     } completion:nil];
}

- (void)setClearButtonHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (self.clearButton.hidden == hidden) {
        return;
    }
    
    if (animated == NO) {
        self.clearButton.hidden = hidden;
        return;
    }
    
    self.clearButton.hidden = NO;
    
    CGAffineTransform visibleTransform = CGAffineTransformIdentity;
    CGAffineTransform hiddenTransform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01f, 0.01f);
    
    CGFloat visibleAlpha = 1.0f;
    CGFloat hiddenAlpha = 0.0f;
    
    self.clearButton.transform = hidden ? visibleTransform : hiddenTransform;
    self.clearButton.alpha = hidden ? visibleAlpha : hiddenAlpha;
    
    [self.clearButton.layer removeAllAnimations];
    [UIView animateWithDuration:0.25f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.1f
                        options:0
                     animations:
     ^{
         self.clearButton.alpha = hidden ? hiddenAlpha : visibleAlpha;
         self.clearButton.transform = hidden ? hiddenTransform : visibleTransform;
     } completion:^(BOOL complete) {
         self.clearButton.hidden = hidden;
     }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (super.selected == selected) { return; }
    
    super.selected = selected;
    
    void (^selectedBlock)(void) = ^{
        self.barBackgroundView.tintColor = selected ? self.selectedBarBackgroundTintColor : self.barBackgroundTintColor;
    };
    
    if (!animated) {
        selectedBlock();
        return;
    }
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:selectedBlock
                     completion:nil];
}

#pragma mark - Text Field Delegate -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL result = YES;
    
    // Allow the delegate to override this value
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        result = [self.delegate searchBarShouldBeginEditing:self];
    }
    
    // Kickstart the editing transition now. Any later creates strange stretch effects
    if (result) {
         [self setEditing:YES animated:YES];
    }
    
    return result;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchBarDidBeginEditing:)]) {
        [self.delegate searchBarDidBeginEditing:self];
    }
    
    [self setSelected:NO animated:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    BOOL result = YES;
    
    // Allow the delegate to override this value
    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        result = [self.delegate searchBarShouldEndEditing:self];
    }
    
    // Kickstart the editing transition now. Any later creates strange stretch effects
    if (result) {
        [self setEditing:YES animated:YES];
    }
    
    return result;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField layoutIfNeeded]; // Necessary to stop bouncing animation glitch
    [self setEditing:NO animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(searchBarDidEndEditing:)]) {
        [self.delegate searchBarDidEndEditing:self];
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    self.placeholderLabel.hidden = self.hasSearchText;
    self.clearButton.enabled     = self.hasSearchText;
    
    [self setClearButtonHidden:!self.hasSearchText animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [self.delegate searchBar:self textDidChange:self.text];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate searchBar:self shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchBarSearchButtonTapped:)]) {
        [self.delegate searchBarSearchButtonTapped:self];
    }
    
    return YES;
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
    self.placeholderLabel.text = placeholderText ?: NSLocalizedStringFromTableInBundle(@"Search",
                                                                                       @"TOSearchBarLocalizable",
                                                                                       [TOSearchBar bundle],
                                                                                       nil);
    [self.placeholderLabel sizeToFit];
    [self setNeedsLayout];
}

- (NSString *)placeholderText
{
    return self.placeholderLabel.text;
}

- (UIColor *)barBackgroundTintColor
{
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

- (void)setPlaceholderTintColor:(UIColor *)placeholderTintColor
{
    _placeholderTintColor = placeholderTintColor;
    self.placeholderLabel.textColor = placeholderTintColor;
    self.iconView.tintColor = placeholderTintColor;
}

- (void)setStyle:(TOSearchBarStyle)style
{
    if (style == _style) {
        return;
    }
    
    _style = style;
    [self configureThemeForCurrentStyle];
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

- (BOOL)centerTextLabel
{
    if (@available(iOS 11.0, *)) {
        return NO;
    }
    
    return (self.editing || self.hasSearchText);
}

+ (NSBundle *)bundle
{
    // Whether installed manually or via CocoaPods, this will configure the bundle paths properly
    NSBundle *resourceBundle = nil;
    NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
    NSURL *resourceBundleURL = [classBundle URLForResource:@"TOSearchBarBundle" withExtension:@"bundle"];
    if (resourceBundleURL) {
        resourceBundle = [[NSBundle alloc] initWithURL:resourceBundleURL];
    }
    else {
        resourceBundle = classBundle;
    }
    
    return resourceBundle;
}

@end
