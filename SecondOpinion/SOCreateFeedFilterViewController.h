//
//  SOCreateFeedFilterViewController.h
//  SecondOpinion
//
//  Created by Eric Jones on 1/27/14.
//  Copyright (c) 2014 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SOCreateFilterFeedViewControllerDelegate <NSObject>

- (void)createFeedFilterWithTitle:(NSString *)title categories:(NSArray *)categories hashtags:(NSArray *)hashtags creators:(NSArray *)creators;

@end

@interface SOCreateFeedFilterViewController : UIViewController

@property (nonatomic, weak) id<SOCreateFilterFeedViewControllerDelegate> delegate;

@end
