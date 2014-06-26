//
//  SOAnswerYesOrNoView.m
//  SecondOpinion
//
//  Created by Eric Jones on 10/10/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOAnswerYesOrNoView.h"

#define PADDING 10
#define HORRIZONTAL_PADDING 30

@interface SOAnswerYesOrNoView ()

@property (nonatomic) UIButton *yesImageButton;
@property (nonatomic) UIButton *noImageButton;

@end

@implementation SOAnswerYesOrNoView

@synthesize delegate;
@synthesize answers;
@synthesize forCreation;

- (id)initWithFrame:(CGRect)frame withAnswers:(NSArray *)answers forCreation:(BOOL)forCreation
{
    self = [super initWithFrame:frame];
    if (self) {
       
        self.forCreation = forCreation;
        self.yesImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.yesImageButton setImage:[UIImage imageNamed:@"thumbs-up.png"] forState:UIControlStateNormal];
        self.yesImageButton.contentMode = UIViewContentModeScaleToFill;
        
        self.noImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.noImageButton setImage:[UIImage imageNamed:@"thumbs-down.png"] forState:UIControlStateNormal];
        self.noImageButton.contentMode = UIViewContentModeScaleToFill;
        
        [self.yesImageButton addTarget:self action:@selector(yesButtonTapped)
                      forControlEvents:UIControlEventTouchUpInside];
        [self.noImageButton addTarget:self action:@selector(noButtonTapped)
                      forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.yesImageButton];
        [self addSubview:self.noImageButton];
        
        self.answers = answers;

    }
    return self;
}

- (void)yesButtonTapped {
    [self.delegate answerPressedAtIndex:0];
}

- (void)noButtonTapped {
    [self.delegate answerPressedAtIndex:1];
}

- (void)layoutSubviews {
    self.yesImageButton.frame = CGRectMake(HORRIZONTAL_PADDING, PADDING, self.frame.size.width/2 - HORRIZONTAL_PADDING * 1.5, self.frame.size.height - PADDING * 2);
    
    self.noImageButton.frame = CGRectMake( self.frame.size.width/2 + HORRIZONTAL_PADDING/2, PADDING, self.frame.size.width/2 - HORRIZONTAL_PADDING * 1.5, self.frame.size.height - PADDING * 2);
    
}

@end
