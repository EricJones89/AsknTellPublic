//
//  SOQuestionFeedView.h
//  SecondOpinion
//
//  Created by Eric Jones on 9/9/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SOQuestionFeedViewDelegate <NSObject>

- (void)createQuestionButtonTapped;
- (void)viewProfileButtonTapped;
- (void)typeChangedTo:(NSString *)type;
- (void)feedFiltersButtonTapped;

@end

@interface SOQuestionFeedView : UIView

@property (nonatomic) UITableView *tableView;
@property (nonatomic, weak) id<SOQuestionFeedViewDelegate> delegate;

-(NSString *)getQuestionType;

@end
