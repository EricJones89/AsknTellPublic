//
//  SOFeedFiltersFetcher.m
//  SecondOpinion
//
//  Created by Eric Jones on 1/18/14.
//  Copyright (c) 2014 Eric Jones. All rights reserved.
//

#import "SOFeedFiltersFetcher.h"
#import "SOFeedFilterModel.h"

@implementation SOFeedFiltersFetcher

- (NSArray *)fetchFiltersForLoggedInUser {
    NSArray *filters = [NSArray new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"FeedFilters"];
    [query whereKey:@"creator" equalTo:[PFUser currentUser]];
    [query addAscendingOrder:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self convertFetchedObjectsToFeedFilters:objects];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return filters;
}


- (void)convertFetchedObjectsToFeedFilters:(NSArray *)objects {
    NSMutableArray *tempFilters = [[NSMutableArray alloc] init];
    SOFeedFilterModel *allFilter = [[SOFeedFilterModel alloc] init];
    
    allFilter.categories = @[@"All"];
    allFilter.title =  @"All Questions";
    [tempFilters addObject:allFilter];
    
    for (PFObject *object in objects) {
        SOFeedFilterModel *filter = [[SOFeedFilterModel alloc] init];
        
        filter.hashTags = [object objectForKey:@"hashtags"];
        filter.creators = [object objectForKey:@"creators"];
        filter.categories = [object objectForKey:@"categories"];
        filter.title = [object objectForKey:@"title"];
        
        [tempFilters addObject:filter];
    }
    
    [self.delegate filtersFetched:tempFilters];
    
}

@end
