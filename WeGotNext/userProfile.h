//
//  userProfile.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/27/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface userProfile : UIViewController{
    BOOL isOnTeam;
    BOOL save;
}

@property (weak, nonatomic) IBOutlet UIImageView *picFrontProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *txtFirstName;
@property (weak, nonatomic) IBOutlet UILabel *txtAge;
@property (weak, nonatomic) IBOutlet UILabel *txtGender;

- (IBAction)btnAddToTeamClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAddToTeam;


@property (weak, nonatomic) IBOutlet UITextView *txtExperience1;
@property (weak, nonatomic) IBOutlet UITextView *txtExperience2;
@property (weak, nonatomic) IBOutlet UITextView *txtExperience3;


@property (weak, nonatomic) IBOutlet UIProgressView *pgrCredibility;
@property (weak, nonatomic) IBOutlet UILabel *txtCredibilityRating;


@property (weak, nonatomic) IBOutlet UISegmentedControl *btnVote;
- (IBAction)btnVoteClicked:(UISegmentedControl *)sender;


@property (nonatomic, strong) Person *player;
@property (nonatomic, strong) NSNumber *matchNumber;

@end
