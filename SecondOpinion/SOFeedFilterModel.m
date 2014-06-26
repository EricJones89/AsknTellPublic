//
//  SOFeedFilterModel.m
//  SecondOpinion
//
//  Created by Eric Jones on 1/18/14.
//  Copyright (c) 2014 Eric Jones. All rights reserved.
//

#import "SOFeedFilterModel.h"

@implementation SOFeedFilterModel

- (id)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

+ (SOFeedFilterModel *)createFeedFilterWithTitle:(NSString *)title categories:(NSArray *)categories hashtags:(NSArray *)hashtags creators:(NSArray *)creators {
    PFObject *feedFilter = [PFObject objectWithClassName:@"FeedFilters"];
    [feedFilter setObject:title forKey:@"title"];
    [feedFilter setObject:categories forKey:@"categories"];

    [feedFilter setObject:hashtags forKey:@"hashtags"];
    [feedFilter setObject:creators forKey:@"creators"];
    [feedFilter setObject:[PFUser currentUser] forKey:@"creator"];
    
    [feedFilter saveInBackground];
    
    SOFeedFilterModel *feed = [[SOFeedFilterModel alloc] init];
    feed.creators = creators;
    feed.title = title;
    feed.hashTags = hashtags;
    feed.categories = categories;
    
    return feed;
}

@end
