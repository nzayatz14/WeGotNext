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

/*FUNCTION IS INCOMPLETE*/
//initialize the labels and such when the view appears to the user
-(void) viewWillAppear:(BOOL)animated{
    save = NO;
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
    
    BOOL up = [sharedManager getUpVotePair:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue]];
    
    //NSLog(@"%d", up);
    
    if(up){
        _btnVote.selectedSegmentIndex = 0;
    }else{
        _btnVote.selectedSegmentIndex = 1;
    }
    
    _btnAddToTeam.enabled = (!isOnTeam);
    
}

//adds the player currently being viewed to the users team in that sport
- (void) addToTeam{
    MyManager *sharedManager = [MyManager sharedManager];
    
    Person *p = [sharedManager.user getMatchFromSport:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue]];
    
    [sharedManager.user addToTeamFromSport:[sharedManager.user getCurrentSport] person:p];
    [sharedManager addTeammateToDatabase:p sport:[sharedManager.user getCurrentSport]];
    
    PFQuery *query = [PFQuery queryWithClassName:[[NSString alloc] initWithFormat:@"Matches%@", [sharedManager.user getUserName]]];
    
    [query whereKey:@"userName" equalTo:[p getUserName]];
    [query whereKey:@"sportNumber" equalTo:@([sharedManager.user getCurrentSport])];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            object[@"isOnTeam"] = @([sharedManager.user isUserOnTeam:p]);
            [object saveInBackground];
        }
    }];
}

- (IBAction)btnAddToTeamClicked:(UIButton *)sender {
    _btnAddToTeam.enabled = NO;
    [self addToTeam];
}

//functio called when the user clicked on one of the up or down vote buttons
- (IBAction)btnVoteClicked:(UISegmentedControl *)sender {
    //NSLog(@"Segmented Control Switched");
    
    //if a change is made the new data must be saved
    save = YES;
    
    //add or subtract an upvote from that player depending on which button is clicked
    if(_btnVote.selectedSegmentIndex == 0){
        [_player addUpVote];
    }else{
        [_player subtractUpVote];
    }
    
    //set the new boolean (up = true, down = false) to the array of booleans of votes
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user setMatchFromSport:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue] person:_player];
    [sharedManager setUpVotePair:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue] value:(_btnVote.selectedSegmentIndex == 0)];
    
    //if the person being voted on is on your team, copy the new voting information
    //into the teammate version of that person
    if(isOnTeam){
        int teammate = [sharedManager.user getTeammateNumber:_player inSport:[sharedManager.user getCurrentSport]];
        
        if(teammate != -1)
            [sharedManager.user setTeammateFromSport:[sharedManager.user getCurrentSport] teammateNumber:teammate person:_player];
    }
    
    //display the votes and reset the progress bar
    _txtCredibilityRating.text = [[NSString alloc]initWithFormat:@"%d",[[NSNumber numberWithInt:[_player getCredibility]] intValue]];
    [_pgrCredibility setProgress:[[NSNumber numberWithInt:[_player getCredibility]] floatValue]/100];
}

//function called just before the view disappears
-(void) viewWillDisappear:(BOOL)animated{
    //if the information needs to be saved, save it
    if(save){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsPath = [paths objectAtIndex:0];
        
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
        
        sqlite3 *inAppDatabase;
        
        //attempts to open the inApp database. if successful, continue, if not, print error.
        if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
            MyManager *sharedManager = [MyManager sharedManager];
            
            NSString *test = [[NSString alloc] initWithFormat:@"UPDATE pairsCurrentUser%d SET upVotes=?, totalVotes=?, upVotePair=? WHERE username='%@'", [sharedManager.user getCurrentSport],[_player getUserName]];
            
            //NSLog(@"%@",test);
            
            const char *testChar = [test UTF8String];
            
            sqlite3_stmt *compiledStatement2;
            
            //attempts to compiled the SQL statement. if successful, continue, if not print error.
            if(sqlite3_prepare_v2(inAppDatabase, testChar, -1, &compiledStatement2, NULL) == SQLITE_OK){
                //NSLog(@"Update Success %d, %d, %d", [_player getUpVotes], [_player getVotes], [sharedManager getUpVotePair:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue]]);
                
                sqlite3_bind_int(compiledStatement2, 1, [_player getUpVotes]);
                sqlite3_bind_int(compiledStatement2, 2, [_player getVotes]);
                sqlite3_bind_int(compiledStatement2, 3, [sharedManager getUpVotePair:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue]]);
            }else{
               NSLog(@"Error 1: %s", sqlite3_errmsg(inAppDatabase));
            }
            
            //finalize the SQL statement
            if(sqlite3_step(compiledStatement2) == SQLITE_DONE)
                sqlite3_finalize(compiledStatement2);
        }else{
            NSLog(@"Error 0: %s", sqlite3_errmsg(inAppDatabase));
        }
        
        //close the database
        sqlite3_close(inAppDatabase);
    }
}

@end
