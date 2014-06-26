//
//  SOProfileModel.h
//  SecondOpinion
//
//  Created by Eric Jones on 11/23/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SOProfileModelDelegate <NSObject>

- (void)profileImageDownloaded;
- (void)questionsLoaded;

@end

@interface SOProfileModel : NSObject

+  (UIImage*)circularCrop:(UIImage*)image inRect:(CGRect)rect;

@property (nonatomic, weak) id<SOProfileModelDelegate> delegate;

@property (nonatomic) PFUser *user;
@property (nonatomic) UIImage *profileImage;
@property (nonatomic) NSString *fullName;
@property (nonatomic) NSArray *questions;

@end
