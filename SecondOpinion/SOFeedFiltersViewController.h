//
//  SOFeedFiltersViewController.h
//  SecondOpinion
//
//  Created by Eric Jones on 1/18/14.
//  Copyright (c) 2014 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOFeedFilterModel.h"


@protocol  SOFeedFiltersViewControllerDelegate <NSObject>

- (void)newFilterSelected:(SOFeedFilterModel *)filter;
- (void)addFilterButtonClicked;

@end

@interface SOFeedFiltersViewController : UIViewController

@property (nonatomic, weak) id<SOFeedFiltersViewControllerDelegate> delegate;

- (void)addFilter:(SOFeedFilterModel *)filter;

@end
