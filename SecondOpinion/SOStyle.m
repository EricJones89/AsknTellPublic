//
//  SOStyle.m
//  SecondOpinion
//
//  Created by Eric Jones on 9/10/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#define QUESTION_HEX 0xFAFAFA
#define QUESTION_BOARDER_HEX 0xA3A3A3
#define BACKGROUND_HEX 0xDDDDDD
#define BLUE_QUESTION_HEX 0x65C7E0
#define HEADER_HEX 0xFFD119
#define DEFAULT_FONT @"HelveticaNeue-Light"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "SOStyle.h"

@implementation SOStyle

+ (UIColor *)backgroundColor {
    return UIColorFromRGB(BACKGROUND_HEX);
}

+ (UIColor *)questionColor {
    return UIColorFromRGB(QUESTION_HEX);
}

+ (UIColor *)questionBoarderColor {
    return UIColorFromRGB(QUESTION_BOARDER_HEX);
}

+ (UIColor *)headerColor {
    return UIColorFromRGB(HEADER_HEX);
}

+ (UIFont *)defaultFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:DEFAULT_FONT size:size];
}

@end
