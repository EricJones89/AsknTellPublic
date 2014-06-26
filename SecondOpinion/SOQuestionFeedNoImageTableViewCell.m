//
//  SOQuestionFeedNoImageTableViewCell.m
//  SecondOpinion
//
//  Created by Eric Jones on 9/10/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOQuestionFeedNoImageTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SOStyle.h"
#import "SOQuestionImageView.h"
#import "SOAnswerViewProtocol.h"
#import "SOAnswerThisOrThatView.h"
#import "SOAnswerYesOrNoView.h"
#import "SOAnswerMutipleChoicesView.h"
#import "SOBarPercentageView.h"
#import "SOMultipleBarPercentageView.h"


@interface SOQuestionFeedNoImageTableViewCell () <SOAnswerViewDelegate, SOQuestionModelDelegate, UIAlertViewDelegate>

@property (nonatomic) UIImageView *imagesView;
@property (nonatomic) id<SOAnswerViewProtocol> answerView;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *answerResultsView;
@property (nonatomic) UIImageView *creatorImageView;
@property (nonatomic) UILabel *creatorNameLabel;
@property (nonatomic) UIButton *reportQuestionButton;

@end

@implementation SOQuestionFeedNoImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
    }
    return self;
}

- (void)prepareForReuse {
    [self.creatorImageView removeFromSuperview];
    self.creatorImageView = nil;
    [self.creatorNameLabel removeFromSuperview];
    self.creatorNameLabel = nil;
    [self.imagesView removeFromSuperview];
    self.imagesView = nil;
    [(UIView *)self.answerView removeFromSuperview];
    self.answerView = nil;
    [self.answerResultsView removeFromSuperview];
    self.answerResultsView = nil;
    [self.textView removeFromSuperview];
    self.textView = nil;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    [self.reportQuestionButton removeFromSuperview];
    self.reportQuestionButton = nil;
}

- (void)setQuestion:(SOQuestionModel *)question {
    _question = question;
    question.delegate = self;
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundView.backgroundColor = [SOStyle questionColor];
    self.backgroundView.layer.shadowOffset = CGSizeMake(0, 1);
    self.backgroundView.layer.shadowOpacity = 1.0;
    self.backgroundView.layer.shadowRadius = 1.0;
    self.backgroundView.layer.shadowColor = [SOStyle questionBoarderColor].CGColor;
    [self addSubview:self.backgroundView];
    
    [self configureCreatorImageView];
    [self configureCreatorNameLabel];
    [self configureQuestionTextView];
    [self configureImageViewWithImage:question.combinedQuestionImages];
    if (self.question.answersShouldBeDisplayed && self.question.hasAnswerResponseFromCurrentUser) {
        [self configureAnswerResultsView];
    } else if (self.question.answersShouldBeDisplayed) {
        [self configureAnswersView];
    }
    
    [self configureReportQuestionButton];

}

- (void)configureReportQuestionButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Report Question" forState:UIControlStateNormal];
    button.titleLabel.font = [SOStyle defaultFontWithSize:10.0];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reportQuestionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    self.reportQuestionButton = button;
}

- (void)configureCreatorImageView {
    UIImageView *imageView;
    if (self.question.creatorImage) {
        imageView = [[UIImageView alloc] initWithImage:self.question.creatorImage];
    } else {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultProfilePictureCropped"]];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:imageView];
    self.creatorImageView = imageView;
}

- (void)configureCreatorNameLabel {
    UILabel *label = [[UILabel alloc] init];
    if (self.question.creator.isDataAvailable) {
        label.text = [NSString stringWithFormat:@"%@ Asks:" , [self.question.creator valueForKey:@"fullName"]];
    }
    label.font = [SOStyle defaultFontWithSize:16];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [SOStyle questionColor];
    
    [self.creatorNameLabel removeFromSuperview];
    [self addSubview:label];
    self.creatorNameLabel = label;
}

- (void)configureAnswersView {
    [((UIView *)self.answerView) removeFromSuperview];
    if ([self.question.answers isEqualToArray:[SOQuestionModel defaultLeftOrRightAnswers]] || [self.question.answers isEqualToArray:[SOQuestionModel defaultTopOrBottomAnswers]]) {
        self.answerView = [[SOAnswerThisOrThatView alloc] initWithFrame:CGRectZero withAnswers:self.question.answers forCreation:NO];
    } else if ([self.question.answers isEqualToArray:[SOQuestionModel defaultYesOrNoAnswers]]) {
        self.answerView = [[SOAnswerYesOrNoView alloc] initWithFrame:CGRectZero withAnswers:self.question.answers forCreation:NO];
    } else {
        self.answerView = [[SOAnswerMutipleChoicesView alloc] initWithFrame:CGRectZero withAnswers:self.question.answers forCreation:NO];
    }
    [self addSubview:(UIView *)self.answerView];
    
    self.answerView.delegate = self;
}

- (void)configureAnswerResultsView {
    [self.answerResultsView removeFromSuperview];
    if ([self.question.answers isEqualToArray:[SOQuestionModel defaultLeftOrRightAnswers]] || [self.question.answers isEqualToArray:[SOQuestionModel defaultTopOrBottomAnswers]] || [self.question.answers isEqualToArray:[SOQuestionModel defaultYesOrNoAnswers]]){
        self.answerResultsView = [[SOBarPercentageView alloc] initWithFrame:((UIView *)self.answerView).frame leftPercentage:[self.question percentageOfResposesForAnswerAtIndex:0] leftText:self.question.answers[0]  rightPercentage:[self.question percentageOfResposesForAnswerAtIndex:1] rightText:self.question.answers[1]];
    }   else {
        self.answerResultsView = [[SOMultipleBarPercentageView alloc] initWithFrame:((UIView *)self.answerView).frame withAnswers:self.question.answers withPercentages:[self.question percentageArrayForResponses]];
    }
    [self addSubview:self.answerResultsView];

}

- (void)configureImageViewWithImage:(UIImage *)image {
    self.imagesView = [[UIImageView alloc] initWithImage:image];
    self.imagesView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imagesView removeFromSuperview];
    [self addSubview:self.imagesView];
    
    
}

- (void)configureQuestionTextView {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.backgroundColor = [SOStyle questionColor];
    textView.text = self.question.text;
    textView.textAlignment = NSTextAlignmentCenter;
    textView.font = [SOStyle defaultFontWithSize:16];
    textView.textColor = [UIColor blackColor];
    [textView setAllowsEditingTextAttributes:NO];
    [textView setScrollEnabled:NO];
    [textView setUserInteractionEnabled:NO];
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    textView.contentMode = UIControlContentVerticalAlignmentCenter;
    textView.editable = NO;
    [self addSubview:textView];
    self.textView = textView;
    [self.textView sizeToFit];
    [self layoutTextView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.textView sizeToFit];
    [self layoutCreatorImageView];
    [self layoutCreatorNameLabel];
    [self layoutTextView];
    [self layoutImageView];
    
    [self layoutAnswerView];
    if (self.question.answersShouldBeDisplayed && self.question.hasAnswerResponseFromCurrentUser) {
        [self layoutAnswerResultsView];
    }
    
    [self layoutReportQuestionButton];
    
    self.backgroundView.frame = CGRectMake(5, 0 , self.frame.size.width - 10, self.frame.size.height-1);
}

- (void)layoutCreatorImageView {
    self.creatorImageView.frame = CGRectMake(self.frame.size.width/16, SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN, self.frame.size.width/4, self.frame.size.width/4);
}

- (void)layoutCreatorNameLabel {
    [self.creatorNameLabel sizeToFit];
    self.creatorNameLabel.center = CGPointMake(CGRectGetMaxX(self.creatorImageView.frame) + SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN * 2 + self.creatorNameLabel.frame.size.width/2, SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN + self.creatorImageView.frame.size.height/2);
}

- (void)layoutImageView {
    BOOL imageViewHasImages = [self.question numberOfImages];
    self.imagesView.frame = CGRectMake(SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN, CGRectGetMaxY(self.textView.frame) + SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN * imageViewHasImages, self.frame.size.width - 2 * SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN, IMAGE_VIEW_HEIGHT * [self.question numberOfImages]);
}

- (void)layoutTextView {
    
    self.textView.frame = CGRectMake(SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN, SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN + CGRectGetMaxY(self.creatorImageView.frame), self.frame.size.width - 2 * SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN, self.textView.frame.size.height );
}

- (void)layoutAnswerView {
    ((UIView *)self.answerView).frame = CGRectMake(SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN, CGRectGetMaxY(self.imagesView.frame)+ SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN, self.frame.size.width - 2*SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN, BASE_ANSWER_VIEW_HEIGHT + self.answerView.answers.count * EACH_ADDITIONAL_ANSWER_HEIGHT);
    [(UIView *)self.answerView layoutSubviews];
}

- (void)layoutAnswerResultsView {
    if ([self.answerResultsView isKindOfClass:SOBarPercentageView.class]) {
        self.answerResultsView.frame = CGRectMake(0, 0, self.frame.size.width - 2*SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN, 25);
        self.answerResultsView.center = CGPointMake(self.center.x, CGRectGetMaxY(self.imagesView.frame)+ SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN + (BASE_ANSWER_VIEW_HEIGHT + self.question.answers.count * EACH_ADDITIONAL_ANSWER_HEIGHT) / 2);
    } else {
        self.answerResultsView.frame = CGRectMake(SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN, CGRectGetMaxY(self.imagesView.frame)+ SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN, self.frame.size.width - 2*SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN, BASE_ANSWER_VIEW_HEIGHT + self.question.answers.count * EACH_ADDITIONAL_ANSWER_HEIGHT);
    }
}

- (void)layoutReportQuestionButton {
    [self.reportQuestionButton sizeToFit];
    self.reportQuestionButton.center = CGPointMake(self.frame.size.width - SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN*2 - self.reportQuestionButton.frame.size.width/2, self.frame.size.height - self.reportQuestionButton.frame.size.height/2 - SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN);
}

- (void)reportQuestionButtonTapped {
    [[[UIAlertView alloc] initWithTitle:@"PleaseConfirm" message:@"Please confirm that you would like to report this question as inappropriate. We take this very seriously and will follow up with the creator" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil] show];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.question reportAsInappropriate];
    }
}

#pragma mark AnswerViewDelegate
- (void)answerPressedAtIndex:(int)index {
    [self.question addAnswerResponseForAnswerIndex:index];
    [self configureAnswerResultsView];
    self.answerResultsView.alpha = 0.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.answerResultsView.alpha = 1.0;
        ((UIView *)self.answerView).alpha = 0.0;
    } completion:^(BOOL finished) {
        ((UIView *)self.answerView).hidden = YES;
        ((UIView *)self.answerView).userInteractionEnabled = NO;
    }];
    [self layoutAnswerResultsView];
}

#pragma mark SOQuestionModelDelegate

- (void) imageLoadedForQuestion:(SOQuestionModel *)question {
    [self.imagesView removeFromSuperview];
    [self configureImageViewWithImage:question.combinedQuestionImages];
    self.creatorImageView.image = self.question.creatorImage;
    [self layoutSubviews];
}

- (void)reloadQuestion:(SOQuestionModel *)question {
    if (self.question.answersShouldBeDisplayed && self.question.hasAnswerResponseFromCurrentUser) {
        [self configureAnswerResultsView];
    } else if (self.question.answersShouldBeDisplayed) {
        [self configureAnswersView];
    }
    [self configureCreatorNameLabel];

    [self layoutSubviews];
}

- (CGFloat)widthOfContainerView {
    return self.frame.size.width-2*SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN;
}


@end
