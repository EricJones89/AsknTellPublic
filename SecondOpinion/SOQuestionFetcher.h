//
//  SOQuestionFetcher.h
//  SecondOpinion
//
//  Created by Eric Jones on 8/13/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOFeedFilterModel.h"

@protocol SOQuestionFetcherDelegate <NSObject>

-(void)questionsReceived:(NSArray *)questions;

@end

@interface SOQuestionFetcher : NSObject

@property (nonatomic, weak) id<SOQuestionFetcherDelegate> delegate;

- (void)getAllQuestionWithMostRecentFirst;
- (void)getAllQuestionsForUser:(PFUser *)user;
- (void)getQuestionsForFilter:(SOFeedFilterModel *)filter withSkipCount:(int)skipCount;

@end
