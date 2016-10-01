//
//  ViewController.m
//  TOSearchBarExample
//
//  Created by Tim Oliver on 27/9/16.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *themeControl;

- (IBAction)themeControlChanged:(id)sender;
- (void)layoutScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutScrollView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self layoutScrollView];
}

- (void)viewWillLayoutSubviews
{
    [self layoutScrollView];
}

- (void)layoutScrollView
{
    CGRect scrollViewBounds = self.scrollView.bounds;
    CGRect contentViewBounds = self.containerView.bounds;
    
    UIEdgeInsets scrollViewInsets = UIEdgeInsetsZero;
    scrollViewInsets.top = (scrollViewBounds.size.height * 0.5f);
    scrollViewInsets.top -= (contentViewBounds.size.height * 0.5f);
    
    scrollViewInsets.bottom = (scrollViewBounds.size.height * 0.5f);
    scrollViewInsets.bottom -= (contentViewBounds.size.height * 0.5f);
    scrollViewInsets.bottom += 1;
    
    self.scrollView.contentInset = scrollViewInsets;
}

- (IBAction)themeControlChanged:(id)sender
{
    
}

@end
