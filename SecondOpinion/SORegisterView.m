//
//  SORegisterView.m
//  SecondOpinion
//
//  Created by Eric Jones on 11/29/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SORegisterView.h"
#import "SOStyle.h"
#import "SOProfileModel.h"

#define TEXTFIELD_WIDTH 150
#define TEXTFIELD_HEIGHT 30
#define HORIZONTAL_MARGIN 10
#define PROFILE_IMAGE_DIAMETER 90
#define PADDING 5

@interface SORegisterView () <UITextFieldDelegate>

@property (nonatomic) UIButton *registerAccountButton;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UITextField *usernameField;
@property (nonatomic) UITextField *passwordField;
@property (nonatomic) UITextField *displayNameField;
@property (nonatomic) UITextField *emailField;
@property (nonatomic) UIButton *importImageButton;
@property (nonatomic) UIButton *captureImageButton;
@property (nonatomic) UILabel *optionalLabel;
@property (nonatomic) UILabel *eulaLabel;
@property (nonatomic) UITextField *ageField;
@property (nonatomic) UIButton *maleButton;
@property (nonatomic) UIButton *femaleButton;
@property (nonatomic) UIActivityIndicatorView *registeringSpinner;
@property (nonatomic) UIScrollView *scrollView;

@end

@implementation SORegisterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureScrollView];
        [self configureLogoImageView];
        [self configureUsernameTextfield];
        [self configurePasswordTextField];
        [self configureDisplayNameField];
        [self configureEmailField];
        [self configureRegisterButton];
        [self configureCancelButton];
        [self configureRegisteringSpinner];
        [self configureImportImageButton];
        [self configureCaptureImageButton];
        [self configureAgeTextField];
        [self configureOptionalLabel];
        [self configureMaleButton];
        [self configureFemaleButton];
        [self configureEulaLabel];
        self.backgroundColor = [SOStyle headerColor];
        
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

- (void)configureScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    self.scrollView = scrollView;
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:scrollView];
}


- (void)configureLogoImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *image = [UIImage imageNamed:@"default ProfilePicture.png"];
    imageView.image = [SOProfileModel circularCrop:image inRect:CGRectMake(0, 0, PROFILE_IMAGE_DIAMETER, PROFILE_IMAGE_DIAMETER)] ;
    
    [self.scrollView addSubview:imageView];
    self.profileImageView = imageView;
    
}

- (void)configureUsernameTextfield {
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [SOStyle defaultFontWithSize:14];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = [UIColor blackColor];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];    textField.backgroundColor = [SOStyle questionColor];
    textField.layer.cornerRadius = 4.0f;
    UIView *paddedView = [[UIView alloc] init];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = paddedView;
    textField.delegate = self;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self.scrollView addSubview:textField];
    self.usernameField = textField;
}

- (void)configurePasswordTextField {
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [SOStyle defaultFontWithSize:14];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = [UIColor blackColor];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];    textField.backgroundColor = [SOStyle questionColor];
    textField.layer.cornerRadius = 4.0f;
    textField.secureTextEntry = YES;
    UIView *paddedView = [[UIView alloc] init];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = paddedView;
    textField.delegate = self;
    
    [self.scrollView addSubview:textField];
    self.passwordField = textField;
}

- (void)configureDisplayNameField {
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [SOStyle defaultFontWithSize:14];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = [UIColor blackColor];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Display Name" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];    textField.backgroundColor = [SOStyle questionColor];
    textField.layer.cornerRadius = 4.0f;
    UIView *paddedView = [[UIView alloc] init];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = paddedView;
    textField.delegate = self;
    
    [self.scrollView addSubview:textField];
    self.displayNameField = textField;
}

- (void)configureEmailField {
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [SOStyle defaultFontWithSize:14];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = [UIColor blackColor];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];    textField.backgroundColor = [SOStyle questionColor];
    textField.layer.cornerRadius = 4.0f;
    UIView *paddedView = [[UIView alloc] init];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = paddedView;
    
    [self.scrollView addSubview:textField];
    self.emailField = textField;
}

- (void)configureOptionalLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.font = [SOStyle defaultFontWithSize:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Optional Fields";
    
    [self.scrollView addSubview:label];
    self.optionalLabel = label;
}

- (void)configureAgeTextField {
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [SOStyle defaultFontWithSize:14];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = [UIColor blackColor];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Age" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];    textField.backgroundColor = [SOStyle questionColor];
    textField.layer.cornerRadius = 4.0f;
    UIView *paddedView = [[UIView alloc] init];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = paddedView;
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [self.scrollView addSubview:textField];
    self.ageField = textField;
}

- (void)configureMaleButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"male.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"male-selected.png"] forState:UIControlStateSelected];
    button.frame = CGRectZero;
    [button addTarget:self action:@selector(maleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.maleButton = button;
    [self.scrollView addSubview:button];
}

- (void)configureFemaleButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"female.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"female-selected.png"] forState:UIControlStateSelected];
    button.frame = CGRectZero;
    [button addTarget:self action:@selector(femaleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.femaleButton = button;
    [self.scrollView addSubview:button];
}


- (void)configureRegisterButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Register" forState:UIControlStateNormal];
    button.frame = CGRectZero;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [SOStyle defaultFontWithSize:15];
    [button addTarget:self action:@selector(registerButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.registerAccountButton = button;
    [self.scrollView addSubview:button];
}

- (void)configureCancelButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    button.frame = CGRectZero;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [SOStyle defaultFontWithSize:15];
    [button addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton = button;
    [self.scrollView addSubview:button];
}

- (void)configureRegisteringSpinner {
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.hidden = YES;
    [self.scrollView addSubview:view];
    self.registeringSpinner = view;
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

- (void)configureEulaLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [SOStyle defaultFontWithSize:8.0];
    label.textAlignment = NSTextAlignmentCenter;
    NSString *string = @"By registering you agree to this End User License Agreement";
    NSMutableAttributedString *finalString= [[NSMutableAttributedString alloc] initWithString:string];
    [finalString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[string rangeOfString:@"By registering you agree to this"]];
    [finalString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[string rangeOfString:@"End User License Agreement"]];
    label.attributedText = finalString;
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eulaLabelTapped)];
    [label addGestureRecognizer:tapGesture];
    
    [self.scrollView addSubview:label];
    self.eulaLabel = label;
}


- (void)layoutSubviews {
    [self layoutProfileImageView];
    [self layoutImportImageButton];
    [self layoutCaptureImageButton];
    [self layoutUsernameTextfield];
    [self layoutPasswordTextfield];
    [self layoutDisplayNameTextfield];
    [self layoutEmailTextfield];
    [self layoutOptionalLabel];
    [self layoutAgeTextfield];
    [self layoutMaleButton];
    [self layoutFemaleButton];
    [self layoutEulaLabel];
    [self layoutRegisterAccountButton];
    [self layoutCancelAccountButton];
    [self layoutRegisteringSpinner];
    [self layoutScrollView];

}

- (void)layoutScrollView {
    
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.cancelButton.frame) + 150);
    [self.scrollView layoutSubviews];
}

- (void)layoutImportImageButton {
    self.importImageButton.frame = CGRectMake(CGRectGetMaxX(self.profileImageView.frame) + PADDING, CGRectGetMaxY(self.profileImageView.frame) - 25, 25, 25);
}

- (void)layoutCaptureImageButton {
    self.captureImageButton.frame = CGRectMake(CGRectGetMaxX(self.importImageButton.frame) + PADDING, CGRectGetMaxY(self.profileImageView.frame) -25, 25, 25);
}


- (void)layoutProfileImageView {
    self.profileImageView.frame = CGRectMake(0, 0, PROFILE_IMAGE_DIAMETER, PROFILE_IMAGE_DIAMETER);
    self.profileImageView.center = CGPointMake(self.center.x-PROFILE_IMAGE_DIAMETER/2, PROFILE_IMAGE_DIAMETER - 20);
}

- (void)layoutUsernameTextfield {
    self.usernameField.frame = CGRectMake(self.center.x - TEXTFIELD_WIDTH/2, CGRectGetMaxY(self.captureImageButton.frame) + PADDING, TEXTFIELD_WIDTH, TEXTFIELD_HEIGHT);
    self.usernameField.leftView.frame = CGRectMake(0, 0, HORIZONTAL_MARGIN, self.usernameField.frame.size.height);
}

- (void)layoutPasswordTextfield {
    self.passwordField.frame = CGRectMake(self.center.x - TEXTFIELD_WIDTH/2, CGRectGetMaxY(self.usernameField.frame) + 1, TEXTFIELD_WIDTH, TEXTFIELD_HEIGHT);
    self.passwordField.leftView.frame = CGRectMake(0, 0, HORIZONTAL_MARGIN, self.passwordField.frame.size.height);
}

- (void)layoutDisplayNameTextfield {
    self.displayNameField.frame = CGRectMake(self.center.x - TEXTFIELD_WIDTH/2, CGRectGetMaxY(self.passwordField.frame) + 1, TEXTFIELD_WIDTH, TEXTFIELD_HEIGHT);
    self.displayNameField.leftView.frame = CGRectMake(0, 0, HORIZONTAL_MARGIN, self.displayNameField.frame.size.height);
}

- (void)layoutEmailTextfield {
    self.emailField.frame = CGRectMake(self.center.x - TEXTFIELD_WIDTH/2, CGRectGetMaxY(self.displayNameField.frame) + 1, TEXTFIELD_WIDTH, TEXTFIELD_HEIGHT);
    self.emailField.leftView.frame = CGRectMake(0, 0, HORIZONTAL_MARGIN, self.emailField.frame.size.height);
}


- (void)layoutOptionalLabel {
    [self.optionalLabel sizeToFit];
    self.optionalLabel.center = CGPointMake(self.center.x, CGRectGetMaxY(self.emailField.frame) + self.optionalLabel.frame.size.height/2 + PADDING/2);
}

- (void)layoutAgeTextfield {
    self.ageField.frame = CGRectMake(self.center.x - TEXTFIELD_WIDTH/2, CGRectGetMaxY(self.optionalLabel.frame) + PADDING/2, 40, TEXTFIELD_HEIGHT);
    self.ageField.leftView.frame = CGRectMake(0, 0, HORIZONTAL_MARGIN, self.ageField.frame.size.height);
}

- (void)layoutMaleButton {
    self.maleButton.frame = CGRectMake(CGRectGetMaxX(self.ageField.frame) + PADDING*11, CGRectGetMinY(self.ageField.frame), 25, TEXTFIELD_HEIGHT);
}

- (void)layoutFemaleButton {
    self.femaleButton.frame = CGRectMake(CGRectGetMaxX(self.maleButton.frame) + PADDING, CGRectGetMinY(self.ageField.frame), 25, TEXTFIELD_HEIGHT);
}

- (void)layoutEulaLabel {
    [self.eulaLabel sizeToFit];
    self.eulaLabel.center = CGPointMake(self.center.x, CGRectGetMaxY(self.ageField.frame) + PADDING + self.eulaLabel.frame.size.height/2);
}

- (void)layoutCancelAccountButton {
    [self.cancelButton sizeToFit];
    self.cancelButton.center = CGPointMake(CGRectGetMinX(self.ageField.frame) + PADDING/2 + self.cancelButton.frame.size.width/2 + HORIZONTAL_MARGIN, CGRectGetMaxY(self.eulaLabel.frame) + PADDING + self.cancelButton.frame.size.height/2);
}

- (void)layoutRegisterAccountButton {
    [self.registerAccountButton sizeToFit];
    self.registerAccountButton.center = CGPointMake(CGRectGetMaxX(self.displayNameField.frame) - PADDING/2 - self.registerAccountButton.frame.size.width/2 - HORIZONTAL_MARGIN, CGRectGetMaxY(self.eulaLabel.frame) + PADDING + self.registerAccountButton.frame.size.height/2);
}

- (void)layoutRegisteringSpinner {
    self.registeringSpinner.frame = CGRectMake(self.center.x - 25, CGRectGetMinY(self.registerAccountButton.frame) , 50, 50);
}

- (void)cancelButtonTapped {
    [self viewDidDisappear:YES];
    [self.delegate cancelButtonTapped];
}

- (void)registerButtonTapped {
    if ([self fieldsAreValid]) {
        [self viewDidDisappear:YES];
        PFFile *file = [PFFile fileWithData:UIImagePNGRepresentation(self.profileImageView.image)];
        NSString *gender = @"None Selected";
        if (self.maleButton.selected) {
            gender = @"Male";
        } else if (self.femaleButton.selected) {
            gender = @"Female";
        }
        [self.delegate registerWithUsername:self.usernameField.text password:self.passwordField.text displayName:self.displayNameField.text age:self.ageField.text gender:gender profileImage:file email:self.emailField.text];
        [self.registeringSpinner startAnimating];
        [UIView animateWithDuration:1.0 animations:^{
            self.cancelButton.alpha = 0.0;
            self.registerAccountButton.alpha = 0.0;
            self.registeringSpinner.hidden = NO;
        } completion:^(BOOL finished) {
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Form" message:@"The registration process can not continue until there is a username, password, display name, and email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)importImageButtonTapped {
    [self.delegate importImageButtonTappedForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)captureImageButtonTapped {
    [self.delegate importImageButtonTappedForSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)maleButtonTapped {
    if (self.maleButton.selected) {
        self.maleButton.selected = NO;
    } else {
        self.maleButton.selected = YES;
    }
    if (self.femaleButton.selected) {
        self.femaleButton.selected = NO;
    }
}

- (void)femaleButtonTapped {
    if (self.femaleButton.selected) {
        self.femaleButton.selected = NO;
    } else {
        self.femaleButton.selected = YES;
    }
    if (self.maleButton.selected) {
        self.maleButton.selected = NO;
    }
}

- (void)eulaLabelTapped {
    [self.delegate eulaLabelTapped];
}

- (BOOL)fieldsAreValid {
    BOOL fieldsAreValid = YES;
    if (self.usernameField.text.length == 0) {
        fieldsAreValid = NO;
    } else if (self.passwordField.text.length == 0) {
        fieldsAreValid = NO;
    } else if (self.displayNameField.text.length == 0) {
        fieldsAreValid = NO;
    } else if (self.emailField.text.length == 0) {
        fieldsAreValid = NO;
    }
    return fieldsAreValid;
}

- (void)registrationFailed {
    [self.registeringSpinner stopAnimating];
    [UIView animateWithDuration:1.0 animations:^{
        self.cancelButton.alpha = 1.0;
        self.registerAccountButton.alpha = 1.0;
        self.registeringSpinner.hidden = YES;
    } completion:^(BOOL finished) {
        [self layoutSubviews];
    }];
}

#pragma mark UITextfieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    } else if ([string isEqualToString:@" "]) {
        return NO;
    }

    
    NSString *text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:textField.font}];
    
    BOOL tooLong = textSize.width > textField.bounds.size.width-20;
    
    return !tooLong;
}

#pragma mark UIScrollView Methods

- (void)keyboardWillShow:(NSNotification *)notification {
    //    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.scrollView.frame;
        self.scrollView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-keyboardSize.height);
    } completion:^(BOOL finished) {
        [self.scrollView scrollRectToVisible:self.cancelButton.frame animated:YES];
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.scrollView.frame;
    self.scrollView.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:duration animations:^{
        
    }];
}


@end
