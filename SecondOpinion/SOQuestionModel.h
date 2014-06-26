//
//  SOQuestionModel.h
//  SecondOpinion
//
//  Created by Eric Jones on 7/30/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AnswerTypeYesNo @"Yes / No"
#define AnswerTypeChoices @"Choices"
#define AnswerTypeThisOrThat @"This or That"


typedef enum SOQuestionType {
    SOQuestionTypeMisc = 0,
    SOQuestionTypeRelationships = 1,
    SOQuestionTypeVS = 2,
    SOQuestionTypeFashion = 3,
    SOQuestionTypeBeauty = 4,
    SOQuestionTypeAroundTheHouse = 5,
    SOQuestionTypeTravel = 6,
    SOQuestionTypeSports = 7
    } SOQuestionType;

typedef void (^SOQuestionSaveFinishedBlock)(BOOL success);

@protocol SOQuestionModelDelegate;
@protocol SOQuestionModelDeleteDelegate;

@interface SOQuestionModel : NSObject

@property (nonatomic) NSString *text;
@property (nonatomic) NSString *title;
@property (nonatomic) UIImage *image;
@property (nonatomic) UIImage *image2;
@property (nonatomic) UIImage *combinedQuestionImages;
@property (nonatomic) UIImage *creatorImage;
@property (nonatomic) PFUser *creator;
@property (nonatomic) NSString *type;
@property (nonatomic) NSArray *answers;
@property (nonatomic) NSArray *responses;
@property (nonatomic) BOOL answersShouldBeDisplayed;
@property (nonatomic) BOOL hasAnswerResponseFromCurrentUser;
@property (nonatomic) BOOL shouldShowQuestionInFeed;
@property (nonatomic) NSString *objectId;
@property (nonatomic, weak) id<SOQuestionModelDelegate> delegate;
@property (nonatomic, weak) id<SOQuestionModelDeleteDelegate> deleteDelegate;

+ (NSArray *)defaultYesOrNoAnswers;
+ (NSArray *)defaultTopOrBottomAnswers;
+ (NSArray *)defaultLeftOrRightAnswers;
+ (NSArray *)defaultChoicesAnswers;

+(NSString *)questionTypeTextForQuesitonType:(SOQuestionType)questionType;
+(NSString *)imageNameForType:(SOQuestionType)questionType;
+(int)numberOfQuestionTypes;
+ (NSArray *)getHashtagsForString:(NSString *)text;
+ (NSArray *)getCreatorsForString:(NSString *)text;

-(id)initWithTitle:(NSString *)title text:(NSString *)text type:(NSString *)type creator:(PFUser *)creator;
-(void)setImage:(UIImage *)image;
-(void)saveWithFinishedBlock:(SOQuestionSaveFinishedBlock)onFinished;
-(int)numberOfImages;
-(void)addAnswerResponseForAnswerIndex:(int)index;
-(CGFloat)percentageOfResposesForAnswerAtIndex:(int)index;
- (NSArray *)percentageArrayForResponses;

- (void)fetchResponsesToQuestion;
- (void)fetchImagesForFile1:(PFFile *)file  file2:(PFFile *)file2;
- (UIImage*)stitch:(UIImage*)image withImage:(UIImage *)image2 inRect:(CGRect)rect;
- (void)reportAsInappropriate;

@end

@protocol SOQuestionModelDelegate <NSObject>

- (void) imageLoadedForQuestion:(SOQuestionModel *)question;
- (void) reloadQuestion:(SOQuestionModel *)question;

@end

@protocol SOQuestionModelDeleteDelegate <NSObject>

- (void) deleteQuestion:(SOQuestionModel *)question;

@end
