//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpBusiness.h"
#import "BusinessCell.h"
#import "FiltersViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate>
    @property (strong, nonatomic) IBOutlet UITableView *tableView;
    @property (strong, nonatomic) NSArray *businesses;
    @property UISearchBar *searchBar;
    @property (nonatomic, strong) NSString *query_term;

    @property int selectedSort;
    @property int selectedDistance;
    @property bool deal_on;
    @property NSMutableSet *categoriesSet;

    - (void)fetchBusinessesWithQuery:(NSString *) query filters:(NSDictionary *) filters;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.query_term = @"Restaurants";
    [self fetchBusinessesWithQuery:self.query_term filters:nil];

    // set up table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];

    // set up navigation controller
    self.title = @"Yelp";

    // set up filter
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];

    // set up table view cell row-height
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    // set up search bar in navigation view
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar sizeToFit];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;

    // set up default values
    self.selectedDistance = 0;
    self.selectedSort = 0;
    self.deal_on = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


// ------------------------ tableView ------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}


// ------------------------ searchBar ------------------------
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
    [searchBar setShowsCancelButton:NO animated:YES];

    self.query_term = self.searchBar.text;
    [self fetchBusinessesWithQuery:self.query_term filters:nil];
}



# pragma mark - Filter Delegate methods

- (void)filtersViewController:(FiltersViewController *) filtersViewController didChangeFilters:(NSDictionary *)filters {
    // fire a new network event
    [self fetchBusinessesWithQuery:self.query_term filters:filters];
}


# pragma mark - private methods

- (void)onFilterButton {
    FiltersViewController *vc = [[FiltersViewController alloc] init];
    vc.delegate = self;
    vc.selectedSort = self.selectedSort;
    vc.selectedDistance = self.selectedDistance;
    vc.deal_on = self.deal_on;
    vc.selectedCategories = self.categoriesSet;

    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)fetchBusinessesWithQuery:(NSString *) query filters:(NSDictionary *) filters {
    NSString *deal = filters[@"deals_filter"][0];
    if ([deal  isEqual: @"on"]) {
        self.deal_on = true;
    } else {
        self.deal_on = false;
    }

    NSArray *categories = filters[@"category_filter"];
    self.categoriesSet = [NSMutableSet setWithArray:categories];

    NSString *sortMode = filters[@"sort_filter"][0];
    YelpSortMode sort;
    if ([sortMode  isEqual: @"distance"]) {
        sort = YelpSortModeDistance;
        self.selectedSort = 1;
    } else if ([sortMode  isEqual: @"highest rated"]) {
        sort = YelpSortModeHighestRated;
        self.selectedSort = 2;
    } else {
        sort = YelpSortModeBestMatched;
        self.selectedSort = 0;
    }

//@"Auto", @"0.3 mile", @"1 mile", @"5 mile", @"20 mile"
    NSString *dis = filters[@"distance_filter"][0];
    int dist;
    if ([dis  isEqual: @"Auto"]) {
        dist = 0;
        self.selectedDistance = 0;
    } else if ([dis  isEqual: @"0.3 mile"]) {
        dist = 0.3;
        self.selectedDistance = 1;
    } else if ([dis  isEqual: @"1 mile"]) {
        dist = 1;
        self.selectedDistance = 2;
    } else if ([dis  isEqual: @"5 mile"]) {
        dist = 5;
        self.selectedDistance = 3;
    } else {
        dist = 20;
        self.selectedDistance = 4;
    }

    [YelpBusiness searchWithTerm:query
                        sortMode:sort
                      categories:categories
                           deals:self.deal_on
                      completion:^(NSArray *businesses, NSError *error) {
                          self.businesses = businesses;

                          [self.tableView reloadData];
                      }];
}


@end
