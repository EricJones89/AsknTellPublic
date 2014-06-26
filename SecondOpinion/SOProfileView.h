//
//  SOProfileView.h
//  SecondOpinion
//
//  Created by Eric Jones on 11/23/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SOProfileViewDelegate <NSObject>

- (void)backButtonPressed;
- (void)importImageButtonTappedForSourceType:(UIImagePickerControllerSourceType)type;
- (void)updateProfileDisplayNameTo:(NSString *)newName;

@end

@interface SOProfileView : UIView

- (void)setProfileImage:(UIImage *)profileImage;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UITextField *nameField;
@property (nonatomic, weak) id<SOProfileViewDelegate> delegate;
@property (nonatomic) UIImageView *profileImageView;


@end
