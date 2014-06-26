//
//  SOBarPercentageView.m
//  SecondOpinion
//
//  Created by Eric Jones on 11/14/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOBarPercentageView.h"
#import "SOStyle.h"
#import <QuartzCore/QuartzCore.h>

#define VIEW_HEIGHT 25

@interface SOBarPercentageView ()

@property (nonatomic) CGFloat leftPercentage;
@property (nonatomic) CGFloat rightPercentage;
@property (nonatomic) UILabel *leftLabel;
@property (nonatomic) UILabel *rightLabel;
@property (nonatomic) UILabel *topLabel;
@property (nonatomic) BOOL onlyDrawLeftSide;
@property (nonatomic) BOOL onlyDrawRightSide;
@property (nonatomic) BOOL noResponsesYet;

@end

@implementation SOBarPercentageView

- (id)initWithFrame:(CGRect)frame leftPercentage:(CGFloat)leftPercentage leftText:(NSString*)leftText rightPercentage:(CGFloat)rightPercentage rightText:(NSString *)rightText
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.leftPercentage = leftPercentage;
        self.rightPercentage = rightPercentage;
        self.onlyDrawLeftSide = (rightPercentage < .005f);
        self.onlyDrawRightSide = (leftPercentage < .005f);
        self.noResponsesYet = self.onlyDrawLeftSide && self.onlyDrawRightSide;
        self.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ / %@", leftText, rightText]];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,5)];
        if (!self.noResponsesYet) {
            NSString* string = [NSString stringWithFormat:@"%@ / %@", leftText, rightText];
            NSArray *array = [string componentsSeparatedByString:@"/"];
            NSMutableAttributedString *finalString= [[NSMutableAttributedString alloc] initWithString:string];
            [finalString addAttribute:NSForegroundColorAttributeName value:[SOStyle headerColor] range:[string rangeOfString:array[0]]];
            [finalString addAttribute:NSForegroundColorAttributeName value:[SOStyle backgroundColor] range:[string rangeOfString:array[1]]];
            self.topLabel = [self defaultLabelWithAttributedText:finalString];
        } else {
            self.topLabel = [self defaultLabelWithText:@"No Responses Yet"];
        }
        [self.topLabel sizeToFit];
        [self addSubview:self.topLabel];
        
        if (!self.onlyDrawRightSide) {
            NSString *labelText = [NSString stringWithFormat:@"%i%%", (int)(leftPercentage*100)];
            self.leftLabel = [self defaultLabelWithText:labelText];
            [self addSubview:self.leftLabel];
        }
        if (!self.onlyDrawLeftSide) {
            NSString *labelText = [NSString stringWithFormat:@"%i%%", (int)(rightPercentage*100)];
            self.rightLabel = [self defaultLabelWithText:labelText];
            [self addSubview:self.rightLabel];
        }
        
       
        
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (UILabel *)defaultLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [SOStyle defaultFontWithSize:16];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    return label;

}

- (UILabel *)defaultLabelWithAttributedText:(NSMutableAttributedString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = text;
    label.font = [SOStyle defaultFontWithSize:16];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    return label;
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if (!self.noResponsesYet) {
        self.leftLabel.center = CGPointMake(self.frame.size.width*self.leftPercentage/2, self.frame.size.height/2);
        self.rightLabel.center = CGPointMake(self.frame.size.width - self.frame.size.width*self.rightPercentage/2, self.frame.size.height/2);
    }
    self.topLabel.center = CGPointMake(self.center.x, -(self.topLabel.frame.size.height/2 + 5));
}

- (void)drawRect:(CGRect)rect
{
    CGFloat width = self.frame.size.width - 10;
    
    CGRect leftRect = CGRectMake(5, 0, width * self.leftPercentage, self.frame.size.height);
    CGRect rightRect = CGRectMake(width + 5 - width * self.rightPercentage, 0, width * self.rightPercentage, self.frame.size.height);
    CGRect fullRect = CGRectMake(5, 0, width, self.frame.size.height);
    if (self.noResponsesYet) {
        UIBezierPath *leftPath = [UIBezierPath bezierPathWithRoundedRect:fullRect
                                                       byRoundingCorners:UIRectCornerAllCorners
                                                             cornerRadii:CGSizeMake(10.0f, 10.0f)];
        [[SOStyle headerColor] setFill];
        [leftPath fill];
    } else if (self.onlyDrawLeftSide) {
        UIBezierPath *leftPath = [UIBezierPath bezierPathWithRoundedRect:leftRect
                                                       byRoundingCorners:UIRectCornerAllCorners
                                                             cornerRadii:CGSizeMake(10.0f, 10.0f)];
        [[SOStyle headerColor] setFill];
        [leftPath fill];
        
     } else if (self.onlyDrawRightSide) {
         UIBezierPath *rightPath = [UIBezierPath bezierPathWithRoundedRect:rightRect
                                                         byRoundingCorners:UIRectCornerAllCorners
                                                               cornerRadii:CGSizeMake(10.0f, 10.0f)];
         
         [[SOStyle backgroundColor] setFill];
         [rightPath fill];
         
     }else {
        UIBezierPath *leftPath = [UIBezierPath bezierPathWithRoundedRect:leftRect
                                                       byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft
                                                             cornerRadii:CGSizeMake(10.0f, 10.0f)];
        [[SOStyle headerColor] setFill];
        [leftPath fill];
        
        UIBezierPath *rightPath = [UIBezierPath bezierPathWithRoundedRect:rightRect
                                                        byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight
                                                              cornerRadii:CGSizeMake(10.0f, 10.0f)];
        
        [[SOStyle backgroundColor] setFill];
        [rightPath fill];
    }
    
    
    
    
    
}


@end
