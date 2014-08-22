//
//  teammateProfile.m
//  WeGotNext
//
//  Created by Nick Zayatz on 7/14/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "teammateProfile.h"
#import "MyManager.h"

@implementation teammateProfile

/*FUNCTION IS INCOMPLETE*/
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
    
}

//removes the currently being viewed teammate from the users team
//then pops the user back to the table view of his/her teammates
- (void) removeFromTeam{
    MyManager *sharedManager = [MyManager sharedManager];
    
    [sharedManager removeTeammateFromDatabase:[sharedManager.user getTeammateFromSport:[sharedManager.user getCurrentSport] teammateNumber:[_matchNumber intValue]] sport:[sharedManager.user getCurrentSport]];
    
    [sharedManager.user removeTeammateFromSport:[sharedManager.user getCurrentSport] teammateNumber:[_matchNumber intValue]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//function called if the remove from team buttong is clicked
//displays warning
- (IBAction)btnRemoveFromTeamClicked:(UIButton *)sender {
    //_btnRemoveFromTeam.enabled = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait" message:@"Are you sure you want to remove this person from you team?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Remove", nil];
    [alert show];
}

//if the user decided to hit ok, the teammate is then removed from the users team in that sport
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        [self removeFromTeam];
    }
}
@end
