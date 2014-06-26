//
//  SOLoginView.m
//  SecondOpinion
//
//  Created by Eric Jones on 11/29/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOLoginView.h"
#import "SOStyle.h"

#define TEXTFIELD_WIDTH 150
#define TEXTFIELD_HEIGHT 30
#define HORIZONTAL_MARGIN 10
#define PADDING 5

@interface SOLoginView () <UITextFieldDelegate>

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *logoImageView;
@property (nonatomic) UIButton *loginButton;
@property (nonatomic) UIButton *registerAccountButton;
@property (nonatomic) UITextField *usernameField;
@property (nonatomic) UITextField *passwordField;
@property (nonatomic) UILabel *usernameLabel;
@property (nonatomic) UILabel *passwordLabel;
@property (nonatomic) UIActivityIndicatorView *logingInSpinner;

@end

@implementation SOLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureTitleLabel];
        [self configureLogoImageView];
        [self configureUsernameTextfield];
        [self configurePasswordTextField];
        [self configureLoginButton];
        [self configureRegisterButton];
        [self configureLogingInSpinner];
        self.backgroundColor = [SOStyle headerColor];
    }
    return self;
}

- (void)configureTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Ask n Tell";
    label.font = [SOStyle defaultFontWithSize:40];
    label.backgroundColor = [SOStyle headerColor];
    label.textColor = [UIColor blackColor];
    
    [self addSubview:label];
    self.titleLabel = label;
}

- (void)configureLogoImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"ant image.png"];
    
    [self addSubview:imageView];
    self.logoImageView = imageView;

}

- (void)configureUsernameTextfield {
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [SOStyle defaultFontWithSize:14];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = [UIColor blackColor];
    textField.backgroundColor = [SOStyle questionColor];
    textField.layer.cornerRadius = 4.0f;
    UIView *paddedView = [[UIView alloc] init];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = paddedView;
    textField.delegate = self;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self addSubview:textField];
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
    
    [self addSubview:textField];
    self.passwordField = textField;
}

- (void)configureLoginButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Login" forState:UIControlStateNormal];
    button.frame = CGRectZero;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [SOStyle defaultFontWithSize:15];
    [button addTarget:self action:@selector(loginButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginButton = button;
    [self addSubview:button];
}

- (void)configureRegisterButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Register" forState:UIControlStateNormal];
    button.frame = CGRectZero;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [SOStyle defaultFontWithSize:15];
    [button addTarget:self action:@selector(registerButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.registerAccountButton = button;
    [self addSubview:button];
}

- (void)configureLogingInSpinner {
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.hidden = YES;
    [self addSubview:view];
    self.logingInSpinner = view;
}


- (void)layoutSubviews {
    [self layoutTitleLabel];
    [self layoutLogoImageView];
    [self layoutUsernameTextfield];
    [self layoutPasswordTextfield];
    [self layoutLoginButton];
    [self layoutRegisterAccountButton];
    [self layoutLogingInSpinner];

}

- (void)layoutTitleLabel {
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.center.x, 100);
}

- (void)layoutLogoImageView {
    self.logoImageView.frame = CGRectMake(0, 0, 100, 50);
    self.logoImageView.center = CGPointMake(self.center.x, CGRectGetMaxY(self.titleLabel.frame)+PADDING);
}


- (void)layoutUsernameTextfield {
    self.usernameField.frame = CGRectMake(self.center.x - TEXTFIELD_WIDTH/2, CGRectGetMaxY(self.logoImageView.frame), TEXTFIELD_WIDTH, TEXTFIELD_HEIGHT);
    self.usernameField.leftView.frame = CGRectMake(0, 0, HORIZONTAL_MARGIN, self.usernameField.frame.size.height);
}

- (void)layoutPasswordTextfield {
    self.passwordField.frame = CGRectMake(self.center.x - TEXTFIELD_WIDTH/2, CGRectGetMaxY(self.usernameField.frame) + 1, TEXTFIELD_WIDTH, TEXTFIELD_HEIGHT);
    self.passwordField.leftView.frame = CGRectMake(0, 0, HORIZONTAL_MARGIN, self.passwordField.frame.size.height);
}

- (void)layoutLoginButton {
    [self.loginButton sizeToFit];
    self.loginButton.center = CGPointMake(CGRectGetMinX(self.passwordField.frame) + PADDING/2 + self.loginButton.frame.size.width/2 + HORIZONTAL_MARGIN, CGRectGetMaxY(self.passwordField.frame) + PADDING + self.loginButton.frame.size.height/2);
}

- (void)layoutRegisterAccountButton {
    [self.registerAccountButton sizeToFit];
    self.registerAccountButton.center = CGPointMake(CGRectGetMaxX(self.passwordField.frame) - PADDING/2 - self.registerAccountButton.frame.size.width/2 - HORIZONTAL_MARGIN, CGRectGetMaxY(self.passwordField.frame) + PADDING + self.registerAccountButton.frame.size.height/2);
}

- (void)layoutLogingInSpinner {
    self.logingInSpinner.frame = CGRectMake(self.center.x - 25, CGRectGetMinY(self.registerAccountButton.frame) , 50, 50);
}

- (void)loginButtonTapped {
    if ([self fieldsAreValid]) {
        [self.delegate loginWithUsername:self.usernameField.text password:self.passwordField.text];
        [self.logingInSpinner startAnimating];
        [UIView animateWithDuration:1.0 animations:^{
            self.loginButton.alpha = 0.0;
            self.registerAccountButton.alpha = 0.0;
            self.logingInSpinner.hidden = NO;
        } completion:^(BOOL finished) {
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Form" message:@"The registration process can not continue until there is a username and password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)registerButtonTapped {
    [self.delegate registerButtonTapped];
}

- (BOOL)fieldsAreValid {
    BOOL fieldsAreValid = YES;
    if (self.usernameField.text.length == 0) {
        fieldsAreValid = NO;
    } else if (self.passwordField.text.length == 0) {
        fieldsAreValid = NO;
    }
    
    return fieldsAreValid;
}

- (void)loginFailed {
    [self.logingInSpinner stopAnimating];
    [UIView animateWithDuration:1.0 animations:^{
        self.loginButton.alpha = 1.0;
        self.registerAccountButton.alpha = 1.0;
        self.logingInSpinner.hidden = YES;
    } completion:^(BOOL finished) {
        [self layoutSubviews];
    }];
}


#pragma mark UITextfieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    NSString *text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:textField.font}];
    
    BOOL tooLong = textSize.width > textField.bounds.size.width-20;
    
    return !tooLong;
}



@end
