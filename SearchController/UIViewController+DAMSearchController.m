//
//  UIViewController+DAMSearchController.m
//  SearchController
//
//  Created by Daniel Martyn on 2016-02-09.
//  Copyright © 2016 Daniel Martyn. All rights reserved.
//

#import "UIViewController+DAMSearchController.h"



@implementation UIViewController (DAMSearchController)


#pragma mark -
#pragma mark - Creation

- (DAMSearchController *)createAndAddSearchController
{
    DAMSearchController *search = [[DAMSearchController alloc] init];
    
    [self addChildViewController:search];
    [search didMoveToParentViewController:self];
    [self.view addSubview:search.view];
    
    return search;
}


#pragma mark -
#pragma mark - Lazy Getter

- (DAMSearchController *)searchController
{
    for (UIViewController *viewController in self.childViewControllers) {
        if ([viewController isKindOfClass:[DAMSearchController class]]) {
            return (DAMSearchController *)viewController;
        }
    }
    
    return [self createAndAddSearchController];
}


#pragma mark -
#pragma mark - Search Bar Setup

- (void)addSearchBar
{
    // we only want to add the search bar once
    for (UIView *subview in self.view.subviews) {
        if (subview == self.searchController.searchBar) {
            return;
        }
    }
    
    
    UISearchBar *searchBar = self.searchController.searchBar;
    [self.view addSubview:searchBar];
    
    // anchor the searchbar to the topLayoutGuide
    NSDictionary *views = @{@"searchBar" : searchBar};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchBar]|" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchBar
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.topLayoutGuide
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    // make sure the search bar is anchored and all other views are in place before moving on
    [self.view layoutIfNeeded];
    
    // now check if there is a tableview under the search bar, and if so, alter the insets
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)subview;
            
            if (CGRectIntersectsRect(searchBar.frame, tableView.frame)) {
                UIEdgeInsets insets = tableView.contentInset;
                insets.top += CGRectGetHeight(searchBar.bounds);
                
                tableView.contentInset = insets;
                tableView.scrollIndicatorInsets = insets;
                
                tableView.contentOffset = CGPointMake(0, 0 - tableView.contentInset.top);
            }
        }
    }
}


@end
