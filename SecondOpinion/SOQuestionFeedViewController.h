//
//  SOQuestionFeedViewController.h
//  SecondOpinion
//
//  Created by Eric Jones on 8/13/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOQuestionFeedViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *questionFeedTableView;
@property (strong, nonatomic) IBOutlet UIButton *createButton;

- (id)initWithUser:(PFUser *)user;

@end
