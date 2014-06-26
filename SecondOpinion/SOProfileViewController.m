//
//  SOProfileViewController.m
//  SecondOpinion
//
//  Created by Eric Jones on 11/23/13.
//  Copyright (c) 2013 Eric Jones. All rights reserved.
//

#import "SOProfileViewController.h"
#import "SOProfileView.h"
#import "SOQuestionFeedNoImageTableViewCell.h"
#import "SOStyle.h"
#import "SOAnswerViewProtocol.h"

@interface SOProfileViewController () <SOProfileModelDelegate, UITableViewDataSource, UITableViewDelegate, SOQuestionModelDelegate, SOProfileViewDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) SOProfileModel *profileModel;
@property (nonatomic) SOProfileView *profileView;
@property (nonatomic) UITableView *answersTableView;

@end

@implementation SOProfileViewController

- (id)initWithProfileModel:(SOProfileModel *)model
{
    self = [super init];
    if (self) {
        self.profileModel = model;
        model.delegate = self;
        self.profileView = [[SOProfileView alloc] initWithFrame:self.view.frame];
        self.profileView.delegate = self;
        [self.profileView setProfileImage:self.profileModel.profileImage];
        self.profileView.nameField.text = self.profileModel.fullName;
        self.answersTableView = self.profileView.tableView;
        self.answersTableView.dataSource = self;
        self.answersTableView.delegate = self;
        self.view = self.profileView;
        
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

- (void)profileImageDownloaded {
    [self.profileView setProfileImage:self.profileModel.profileImage];
    [self.profileView layoutSubviews];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SOQuestionFeedNoImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nonImageCell"];
    
    if (!cell) {
        cell = [[SOQuestionFeedNoImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nonImageCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.question = self.profileModel.questions[indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.profileModel.questions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [((SOQuestionModel *)self.profileModel.questions[indexPath.row]).text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 50, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [SOStyle defaultFontWithSize:16]} context:nil].size.height;
    height += (IMAGE_VIEW_HEIGHT + SOQUESTION_FEED_TABLE_VIEW_CELL_MARGIN) * ((SOQuestionModel *)self.profileModel.questions[indexPath.row]).numberOfImages;
    if (((SOQuestionModel *)self.profileModel.questions[indexPath.row]).answersShouldBeDisplayed)
    {
        height += BASE_ANSWER_VIEW_HEIGHT + ((SOQuestionModel *)self.profileModel.questions[indexPath.row]).answers.count * EACH_ADDITIONAL_ANSWER_HEIGHT;
    }
    height += 120; //constant for image view
    return height;
}


#pragma mark SOProfileModelDelegte

- (void)questionsLoaded {
    [self.answersTableView reloadData];
}

#pragma mark SOProfileViewDelegate

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateProfileDisplayNameTo:(NSString *)newName {
    [self.profileModel.user setObject:newName forKey:@"fullName"];
    [self.profileModel.user saveInBackground];
}

#pragma mark SOQuestionModelDelegate

- (void) imageLoadedForQuestion:(SOQuestionModel *)question {
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[self.profileModel.questions indexOfObject:question] inSection:0];
    [self.answersTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadQuestion:(SOQuestionModel *)question {
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[self.profileModel.questions indexOfObject:question] inSection:0];
    [self.answersTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark UIImagePickerControllerDelegate

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
    self.profileView.profileImageView.image = image;
    [self.profileView layoutSubviews];
    PFFile *file = [PFFile fileWithData:UIImagePNGRepresentation(image)];
    [self.profileModel.user setObject:file forKey:@"profileImage"];
    [self.profileModel.user saveInBackground];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
