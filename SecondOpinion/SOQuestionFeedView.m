//
//  SOQuestionFeedView.m
//  SecondOpinion
//
//  Created by Eric Jones on 9/9/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOQuestionFeedView.h"
#import "SOStyle.h"
#import "SOQuestionModel.h"

#define HEADER_MARGIN 55
#define HORIZONTAL_MARGIN 10
#define CREATE_QUESTION_BUTTON_WIDTH 100
#define BOUNCE_HEIGHT 10
#define TYPE_BUTTON_HEIGHT 25
#define TYPE_BUTTON_WIDTH 35

@interface SOQuestionFeedView ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIButton *createQuestionButton;
@property (nonatomic) UIButton *viewProfileButton;
@property (nonatomic) UIView *titleBar;
@property (nonatomic) UIButton *showFiltersButton;
@property (nonatomic) BOOL questionTypeButtonsAreAnimated;
@property (nonatomic) int selectedIndex;
@property (nonatomic) NSMutableArray *typeNames;


@end

@implementation SOQuestionFeedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configuretitleBar];
        [self configureTableView];
        [self configureTitleLabel];
        [self configureViewProfileButton];
        [self configureQuestionTypeButtons];
        self.selectedIndex = 0;
        [self setUserInteractionEnabled:YES];
        self.backgroundColor = [SOStyle backgroundColor];
    }
    return self;
}

- (void)configureQuestionTypeButtons {
    
    self.typeNames = [[NSMutableArray alloc] init];
    
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.contentMode = UIViewContentModeScaleAspectFit;
        [button setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(questionTypeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        self.showFiltersButton = button;
        [self addSubview:button];
    
}


- (void)configureTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView = tableView;
    [self addSubview:tableView];
}

- (void)configureTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Ask A Question";
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectZero;
    label.textColor = [UIColor blackColor];
    label.font = [SOStyle defaultFontWithSize:20];
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createQuestionButtonTapped:)]];
    
    self.titleLabel = label;
    [self addSubview:label];
}

- (void)configureViewProfileButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"profileIcon.png"] forState:UIControlStateNormal];
    button.frame = CGRectZero;
    [button addTarget:self action:@selector(viewProfileButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.viewProfileButton = button;
    [self addSubview:button];
}

- (void)configuretitleBar {
    UIView *titleBar = [[UIView alloc] initWithFrame:CGRectZero];
    titleBar.backgroundColor = [SOStyle headerColor];
    
    self.titleBar = titleBar;
    [self addSubview:titleBar];
}

-(void)layoutSubviews {
    [self layoutTableView];
    [self layoutTitleLabel];
    [self layoutViewProfileButton];
    [self layoutTitleBar];
    [self layoutTypeButtons];
}

- (void)layoutTableView {
    self.tableView.frame = CGRectMake(HORIZONTAL_MARGIN, HEADER_MARGIN, self.frame.size.width - 2 * HORIZONTAL_MARGIN, self.frame.size.height - HORIZONTAL_MARGIN - HEADER_MARGIN);
}

- (void)layoutTitleLabel {
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.center.x, HEADER_MARGIN/2+10);
}

- (void)layoutViewProfileButton {
    self.viewProfileButton.frame = CGRectMake(0, 0, HEADER_MARGIN - 2 *HORIZONTAL_MARGIN, HEADER_MARGIN - 2 *HORIZONTAL_MARGIN);
    self.viewProfileButton.center = CGPointMake(self.frame.size.width - self.viewProfileButton.frame.size.width/2 - HORIZONTAL_MARGIN, HEADER_MARGIN/2+10);
}

- (void)layoutTitleBar {
    self.titleBar.frame = CGRectMake(0, 0, self.frame.size.width, HEADER_MARGIN);
}

- (void)layoutTypeButtons {
    

        CGFloat buttonHeight = HEADER_MARGIN - TYPE_BUTTON_HEIGHT - 7;
        self.showFiltersButton.frame = CGRectMake(HORIZONTAL_MARGIN, buttonHeight, TYPE_BUTTON_WIDTH, TYPE_BUTTON_HEIGHT);
}

- (void)createQuestionButtonTapped:(UITapGestureRecognizer *)recognizer {
    [self.delegate createQuestionButtonTapped];
}

- (void)viewProfileButtonTapped {
    [self.delegate viewProfileButtonTapped];
}

-(NSString *)getQuestionType {
    return self.typeNames[0];
}

#pragma mark dropDownTypeButtons

- (void)questionTypeButtonTapped:(id)sender {
    [self.delegate feedFiltersButtonTapped];
}

@end
