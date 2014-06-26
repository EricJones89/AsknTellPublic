//
//  SOCreateNewQuestionViewController.h
//  SecondOpinion
//
//  Created by Eric Jones on 8/15/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SOCreateNewQuestionViewControllerDelegate <NSObject>

- (void)createQuestionWithType:(NSString *)type text:(NSString *)text primaryImage:(UIImage *)primaryImage secondaryImage:(UIImage *)secondaryImage answers:(NSArray *)answers;

@end

@interface SOCreateNewQuestionViewController : UIViewController

@property (nonatomic, weak) id<SOCreateNewQuestionViewControllerDelegate> delegate;

@end
