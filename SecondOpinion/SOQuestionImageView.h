//
//  SOQuestionImageView.h
//  SecondOpinion
//
//  Created by Eric Jones on 9/20/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOQuestionImageView : UIView

- (id)initWithFrame:(CGRect)frame primaryImage:(UIImage *)primaryImage secondaryImage:(UIImage *)secondaryImage;

@property (nonatomic) BOOL areImagesLayoutOutHorrizontal;

@end
