//
//  SOCreateNewQuestionView.m
//  SecondOpinion
//
//  Created by Eric Jones on 9/9/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOCreateNewQuestionView.h"
#import <QuartzCore/QuartzCore.h>
#import "SOStyle.h"
#import "SOQuestionModel.h"
#import "SOQuestionImageView.h"
#import "SOAnswerYesOrNoView.h"
#import "SOAnswerMutipleChoicesView.h"
#import "SOAnswerViewProtocol.h"
#import "SOAnswerThisOrThatView.h"


#define HORIZONTAL_MARGIN 25
#define HORIZONTAL_TYPE_MARGIN 80
#define TITLE_TEXT_FIELD_HEIGHT 25
#define PADDING 5
#define BOUNCE_HEIGHT 10
#define BACKGROUND_VIEW_PADDING 10


@interface SOCreateNewQuestionView () <UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, SOAnswerViewDelegate>

@property (nonatomic) UIButton *createQuestionButton;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *importImageButton;
@property (nonatomic) UIButton *captureImageButton;
@property (nonatomic) NSMutableArray *questionTextViews;
@property (nonatomic) BOOL textFieldsAreAnimated;
@property (nonatomic) int selectedIndex;
@property (nonatomic) SOQuestionImageView *imagesView;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UISegmentedControl *answerOptions;
@property (nonatomic) id<SOAnswerViewProtocol> answerView;
@property (nonatomic) UIView *backgroundView;


@end

@implementation SOCreateNewQuestionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureScrollView];
        [self configureBackgroundView];
        [self configureQuestionTextView];
        [self configureQuestionTextFieldViews];
        [self configureCreateQuestionButton];
        [self configureCancelButton];
        [self configureImportImageButton];
        [self configureCaptureImageButton];
        [self configureImagesView];
        [self configureAnswerOptions];
        [self configureAnswerView];
        self.textFieldsAreAnimated = NO;
        self.selectedIndex = 0;
        self.backgroundColor = [SOStyle backgroundColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        //For Later Use
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated {    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)configureBackgroundView {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [SOStyle questionColor];
    backgroundView.layer.cornerRadius = 4.0;
    
    [self.scrollView addSubview:backgroundView];
    self.backgroundView = backgroundView;
}

- (void)configureScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    self.scrollView = scrollView;
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:scrollView];
}

- (void)configureAnswerView {
    
    self.answerView = [[SOAnswerYesOrNoView alloc] initWithFrame:CGRectZero withAnswers:[SOQuestionModel defaultYesOrNoAnswers] forCreation:YES];
    
    self.answerView.delegate = self;
    
    [self.scrollView addSubview:(UIView *)self.answerView];
}

- (void)configureAnswerOptions {
    UISegmentedControl *answerTypeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[AnswerTypeYesNo, AnswerTypeChoices, AnswerTypeThisOrThat]];
    [answerTypeSegmentedControl setSelectedSegmentIndex:0];
    [self.scrollView addSubview:answerTypeSegmentedControl];
    for (UIView *view in answerTypeSegmentedControl.subviews) {
        [((id)view) setTintColor:[SOStyle headerColor]];
    }
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                                              NSForegroundColorAttributeName : [UIColor blackColor],
                                                              NSFontAttributeName : [SOStyle defaultFontWithSize:13]
                                                              } forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                                              NSForegroundColorAttributeName : [UIColor blackColor],
                                                              NSFontAttributeName : [SOStyle defaultFontWithSize:13]
                                                              } forState:UIControlStateSelected];
    [answerTypeSegmentedControl addTarget:self
                         action:@selector(answerViewSelected:)
               forControlEvents:UIControlEventValueChanged];
    self.answerOptions = answerTypeSegmentedControl;
}

- (void)configureImagesView {
    self.ImagesView = [[SOQuestionImageView alloc] initWithFrame:CGRectZero primaryImage:nil secondaryImage:nil];
}

- (void)configureQuestionTextFieldViews {
    
    self.questionTextViews = [[NSMutableArray alloc] init];
    
    for (int i = [SOQuestionModel numberOfQuestionTypes] ; i >= 0 ; i--) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.backgroundColor = [SOStyle headerColor];
        textField.text = [SOQuestionModel questionTypeTextForQuesitonType:i];
        textField.font = [SOStyle defaultFontWithSize:15.0];
        textField.textColor = [UIColor blackColor];
        textField.tag = i;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.layer.cornerRadius = 10.0;
        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        textField.delegate = self;
        UIImage *image = [UIImage imageNamed:[SOQuestionModel imageNameForType:i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        UIView *paddedView = [[UIView alloc] init];
        [paddedView addSubview:imageView];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = paddedView;
        if (i!=0) {
            textField.hidden = YES;
        }
        [self.questionTextViews insertObject:textField atIndex:0];
        [self.scrollView addSubview:textField];
    }
    
}

- (void)configureQuestionTextView {
    UITextView *questionText = [[UITextView alloc] init];
    questionText.text = @"";
    questionText.layer.cornerRadius = 10.0;
    questionText.backgroundColor = [SOStyle questionColor];
    questionText.returnKeyType = UIReturnKeyDone;
    questionText.delegate = self;
    questionText.font = [SOStyle defaultFontWithSize:15.0];
    questionText.textColor = [UIColor blackColor];
    questionText.layer.borderColor = [SOStyle headerColor].CGColor;
    questionText.layer.borderWidth = 1.0f;
    
    self.questionText = questionText;
    [self.scrollView addSubview:questionText];
}

- (void)configureCreateQuestionButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Create" forState:UIControlStateNormal];
    button.frame = CGRectZero;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.borderColor = [SOStyle headerColor].CGColor;
    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 10.0;
    button.titleLabel.font = [SOStyle defaultFontWithSize:15];
    [button addTarget:self action:@selector(createQuestionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.createQuestionButton = button;
    [self.scrollView addSubview:button];
}

- (void)configureCancelButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    button.frame = CGRectZero;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.borderColor = [SOStyle headerColor].CGColor;
    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 10.0;
    button.titleLabel.font = [SOStyle defaultFontWithSize:15];
    [button addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton = button;
    [self.scrollView addSubview:button];
}

- (void)configureImportImageButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"album.png"] forState:UIControlStateNormal];
    button.frame = CGRectZero;
    [button addTarget:self action:@selector(importImageButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.importImageButton = button;
    [self.scrollView addSubview:button];
}

- (void)configureCaptureImageButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    button.frame = CGRectZero;
    [button addTarget:self action:@selector(captureImageButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.captureImageButton = button;
    [self.scrollView addSubview:button];
}

- (void)setPrimaryImage:(UIImage *)primaryImage {
    _primaryImage = primaryImage;
    [self.imagesView removeFromSuperview];
    self.imagesView = [[SOQuestionImageView alloc] initWithFrame:CGRectMake(HORIZONTAL_MARGIN, CGRectGetMaxY(self.importImageButton.frame) + PADDING, self.frame.size.width - HORIZONTAL_MARGIN *2, 100) primaryImage:primaryImage secondaryImage:nil];
    
    [self.scrollView addSubview:self.imagesView];
    [self layoutSubviews];
}

- (void)setSecondaryImage:(UIImage *)secondaryImage {
    _secondaryImage = secondaryImage;
    [self.imagesView removeFromSuperview];
    self.imagesView = [[SOQuestionImageView alloc] initWithFrame:CGRectMake(HORIZONTAL_MARGIN, CGRectGetMaxY(self.importImageButton.frame) + PADDING, self.frame.size.width - HORIZONTAL_MARGIN *2, 200) primaryImage:self.primaryImage secondaryImage:secondaryImage];
    
    [self.scrollView addSubview:self.imagesView];
    [self layoutSubviews];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutTitleTypeView];
    [self layoutQuestionTextView];
    [self layoutImportImageButton];
    [self layoutCaptureImageButton];
    [self.imagesView layoutSubviews];
    [self layoutAnswerOptions];
    [self layoutAnswerView];
    [self layoutCreateQuestionButton];
    [self layoutCancelButton];
    [self layoutScrollView];
    [self layoutBackgroundView];
}

- (void)layoutBackgroundView {
    self.backgroundView.frame = CGRectMake(BACKGROUND_VIEW_PADDING, BACKGROUND_VIEW_PADDING * 2, self.frame.size.width-BACKGROUND_VIEW_PADDING*2, CGRectGetMaxY(self.cancelButton.frame) + PADDING);
}

- (void)layoutAnswerView {
    ((UIView *)self.answerView).frame = CGRectMake(HORIZONTAL_MARGIN, CGRectGetMaxY(self.answerOptions.frame)+ 2 * PADDING, self.frame.size.width - 2*HORIZONTAL_MARGIN, BASE_ANSWER_VIEW_HEIGHT + self.answerView.answers.count * EACH_ADDITIONAL_ANSWER_HEIGHT);
    [(UIView *)self.answerView layoutSubviews];
}

- (void)layoutScrollView {
    
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.createQuestionButton.frame) + 150);
    [self.scrollView layoutSubviews];
}

- (void)layoutAnswerOptions {
    self.answerOptions.frame = CGRectMake(HORIZONTAL_MARGIN, CGRectGetMaxY(self.importImageButton.frame) + 2 *PADDING + self.imagesView.frame.size.height, self.frame.size.width - 2*HORIZONTAL_MARGIN, TITLE_TEXT_FIELD_HEIGHT);
}

- (void)layoutTitleTypeView {
    
    for (UITextField *textField in self.questionTextViews) {
        CGFloat textViewHeight = self.textFieldsAreAnimated ? [self originHeightForTextViewIndex:[self.questionTextViews indexOfObject:textField]] : [self originHeightForTextViewIndex:0];
        textField.frame = CGRectMake(HORIZONTAL_TYPE_MARGIN, textViewHeight, self.frame.size.width - 2 * HORIZONTAL_TYPE_MARGIN, TITLE_TEXT_FIELD_HEIGHT);
        textField.leftView.frame = CGRectMake(0, 0, textField.frame.size.width/4, textField.frame.size.height);
        ((UIImageView *)textField.leftView.subviews[0]).frame = CGRectMake(5, 0, textField.leftView.frame.size.width - 10, textField.leftView.frame.size.height);
    }
}

- (void)layoutImportImageButton {
    self.importImageButton.frame = CGRectMake(HORIZONTAL_MARGIN + PADDING, CGRectGetMaxY(self.questionText.frame) + PADDING, 25, 25);
}

- (void)layoutCaptureImageButton {
    self.captureImageButton.frame = CGRectMake(HORIZONTAL_MARGIN + self.importImageButton.frame.size.width + 2 * PADDING, CGRectGetMaxY(self.questionText.frame) + PADDING, 25, 25);
}

- (void)layoutQuestionTextView {
    self.questionText.frame = CGRectMake(HORIZONTAL_MARGIN, self.frame.size.height/8, self.frame.size.width - 2 * HORIZONTAL_MARGIN, self.frame.size.height/4);
}

- (void)layoutCreateQuestionButton {
    [self.createQuestionButton sizeToFit];
    self.createQuestionButton.frame = CGRectMake(0, 0, self.createQuestionButton.frame.size.width + 50, self.createQuestionButton.frame.size.height + 10);
    self.createQuestionButton.center = CGPointMake(self.center.x + self.createQuestionButton.frame.size.width/2 + HORIZONTAL_MARGIN/2, CGRectGetMaxY(((UIView *)self.answerView).frame) + self.createQuestionButton.frame.size.height/2 + PADDING);
}

- (void)layoutCancelButton {
    [self.cancelButton sizeToFit];
    self.cancelButton.frame = CGRectMake(0, 0, self.cancelButton.frame.size.width + 50, self.cancelButton.frame.size.height + 10);
    self.cancelButton.center = CGPointMake(self.center.x - self.cancelButton.frame.size.width/2 - HORIZONTAL_MARGIN/2, CGRectGetMaxY(((UIView *)self.answerView).frame) + self.cancelButton.frame.size.height/2 + PADDING);
}

- (void)createQuestionButtonTapped {
    if ([self fieldsAreValid]) {
        [self viewDidDisappear:YES];
        [self.delegate createQuestionButtonTapped];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Form" message:@"Questions must have text with them." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)cancelButtonTapped {
    [self viewDidDisappear:YES];
    [self.delegate cancelButtonTapped];
}

- (void)importImageButtonTapped {
    [self.delegate importImageButtonTappedForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)captureImageButtonTapped {
    [self.delegate importImageButtonTappedForSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)questionTypeTextFieldTapped:(UITextField *)textField {
    if (!self.textFieldsAreAnimated) {
        textField.hidden = NO;
        [self prepareTextFieldsForAnimating];
        [self animateTextViewsFromTextView:self.questionTextViews[0]];
        
    } else {
        [self.scrollView bringSubviewToFront:textField];
        self.selectedIndex = [self.questionTextViews indexOfObject:textField];
        [self unAnimateTextViewsFromTextView:[self textFieldForIndex:[SOQuestionModel numberOfQuestionTypes]]];
    }
}

- (void)animateTextViewsFromTextView:(UITextField *)textField {
    int nextIndex = textField.tag +1;
    [self textFieldForIndex:nextIndex].hidden = NO;
    [UIView animateWithDuration:0.125 animations:^{
        [self textFieldForIndex:textField.tag].frame = CGRectMake(textField.frame.origin.x, [self originHeightForTextViewIndex:textField.tag], textField.frame.size.width, TITLE_TEXT_FIELD_HEIGHT);
        [self textFieldForIndex:nextIndex].frame = CGRectMake(textField.frame.origin.x, [self originHeightForTextViewIndex:nextIndex]+BOUNCE_HEIGHT, textField.frame.size.width, TITLE_TEXT_FIELD_HEIGHT);
    } completion:^(BOOL finished) {
        if (nextIndex != [SOQuestionModel numberOfQuestionTypes]) {
            [self animateTextViewsFromTextView:self.questionTextViews[nextIndex]];
        } else {
            self.textFieldsAreAnimated = YES;
            [UIView animateWithDuration:.125 animations:^{
                [self textFieldForIndex:nextIndex].frame = CGRectMake(textField.frame.origin.x, [self originHeightForTextViewIndex:nextIndex], textField.frame.size.width, TITLE_TEXT_FIELD_HEIGHT);
            }];
            [self bringTextViewsToFrontInCorrectOrder];
        }
    }];
}

- (void)unAnimateTextViewsFromTextView:(UITextField *)textField {
    int nextIndex = textField.tag + 1;
    
    [UIView animateWithDuration:0.125 animations:^{
        if (textField.tag != 0) {
            textField.frame = [self rectForTextFieldatHeight:[self originHeightForTextViewIndex:textField.tag] + 10];
        }
        if (textField.tag != [SOQuestionModel numberOfQuestionTypes] ) {
            [self textFieldForIndex:nextIndex].frame = [self rectForTextFieldatHeight:[self originHeightForTextViewIndex:textField.tag]+10];
        }
    } completion:^(BOOL finished) {
        UITextField *completionTextField = textField;
        if (nextIndex == self.selectedIndex) {
            UITextField *nextTextField = [self textFieldForIndex:nextIndex];
            [self.questionTextViews removeObject:nextTextField];
            [self.questionTextViews insertObject:nextTextField atIndex:completionTextField.tag];
            completionTextField.tag++;
            self.selectedIndex--;
            completionTextField = [self textFieldForIndex:self.selectedIndex];
            completionTextField.tag--;
            
        }
        
        if (completionTextField.tag != 0) {
            if (completionTextField.tag != [SOQuestionModel numberOfQuestionTypes]) {
                [self textFieldForIndex:nextIndex].hidden = YES;
            } 
            [self unAnimateTextViewsFromTextView:self.questionTextViews[completionTextField.tag - 1]];
        } else {
            self.textFieldsAreAnimated = NO;
            [UIView animateWithDuration:.125 animations:^{
                CGRect frame = CGRectMake([self textFieldForIndex:0].frame.origin.x, [self originHeightForTextViewIndex:0], completionTextField.frame.size.width, TITLE_TEXT_FIELD_HEIGHT);
                [self textFieldForIndex:0].frame = frame;
                [self textFieldForIndex:1].frame = frame;
            }];
            
        }
    }];
}

- (void)bringTextViewsToFrontInCorrectOrder {
    for (int i = [SOQuestionModel numberOfQuestionTypes] ; i >= 0 ; i--) {
        [self.scrollView bringSubviewToFront:self.questionTextViews[i]];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.scrollView bringSubviewToFront:textField];
    [self questionTypeTextFieldTapped:textField];
    return NO;
}

-(UITextField *)textFieldForIndex:(int)index {
    return (UITextField *)self.questionTextViews[index];
}

-(CGFloat)originHeightForTextViewIndex:(int)index {
    return self.frame.size.height / 16 - (TITLE_TEXT_FIELD_HEIGHT / 2.0) + (TITLE_TEXT_FIELD_HEIGHT + 5) * index;
}

-(void)prepareTextFieldsForAnimating {
    for (int i=1; i<self.questionTextViews.count; ++i) {
        [self textFieldForIndex:i].frame = [self rectForTextFieldatHeight:[self originHeightForTextViewIndex:i-1]+BOUNCE_HEIGHT];
    }
}

-(CGRect)rectForTextFieldatHeight:(CGFloat)height {
    UITextField *anchorTextField = [self textFieldForIndex:0];
    return CGRectMake(anchorTextField.frame.origin.x, height, anchorTextField.frame.size.width , anchorTextField.frame.size.height);
}

- (NSString *)questionType {
    return ((UITextField *)self.questionTextViews[0]).text;
}

- (void)keyboardWillShow:(NSNotification *)notification {
//    // Get the size of the keyboard.
    if (![self.questionText isFirstResponder]) {
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = self.scrollView.frame;
            self.scrollView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-keyboardSize.height);
        } completion:^(BOOL finished) {
            [self.scrollView scrollRectToVisible:((UIView *)self.answerView).frame animated:YES];
        }];
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.scrollView.frame;
    self.scrollView.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:duration animations:^{
        
    }];
}

- (void)answerViewSelected:(id)sender {
    [(UIView *)self.answerView removeFromSuperview];
    
    if (self.answerOptions.selectedSegmentIndex == 0) {
        self.answerView = [[SOAnswerYesOrNoView alloc] initWithFrame:CGRectZero withAnswers:[SOQuestionModel defaultYesOrNoAnswers] forCreation:YES];
    } else if (self.answerOptions.selectedSegmentIndex == 1) {
        self.answerView = [[SOAnswerMutipleChoicesView alloc] initWithFrame:CGRectZero withAnswers:[SOQuestionModel defaultChoicesAnswers] forCreation:YES];
    } else {
        if (self.imagesView.areImagesLayoutOutHorrizontal) {
            self.answerView = [[SOAnswerThisOrThatView alloc] initWithFrame:CGRectZero withAnswers:[SOQuestionModel defaultLeftOrRightAnswers] forCreation:YES];
        } else {
            self.answerView = [[SOAnswerThisOrThatView alloc] initWithFrame:CGRectZero withAnswers:[SOQuestionModel defaultTopOrBottomAnswers] forCreation:YES];
        }
        
    }
    
    
    self.answerView.delegate = self;
    
    [self.scrollView addSubview:(UIView *)self.answerView];
    
    [self layoutSubviews];
}

- (NSArray *)answers {
    return self.answerView.answers;
}

- (BOOL)fieldsAreValid {
    BOOL fieldsAreValid = YES;
    if (self.questionText.text.length == 0) {
        fieldsAreValid = NO;
    }
    
    return fieldsAreValid;
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [self.questionText resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - <SOAnswerViewDelegate>

- (void) containerViewNeedsLayout {
    [self layoutSubviews];
}

- (void)alternateButtonPressed {
    if (self.answerView.answers.count < 4) {
        [self.answerView addAnswer:@"Another Choice"];
        [self layoutSubviews];
    }
}

- (void)answerViewDidBeginEditingAtHeight:(CGFloat)height{

}

- (void)answerViewEndBeginEditing {
    
}

@end
