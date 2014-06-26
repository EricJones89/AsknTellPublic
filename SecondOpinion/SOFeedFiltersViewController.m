//
//  SOFeedFiltersViewController.m
//  SecondOpinion
//
//  Created by Eric Jones on 1/18/14.
//  Copyright (c) 2014 Eric Jones. All rights reserved.
//

#import "SOFeedFiltersViewController.h"
#import "SOFeedFilterView.h"
#import "SOFeedFiltersFetcher.h"
#import "SOStyle.h"

@interface SOFeedFiltersViewController () <UITableViewDataSource, UITableViewDelegate, SOFeedFilterFetchDelegate, SOFeedFilterViewDelegate>

@property (nonatomic) UITableView *tableview;
@property (nonatomic) SOFeedFilterView *feedFilterView;
@property (nonatomic) NSMutableArray *filters;
@property (nonatomic) SOFeedFiltersFetcher *fetcher;

@end

@implementation SOFeedFiltersViewController

- (id)init {
    self = [super init];
    if (self) {
        CGRect frame = CGRectMake(0, 0, 253.5, self.view.frame.size.height);
        self.feedFilterView = [[SOFeedFilterView alloc] initWithFrame:frame];
        self.feedFilterView.delegate = self;
        self.tableview = self.feedFilterView.tableView;
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        self.view = self.feedFilterView;
        
        self.filters = [[NSMutableArray alloc] init];
        
        SOFeedFiltersFetcher *fetcher = [[SOFeedFiltersFetcher alloc] init];
        self.fetcher = fetcher;
        self.fetcher.delegate = self;
        [self.fetcher fetchFiltersForLoggedInUser];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"default"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1)];
        [seperator setBackgroundColor:[UIColor blackColor]];
        [cell addSubview:seperator];
    }
    
    cell.textLabel.text = ((SOFeedFilterModel *)self.filters[indexPath.row]).title;
    cell.backgroundColor = [SOStyle headerColor];
    cell.textLabel.font = [SOStyle defaultFontWithSize:16];
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate newFilterSelected:self.filters[indexPath.row]];
}

- (void)addFilter:(SOFeedFilterModel *)filter {
    [self.filters addObject:filter];
    [self.tableview reloadData];
}

#pragma mark SOFeedFilterFetcherDelegate

-(void)filtersFetched:(NSArray *)filters {
    self.filters = filters.mutableCopy;
    [self.tableview reloadData];
}

#pragma mark SOFeedFilterViewDelegate

-(void)addButtonClicked {
    [self.delegate addFilterButtonClicked];
}

@end
