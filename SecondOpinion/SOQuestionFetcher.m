//
//  SOQuestionFetcher.m
//  SecondOpinion
//
//  Created by Eric Jones on 8/13/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOQuestionFetcher.h"
#import "SOQuestionModel.h"

@implementation SOQuestionFetcher

-(void)getAllQuestionWithMostRecentFirst {
    PFQuery *bannedUsers = [PFUser query];
    [bannedUsers whereKey:@"reported" equalTo:[NSNumber numberWithBool:YES]];
    PFQuery *query = [PFQuery queryWithClassName:@"Question"];
    [query addDescendingOrder:@"createdAt"];
    [query whereKey:@"creator" notEqualTo:[PFUser currentUser]];
    [query whereKey:@"creator" doesNotMatchQuery:bannedUsers];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self convertFetchedObjectsToQuestions:objects];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)getAllQuestionsForUser:(PFUser *)user {
    PFQuery *query = [PFQuery queryWithClassName:@"Question"];
    [query whereKey:@"creator" equalTo:user];
    [query addDescendingOrder:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self convertFetchedObjectsToQuestions:objects];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)getQuestionsForFilter:(SOFeedFilterModel *)filter withSkipCount:(int)skipCount {
    
    PFQuery *creatorsQuery = [PFQuery queryWithClassName:@"Question"];
    PFQuery *hashtagsQuery = [PFQuery queryWithClassName:@"Question"];
    PFQuery *typeQuery = [PFQuery queryWithClassName:@"Question"];
    
    if (filter.creators) {
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"username" containedIn:filter.creators];
        [creatorsQuery whereKey:@"creator" matchesQuery:userQuery];
    }
    if (filter.hashTags) {
        [hashtagsQuery whereKey:@"hashtags" containedIn:filter.hashTags];
    }
    if (filter.creators) {
        [typeQuery whereKey:@"type" containedIn:filter.categories];
    }
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[creatorsQuery, hashtagsQuery, typeQuery]];
    [query addDescendingOrder:@"createdAt"];
    [query whereKey:@"creator" notEqualTo:[PFUser currentUser]];
    
    query.skip = skipCount;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self convertFetchedObjectsToQuestions:objects];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)convertFetchedObjectsToQuestions:(NSArray *)objects {
    NSMutableArray *tempQuestions = [[NSMutableArray alloc] init];
    
    for (PFObject *object in objects) {
        SOQuestionModel *question = [[SOQuestionModel alloc] initWithTitle:[object valueForKey:@"title"] text:[object valueForKey:@"text"] type:[object valueForKey:@"type"] creator:[object valueForKey:@"creator"]];
        [question setObjectId:[object objectId]];
        PFFile *image = [object valueForKey:@"image"];
        PFFile *image2 = [object valueForKey:@"image2"];
        NSMutableArray *answers = [NSMutableArray array];
        if ([object valueForKey:@"answer0"]) {
            [answers addObject:[object valueForKey:@"answer0"]];
        }
        if ([object valueForKey:@"answer1"]) {
            [answers addObject:[object valueForKey:@"answer1"]];
        }
        if ([object valueForKey:@"answer2"]) {
            [answers addObject:[object valueForKey:@"answer2"]];
        }
        if ([object valueForKey:@"answer3"]) {
            [answers addObject:[object valueForKey:@"answer3"]];
        }
        if (image && image2) {
            [question fetchImagesForFile1:image file2:image2];
        } else if (image) {
            [question fetchImagesForFile1:image file2:nil];
        }
        
        question.answers = answers;
        [tempQuestions addObject:question];
        [question fetchResponsesToQuestion];
    }
    [self.delegate questionsReceived:tempQuestions];
}
@end
