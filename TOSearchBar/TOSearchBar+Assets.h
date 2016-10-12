//
//  TOSearchBar+ImageAssets.h
//  TOSearchBarExample
//
//  Created by Tim Oliver on 29/9/16.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import "TOSearchBar.h"

@interface TOSearchBar (ImageAssets)

+ (UIImage *)sharedSearchBarBackground; /* The rounded rectangle for the background */
+ (UIImage *)sharedSearchIcon; /* The magnifying glads icon */
+ (UIImage *)sharedClearIcon;  /* The clear button icon. */

+ (void)cleanUpSharedAssets; /* Called upon each `dealloc` method call to clean up any freed assets. */

@end
