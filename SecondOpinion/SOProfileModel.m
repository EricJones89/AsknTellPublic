//
//  SOProfileModel.m
//  SecondOpinion
//
//  Created by Eric Jones on 11/23/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOProfileModel.h"
#import "SOQuestionFetcher.h"

@interface SOProfileModel () <SOQuestionFetcherDelegate>

@property (nonatomic) SOQuestionFetcher *fetcher;

@end

@implementation SOProfileModel

+  (UIImage*)circularCrop:(UIImage*)image inRect:(CGRect)rect{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat rectWidth = rect.size.width;
    CGFloat rectHeight = rect.size.height;
    CGFloat widthScale = rectWidth/imageWidth;
    CGFloat heightScale = rectHeight/imageHeight;
    if (widthScale>heightScale) {
        image = [UIImage imageWithCGImage:[image CGImage]
                                    scale:1.0/widthScale
                              orientation:(image.imageOrientation)];
    } else {
        image = [UIImage imageWithCGImage:[image CGImage]
                                    scale:1.0/heightScale
                              orientation:(image.imageOrientation)];
    }
    
    imageWidth = image.size.width;
    imageHeight = image.size.height;
    
    CGFloat imageCenterX = rectWidth/2;
    CGFloat imageCenterY = rectHeight/2;
    
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCenterX, imageCenterY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (id)init {
    if (self = [super init]) {
        self.user = [PFUser currentUser];
        PFFile *image = [self.user valueForKey:@"profileImage"];
        [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            self.profileImage = [UIImage imageWithData:data];
            [self.delegate profileImageDownloaded];
            [self save];
        }];
        self.fetcher = [[SOQuestionFetcher alloc] init];
        self.fetcher.delegate = self;
        [self.fetcher getAllQuestionsForUser:[PFUser currentUser]];
        self.fullName = [self.user valueForKey:@"fullName"];
        
    }
    
    return self;
}

- (void)save {
    NSData *data = UIImagePNGRepresentation(self.profileImage);
    PFFile *file = [PFFile fileWithName:@"profileImage" data:data];
    [self.user setObject:file forKey:@"profileImage"];
    [self.user saveInBackground];
}

#pragma mark SOQuestionFetchDelegate

-(void)questionsReceived:(NSArray *)questions {
    self.questions = questions;
    [self.delegate questionsLoaded];
}

@end
