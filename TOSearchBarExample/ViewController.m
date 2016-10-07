//
//  ViewController.m
//  TOSearchBarExample
//
//  Created by Tim Oliver on 27/9/16.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import "ViewController.h"
#import "TOSearchBar.h"

@interface ViewController () <UIScrollViewDelegate, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *themeControl;

@property (nonatomic, weak) IBOutlet UISearchBar *classicSearchBar;
@property (nonatomic, weak) IBOutlet TOSearchBar *searchBar;

@property (nonatomic, assign) CGFloat keyboardHeight;

- (IBAction)themeControlChanged:(id)sender;
- (void)layoutScrollView;

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.tapRecognizer == nil) {
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
        [self.scrollView addGestureRecognizer:self.tapRecognizer];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Must be called at this point since
    // any point beforehand won't be properly
    // laid out yet
    [self layoutScrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
    
    //Center it on iPad
    /*if (self.view.frame.size.height >= 768.0f) {
        scrollViewBounds.size.height -= self.keyboardHeight;
    
        scrollViewInsets.top = (scrollViewBounds.size.height * 0.5f);
        scrollViewInsets.top -= (contentViewBounds.size.height * 0.5f);
        scrollViewInsets.top = MAX(0.0f, scrollViewInsets.top);
        
        scrollViewInsets.bottom = (scrollViewBounds.size.height * 0.5f);
        scrollViewInsets.bottom -= (contentViewBounds.size.height * 0.5f);
        scrollViewInsets.bottom = MAX(0.0f, scrollViewInsets.bottom);
        
        scrollViewInsets.bottom += self.keyboardHeight;
    }
    else { // Static vertical offset*/
        scrollViewInsets.top = 40.0f;
        scrollViewInsets.bottom = MAX(self.keyboardHeight, scrollViewBounds.size.height - (40.0f + contentViewBounds.size.height));
    //}
    scrollViewInsets.bottom += 1;
    
    self.scrollView.contentInset = scrollViewInsets;
}

#pragma mark - Event Handling -

- (void)scrollViewTapped:(UITapGestureRecognizer *)tapRecognizer
{
    [self.classicSearchBar resignFirstResponder];
    [self.searchBar resignFirstResponder];
}

- (IBAction)themeControlChanged:(id)sender
{
    
}

#pragma mark - Search Bar Delegate -

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - Keyboard Handling -
- (void)keyboardWillShow:(NSNotification *)notification
{
    self.keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self layoutScrollView];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.keyboardHeight = 0.0f;
    [self layoutScrollView];
}

@end
