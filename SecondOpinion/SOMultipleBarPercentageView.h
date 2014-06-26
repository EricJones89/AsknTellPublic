//
//  SOMultipleBarPercentageView.h
//  SecondOpinion
//
//  Created by Eric Jones on 11/19/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOMultipleBarPercentageView : UIView

- (id)initWithFrame:(CGRect)frame withAnswers:(NSArray *)answers withPercentages:(NSArray *)percentages;

@property (nonatomic) NSMutableArray *answers;

@end
