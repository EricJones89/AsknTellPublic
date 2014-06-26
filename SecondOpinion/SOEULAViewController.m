//
//  SOEULAViewController.m
//  SecondOpinion
//
//  Created by Eric Jones on 12/8/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOEULAViewController.h"

@interface SOEULAViewController ()

@end

@implementation SOEULAViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = self.view.frame;
        [self.view addSubview:scrollView];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
