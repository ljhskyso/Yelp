//
//  FiltersViewController.m
//  Yelp
//
//  Created by Jiheng Lu on 11/1/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"
#import "SelectionCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>

    @property (nonatomic, readonly) NSDictionary *filters;
    @property (weak, nonatomic) IBOutlet UITableView *tableView;
    @property (nonatomic, strong) NSArray *categories;
    @property (nonatomic, strong) NSArray *sections;
    @property (nonatomic, strong) NSArray *sorts;
    @property (nonatomic, strong) NSArray *distances;



    - (void)initCategories;

@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        self.selectedCategories = [NSMutableSet set];
        [self initCategories];
        [self initSections];
        [self initSelections];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    self.navigationItem.title = @"Filter";

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectionCell" bundle:nil] forCellReuseIdentifier:@"SelectionCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 ) {
        return 1;
    } else if (section == 1) {
        return self.sorts.count;
    } else if (section == 2) {
        return self.distances.count;
    } else {
        // category
        return self.categories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==  0) {
        // deal
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.titleLabel.text = @"Offering a Deal";
        cell.on = self.deal_on;

        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 1) {
        // sort
        SelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        cell.textLabel.text = self.sorts[indexPath.row];

        if (indexPath.row == self.selectedSort) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }

        return cell;
    } else if (indexPath.section == 2) {
        // distance
        SelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        cell.textLabel.text = self.distances[indexPath.row];

        if (indexPath.row == self.selectedDistance) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }

        return cell;
    } else {
        // category
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.titleLabel.text = self.categories[indexPath.row][@"name"];
        cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];

        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 1) {
        [self uncheckRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedSort inSection:indexPath.section]];
        self.selectedSort = (int) indexPath.row;
        [self checkRowAtIndexPath:indexPath];
    } else if (indexPath.section == 2) {
        [self uncheckRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedDistance inSection:indexPath.section]];
        self.selectedDistance = (int) indexPath.row;
        [self checkRowAtIndexPath:indexPath];
    }
}

- (void)checkRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)uncheckRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark - Switch Cell delegate methods

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    if (indexPath.section == 3) {
        if (value) {
            [self.selectedCategories addObject:self.categories[indexPath.row]];
        } else {
            [self.selectedCategories removeObject:self.categories[indexPath.row]];
        }
    } else {
        if (value) {
            self.deal_on = true;
            NSLog(@"true");
        } else {
            self.deal_on = false;
            NSLog(@"false");
        }
    }
}

#pragma mark - Private methods

- (NSDictionary *)filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];

    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
        }
        [filters setObject:names forKey:@"category_filter"];
    }
    NSMutableArray *deals = [NSMutableArray array];
    if (self.deal_on) {
        [deals addObject:@"on"];
        NSLog(@"true");
    } else {
        [deals addObject:@"off"];
        NSLog(@"false");
    }
    [filters setObject:deals forKey:@"deals_filter"];

    NSMutableArray *sort = [NSMutableArray array];
    [sort addObject:self.sorts[self.selectedSort]];
    [filters setObject:sort forKey:@"sort_filter"];

    NSMutableArray *dis = [NSMutableArray array];
    [dis addObject:self.distances[self.selectedDistance]];
    [filters setObject:dis forKey:@"distance_filter"];

    return filters;
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onApplyButton {
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
 }

// ------------------------ initData ------------------------
- (void)initCategories {
    self.categories =
    @[@{@"name": @"Afghan", @"code": @"afghani"},
      @{@"name": @"African", @"code": @"african"},
      @{@"name": @"American, New", @"code": @"newamerican"},
      @{@"name": @"American, Traditional", @"code": @"tradamerican"},
      @{@"name": @"Arabian", @"code": @"arabian"},
      @{@"name": @"Argentine", @"code": @"argentine"},
      @{@"name": @"Armenian", @"code": @"armenian"},
      @{@"name": @"Asian Fusion", @"code": @"asianfusion"},
      @{@"name": @"Asturian", @"code": @"asturian"},
      @{@"name": @"Australian", @"code": @"australian"},
      @{@"name": @"Austrian", @"code": @"austrian"},
      @{@"name": @"Baguettes", @"code": @"baguettes"},
      @{@"name": @"Bangladeshi", @"code": @"bangladeshi"},
      @{@"name": @"Barbeque", @"code": @"bbq"},
      @{@"name": @"Basque", @"code": @"basque"},
      @{@"name": @"Bavarian", @"code": @"bavarian"},
      @{@"name": @"Beer Garden", @"code": @"beergarden"},
      @{@"name": @"Beer Hall", @"code": @"beerhall"},
      @{@"name": @"Beisl", @"code": @"beisl"},
      @{@"name": @"Belgian", @"code": @"belgian"},
      @{@"name": @"Bistros", @"code": @"bistros"},
      @{@"name": @"Black Sea", @"code": @"blacksea"},
      @{@"name": @"Brasseries", @"code": @"brasseries"},
      @{@"name": @"Brazilian", @"code": @"brazilian"},
      @{@"name": @"Breakfast & Brunch", @"code": @"breakfast_brunch"},
      @{@"name": @"British", @"code": @"british"},
      @{@"name": @"Buffets", @"code": @"buffets"},
      @{@"name": @"Bulgarian", @"code": @"bulgarian"},
      @{@"name": @"Burgers", @"code": @"burgers"},
      @{@"name": @"Burmese", @"code": @"burmese"},
      @{@"name": @"Cafes", @"code": @"cafes"},
      @{@"name": @"Cafeteria", @"code": @"cafeteria"},
      @{@"name": @"Cajun/Creole", @"code": @"cajun"},
      @{@"name": @"Cambodian", @"code": @"cambodian"},
      @{@"name": @"Canadian", @"code": @"New)"},
      @{@"name": @"Canteen", @"code": @"canteen"},
      @{@"name": @"Caribbean", @"code": @"caribbean"},
      @{@"name": @"Catalan", @"code": @"catalan"},
      @{@"name": @"Chech", @"code": @"chech"},
      @{@"name": @"Cheesesteaks", @"code": @"cheesesteaks"},
      @{@"name": @"Chicken Shop", @"code": @"chickenshop"},
      @{@"name": @"Chicken Wings", @"code": @"chicken_wings"},
      @{@"name": @"Chilean", @"code": @"chilean"},
      @{@"name": @"Chinese", @"code": @"chinese"},
      @{@"name": @"Comfort Food", @"code": @"comfortfood"},
      @{@"name": @"Corsican", @"code": @"corsican"},
      @{@"name": @"Creperies", @"code": @"creperies"},
      @{@"name": @"Cuban", @"code": @"cuban"},
      @{@"name": @"Curry Sausage", @"code": @"currysausage"},
      @{@"name": @"Cypriot", @"code": @"cypriot"},
      @{@"name": @"Czech", @"code": @"czech"},
      @{@"name": @"Czech/Slovakian", @"code": @"czechslovakian"},
      @{@"name": @"Danish", @"code": @"danish"},
      @{@"name": @"Delis", @"code": @"delis"},
      @{@"name": @"Diners", @"code": @"diners"},
      @{@"name": @"Dumplings", @"code": @"dumplings"},
      @{@"name": @"Eastern European", @"code": @"eastern_european"},
      @{@"name": @"Ethiopian", @"code": @"ethiopian"},
      @{@"name": @"Fast Food", @"code": @"hotdogs"},
      @{@"name": @"Filipino", @"code": @"filipino"},
      @{@"name": @"Fish & Chips", @"code": @"fishnchips"},
      @{@"name": @"Fondue", @"code": @"fondue"},
      @{@"name": @"Food Court", @"code": @"food_court"},
      @{@"name": @"Food Stands", @"code": @"foodstands"},
      @{@"name": @"French", @"code": @"french"},
      @{@"name": @"French Southwest", @"code": @"sud_ouest"},
      @{@"name": @"Galician", @"code": @"galician"},
      @{@"name": @"Gastropubs", @"code": @"gastropubs"},
      @{@"name": @"Georgian", @"code": @"georgian"},
      @{@"name": @"German", @"code": @"german"},
      @{@"name": @"Giblets", @"code": @"giblets"},
      @{@"name": @"Gluten-Free", @"code": @"gluten_free"},
      @{@"name": @"Greek", @"code": @"greek"},
      @{@"name": @"Halal", @"code": @"halal"},
      @{@"name": @"Hawaiian", @"code": @"hawaiian"},
      @{@"name": @"Heuriger", @"code": @"heuriger"},
      @{@"name": @"Himalayan/Nepalese", @"code": @"himalayan"},
      @{@"name": @"Hong Kong Style Cafe", @"code": @"hkcafe"},
      @{@"name": @"Hot Dogs", @"code": @"hotdog"},
      @{@"name": @"Hot Pot", @"code": @"hotpot"},
      @{@"name": @"Hungarian", @"code": @"hungarian"},
      @{@"name": @"Iberian", @"code": @"iberian"},
      @{@"name": @"Indian", @"code": @"indpak"},
      @{@"name": @"Indonesian", @"code": @"indonesian"},
      @{@"name": @"International", @"code": @"international"},
      @{@"name": @"Irish", @"code": @"irish"},
      @{@"name": @"Island Pub", @"code": @"island_pub"},
      @{@"name": @"Israeli", @"code": @"israeli"},
      @{@"name": @"Italian", @"code": @"italian"},
      @{@"name": @"Japanese", @"code": @"japanese"},
      @{@"name": @"Jewish", @"code": @"jewish"},
      @{@"name": @"Kebab", @"code": @"kebab"},
      @{@"name": @"Korean", @"code": @"korean"},
      @{@"name": @"Kosher", @"code": @"kosher"},
      @{@"name": @"Kurdish", @"code": @"kurdish"},
      @{@"name": @"Laos", @"code": @"laos"},
      @{@"name": @"Laotian", @"code": @"laotian"},
      @{@"name": @"Latin American", @"code": @"latin"},
      @{@"name": @"Live/Raw Food", @"code": @"raw_food"},
      @{@"name": @"Lyonnais", @"code": @"lyonnais"},
      @{@"name": @"Malaysian", @"code": @"malaysian"},
      @{@"name": @"Meatballs", @"code": @"meatballs"},
      @{@"name": @"Mediterranean", @"code": @"mediterranean"},
      @{@"name": @"Mexican", @"code": @"mexican"},
      @{@"name": @"Middle Eastern", @"code": @"mideastern"},
      @{@"name": @"Milk Bars", @"code": @"milkbars"},
      @{@"name": @"Modern Australian", @"code": @"modern_australian"},
      @{@"name": @"Modern European", @"code": @"modern_european"},
      @{@"name": @"Mongolian", @"code": @"mongolian"},
      @{@"name": @"Moroccan", @"code": @"moroccan"},
      @{@"name": @"New Zealand", @"code": @"newzealand"},
      @{@"name": @"Night Food", @"code": @"nightfood"},
      @{@"name": @"Norcinerie", @"code": @"norcinerie"},
      @{@"name": @"Open Sandwiches", @"code": @"opensandwiches"},
      @{@"name": @"Oriental", @"code": @"oriental"},
      @{@"name": @"Pakistani", @"code": @"pakistani"},
      @{@"name": @"Parent Cafes", @"code": @"eltern_cafes"},
      @{@"name": @"Parma", @"code": @"parma"},
      @{@"name": @"Persian/Iranian", @"code": @"persian"},
      @{@"name": @"Peruvian", @"code": @"peruvian"},
      @{@"name": @"Pita", @"code": @"pita"},
      @{@"name": @"Pizza", @"code": @"pizza"},
      @{@"name": @"Polish", @"code": @"polish"},
      @{@"name": @"Portuguese", @"code": @"portuguese"},
      @{@"name": @"Potatoes", @"code": @"potatoes"},
      @{@"name": @"Poutineries", @"code": @"poutineries"},
      @{@"name": @"Pub Food", @"code": @"pubfood"},
      @{@"name": @"Rice", @"code": @"riceshop"},
      @{@"name": @"Romanian", @"code": @"romanian"},
      @{@"name": @"Rotisserie Chicken", @"code": @"rotisserie_chicken"},
      @{@"name": @"Rumanian", @"code": @"rumanian"},
      @{@"name": @"Russian", @"code": @"russian"},
      @{@"name": @"Salad", @"code": @"salad"},
      @{@"name": @"Sandwiches", @"code": @"sandwiches"},
      @{@"name": @"Scandinavian", @"code": @"scandinavian"},
      @{@"name": @"Scottish", @"code": @"scottish"},
      @{@"name": @"Seafood", @"code": @"seafood"},
      @{@"name": @"Serbo Croatian", @"code": @"serbocroatian"},
      @{@"name": @"Signature Cuisine", @"code": @"signature_cuisine"},
      @{@"name": @"Singaporean", @"code": @"singaporean"},
      @{@"name": @"Slovakian", @"code": @"slovakian"},
      @{@"name": @"Soul Food", @"code": @"soulfood"},
      @{@"name": @"Soup", @"code": @"soup"},
      @{@"name": @"Southern", @"code": @"southern"},
      @{@"name": @"Spanish", @"code": @"spanish"},
      @{@"name": @"Steakhouses", @"code": @"steak"},
      @{@"name": @"Sushi Bars", @"code": @"sushi"},
      @{@"name": @"Swabian", @"code": @"swabian"},
      @{@"name": @"Swedish", @"code": @"swedish"},
      @{@"name": @"Swiss Food", @"code": @"swissfood"},
      @{@"name": @"Tabernas", @"code": @"tabernas"},
      @{@"name": @"Taiwanese", @"code": @"taiwanese"},
      @{@"name": @"Tapas Bars", @"code": @"tapas"},
      @{@"name": @"Tapas/Small Plates", @"code": @"tapasmallplates"},
      @{@"name": @"Tex-Mex", @"code": @"tex-mex"},
      @{@"name": @"Thai", @"code": @"thai"},
      @{@"name": @"Traditional Norwegian", @"code": @"norwegian"},
      @{@"name": @"Traditional Swedish", @"code": @"traditional_swedish"},
      @{@"name": @"Trattorie", @"code": @"trattorie"},
      @{@"name": @"Turkish", @"code": @"turkish"},
      @{@"name": @"Ukrainian", @"code": @"ukrainian"},
      @{@"name": @"Uzbek", @"code": @"uzbek"},
      @{@"name": @"Vegan", @"code": @"vegan"},
      @{@"name": @"Vegetarian", @"code": @"vegetarian"},
      @{@"name": @"Venison", @"code": @"venison"},
      @{@"name": @"Vietnamese", @"code": @"vietnamese"},
      @{@"name": @"Wok", @"code": @"wok"},
      @{@"name": @"Wraps", @"code": @"wraps"},
      @{@"name": @"Yugoslav", @"code": @"yugoslav"}];
}

- (void)initSections {
    self.sections = @[@"deals", @"sort", @"distance", @"category"];
}

- (void)initSelections {
    self.sorts = @[@"best match", @"distance", @"highest rated"];
    self.distances = @[@"Auto", @"0.3 mile", @"1 mile", @"5 mile", @"20 mile"];
}

@end
