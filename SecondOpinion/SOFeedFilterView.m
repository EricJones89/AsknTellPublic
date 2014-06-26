//
//  SOFeedFilterView.m
//  SecondOpinion
//
//  Created by Eric Jones on 1/18/14.
//  Copyright (c) 2014 Eric Jones. All rights reserved.
//

#import "SOFeedFilterView.h"
#import "SOStyle.h"

#define HEADER_MARGIN 55
#define HORIZONTAL_MARGIN 10


@interface SOFeedFilterView ()

@property (nonatomic) UIView *titleBar;
@property (nonatomic) UIView *separator;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIButton *addFeedFilterButton;

@end

@implementation SOFeedFilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [SOStyle headerColor];
        
        [self configuretitleBar];
        [self configureTableView];
        [self configureTitleLabel];
        [self configureAddFeedFilterButton];

        
    }
    return self;
}

- (void)configuretitleBar {
    UIView *titleBar = [[UIView alloc] initWithFrame:CGRectZero];
    titleBar.backgroundColor = [SOStyle headerColor];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectZero];
    [seperator setBackgroundColor:[UIColor blackColor]];
    self.separator = seperator;
    [titleBar addSubview:seperator];
    self.titleBar = titleBar;
    [self addSubview:titleBar];
}

- (void)configureTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [SOStyle headerColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView = tableView;
    [self addSubview:tableView];
}

- (void)configureTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Feed Filters";
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectZero;
    label.textColor = [UIColor blackColor];
    label.font = [SOStyle defaultFontWithSize:20];
    
    self.titleLabel = label;
    [self addSubview:label];
}

- (void)configureAddFeedFilterButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectZero;
    button.tintColor = [UIColor blackColor];
    [button addTarget:self action:@selector(addFeedFilterButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.addFeedFilterButton = button;
    [self addSubview:button];
}

-(void)layoutSubviews {
    [self layoutTitleBar];
    [self layoutTableView];
    [self layoutTitleLabel];
    [self layoutAddButton];
}

- (void)layoutAddButton {
    self.addFeedFilterButton.frame = CGRectMake(HORIZONTAL_MARGIN, HEADER_MARGIN/2-2, 25, 25);
}

- (void)layoutTableView {
    self.tableView.frame = CGRectMake(0, HEADER_MARGIN, self.frame.size.width, self.frame.size.height - HEADER_MARGIN);
}

- (void)layoutTitleLabel {
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.center.x, HEADER_MARGIN/2+10);
}

- (void)layoutTitleBar {
    self.titleBar.frame = CGRectMake(0, 0, self.frame.size.width, HEADER_MARGIN);
    self.separator.frame = CGRectMake(0, self.titleBar.frame.size.height-1, self.titleBar.frame.size.width, 1);
}

- (void)layoutAddFeedFilterButton {
    self.addFeedFilterButton.frame = CGRectMake(0, 0, HEADER_MARGIN - 2 *HORIZONTAL_MARGIN, HEADER_MARGIN - 2 *HORIZONTAL_MARGIN);
    self.addFeedFilterButton.center = CGPointMake(self.addFeedFilterButton.frame.size.width/2 + HORIZONTAL_MARGIN, HEADER_MARGIN/2+10);
}

- (void)addFeedFilterButtonTapped {
    [self.delegate addButtonClicked];
}


@end
