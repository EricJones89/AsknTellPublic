//
//  SOAnswerMutipleChoicesView.m
//  SecondOpinion
//
//  Created by Eric Jones on 10/14/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOAnswerMutipleChoicesView.h"
#import "SOStyle.h"

#define ANSWER_TEXT_FIELD_HEIGHT 25
#define PADDING 5

@interface SOAnswerMutipleChoicesView () <UITextFieldDelegate>

@property (nonatomic) NSMutableArray *answerFields;

@property (nonatomic) UIButton *addAnswerButton;

@end

@implementation SOAnswerMutipleChoicesView

@synthesize answers;
@synthesize delegate;
@synthesize forCreation;

- (id)initWithFrame:(CGRect)frame withAnswers:(NSArray *)answers forCreation:(BOOL)forCreation
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.forCreation = forCreation;
        self.answers = answers.mutableCopy;
        self.answerFields = [[NSMutableArray alloc] init];
        
        for (int i=0; i<self.answers.count; i++) {
            [self.answerFields addObject:[self defaultTextFieldWithText:self.answers[i] withOrderNumber:i+1]];
        }
        
        self.addAnswerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addAnswerButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        [self.addAnswerButton addTarget:self action:@selector(addAnswerField) forControlEvents:UIControlEventTouchUpInside];
        self.addAnswerButton.hidden = !self.forCreation;
        [self addSubview:self.addAnswerButton];
    }
    return self;
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
    if (self.forCreation) {
        textField.placeholder = text;
    } else {
        textField.text = text;
    }
    
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
        ((UITextField *)self.answerFields[i]).frame = CGRectMake(5, i * (ANSWER_TEXT_FIELD_HEIGHT + PADDING) , self.frame.size.width-10, ANSWER_TEXT_FIELD_HEIGHT);
        ((UITextField *)self.answerFields[i]).leftView.frame = CGRectMake(0, 0, 10, 20);
    }
    
    if (self.answerFields.count < 4) {
        self.addAnswerButton.frame = CGRectMake(5, self.answerFields.count * (ANSWER_TEXT_FIELD_HEIGHT + PADDING), 15, 15);
    } else {
        self.addAnswerButton.hidden = YES;
    }
    
    
}

- (void)goToNextAnswerFromTextField:(UITextField *)textField {
    if (textField.tag >= self.answerFields.count) {
        [textField resignFirstResponder];
    } else {
        [self.answerFields[textField.tag] becomeFirstResponder];
    }
}

- (void)addAnswerField {
    [self.delegate alternateButtonPressed];
    
}

- (int)numberOfFields {
    return self.answerFields.count;
}

- (void)addAnswer:(NSString *)answer {
    [self.answers addObject:answer];
    [self.answerFields addObject:[self defaultTextFieldWithText:answer withOrderNumber:self.answers.count]];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        [self goToNextAnswerFromTextField:textField];
        return NO;
    }
    
    NSString *text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:textField.font}];
    
    BOOL tooLong = textSize.width > textField.bounds.size.width-20;
    if  (!tooLong) {
        self.answers[textField.tag-1] = [textField.text stringByReplacingCharactersInRange:range withString:string];
    } else {
        self.answers[textField.tag-1] = textField.text;
    }
    
    return !tooLong;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!self.forCreation) {
        [self.delegate answerPressedAtIndex:textField.tag-1];
        return NO;
    }
    
    return YES;
}



@end
