//
//  SOAnswerThisOrThatView.m
//  SecondOpinion
//
//  Created by Eric Jones on 10/29/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOAnswerThisOrThatView.h"

#define PADDING 10
#define HORRIZONTAL_PADDING 30

@interface SOAnswerThisOrThatView ()

@property (nonatomic) UIButton *thisImageButton;
@property (nonatomic) UIButton *thatImageButton;
@property (nonatomic) BOOL typeIsHorizontal;

@end

@implementation SOAnswerThisOrThatView

@synthesize delegate;
@synthesize answers;
@synthesize forCreation;

- (id)initWithFrame:(CGRect)frame withAnswers:(NSArray *)answers forCreation:(BOOL)forCreation
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.forCreation = forCreation;
        self.answers = answers;
        if ([answers[0] isEqualToString:@"Left"]) {
            self.typeIsHorizontal = YES;
            self.thisImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.thisImageButton setImage:[UIImage imageNamed:@"left-arrow.png"] forState:UIControlStateNormal];
            self.thisImageButton.contentMode = UIViewContentModeScaleToFill;
            
            self.thatImageButton= [UIButton buttonWithType:UIButtonTypeCustom];
            [self.thatImageButton setImage:[UIImage imageNamed:@"right-arrow.png"] forState:UIControlStateNormal];
            self.thatImageButton.contentMode = UIViewContentModeScaleToFill;
        } else {
            self.thisImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.thisImageButton setImage:[UIImage imageNamed:@"up-arrow.png"] forState:UIControlStateNormal];
            self.thisImageButton.contentMode = UIViewContentModeScaleToFill;
            
            self.thatImageButton= [UIButton buttonWithType:UIButtonTypeCustom];
            [self.thatImageButton setImage:[UIImage imageNamed:@"down-arrow.png"] forState:UIControlStateNormal];
            self.thatImageButton.contentMode = UIViewContentModeScaleToFill;
        }
        
        
        
        [self.thisImageButton addTarget:self action:@selector(thisButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        [self.thatImageButton addTarget:self action:@selector(thatButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.thisImageButton];
        [self addSubview:self.thatImageButton];
    }
    return self;
}

- (void)addAnswer:(NSString *)answer {
    //do nothing
}

- (void)layoutSubviews {
    if (self.typeIsHorizontal) {
        self.thisImageButton.frame = CGRectMake(PADDING, PADDING, self.frame.size.width/2 - PADDING * 1.5, self.frame.size.height - PADDING * 2);
        
        self.thatImageButton.frame = CGRectMake( self.frame.size.width/2 + PADDING /2, PADDING, self.frame.size.width/2 - PADDING, self.frame.size.height - PADDING * 2);
    } else {
        self.thisImageButton.frame = CGRectMake(HORRIZONTAL_PADDING, PADDING, self.frame.size.width - HORRIZONTAL_PADDING * 2, self.frame.size.height/2 - PADDING * 1.5);
        
        self.thatImageButton.frame = CGRectMake(HORRIZONTAL_PADDING , self.frame.size.height/2 + PADDING * .5, self.frame.size.width - HORRIZONTAL_PADDING *2, self.frame.size.height/2 - PADDING * 1.5);
    }
    
    [self.thisImageButton sizeThatFits:self.thisImageButton.frame.size];
    [self.thatImageButton sizeThatFits:self.thisImageButton.frame.size];
}

- (void)thisButtonTapped {
    [self.delegate answerPressedAtIndex:0];
}

- (void)thatButtonTapped {
    [self.delegate answerPressedAtIndex:1];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
