//
//  SOAppDelegate.m
//  SecondOpinion
//
//  Created by Eric Jones on 7/30/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOAppDelegate.h"

#import "SOQuestionFeedViewController.h"

static CLLocation *currentLocation;

@interface SOAppDelegate () <SOQuestionViewControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation SOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"Your Key Here"
                  clientKey:@"Your Id Here"];
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    self.locationManager = locationManager;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedOut) name:@"UserLogoutEvent" object:nil];
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    self.loginViewController = [[SOLoginViewController alloc] init];
    self.loginViewController.delegate = self;
    
    
    
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    PFUser *currentUser = [PFUser currentUser];
    [currentUser refresh];
    if  ([[currentUser objectForKey:@"emailVerified"] boolValue] && ![[currentUser objectForKey:@"reported"] boolValue]) {
        self.feedViewController = [[SOQuestionFeedViewController alloc] initWithUser:[PFUser currentUser]];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.feedViewController];
    } else {
        [PFUser logOut];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];

    }
    self.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    PFUser *currentUser = [PFUser currentUser];
    [currentUser refresh];
    if  ([[currentUser objectForKey:@"reported"] boolValue]) {
        [PFUser logOut];
        
        self.loginViewController = [[SOLoginViewController alloc] init];
        self.loginViewController.delegate = self;
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
        self.navigationController.navigationBarHidden = YES;
        self.window.rootViewController = self.navigationController;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    if ([PFUser currentUser]) {
        [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
    }
    [currentInstallation saveInBackground];
}

#pragma mark SOLoginViewControllerDelegate

- (void)loginSucceded {
    
    [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
    [[PFInstallation currentInstallation] saveEventually];
    
    self.feedViewController = [[SOQuestionFeedViewController alloc] initWithUser:[PFUser currentUser]];
    if ([self.navigationController.viewControllers[0] isKindOfClass:SOLoginViewController.class]) {
        [self.navigationController pushViewController:self.feedViewController animated:YES];
    }
    
}

- (void)userLoggedOut {
    
    [[PFInstallation currentInstallation] removeObjectForKey:@"user"];
    [[PFInstallation currentInstallation] saveEventually];
    
    self.feedViewController = nil;
    self.loginViewController = [[SOLoginViewController alloc] init];
    self.loginViewController.delegate = self;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    
    self.navigationController.navigationBarHidden = YES;
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.window.rootViewController = self.navigationController;
                    }
                    completion:nil];
}

#pragma mark CLLocationManager delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = locations[0];
}

+ (CLLocation *)currentLocation {
    return  currentLocation;
}

@end
