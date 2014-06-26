//
//  SOAnswerMutipleChoicesView.h
//  SecondOpinion
//
//  Created by Eric Jones on 10/14/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOAnswerViewProtocol.h"


@interface SOAnswerMutipleChoicesView : UIView <SOAnswerViewProtocol>

- (int)numberOfFields;

@end
