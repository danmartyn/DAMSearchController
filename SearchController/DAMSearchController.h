//
//  DAMSearchController.h
//  SearchController
//
//  Created by Daniel Martyn on 2016-02-09.
//  Copyright © 2016 Daniel Martyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DAMSearchControllerDataSource;
@protocol DAMSearchControllerDelegate;



@interface DAMSearchController : UIViewController


@property (strong, nonatomic) UISearchBar *searchBar;

@property (weak, nonatomic) id<DAMSearchControllerDataSource> dataSource;
@property (weak, nonatomic) id<DAMSearchControllerDelegate> delegate;


- (void)startSearch;
- (void)endSearch;


@end



@protocol DAMSearchControllerDataSource <NSObject>

@required;
- (NSArray *)allSearchableObjects;
- (NSPredicate *)predicateForSearchTerm:(NSString *)searchTerm;
- (UITableViewCell *)resultsTableView:(UITableView *)resultsTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object;

@end



@protocol DAMSearchControllerDelegate <NSObject>

@required
- (void)registerCellsForResultsTableView:(UITableView *)resultsTableView;
- (void)resultsTableView:(UITableView *)resultsTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object;

@end
