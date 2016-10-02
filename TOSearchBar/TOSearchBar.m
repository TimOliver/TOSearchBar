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

@property (nonatomic, strong) UIImageView *barBackgroundView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

- (void)setUpViews;

@end

@implementation TOSearchBar

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview != nil) {
        [self setUpViews];
    }
}

- (void)setUpViews
{
    CGRect frame;
    if (self.barBackgroundView == nil) {
        self.barBackgroundView = [[UIImageView alloc] initWithImage:[TOSearchBar sharedSearchBarBackground]];
        self.barBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                                    UIViewAutoresizingFlexibleWidth;
        
        
        frame = self.barBackgroundView.frame;
        frame.size.width = (self.frame.size.width) - (self.horizontalInset * 2.0f);
        frame.origin.x = self.horizontalInset;
        frame.origin.y = floorf((frame.size.height - self.frame.size.height) * 0.5f);
        self.barBackgroundView.frame = frame;
        
        self.barBackgroundView.tintColor = self.barBackgroundTintColor;
        [self addSubview:self.barBackgroundView];
    }
}

#pragma mark - Tint Colors -
- (UIColor *)barBackgroundTintColor
{
    if (_barBackgroundTintColor == nil) {
        _barBackgroundTintColor = [UIColor colorWithRed:0.0f green:0.05f blue:0.13f alpha:0.083f];
    }
    
    return _barBackgroundTintColor;
}

@end
