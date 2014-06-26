//
//  SOAppDelegate.h
//  SecondOpinion
//
//  Created by Eric Jones on 7/30/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

/*
 The MIT License (MIT)
 
 Copyright (c) 2013 Eric Jones
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "SOQuestionFeedViewController.h"
#import "SOLoginViewController.h"
#import <CoreLocation/CoreLocation.h>



@class SOQuestionFeedViewController;

@interface SOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SOQuestionFeedViewController *feedViewController;
@property (strong, nonatomic) SOLoginViewController *loginViewController;
@property (nonatomic) UINavigationController *navigationController;

+ (CLLocation *)currentLocation;

@end
