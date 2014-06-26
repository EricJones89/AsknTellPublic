//
//  SOProfileView.m
//  SecondOpinion
//
//  Created by Eric Jones on 11/23/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOProfileView.h"
#import "SOStyle.h"

#define PADDING 10
#define HEADER_MARGIN 55
#define BACKGROUND_VIEW_PADDING 10
#define TABLE_VIEW_PADDING 5

@interface SOProfileView () <UITextFieldDelegate>

@property (nonatomic) UIView *titleBar;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *answerTableViewLabel;
@property (nonatomic) UIButton *backButton;
@property (nonatomic) UIButton *logoutButton;
@property (nonatomic) UIButton *importImageButton;
@property (nonatomic) UIButton *captureImageButton;
@property (nonatomic) UIButton *editDisplayNameButton;
@property (nonatomic) UIView *backgroundView;

@end

@implementation SOProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configuretitleBar];
        [self configureTitleLabel];
        [self configureBackButton];
        [self configureLogoutButton];
        [self configureBackgroundView];
        [self configureNameField];
        [self configureTableViewLabel];
        [self configureTableView];
        [self configureImportImageButton];
        [self configureCaptureImageButton];
        [self configureEditDisplayNameButton];
        self.backgroundColor = [SOStyle backgroundColor];
    }
    return self;
}

- (void)configureBackgroundView {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [SOStyle questionColor];
    
    [self addSubview:backgroundView];
    self.backgroundView = backgroundView;
}

- (void) configureEditDisplayNameButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Edit Display Name" forState:UIControlStateNormal];
    button.frame = CGRectZero;
    [button setTitleColor:[SOStyle headerColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(editDisplayNameButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.editDisplayNameButton = button;
    [self addSubview:button];
}

- (void)configureBackButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"Slider_Arrow.png"] forState:UIControlStateNormal];
    button.frame = CGRectZero;
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.backButton = button;
    
}

- (void)configureLogoutButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Logout" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(logoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [SOStyle defaultFontWithSize:14];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self addSubview:button];
    self.logoutButton = button;
    
}

- (void)configureTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    tableView.tableHeaderView = self.answerTableViewLabel;
    
    self.tableView = tableView;
    [self addSubview:tableView];
}

- (void)configureTableViewLabel {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectZero;
    label.textColor = [UIColor blackColor];
    label.font = [SOStyle defaultFontWithSize:18];
    label.text = @"Asked Questions";
    
    self.answerTableViewLabel = label;
}

- (void)configureNameField {
    UITextField *field = [[UITextField alloc] init];
    field.backgroundColor = [UIColor clearColor];
    field.frame = CGRectZero;
    field.textColor = [UIColor blackColor];
    field.font = [SOStyle defaultFontWithSize:16];
    UIView *paddedView = [[UIView alloc] init];
    field.leftViewMode = UITextFieldViewModeAlways;
    field.leftView = paddedView;
    field.delegate = self;
    field.textAlignment = NSTextAlignmentLeft;
    field.userInteractionEnabled = NO;

    
    self.nameField = field;
    [self addSubview:field];
}

- (void)configureTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Profile";
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectZero;
    label.textColor = [UIColor blackColor];
    label.font = [SOStyle defaultFontWithSize:20];
    
    self.titleLabel = label;
    [self addSubview:label];
}

- (void)configuretitleBar {
    UIView *titleBar = [[UIView alloc] initWithFrame:CGRectZero];
    titleBar.backgroundColor = [SOStyle headerColor];
    
    self.titleBar = titleBar;
    [self addSubview:titleBar];
}

- (void)configureImportImageButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"album.png"] forState:UIControlStateNormal];
    button.frame = CGRectZero;
    [button addTarget:self action:@selector(importImageButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.importImageButton = button;
    [self addSubview:button];
}

- (void)configureCaptureImageButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    button.frame = CGRectZero;
    [button addTarget:self action:@selector(captureImageButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.captureImageButton = button;
    [self addSubview:button];
}

- (void)configureProfileImageViewWithImage:(UIImage *)profileImage {
    self.profileImageView = [[UIImageView alloc] initWithImage:profileImage];
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.profileImageView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.profileImageView];
}

- (void)layoutSubviews {
    [self layoutTitleBar];
    [self layoutTitleLabel];
    [self layoutBackButton];
    [self layoutLogoutButton];
    [self layoutProfileImageView];
    [self layoutImportImageButton];
    [self layoutCaptureImageButton];
    [self layoutNameLabel];
    [self layoutEditDisplayNameButton];
    [self layoutBackgroundView];
    [self layoutTableView];
}

- (void)layoutBackgroundView {
    self.backgroundView.frame = CGRectMake(CGRectGetMinX(self.profileImageView.frame) - BACKGROUND_VIEW_PADDING,CGRectGetMinY(self.profileImageView.frame) - BACKGROUND_VIEW_PADDING , self.frame.size.width-BACKGROUND_VIEW_PADDING*2, self.profileImageView.frame.size.height + 2*PADDING);
}

- (void)layoutTitleLabel {
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.center.x, HEADER_MARGIN/2+10);
}

- (void)layoutTitleBar {
    self.titleBar.frame = CGRectMake(0, 0, self.frame.size.width, HEADER_MARGIN);
}

- (void)layoutLogoutButton {
    [self.logoutButton sizeToFit];
    self.logoutButton.center = CGPointMake(self.frame.size.width - self.logoutButton.frame.size.width/2 - PADDING, PADDING+20 + self.logoutButton.frame.size.height/2) ;
}

- (void)layoutBackButton {
    self.backButton.frame = CGRectMake(PADDING, PADDING+13, 40, HEADER_MARGIN/2+10);
}

- (void)layoutProfileImageView {
    
    self.profileImageView.frame = CGRectMake(self.frame.size.width/16 , HEADER_MARGIN + 2*PADDING, self.frame.size.width/3, self.frame.size.width/3);
}

- (void)layoutImportImageButton {
    self.importImageButton.frame = CGRectMake(CGRectGetMaxX(self.profileImageView.frame) + PADDING, CGRectGetMaxY(self.profileImageView.frame) - 25, 25, 25);
}

- (void)layoutCaptureImageButton {
    self.captureImageButton.frame = CGRectMake(CGRectGetMaxX(self.importImageButton.frame) + PADDING, CGRectGetMaxY(self.profileImageView.frame) - 25, 25, 25);
}

- (void)layoutNameLabel {
    [self.nameField sizeToFit];
    self.nameField.center = CGPointMake(CGRectGetMaxX(self.profileImageView.frame) + PADDING + self.nameField.frame.size.width/2, CGRectGetMidY(self.profileImageView.frame) - self.nameField.frame.size.height/2);
}

- (void)layoutEditDisplayNameButton {
    [self.editDisplayNameButton sizeToFit];
    self.editDisplayNameButton.center = CGPointMake(CGRectGetMaxX(self.profileImageView.frame) + PADDING + self.editDisplayNameButton.frame.size.width/2, CGRectGetMaxY(self.nameField.frame) + self.editDisplayNameButton.frame.size.height/2);
}

- (void)layoutTableView {
    self.tableView.frame = CGRectMake(TABLE_VIEW_PADDING, CGRectGetMaxY(self.backgroundView.frame) + PADDING, self.frame.size.width - 2 * TABLE_VIEW_PADDING, self.frame.size.height - (CGRectGetMaxY(self.backgroundView.frame) + 2*PADDING));
}

- (void)logoutButtonPressed {
    [PFUser logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLogoutEvent" object:self];
}

- (void)backButtonPressed {
    [self.delegate backButtonPressed];
}

- (void)setProfileImage:(UIImage *)profileImage {
    [self configureProfileImageViewWithImage:profileImage];
    
}

- (void)importImageButtonTapped {
    [self.delegate importImageButtonTappedForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)captureImageButtonTapped {
    [self.delegate importImageButtonTappedForSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)editDisplayNameButtonTapped {
    [self.editDisplayNameButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.editDisplayNameButton addTarget:self action:@selector(doneButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self layoutEditDisplayNameButton];
    self.nameField.userInteractionEnabled = YES;
    [self.nameField becomeFirstResponder];
}

- (void)doneButtonTapped {
    [self.nameField resignFirstResponder];
    self.nameField.userInteractionEnabled = NO;
    [self.editDisplayNameButton setTitle:@"Edit Display Name" forState:UIControlStateNormal];
    [self.editDisplayNameButton addTarget:self action:@selector(editDisplayNameButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self layoutEditDisplayNameButton];
    [self.delegate updateProfileDisplayNameTo:self.nameField.text];
}

#pragma mark UITextfieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        [self doneButtonTapped];
        return NO;
    }
    
    return YES;
}


@end
