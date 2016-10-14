//
//  TOSearchBarExampleTests.m
//  TOSearchBarExampleTests
//
//  Created by Tim Oliver on 13/10/16.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TOSearchBar.h"

@interface TOSearchBarExampleTests : XCTestCase

@end

@implementation TOSearchBarExampleTests

- (void)testSearchBar
{
    TOSearchBar *searchBar = [[TOSearchBar alloc] initWithFrame:CGRectZero style:TOSearchBarStyleDark];
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [containerView addSubview:searchBar];
    XCTAssertNotNil(searchBar);
}

@end
