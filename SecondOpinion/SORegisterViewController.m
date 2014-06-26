//
//  SORegisterViewController.m
//  SecondOpinion
//
//  Created by Eric Jones on 11/29/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SORegisterViewController.h"
#import "SORegisterView.h"
#import "SOProfileModel.h"
#import <QuickLook/QuickLook.h>
#import "SOEulaModel.h"

@interface SORegisterViewController () <SORegisterViewDelegate, UIImagePickerControllerDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (nonatomic) SORegisterView *registerView;
@property (nonatomic) QLPreviewController *previewController;

@end

@implementation SORegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.registerView = [[SORegisterView alloc] initWithFrame:self.view.frame];
        self.registerView.delegate = self;
        self.view = self.registerView;
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

- (void)importImageButtonTappedForSourceType:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = type;
    imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePickerController.sourceType];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    image = [SOProfileModel circularCrop:image inRect:CGRectMake(0, 0, 100, 100)];
    self.registerView.profileImageView.image = image;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark SORegisterViewDelegate

- (void)registerWithUsername:(NSString *)username password:(NSString *)password displayName:(NSString *)displayName age:(NSString *)age gender:(NSString *)gender profileImage:(PFFile *)image email:(NSString *)email {
    
    PFUser *newUser = [[PFUser alloc] init];
    newUser.password = password;
    newUser.username = [username lowercaseString];
    [newUser setObject:image forKey:@"profileImage"];
    [newUser setObject:displayName forKey:@"fullName"];
    [newUser setObject:age forKey:@"Age"];
    [newUser setObject:gender forKey:@"Gender"];
    [newUser setObject:email forKey:@"email"];
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[[UIAlertView alloc] initWithTitle:@"Success" message:@"You are now registered, please check your email and confirm before loging in" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            if (error.code == 202) {
                [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"That Username Is Already Taken!" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            } else if (error.code == 203) {
                [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"That Email Has Already Been Used!" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            [self.registerView registrationFailed];
        }
    }];
    
    
}

- (void)cancelButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)eulaLabelTapped {
    QLPreviewController *previewEula = [[QLPreviewController alloc] init];
    previewEula.delegate = self;
    previewEula.dataSource = self;
    self.previewController = previewEula;
    [self presentViewController:self.previewController animated:YES completion:nil];
}

#pragma mark QLPreviewItemDelegates

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    SOEulaModel *eula = [[SOEulaModel alloc] init];
    return (id<QLPreviewItem>)eula;
}

@end
