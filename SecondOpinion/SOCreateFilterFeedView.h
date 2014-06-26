//
//  SOCreateFilterFeedView.h
//  SecondOpinion
//
//  Created by Eric Jones on 1/27/14.
//  Copyright (c) 2014 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SOCreateFilterFeedViewDelegate <NSObject>

- (void)createFeedFilterWithTitle:(NSString *)title categories:(NSArray *)categories hashtags:(NSArray *)hashtags creators:(NSArray *)creators;
- (void)cancelButtonTapped;

@end

@interface SOCreateFilterFeedView : UIView

@property (nonatomic, weak) id<SOCreateFilterFeedViewDelegate> delegate;

@end
