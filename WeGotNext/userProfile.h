//
//  userProfile.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/27/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface userProfile : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *picFrontProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *txtFirstName;
@property (weak, nonatomic) IBOutlet UILabel *txtAge;
@property (weak, nonatomic) IBOutlet UILabel *txtGender;

@property (weak, nonatomic) IBOutlet UITextView *txtExperience1;
@property (weak, nonatomic) IBOutlet UITextView *txtExperience2;
@property (weak, nonatomic) IBOutlet UITextView *txtExperience3;


@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *selectedImage;

@property (weak, nonatomic) IBOutlet UIProgressView *pgrCredibility;
@property (weak, nonatomic) IBOutlet UILabel *txtCredibilityRating;

@property (nonatomic, strong) Person *player;

@end
