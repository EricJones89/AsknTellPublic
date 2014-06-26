//
//  SOStyle.h
//  SecondOpinion
//
//  Created by Eric Jones on 9/10/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SOStyle : NSObject

+ (UIFont *)defaultFontWithSize:(CGFloat)size;

+ (UIColor *)backgroundColor;
+ (UIColor *)questionColor;
+ (UIColor *)questionBoarderColor;
+ (UIColor *)headerColor;

@end
