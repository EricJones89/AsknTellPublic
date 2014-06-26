//
//  SOEulaModel.m
//  SecondOpinion
//
//  Created by Eric Jones on 12/8/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOEulaModel.h"
#import <QuickLook/QuickLook.h>

@interface SOEulaModel () <QLPreviewItem>

@end

@implementation SOEulaModel

-(NSString *)previewItemTitle {
    return @"End User License Agreement";
}

- (NSURL *)previewItemURL {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EULA" ofType:@"pdf"];
    return [[NSURL alloc] initFileURLWithPath:path];
}

@end
