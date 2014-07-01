//
//  userProfile.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/27/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "userProfile.h"
#import "MyManager.h"

@implementation userProfile

- (void) viewDidLoad{
    isOnTeam = NO;
}

//initialize the labels and such when the view appears to the user
-(void) viewWillAppear:(BOOL)animated{
    
    //set the information of the profile menu equal to the information of the user
    
    //also need to set picture(s)
    
    _txtFirstName.text = [_player getFirstName];
    _txtAge.text = [NSString stringWithFormat:@"%d", [_player getAge]];
    _txtExperience1.text = [[NSString alloc] initWithFormat:@"Exp 1"];
    _txtExperience2.text = [[NSString alloc] initWithFormat:@"Exp 2"];
    _txtExperience3.text = [[NSString alloc] initWithFormat:@"Exp 3"];
    _txtCredibilityRating.text = [[NSString alloc]initWithFormat:@"%d",[[NSNumber numberWithInt:[_player getCredibility]] intValue]];
    
    if([_player isMale]){
        _txtGender.text = [[NSString alloc] initWithFormat:@"M"];
    }else{
        _txtGender.text = [[NSString alloc] initWithFormat:@"F"];
    }
    
    [_pgrCredibility setProgress:[[NSNumber numberWithInt:[_player getCredibility]] floatValue]/100];
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    isOnTeam = [sharedManager isUserOnTeam:_player];
    _btnAddToTeam.enabled = (!isOnTeam);
    
}

- (void) addToTeam{
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user addToTeamFromSport:[sharedManager.user getCurrentSport] person:[sharedManager.user getMatchFromSport:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue]]];
}

- (IBAction)btnAddToTeamClicked:(UIButton *)sender {
    _btnAddToTeam.enabled = NO;
    [self addToTeam];
}
@end
