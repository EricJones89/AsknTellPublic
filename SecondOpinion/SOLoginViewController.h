//
//  SOLoginViewController.h
//  SecondOpinion
//
//  Created by Eric Jones on 11/29/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SOQuestionViewControllerDelegate <NSObject>

- (void)loginSucceded;

@end

@interface SOLoginViewController : UIViewController

@property (nonatomic, weak) id<SOQuestionViewControllerDelegate> delegate;

@end
