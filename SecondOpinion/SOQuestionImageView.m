//
//  SOQuestionImageView.m
//  SecondOpinion
//
//  Created by Eric Jones on 9/20/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOQuestionImageView.h"
#import <QuartzCore/QuartzCore.h>

#define PADDING 5

@interface SOQuestionImageView ()

@property (nonatomic) UIImageView *primaryImageView;
@property (nonatomic) UIImageView *secondaryImageView;
@property (nonatomic) int numberOfImages;


@end

@implementation SOQuestionImageView

- (id)initWithFrame:(CGRect)frame primaryImage:(UIImage *)primaryImage secondaryImage:(UIImage *)secondaryImage
{
    self = [super initWithFrame:frame];
    if (self) {
        self.primaryImageView = [self configureImageViewWithImage:primaryImage];
        self.secondaryImageView = [self configureImageViewWithImage:secondaryImage];
        
        if (primaryImage && secondaryImage) {
            self.numberOfImages = 2;
        } else {
            self.numberOfImages = 1;
        }
        
        self.areImagesLayoutOutHorrizontal = !(self.primaryImageView.image.size.width > self.primaryImageView.image.size.height);
        
    }
    return self;
}

- (UIImageView *)configureImageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:imageView];
    return imageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutImageViews];
}

- (void)layoutImageViews {
    if (self.frame.size.width>0 && self.frame.size.height > 0) {
        if (!self.areImagesLayoutOutHorrizontal) {
            if (self.numberOfImages == 1) {
                self.primaryImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                self.primaryImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            } else {
                self.primaryImageView.frame = CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height - PADDING)/2);
                self.secondaryImageView.frame = CGRectMake(0, CGRectGetMaxY(self.primaryImageView.frame) + PADDING, self.frame.size.width, (self.frame.size.height - PADDING)/2);
            }
        } else {
            if (self.numberOfImages == 1) {
                self.primaryImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            } else {
                self.primaryImageView.frame = CGRectMake(0, 0, (self.frame.size.width - PADDING)/2, self.frame.size.height);
                self.secondaryImageView.frame = CGRectMake(CGRectGetMaxX(self.primaryImageView.frame) + PADDING, 0, (self.frame.size.width - PADDING)/2, self.frame.size.height);
            }
        }
    }
}

@end
