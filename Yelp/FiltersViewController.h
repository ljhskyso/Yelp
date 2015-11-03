//
//  FiltersViewController.h
//  Yelp
//
//  Created by Jiheng Lu on 11/1/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>

- (void)filtersViewController:(FiltersViewController *) filtersViewController didChangeFilters:(NSDictionary *)filters;


@end

@interface FiltersViewController : UIViewController

@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;
@property bool deal_on;
@property int selectedSort;
@property int selectedDistance;
@property (nonatomic, strong) NSMutableSet *selectedCategories;

@end
