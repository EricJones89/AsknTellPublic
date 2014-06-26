//
//  SOFeedFiltersFetcher.h
//  SecondOpinion
//
//  Created by Eric Jones on 1/18/14.
//  Copyright (c) 2014 Eric Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SOFeedFilterFetchDelegate <NSObject>

- (void)filtersFetched:(NSArray *)filters;

@end

@interface SOFeedFiltersFetcher : NSObject

- (NSArray *)fetchFiltersForLoggedInUser;

@property (nonatomic, weak) id<SOFeedFilterFetchDelegate> delegate;

@end
