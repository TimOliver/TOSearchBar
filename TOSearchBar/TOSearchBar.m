//
//  TOSearchBar.m
//  TOSearchBarExample
//
//  Created by Tim Oliver on 29/9/16.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import "TOSearchBar.h"
#import "TOSearchBar+Assets.h"

@interface TOSearchBar ()

// UI components
@property (nonatomic, strong) UIImageView *barBackgroundView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIImageView *iconView;

// Interaction */
@property (nonatomic, strong) UILongPressGestureRecognizer *tapGestureRecognizer;

// State Tracking
@property (nonatomic, assign) BOOL barBackgroundHighlighted;

/* View Set-up */
- (void)setUpViews;
- (void)setUpBackgroundView;
- (void)setUpPlaceholderViews;
- (void)setUpButtons;
- (void)setUpGestureRecognizers;

/* Event Handling */
- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGestureRecognizer;

/* View Animating */
- (void)setBarBackgroundHighlighted:(BOOL)highlighted animated:(BOOL)animated;

@end

@implementation TOSearchBar

@synthesize barBackgroundTintColor            = _barBackgroundTintColor;
@synthesize barBackgroundTintColorHighlighted = _barBackgroundTintColorHighlighted;

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
    [self setUpBackgroundView];
    [self setUpPlaceholderViews];
    [self setUpButtons];
    [self setUpGestureRecognizers];
}

- (void)setUpBackgroundView
{
    if (self.barBackgroundView) {
        return;
    }
    
    self.barBackgroundView = [[UIImageView alloc] initWithImage:[TOSearchBar sharedSearchBarBackground]];
    self.barBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.barBackgroundView.tintColor = self.barBackgroundTintColor;
    [self addSubview:self.barBackgroundView];
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
    [self addSubview:self.placeholderLabel];

    // Set up the accessory icon view
    if (self.iconView) {
        return;
    }

    self.iconView = [[UIImageView alloc] initWithImage:[TOSearchBar sharedSearchIcon]];
    self.iconView.tintColor = [UIColor grayColor];
    [self addSubview:self.iconView];
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
    self.tapGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    self.tapGestureRecognizer.minimumPressDuration = 0.0f;
    [self addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark - View Management -
- (void)layoutSubviews
{
    CGRect frame;
    
    frame = self.barBackgroundView.frame;
    frame.size.width = (self.frame.size.width) - (self.horizontalInset * 2.0f);
    frame.origin.x = self.horizontalInset;
    frame.origin.y = floorf((self.frame.size.height - frame.size.height) * 0.5f);
    self.barBackgroundView.frame = frame;
    
    frame = self.placeholderLabel.frame;
    frame.origin.x = CGRectGetMidX(self.barBackgroundView.frame) - (CGRectGetWidth(frame) * 0.5f);
    frame.origin.y = CGRectGetMidY(self.barBackgroundView.frame) - (CGRectGetHeight(frame) * 0.5f);
    self.placeholderLabel.frame = frame;
    
    frame = self.iconView.frame;
    frame.origin.x = CGRectGetMinX(self.placeholderLabel.frame) - (CGRectGetWidth(self.iconView.frame) + 5);
    frame.origin.y = CGRectGetMidY(self.placeholderLabel.frame) - (CGRectGetHeight(self.iconView.frame) * 0.5f);
    self.iconView.frame = frame;
}

#pragma mark - Event Handling -
- (void)tapGestureRecognized:(UILongPressGestureRecognizer *)tapGestureRecognizer
{
    if (tapGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self setBarBackgroundHighlighted:YES animated:YES];
    }
    else if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self setBarBackgroundHighlighted:NO animated:YES];
    }
}

#pragma mark - Animation -
- (void)setBarBackgroundHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (animated == NO) {
        self.barBackgroundHighlighted = highlighted;
        return;
    }
    
    UIColor *destinationColor = highlighted ? self.barBackgroundTintColorHighlighted : self.barBackgroundTintColor;
    [UIView animateWithDuration:0.15f animations:^{
        self.barBackgroundView.tintColor = destinationColor;
    }];
}

#pragma mark - Accessors -
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

- (UIColor *)barBackgroundTintColorHighlighted
{
    if (_barBackgroundTintColorHighlighted == nil) {
        _barBackgroundTintColorHighlighted = [UIColor colorWithRed:0.0f green:0.05f blue:0.13f alpha:0.15f];
    }
    return _barBackgroundTintColorHighlighted;
}

- (void)setHorizontalInset:(CGFloat)horizontalInset
{
    if (_horizontalInset == horizontalInset) {
        return;
    }
    
    _horizontalInset = horizontalInset;
    [self setNeedsLayout];
}

- (void)setBarBackgroundHighlighted:(BOOL)barBackgroundHighlighted
{
    _barBackgroundHighlighted = barBackgroundHighlighted;
    self.barBackgroundView.tintColor = _barBackgroundHighlighted ? self.barBackgroundTintColorHighlighted :
                                                                                self.barBackgroundTintColor;
}

@end
