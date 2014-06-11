//
//  Profile.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Profile : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

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

@property (strong, nonatomic) NSString *First;
@property (strong, nonatomic) NSString *Age;
@property (strong, nonatomic) NSString *Gender;
@property (strong, nonatomic) NSString *Exp1;
@property (strong, nonatomic) NSString *Exp2;
@property (strong, nonatomic) NSString *Exp3;
@property (strong, nonatomic) NSNumber *credibility;


- (IBAction)holdProfilePicture:(UILongPressGestureRecognizer *)sender;
@end
