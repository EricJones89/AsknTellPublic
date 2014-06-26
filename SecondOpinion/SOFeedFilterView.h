//
//  SOFeedFilterView.h
//  SecondOpinion
//
//  Created by Eric Jones on 1/18/14.
//  Copyright (c) 2014 Eric Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SOFeedFilterViewDelegate <NSObject>

- (void)addButtonClicked;

@end

@interface SOFeedFilterView : UIView

@property (nonatomic) UITableView *tableView;
@property (nonatomic, weak) id<SOFeedFilterViewDelegate> delegate;

@end
