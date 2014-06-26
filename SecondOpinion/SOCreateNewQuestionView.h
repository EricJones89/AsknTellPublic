//
//  SOCreateNewQuestionView.h
//  SecondOpinion
//
//  Created by Eric Jones on 9/9/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SOCreateNewQuestionViewDelegate <NSObject>

- (void)createQuestionButtonTapped;
- (void)cancelButtonTapped;
- (void)importImageButtonTappedForSourceType:(UIImagePickerControllerSourceType)type;

@end

@interface SOCreateNewQuestionView : UIView

@property (nonatomic) UITextView *questionText;
@property (nonatomic, weak) id<SOCreateNewQuestionViewDelegate> delegate;
@property (nonatomic) UIImage *primaryImage;
@property (nonatomic) UIImage *secondaryImage;

- (NSString *)questionType;
- (NSArray *)answers;

@end
