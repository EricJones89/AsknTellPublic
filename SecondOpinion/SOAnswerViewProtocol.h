//
//  SOAnswerViewProtocol.h
//  SecondOpinion
//
//  Created by Eric Jones on 10/28/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_ANSWER_VIEW_HEIGHT 30
#define EACH_ADDITIONAL_ANSWER_HEIGHT 25

@protocol SOAnswerViewDelegate <NSObject>

@optional
- (void)containerViewNeedsLayout;
- (void)answerPressedAtIndex:(int)index;
- (void)alternateButtonPressed;
- (void)answerViewDidBeginEditingAtHeight:(CGFloat)height;
- (void)answerViewEndBeginEditing;

@end

@protocol SOAnswerViewProtocol <NSObject>

@property (nonatomic) NSMutableArray *answers;
@property (nonatomic, weak) id<SOAnswerViewDelegate> delegate;
@property (nonatomic) BOOL forCreation;

- (id)initWithFrame:(CGRect)frame withAnswers:(NSArray *)answers forCreation:(BOOL)forCreation;

@optional
- (void)addAnswer:(NSString *)answer;

@end
