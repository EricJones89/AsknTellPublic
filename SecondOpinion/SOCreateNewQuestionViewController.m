//
//  SOCreateNewQuestionViewController.m
//  SecondOpinion
//
//  Created by Eric Jones on 8/15/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOCreateNewQuestionViewController.h"
#import "SOCreateNewQuestionView.h"
#import "SOQuestionModel.h"
#import "SOStyle.h"

@interface SOCreateNewQuestionViewController () <SOCreateNewQuestionViewDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) SOCreateNewQuestionView *createQuestionView;

@end

@implementation SOCreateNewQuestionViewController

- (id)init {
    if (self = [super init]) {
        SOCreateNewQuestionView *view = [[SOCreateNewQuestionView alloc] initWithFrame:self.view.frame];
        view.delegate = self;
        self.createQuestionView = view;
        self.view = self.createQuestionView;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createQuestionButtonTapped {
    [self.delegate createQuestionWithType:self.createQuestionView.questionType text:self.createQuestionView.questionText.text primaryImage:self.createQuestionView.primaryImage secondaryImage:self.createQuestionView.secondaryImage answers:self.createQuestionView.answers];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    if (!self.createQuestionView.primaryImage) {
        self.createQuestionView.primaryImage = image;
    } else {
        self.createQuestionView.secondaryImage = image;
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
