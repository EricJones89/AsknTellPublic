//
//  SOQuestionFeedNoImageTableViewCell.h
//  SecondOpinion
//
//  Created by Eric Jones on 9/10/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOQuestionModel.h"

#define IMAGE_VIEW_HEIGHT 100
#define ANSWERS_VIEW_HEIGHT 100
#define SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN 5

@interface SOQuestionFeedNoImageTableViewCell : UITableViewCell

@property (nonatomic) SOQuestionModel *question;
@property (nonatomic) UITextView *textView;

@end
