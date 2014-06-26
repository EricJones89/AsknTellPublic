//
//  SOMultipleBarPercentageView.m
//  SecondOpinion
//
//  Created by Eric Jones on 11/19/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOMultipleBarPercentageView.h"
#import "SOStyle.h"
#import "SOAnswerViewProtocol.h"
#import <QuartzCore/QuartzCore.h>

#define ANSWER_TEXT_FIELD_HEIGHT 25
#define PADDING 5

@interface SOMultipleBarPercentageView () <UITextFieldDelegate>

@property (nonatomic) NSMutableArray *answerFields;
@property (nonatomic) NSMutableArray *percentageLabels;
@property (nonatomic) NSArray *percentages;

@end

@implementation SOMultipleBarPercentageView

- (id)initWithFrame:(CGRect)frame withAnswers:(NSArray *)answers withPercentages:(NSArray *)percentages
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.answers = answers.mutableCopy;
        self.answerFields = [[NSMutableArray alloc] init];
        self.percentageLabels = [[NSMutableArray alloc] init];
        self.percentages = percentages;
        
        self.backgroundColor = [UIColor clearColor];
        
        for (int i=0 ; i<self.answers.count; i++) {
            [self.answerFields addObject:[self defaultTextFieldWithText:self.answers[i] withOrderNumber:i+1]];
            [self.percentageLabels addObject:[self defaultPercentageLabelWithPercentage:((NSNumber *)self.percentages[i]).floatValue]];
        }

    }
    return self;
}

- (UILabel *)defaultPercentageLabelWithPercentage:(CGFloat)percentage {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"%i%%", ((int)(percentage * 100))];
    label.font = [SOStyle defaultFontWithSize:15.0];
    label.textColor = [UIColor blackColor];
    
    [label sizeToFit];
    
    [self addSubview:label];
    return label;
}

- (UITextField *)defaultTextFieldWithText:(NSString *)text withOrderNumber:(int)order {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.backgroundColor = [SOStyle backgroundColor];
    textField.font = [SOStyle defaultFontWithSize:15.0];
    textField.textColor = [UIColor blackColor];
    textField.layer.cornerRadius = 10.0;
    textField.delegate = self;
    textField.tag = order;
    [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [textField setReturnKeyType:UIReturnKeyDone];
    textField.userInteractionEnabled = NO;

    textField.text = text;
    
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectZero];
    leftView.backgroundColor = [UIColor clearColor];
    [leftView sizeToFit];
    
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    
    [self addSubview:textField];
    
    return textField;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (int i=0; i<self.answerFields.count; ++i) {
        CGRect frame = CGRectMake(5, i * (ANSWER_TEXT_FIELD_HEIGHT + PADDING) , self.frame.size.width - 10, ANSWER_TEXT_FIELD_HEIGHT);
        ((UITextField *)self.answerFields[i]).frame = frame;
        ((UITextField *)self.answerFields[i]).leftView.frame = CGRectMake(0, 0, 10, 20);
        ((UILabel *)self.percentageLabels[i]).center = CGPointMake(frame.size.width - ((UILabel *)self.percentageLabels[i]).frame.size.width/2 - 5, frame.origin.y + ANSWER_TEXT_FIELD_HEIGHT/2);
        
    }
    
    
}


- (int)numberOfFields {
    return self.answerFields.count;
}





// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    for (UITextField *textfield in self.answerFields) {
        CGFloat width = ((NSNumber *)self.percentages[[self.answerFields indexOfObject:textfield]]).floatValue;
        CGRect rect = CGRectMake(0, 0 , (self.frame.size.width-10) * width, ANSWER_TEXT_FIELD_HEIGHT);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                       byRoundingCorners:UIRectCornerAllCorners
                                                             cornerRadii:CGSizeMake(10.0f, 10.0f)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = rect;
        layer.path = path.CGPath;
        layer.cornerRadius = 10.0f;
        layer.fillColor = [SOStyle headerColor].CGColor;
        [textfield.layer insertSublayer:layer atIndex:0];
        
    }
}


@end
