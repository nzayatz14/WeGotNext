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
    
    BOOL up = [sharedManager.user getUpVotePair:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue]];
    
    if(up){
        _btnVote.selectedSegmentIndex = 0;
    }else{
        _btnVote.selectedSegmentIndex = 1;
    }
    
    _btnAddToTeam.enabled = (!isOnTeam);
    
}

- (void) addToTeam{
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user addToTeamFromSport:[sharedManager.user getCurrentSport] person:[sharedManager.user getMatchFromSport:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue]]];
    
    [sharedManager addTeammateToDatabase:[sharedManager.user getMatchFromSport:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue]] sport:[sharedManager.user getCurrentSport]];
}

- (IBAction)btnAddToTeamClicked:(UIButton *)sender {
    _btnAddToTeam.enabled = NO;
    [self addToTeam];
}
- (IBAction)btnVoteClicked:(UISegmentedControl *)sender {
    NSLog(@"Segmented Control Switched");
    
    if(_btnVote.selectedSegmentIndex == 0){
        [_player addUpVote];
    }else{
        [_player subtractUpVote];
    }
    
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user setMatchFromSport:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue] person:_player];
    [sharedManager.user setUpVotePair:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue] value:(_btnVote.selectedSegmentIndex == 0)];
    
    if(isOnTeam){
        int teammate = [sharedManager.user getTeammateNumber:_player inSport:[sharedManager.user getCurrentSport]];
        
        if(teammate != -1)
            [sharedManager.user setTeammateFromSport:[sharedManager.user getCurrentSport] teammateNumber:teammate person:_player];
    }
    
    _txtCredibilityRating.text = [[NSString alloc]initWithFormat:@"%d",[[NSNumber numberWithInt:[_player getCredibility]] intValue]];
    [_pgrCredibility setProgress:[[NSNumber numberWithInt:[_player getCredibility]] floatValue]/100];
}

@end
