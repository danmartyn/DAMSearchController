//
//  ViewController.m
//  SearchController
//
//  Created by Daniel Martyn on 2016-02-09.
//  Copyright © 2016 Daniel Martyn. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "UIViewController+DAMSearchController.h"

static NSString * const kPersonCellIdentifier = @"Person Cell Identifier";
static NSString * const kResultsCellIdentifier = @"Results Person Cell Identifier";



@interface ViewController () <UITableViewDataSource, UITableViewDelegate, DAMSearchControllerDataSource, DAMSearchControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortingSegmentedControl;

@property (strong, nonatomic) NSArray <Person*> *people;
@property (strong, nonatomic) NSArray <Person*> *originalPeopleArray;

@end



@implementation ViewController


#pragma mark -
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.people = ({
        NSMutableArray *mutablePeopleArray = @[].mutableCopy;
        
        for (NSInteger i = 0; i < 200; i++) {
            [mutablePeopleArray addObject:[Person randomPerson]];
        }
        
        self.originalPeopleArray = [mutablePeopleArray copy];
        [mutablePeopleArray copy];
    });
    
    self.searchController.dataSource = self;
    self.searchController.delegate = self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom = CGRectGetHeight(self.toolbar.bounds);
    
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
    
    [self addSearchBar];
}


#pragma mark -
#pragma mark - Action Handlers

- (IBAction)sortingSegmentedControlChanged:(UISegmentedControl *)segmentedControl
{
    switch (segmentedControl.selectedSegmentIndex)
    {
        case 0: // None
            self.people = [self.originalPeopleArray copy];
            break;
            
        case 1: // Name
        {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            self.people = [self.people sortedArrayUsingDescriptors:@[sortDescriptor]];
        }
            break;
            
        case 2: // Age
        {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
            self.people = [self.people sortedArrayUsingDescriptors:@[sortDescriptor]];
        }
            break;
    }
    
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPersonCellIdentifier forIndexPath:indexPath];
    
    Person *person = self.people[indexPath.row];
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld years old", (long)person.age];
    
    return cell;
}


#pragma mark -
#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Person *person = self.people[indexPath.row];
    NSLog(@"Selected Person: %@", person);
}


#pragma mark -
#pragma mark - DAMSearchControllerDataSource Methods

- (NSArray *)allSearchableObjects
{
    return self.people;
}

- (NSPredicate *)predicateForSearchTerm:(NSString *)searchTerm
{
    return [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", @"name", searchTerm];
}

- (UITableViewCell *)resultsTableView:(UITableView *)resultsTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(Person *)person
{
    UITableViewCell *cell = [resultsTableView dequeueReusableCellWithIdentifier:kResultsCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kResultsCellIdentifier];
    }
    
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld years old", (long)person.age];
    
    return cell;
}


#pragma mark -
#pragma mark - DAMSearchControllerDelegate Methods

- (void)registerCellsForResultsTableView:(UITableView *)resultsTableView
{
    // doing nothing, because I just need a subtitle cell
}

- (void)resultsTableView:(UITableView *)resultsTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath object:(Person *)person
{
    [self.searchController endSearch];
    
    NSLog(@"Search Selected: %@", person);
}


@end
