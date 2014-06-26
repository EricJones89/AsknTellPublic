//
//  SORegisterView.h
//  SecondOpinion
//
//  Created by Eric Jones on 11/29/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SORegisterViewDelegate <NSObject>

- (void)registerWithUsername:(NSString *)username password:(NSString *)password displayName:(NSString *)displayName age:(NSString *)age gender:(NSString *)gender profileImage:(PFFile *)image email:(NSString *)email;
- (void)importImageButtonTappedForSourceType:(UIImagePickerControllerSourceType)type;
- (void)cancelButtonTapped;
- (void)eulaLabelTapped;


@end

@interface SORegisterView : UIView

@property (nonatomic) UIImageView *profileImageView;
@property (nonatomic, weak) id<SORegisterViewDelegate> delegate;

- (void)registrationFailed;

@end
