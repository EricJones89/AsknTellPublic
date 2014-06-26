//
//  SOCreateFeedFilterViewController.m
//  SecondOpinion
//
//  Created by Eric Jones on 1/27/14.
//  Copyright (c) 2014 Eric Jones. All rights reserved.
//

#import "SOCreateFeedFilterViewController.h"
#import "SOCreateFilterFeedView.h"

@interface SOCreateFeedFilterViewController ()<SOCreateFilterFeedViewDelegate>

@property (nonatomic) SOCreateFilterFeedView *createView;

@end

@implementation SOCreateFeedFilterViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.createView = [[SOCreateFilterFeedView alloc] initWithFrame:self.view.frame];
        self.createView.delegate = self;
        self.view = self.createView;
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

-(void)createFeedFilterWithTitle:(NSString *)title categories:(NSArray *)categories hashtags:(NSArray *)hashtags creators:(NSArray *)creators {
    [self.delegate createFeedFilterWithTitle:title categories:categories hashtags:hashtags creators:creators];
}

- (void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
