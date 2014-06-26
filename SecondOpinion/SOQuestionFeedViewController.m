//
//  SOQuestionFeedViewController.m
//  SecondOpinion
//
//  Created by Eric Jones on 8/13/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOQuestionFeedViewController.h"
#import "SOQuestionFetcher.h"
#import "SOQuestionModel.h"
#import "SOCreateNewQuestionViewController.h"
#import "SOQuestionFeedView.h"
#import "SOQuestionModel.h"
#import "SOQuestionFeedNoImageTableViewCell.h"
#import "SOStyle.h"
#import "SOAnswerViewProtocol.h"
#import "SOProfileViewController.h"
#import "SOProfileModel.h"
#import "SOFeedFiltersViewController.h"
#import "SOCreateFeedFilterViewController.h"

@interface SOQuestionFeedViewController () <UITableViewDataSource, UITableViewDelegate, SOQuestionFetcherDelegate, SOQuestionFeedViewDelegate, SOCreateNewQuestionViewControllerDelegate, SOQuestionModelDeleteDelegate, SOFeedFiltersViewControllerDelegate, SOCreateFilterFeedViewControllerDelegate>

@property (nonatomic) NSMutableArray *questions;
@property (nonatomic) SOQuestionFetcher *fetcher;
@property (nonatomic) SOProfileModel *profileModel;
@property (nonatomic) UIRefreshControl *refreshController;
@property (nonatomic) int lastFetchedIndex;
@property (nonatomic) SOFeedFiltersViewController *filtersViewController;
@property (nonatomic) SOQuestionFeedView *questionFeedView;
@property (nonatomic) SOFeedFilterModel *currentFilter;

@end

@implementation SOQuestionFeedViewController

- (id)initWithUser:(PFUser *)user
{
    self = [super init];
    if (self) {
        SOQuestionFeedView *view = [[SOQuestionFeedView alloc] initWithFrame:self.view.frame];
        self.questionFeedTableView = view.tableView;
        self.questionFeedTableView.dataSource = self;
        self.questionFeedTableView.delegate = self;
        view.delegate = self;
        self.questionFeedView = view;
        self.filtersViewController = [[SOFeedFiltersViewController alloc] init];
        self.filtersViewController.delegate = self;
//        [view addSubview:self.filtersViewController.view];
//        [view sendSubviewToBack:self.filtersViewController.view];
        [self.view addSubview:self.filtersViewController.view];
        [self.view addSubview:view];
        self.questions = [NSMutableArray array];
        self.fetcher = [[SOQuestionFetcher alloc] init];
        self.fetcher.delegate = self;
        SOFeedFilterModel *allFilter = [[SOFeedFilterModel alloc] init];
        allFilter.categories = @[@"All"];
        self.currentFilter = allFilter;
        [self getQuestions];
        
        UITableViewController *tableViewController = [[UITableViewController alloc] init];
        tableViewController.tableView = self.questionFeedTableView;
        
        UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
        
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
        
        
        
        [refresh addTarget:self action:@selector(refreshQuestions) forControlEvents:UIControlEventValueChanged];
        
        tableViewController.refreshControl = refresh;
        self.refreshController = refresh;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
//    [self getQuestions];
}

-(void)getQuestions {
    [self.fetcher getQuestionsForFilter:self.currentFilter withSkipCount:self.lastFetchedIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshQuestions {
    [self.fetcher getQuestionsForFilter:self.currentFilter withSkipCount:self.lastFetchedIndex];
}

#pragma mark UITableView Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SOQuestionFeedNoImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nonImageCell"];
    
    if (!cell) {
        cell = [[SOQuestionFeedNoImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nonImageCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.question = self.questions[indexPath.row];
    cell.question.deleteDelegate = self;
    if ((indexPath.row == self.questions.count-5) && (self.lastFetchedIndex != self.questions.count)) {
        self.lastFetchedIndex = self.questions.count;
        if (self.currentFilter) {
            [self.fetcher getQuestionsForFilter:self.currentFilter withSkipCount:self.lastFetchedIndex];
        } else {
            [self getQuestions];
        }
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questions.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!((SOQuestionModel *)self.questions[indexPath.row]).answersShouldBeDisplayed && ![self.refreshController isRefreshing]) {
        ((SOQuestionModel *)self.questions[indexPath.row]).answersShouldBeDisplayed = YES;
        [self.questionFeedTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [((SOQuestionModel *)self.questions[indexPath.row]).text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 50, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [SOStyle defaultFontWithSize:16]} context:nil].size.height;
    height += (IMAGE_VIEW_HEIGHT + SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN) * ((SOQuestionModel *)self.questions[indexPath.row]).numberOfImages;
    if (((SOQuestionModel *)self.questions[indexPath.row]).answersShouldBeDisplayed)
    {
        height += BASE_ANSWER_VIEW_HEIGHT + ((SOQuestionModel *)self.questions[indexPath.row]).answers.count * EACH_ADDITIONAL_ANSWER_HEIGHT;
    }
    height += 120; //constant for image view and report button
    return height;
}

#pragma mark SOQuestionFetcher Delegate

-(void)questionsReceived:(NSArray *)questions {
    
    [self.questions addObjectsFromArray:questions];
    [self.questionFeedTableView reloadData];
    [self.refreshController endRefreshing];
}

#pragma mark SOQuestionFeedViewDelegate

- (void)createQuestionButtonTapped {
    SOCreateNewQuestionViewController *viewController = [[SOCreateNewQuestionViewController alloc] init];
    viewController.delegate = self;
    
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:viewController animated:YES completion:nil];
    
    
}

- (void)viewProfileButtonTapped {

    self.profileModel = [[SOProfileModel alloc] init];
    SOProfileViewController *viewController = [[SOProfileViewController alloc] initWithProfileModel:self.profileModel];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)createQuestionWithType:(NSString *)type text:(NSString *)text primaryImage:(UIImage *)primaryImage secondaryImage:(UIImage *)secondaryImage answers:(NSArray *)answers {
    SOQuestionModel *newQuestion = [[SOQuestionModel alloc] initWithTitle:@"no more titles" text:text type:type creator:[PFUser currentUser]];
    
    newQuestion.image = primaryImage;
    newQuestion.image2 = secondaryImage;
    newQuestion.answers = answers;
    
    [newQuestion saveWithFinishedBlock:^(BOOL success) {
        [self getQuestions];
    }];
}

- (void)typeChangedTo:(NSString *)type {
    self.lastFetchedIndex = 0;
    self.questions = [[NSMutableArray alloc] init];
}

- (void)feedFiltersButtonTapped {
    
    CGRect destination = self.questionFeedView.frame;
    
    if (destination.origin.x > 0) {
        destination.origin.x = 0;
    } else {
        destination.origin.x += 254.5;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.questionFeedView.frame = destination;
        
    } completion:^(BOOL finished) {
        
        
    }];
}

#pragma mark SOQuestionModelDeleteDelegate

- (void)deleteQuestion:(SOQuestionModel *)question {
    [self.questions removeObject:question];
    [self.questionFeedTableView reloadData];
}

#pragma mark SOFeedFilterViewControllerDelegte

- (void)newFilterSelected:(SOFeedFilterModel *)filter {
    self.lastFetchedIndex = 0;
    self.questions = [[NSMutableArray alloc] init];
    self.currentFilter = filter;
    [self.fetcher getQuestionsForFilter:filter withSkipCount:self.lastFetchedIndex];
    [self feedFiltersButtonTapped];
}

-(void)addFilterButtonClicked {
    SOCreateFeedFilterViewController *controller = [[SOCreateFeedFilterViewController alloc] init];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:^{
        [self feedFiltersButtonTapped];
    }];
}

#pragma mark SOCreateFilterFeedViewControllerDelegate 

-(void)createFeedFilterWithTitle:(NSString *)title categories:(NSArray *)categories hashtags:(NSArray *)hashtags creators:(NSArray *)creators {
    SOFeedFilterModel *newFilter = [SOFeedFilterModel createFeedFilterWithTitle:title categories:categories hashtags:hashtags creators:creators];
    [self.filtersViewController addFilter:newFilter];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
