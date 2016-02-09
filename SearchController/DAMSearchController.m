//
//  DAMSearchController.m
//  SearchController
//
//  Created by Daniel Martyn on 2016-02-09.
//  Copyright © 2016 Daniel Martyn. All rights reserved.
//

#import "DAMSearchController.h"



@interface DAMSearchController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIView *statusBarBackgroundView;
@property (strong, nonatomic) UITableView *resultsTableView;
@property (strong, nonatomic) NSLayoutConstraint *statusBarBackgroundViewHeightConstraint;

@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) UITapGestureRecognizer *backgroundTap;
@property (assign, nonatomic) BOOL isActive;

@end



@implementation DAMSearchController


#pragma mark -
#pragma mark - Custom Setter

- (void)setDelegate:(id<DAMSearchControllerDelegate>)delegate
{
    _delegate = delegate;
    [_delegate registerCellsForResultsTableView:self.resultsTableView];
}


#pragma mark -
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar = ({
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.translatesAutoresizingMaskIntoConstraints = NO;
        
        searchBar.delegate = self;
        searchBar.placeholder = @"Search";
        searchBar.translucent = NO;
        searchBar.barTintColor = [UIColor colorWithWhite:0.811 alpha:1.000];
        searchBar.backgroundImage = [UIImage new]; // get rid of the hairlines
        
        searchBar;
    });
    
    self.resultsTableView = ({
        UITableView *tableView = [[UITableView alloc] init];
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        tableView.alpha = 0.0;
        [self.view addSubview:tableView];
        
        NSDictionary *views = @{@"table" : tableView};
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[table]|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table]|" options:0 metrics:nil views:views]];
        
        tableView;
    });
    
    self.statusBarBackgroundView = ({
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        // use the same barTintColor color as the search bar so its seemless
        view.backgroundColor = self.searchBar.barTintColor;
        [self.view addSubview:view];
        
        // put this under the status bar
        NSDictionary *views = @{ @"view" : view };
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil views:views]];
        self.statusBarBackgroundViewHeightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:nil
                                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                                   multiplier:1.0
                                                                                     constant:[self statusBarHeight]];
        [self.view addConstraint:self.statusBarBackgroundViewHeightConstraint];
        
        view;
    });
    
    self.backgroundTap = ({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundTap:)];
        [self.view addGestureRecognizer:tap];
        
        tap;
    });
    
    self.view.alpha = 0.0;
    self.view.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
    self.results = @[];
    self.isActive = NO;
    
    // whenever the status bar height is changed, lets update our background view height constraint
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillChangeStatusBarFrameNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      self.statusBarBackgroundViewHeightConstraint.constant = [self statusBarHeight];
                                                  }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // results table view should take the height of the search bar into consideration so the top row isn't obstructed
    UIEdgeInsets insets = self.resultsTableView.contentInset;
    insets.top = [self statusBarHeight] + CGRectGetHeight(self.searchBar.bounds);
    self.resultsTableView.contentInset = insets;
    self.resultsTableView.scrollIndicatorInsets = insets;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    /**
     *  update the background view height constraint on rotation as well, this is needed because the notification added above
     *  returns the wrong height for the status bar for rotation, but does return the correct height for the in-call status
     */
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.statusBarBackgroundViewHeightConstraint.constant = [self statusBarHeight];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.isActive ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}


#pragma mark -
#pragma mark - Private Helpers

- (void)handleBackgroundTap:(UITapGestureRecognizer *)tap
{
    [self endSearch];
}

- (CGFloat)statusBarHeight
{
    CGRect statusBarFrame = [self.view convertRect:[UIApplication sharedApplication].statusBarFrame fromView:self.view.window];
    CGFloat height = CGRectGetHeight(statusBarFrame);
    
    return height;
}


#pragma mark -
#pragma mark - Search Helper Methods

- (void)startSearch
{
    self.isActive = YES;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    self.resultsTableView.alpha = 0.0;
    self.backgroundTap.enabled = YES;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.view.alpha = 1.0;
                     }];
}

- (void)endSearch
{
    self.isActive = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    [self.searchBar resignFirstResponder];
    self.searchBar.text = nil;
    self.backgroundTap.enabled = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 0.0;
        self.resultsTableView.alpha = 0.0;
    }];
}

- (void)refreshResultsForSearchString:(NSString *)searchString
{
    NSArray *components = [searchString componentsSeparatedByString:@" "];
    NSMutableArray *subPredicates = @[].mutableCopy;
    
    for (NSString *searchTerm in components) {
        [subPredicates addObject:[self.dataSource predicateForSearchTerm:searchTerm]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[subPredicates copy]];
    self.results = [[self.dataSource allSearchableObjects] filteredArrayUsingPredicate:predicate];
    [self.resultsTableView reloadData];
}


#pragma mark -
#pragma mark - UISearchBarDelegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self startSearch];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self endSearch];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self refreshResultsForSearchString:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self refreshResultsForSearchString:searchText];
    
    BOOL shouldShowResultsTable = ([searchText length] > 0);
    self.resultsTableView.alpha = shouldShowResultsTable ? 1.0 : 0.0;
    self.backgroundTap.enabled = (shouldShowResultsTable == NO);
}


#pragma mark -
#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource resultsTableView:tableView cellForRowAtIndexPath:indexPath object:self.results[indexPath.row]];
}


#pragma mark -
#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate resultsTableView:tableView didSelectRowAtIndexPath:indexPath object:self.results[indexPath.row]];
}


@end
