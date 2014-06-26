//
//  SOLoginView.h
//  SecondOpinion
//
//  Created by Eric Jones on 11/29/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SOLoginViewDelegate <NSObject>

- (void)loginWithUsername:(NSString *)username password:(NSString *)password;
- (void)registerButtonTapped;

@end

@interface SOLoginView : UIView

@property (nonatomic, weak) id<SOLoginViewDelegate> delegate;

- (void)loginFailed;

@end
