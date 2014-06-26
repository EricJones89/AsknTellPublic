//
//  SOLoginViewController.m
//  SecondOpinion
//
//  Created by Eric Jones on 11/29/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOLoginViewController.h"
#import "SOLoginView.h"
#import "SORegisterViewController.h"

@interface SOLoginViewController () <SOLoginViewDelegate>

@property (nonatomic) SOLoginView *loginView;

@end

@implementation SOLoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.loginView = [[SOLoginView alloc] initWithFrame:self.view.frame];
        self.loginView.delegate = self;
        self.view = self.loginView;
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

#pragma mark SOLoginViewDelegate

- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
    [PFUser logInWithUsernameInBackground:[username lowercaseString] password:password block:^(PFUser *user, NSError *error) {
         if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"The Username Or Password Entered Is Not Correct" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self.loginView loginFailed];
         } else if (![[user objectForKey:@"emailVerified"] boolValue]){
             [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"This Account Email Has Not Been Verified! Please Check Your Email And Confirm" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
             [PFUser logOut];
             [self.loginView loginFailed];
         } else if ([[user objectForKey:@"reported"] boolValue]){
             [[[UIAlertView alloc] initWithTitle:@"Banned User" message:@"This account has been flagged for posting inappropriate questions. Please contact support if you feel this has been done in error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
             [PFUser logOut];
             [self.loginView loginFailed];
         } else {
            [self.delegate loginSucceded];
        }
    }];
}

- (void)registerButtonTapped {
    SORegisterViewController *viewController = [[SORegisterViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
