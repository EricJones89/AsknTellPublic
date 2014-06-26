//
//  SOQuestionModel.m
//  SecondOpinion
//
//  Created by Eric Jones on 7/30/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOQuestionModel.h"
#import "SOAppDelegate.h"
#import "SOQuestionImageView.h"
#import "SOQuestionFeedNoImageTableViewCell.h"
#import "SOStyle.h"
#import "SOAppDelegate.h"



@interface SOQuestionModel ()

@property (nonatomic) NSMutableArray *percentages;
@property (nonatomic) int numberOfImages;

@end

@implementation SOQuestionModel

+ (NSArray *)defaultYesOrNoAnswers {
    return @[@"Yes", @"No"];
    
}

+ (NSArray *)defaultTopOrBottomAnswers {
    return @[@"Top", @"Bottom"];
}

+ (NSArray *)defaultLeftOrRightAnswers {
    return @[@"Left", @"Right"];
}

+ (NSArray *)defaultChoicesAnswers {
    return @[@"Choice", @"Another Choice"];
    
}

+(int)numberOfQuestionTypes {
    return 7;
}

+(NSString *)questionTypeTextForQuesitonType:(SOQuestionType)questionType {
    switch (questionType) {
        case SOQuestionTypeSports:
            return @"Sports";
            break;
        case SOQuestionTypeAroundTheHouse:
            return @"Around The House";
            break;
        case SOQuestionTypeBeauty:
            return @"Beauty";
            break;
        case SOQuestionTypeFashion:
            return @"Fashion";
            break;
        case SOQuestionTypeMisc:
            return @"All";
            break;
        case SOQuestionTypeRelationships:
            return @"Relationhsips";
            break;
        case SOQuestionTypeTravel:
            return @"Travel";
            break;
        case SOQuestionTypeVS:
            return @"VS";
            break;
        default:
            return @"Type";
            break;
    }
}

+(NSString *)imageNameForType:(SOQuestionType)questionType {
    switch (questionType) {
        case SOQuestionTypeSports:
            return @"football icon.png";
            break;
        case SOQuestionTypeAroundTheHouse:
            return @"house icon.png";
            break;
        case SOQuestionTypeBeauty:
            return @"beauty icon.png";
            break;
        case SOQuestionTypeFashion:
            return @"fashion icon.png";
            break;
        case SOQuestionTypeMisc:
            return @"infinity icon.png";
            break;
        case SOQuestionTypeRelationships:
            return @"relationship icon.png";
            break;
        case SOQuestionTypeTravel:
            return @"airplane icon.png";
            break;
        case SOQuestionTypeVS:
            return @"settle icon.png";
            break;
        default:
            return @"filled in user.png";
            break;
    }
}



-(id)initWithTitle:(NSString *)title text:(NSString *)text type:(NSString *)type creator:(PFUser *)creator {
    
    if (self = [super init]) {
        self.title = title;
        self.text = text;
        self.creator = creator;
        if ([creator.objectId isEqualToString:[PFUser currentUser].objectId]) { //always show the answers
            self.answersShouldBeDisplayed = YES;
            self.hasAnswerResponseFromCurrentUser = YES;
        }
        [creator fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            self.creator = creator;
            [self setCreatorImageFromUser];
        }];
        self.type = type;
    }
    
    return self;
}

-(void)saveWithFinishedBlock:(SOQuestionSaveFinishedBlock)onFinished {
    PFObject *testObject = [self selfAsPFObject];
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        onFinished(succeeded);
    }];
}

- (int)numberOfImages {
    
    return _numberOfImages;
}

- (void)setResponses:(NSMutableArray *)responses {
    _responses = responses;
    for (int i = 0; i<responses.count; ++i) {
        if ([((PFUser *)responses[i][@"responder"]).objectId isEqualToString:[PFUser currentUser].objectId]) {
            self.hasAnswerResponseFromCurrentUser = YES;
        }
    }
    
}

- (void)addAnswerResponseForAnswerIndex:(int)index {
    self.hasAnswerResponseFromCurrentUser = YES;
    PFObject *response = [PFObject objectWithClassName:@"response"];
    [response setObject:[PFUser currentUser] forKey:@"responder"];
    [response setObject:@(index) forKey:@"response"];
    [response setObject:[self selfAsPFObject] forKey:@"question"];
    CLLocation *location = [SOAppDelegate currentLocation];
    NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    [response setObject:latitude forKey:@"latitude"];
    [response setObject:longitude forKey:@"longitude"];
    
    [response saveInBackground];
    
    self.responses = [self.responses arrayByAddingObject:@{@"response": @(index)}];
    [self calculatePercentages];
}

- (CGFloat)percentageOfResposesForAnswerAtIndex:(int)index {
    return ((NSNumber *)self.percentages[index]).floatValue;
}

- (NSArray *)percentageArrayForResponses {
    return self.percentages;
}

- (void)fetchResponsesToQuestion {
    PFQuery *query = [PFQuery queryWithClassName:@"response"];
    PFObject *object = [PFObject objectWithClassName:@"Question"];
    object.objectId = self.objectId;
    [query whereKey:@"question" equalTo:object];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.responses = objects;
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self calculatePercentages];
    }];
}

- (void)fetchImagesForFile1:(PFFile *)file  file2:(PFFile *)file2 {

    if (file) {
        self.numberOfImages++;
        self.combinedQuestionImages = [UIImage imageNamed:@"defaultImage"];
    }
    if (file2) {
        self.numberOfImages++;
    }
    if (file) {
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            self.image = [UIImage imageWithData:data];
            if (file2) {
                [file2 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    self.image2 = [UIImage imageWithData:data];
                    SOQuestionImageView *imageView = [[SOQuestionImageView alloc] initWithFrame:CGRectMake(0, 0, 300, self.numberOfImages * IMAGE_VIEW_HEIGHT) primaryImage:self.image secondaryImage:self.image2];
                    [imageView layoutSubviews];
                    self.combinedQuestionImages = [self imageWithView:imageView];
                    [self.delegate imageLoadedForQuestion:self];
                }];
            } else {
                SOQuestionImageView *imageView = [[SOQuestionImageView alloc] initWithFrame:CGRectMake(0, 0, 300, self.numberOfImages * IMAGE_VIEW_HEIGHT) primaryImage:self.image secondaryImage:nil];
                [imageView layoutSubviews];
                self.combinedQuestionImages = [self imageWithView:imageView];
                [self.delegate imageLoadedForQuestion:self];
            }
        }];
    }
}
- (void)reportAsInappropriate {
    [self.deleteDelegate deleteQuestion:self];
    [PFCloud callFunctionInBackground:@"reportUser" withParameters:@{@"userId":self.creator.objectId} block:^(id object, NSError *error) {
        
    }];
}

#pragma mark helper mathods

- (PFObject *)selfAsPFObject {
    PFObject *testObject = [PFObject objectWithClassName:@"Question"];
    testObject.objectId = self.objectId;
    [testObject setObject:self.text forKey:@"text"];
    [testObject setObject:self.title forKey:@"title"];
    [testObject setObject:self.type forKey:@"type"];
    [testObject setObject:[SOQuestionModel getHashtagsForString:self.text] forKey:@"hashtags"];
    
    
    
    if (self.image) {
        NSData *data = UIImageJPEGRepresentation(self.image, 0.1);
        PFFile *file = [PFFile fileWithName:@"image1" data:data];
        [testObject setObject:file forKey:@"image"];
    }
    if (self.image2) {
        NSData *data2 = UIImageJPEGRepresentation(self.image2, 0.1);
        PFFile *file2 = [PFFile fileWithName:@"image2" data:data2];
        [testObject setObject:file2 forKey:@"image2"];
    }
    
    [testObject setObject:self.creator forKey:@"creator"];
    for (int i=0; i<self.answers.count ; i++) {
        [testObject setObject:self.answers[i] forKey:[NSString stringWithFormat:@"answer%i", i]];
    }
    return testObject;
}

+ (NSArray *)getHashtagsForString:(NSString *)text {
    NSMutableArray *hashtags = [[NSMutableArray alloc] init];
    NSArray *words = [text componentsSeparatedByString:@" "];
    for (NSString *word in words) {
        if (word.length) {
            if ([[word substringToIndex:1] isEqualToString:@"#"]) {
                NSLog(@"Found tag %@", word);
                [hashtags addObject:[word substringFromIndex:1]];
            }
        }
    }
    
    return hashtags;
}

+ (NSArray *)getCreatorsForString:(NSString *)text {
    NSMutableArray *creators = [[NSMutableArray alloc] init];
    NSArray *words = [text componentsSeparatedByString:@" "];
    for (NSString *word in words) {
        if (word.length) {
            if ([[word substringToIndex:1] isEqualToString:@"@"]) {
                [creators addObject:[word substringFromIndex:1]];
            }
        }
    }
    
    return creators;
}

- (void)calculatePercentages {
    self.percentages = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.answers.count; i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"response == %i" , i];
        NSArray *results = [self.responses filteredArrayUsingPredicate:predicate];
        if (results.count > 0) {
            [self.percentages addObject:@(((CGFloat)results.count)/self.responses.count)];
        } else {
            [self.percentages addObject:@0.0];
        }
    }
    
    [self.delegate reloadQuestion:self];
}

- (void)setCreatorImageFromUser {
    PFFile *image = [self.creator objectForKey:@"profileImage"];
    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.creatorImage = [UIImage imageWithData:data];
        [self.delegate imageLoadedForQuestion:self];
    }];
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    view.layer.backgroundColor = [SOStyle questionColor].CGColor;
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}




@end
