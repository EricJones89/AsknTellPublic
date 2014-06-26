//
//  SOCreateFilterFeedView.m
//  SecondOpinion
//
//  Created by Eric Jones on 1/27/14.
//  Copyright (c) 2014 Eric Jones. All rights reserved.
//

#import "SOCreateFilterFeedView.h"
#import "SOQuestionModel.h"
#import "SOStyle.h"

#define Vertical_Padding 10
#define Horizontal_Padding 10
#define HashTag_PlaceHolder_Text @"HashTags (i.e. #imAwesome #noYoureNot ...)"
#define Creator_PlaceHolder_Text @"Creators (i.e. @Ant @Froduck ...)"

@interface SOCreateFilterFeedView () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic) NSMutableArray *catergoryButtons;
@property (nonatomic) UITextField *titleTextField;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UITextView *creatorTextView;
@property (nonatomic) UITextView *hashTagTextView;
@property (nonatomic) UIButton *createFeedFilterButton;
@property (nonatomic) UIButton *cancelButton;



@end

@implementation SOCreateFilterFeedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [SOStyle headerColor];
        [self configureScrollView];
        [self configureTitleTextField];
        [self createCategoryButtons];
        [self configureHashTagTextView];
        [self configureCreatorTextView];
        [self configureCreateFeedFilterButton];
        [self configureCancelButton];
        
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

- (void)configureCancelButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    button.frame = CGRectZero;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [SOStyle defaultFontWithSize:15];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 10.0;
    [button addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton = button;
    [self.scrollView addSubview:button];
}

- (void)configureScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    self.scrollView = scrollView;
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:scrollView];
}

- (void)configureCreateFeedFilterButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Create Feed" forState:UIControlStateNormal];
    button.frame = CGRectZero;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 10.0;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [SOStyle defaultFontWithSize:15];
    [button addTarget:self action:@selector(createFeedFilterButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.createFeedFilterButton = button;
    [self.scrollView addSubview:button];
}

- (void)configureCreatorTextView {
    UITextView *creatorText = [[UITextView alloc] init];
    creatorText.text = Creator_PlaceHolder_Text;
    creatorText.layer.cornerRadius = 10.0;
    creatorText.backgroundColor = [SOStyle questionColor];
    creatorText.returnKeyType = UIReturnKeyDone;
    creatorText.font = [SOStyle defaultFontWithSize:15.0];
    creatorText.textColor = [UIColor blackColor];
    creatorText.layer.borderColor = [UIColor whiteColor].CGColor;
    creatorText.layer.borderWidth = 1.0f;
    creatorText.delegate = self;
    
    [self.scrollView addSubview:creatorText];
    self.creatorTextView = creatorText;
}

- (void)configureHashTagTextView {
    UITextView *hashTagText = [[UITextView alloc] init];
    hashTagText.text = HashTag_PlaceHolder_Text;
    hashTagText.layer.cornerRadius = 10.0;
    hashTagText.backgroundColor = [SOStyle questionColor];
    hashTagText.returnKeyType = UIReturnKeyDone;
    hashTagText.font = [SOStyle defaultFontWithSize:15.0];
    hashTagText.textColor = [UIColor blackColor];
    hashTagText.layer.borderColor = [UIColor whiteColor].CGColor;
    hashTagText.layer.borderWidth = 1.0f;
    hashTagText.delegate = self;
    
    [self.scrollView addSubview:hashTagText];
    self.hashTagTextView = hashTagText;
}

- (void)configureTitleTextField {
    
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [SOStyle defaultFontWithSize:14];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = [UIColor blackColor];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Filter Title" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];    textField.backgroundColor = [SOStyle questionColor];
    textField.layer.cornerRadius = 10.0;
    UIView *paddedView = [[UIView alloc] init];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = paddedView;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    [self.scrollView addSubview:textField];
    self.titleTextField = textField;

}

- (void)createCategoryButtons {
    
    self.catergoryButtons = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 8 ; i++) {
        SOQuestionType type = i;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:[SOQuestionModel imageNameForType:type]];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 15.0;
        [button addTarget:self action:@selector(categoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [self.catergoryButtons addObject:button];
        
    }
}

- (void)cancelButtonTapped {
    [self viewDidDisappear:YES];
    [self.delegate cancelButtonTapped];
}

- (void)createFeedFilterButtonTapped {
    
    [self viewDidDisappear:YES];
    
    NSArray *categories = [self categoriesFromSelectedButtons];
    NSArray *hashtags = [SOQuestionModel getHashtagsForString:self.hashTagTextView.text];
    NSArray *creators = [SOQuestionModel getCreatorsForString:self.creatorTextView.text];
    
    [self.delegate createFeedFilterWithTitle:self.titleTextField.text? self.titleTextField.text : @"Feed Title" categories:categories hashtags:hashtags creators:creators];
    
}

- (NSArray *)categoriesFromSelectedButtons {
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    for (int i =0; i < self.catergoryButtons.count; i++) {
        if (((UIButton *)self.catergoryButtons[i]).isSelected) {
            [categories addObject:[SOQuestionModel questionTypeTextForQuesitonType:i]];
        }
    }
    
    return categories;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutScrollView];
    [self layoutTitleTextField];
    [self layoutButtons];
    [self layoutHashTagsTextView];
    [self layoutCreatorTextView];
    [self layoutFeedFilterButton];
    [self layoutCancelAccountButton];
}

- (void)layoutScrollView {
    [self.scrollView layoutSubviews];
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.creatorTextView.frame) + 150);
    [self.scrollView layoutSubviews];
}

- (void)layoutFeedFilterButton {
    [self.createFeedFilterButton sizeToFit];
    self.createFeedFilterButton.frame = CGRectMake(0, 0, self.createFeedFilterButton.frame.size.width + 50, self.createFeedFilterButton.frame.size.height + 10);
    self.createFeedFilterButton.center = CGPointMake(self.center.x + self.createFeedFilterButton.frame.size.width/2 + Horizontal_Padding/2, CGRectGetMaxY(self.creatorTextView.frame) + Vertical_Padding + self.createFeedFilterButton.frame.size.height/2);
}

- (void)layoutCancelAccountButton {
    [self.cancelButton sizeToFit];
    self.cancelButton.frame = CGRectMake(0, 0, self.cancelButton.frame.size.width + 50, self.cancelButton.frame.size.height + 10);
    self.cancelButton.center = CGPointMake(self.center.x - self.cancelButton.frame.size.width/2 -Horizontal_Padding/2, CGRectGetMaxY(self.creatorTextView.frame) + Vertical_Padding + self.cancelButton.frame.size.height/2);
}

- (void)layoutHashTagsTextView {
    self.hashTagTextView.frame = CGRectMake(Horizontal_Padding, CGRectGetMaxY(((UIView *)[self.catergoryButtons lastObject]).frame)+Vertical_Padding, self.frame.size.width-2*Horizontal_Padding, 100);
}

- (void)layoutCreatorTextView {
    self.creatorTextView.frame = CGRectMake(Horizontal_Padding, CGRectGetMaxY(self.hashTagTextView.frame)+Vertical_Padding, self.frame.size.width-2*Horizontal_Padding, 100);
}

- (void)layoutTitleTextField {
    self.titleTextField.frame = CGRectMake(Horizontal_Padding, Vertical_Padding, self.frame.size.width/2, 30);
    self.titleTextField.center = CGPointMake(self.center.x, Vertical_Padding*2 + 15);
    self.titleTextField.leftView.frame = CGRectMake(0, 0, 10, self.titleTextField.frame.size.height);
}

- (void)layoutButtons {
    CGFloat buttonSize = ((self.frame.size.width - Horizontal_Padding) / 4)-Horizontal_Padding;
    for (int i=0; i<self.catergoryButtons.count; ++i) {
        UIButton *button = self.catergoryButtons[i];
        if (i == 0) {
            button.frame = CGRectMake(Horizontal_Padding, CGRectGetMaxY(self.titleTextField.frame)+Vertical_Padding, buttonSize, buttonSize);
        } else if (i==4) {
            button.frame = CGRectMake(Horizontal_Padding, CGRectGetMaxY(((UIView *)[self.catergoryButtons firstObject]).frame)+Vertical_Padding, buttonSize, buttonSize);
        } else {
            UIButton *previousButton = self.catergoryButtons[i-1];
            button.frame = CGRectMake(Horizontal_Padding + CGRectGetMaxX(previousButton.frame), previousButton.frame.origin.y, buttonSize, buttonSize);
        }
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
        UIView *firstResponder = self.hashTagTextView.isFirstResponder ? self.hashTagTextView : self.creatorTextView;
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = self.scrollView.frame;
            self.scrollView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-keyboardSize.height);
        } completion:^(BOOL finished) {
            if (!self.titleTextField.isFirstResponder) {
                [self.scrollView scrollRectToVisible:firstResponder.frame animated:YES];
            }
        }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.scrollView.frame;
    self.scrollView.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:duration animations:^{
        
    }];
}

- (void)categoryButtonTapped:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setSelected:NO];
        sender.backgroundColor = [UIColor whiteColor];
    } else {
        [sender setSelected:YES];
        sender.backgroundColor = [SOStyle backgroundColor];
    }
}

#pragma mark UITextViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self.hashTagTextView && [textView.text isEqualToString:HashTag_PlaceHolder_Text]) {
        textView.text = @"";
    } else if (textView == self.creatorTextView && [textView.text isEqualToString:Creator_PlaceHolder_Text]) {
        textView.text = @"";
    }
    [self.scrollView scrollRectToVisible:textView.frame animated:YES];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
