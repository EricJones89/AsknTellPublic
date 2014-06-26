//
//  SOFeedFilterModel.h
//  SecondOpinion
//
//  Created by Eric Jones on 1/18/14.
//  Copyright (c) 2014 Eric Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOFeedFilterModel : NSObject

@property (nonatomic) NSArray *creators;
@property (nonatomic) NSArray *hashTags;
@property (nonatomic) NSArray *categories;
@property (nonatomic) NSString *title;

+ (SOFeedFilterModel *)createFeedFilterWithTitle:(NSString *)title categories:(NSArray *)categories hashtags:(NSArray *)hashtags creators:(NSArray *)creators;

@end
