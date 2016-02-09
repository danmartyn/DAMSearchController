//
//  UIViewController+DAMSearchController.h
//  SearchController
//
//  Created by Daniel Martyn on 2016-02-09.
//  Copyright © 2016 Daniel Martyn. All rights reserved.
//

@import UIKit;
#import "DAMSearchController.h"



@interface UIViewController (DAMSearchController)


- (DAMSearchController *)createAndAddSearchController;
- (DAMSearchController *)searchController;

- (void)addSearchBar;


@end
