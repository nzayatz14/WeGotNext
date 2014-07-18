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
    
    NSLog(@"%d", up);
    
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
    save = YES;
    
    if(_btnVote.selectedSegmentIndex == 0){
        [_player addUpVote];
    }else{
        [_player subtractUpVote];
    }
    
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user setMatchFromSport:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue] person:_player];
    [sharedManager setUpVotePair:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue] value:(_btnVote.selectedSegmentIndex == 0)];
    
    if(isOnTeam){
        int teammate = [sharedManager.user getTeammateNumber:_player inSport:[sharedManager.user getCurrentSport]];
        
        if(teammate != -1)
            [sharedManager.user setTeammateFromSport:[sharedManager.user getCurrentSport] teammateNumber:teammate person:_player];
    }
    
    _txtCredibilityRating.text = [[NSString alloc]initWithFormat:@"%d",[[NSNumber numberWithInt:[_player getCredibility]] intValue]];
    [_pgrCredibility setProgress:[[NSNumber numberWithInt:[_player getCredibility]] floatValue]/100];
}

-(void) viewWillDisappear:(BOOL)animated{
    if(save){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsPath = [paths objectAtIndex:0];
        
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
        
        sqlite3 *inAppDatabase;
        
        if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
            MyManager *sharedManager = [MyManager sharedManager];
            
            NSString *test = [[NSString alloc] initWithFormat:@"UPDATE pairsCurrentUser%d SET upVotes=?, totalVotes=?, upVotePair=? WHERE username='%@'", [sharedManager.user getCurrentSport],[_player getUserName]];
            
            NSLog(@"%@",test);
            
            const char *testChar = [test UTF8String];
            
            sqlite3_stmt *compiledStatement2;
            
            if(sqlite3_prepare_v2(inAppDatabase, testChar, -1, &compiledStatement2, NULL) == SQLITE_OK){
                NSLog(@"Update Success %d, %d, %d", [_player getUpVotes], [_player getVotes], [sharedManager getUpVotePair:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue]]);
                
                sqlite3_bind_int(compiledStatement2, 1, [_player getUpVotes]);
                sqlite3_bind_int(compiledStatement2, 2, [_player getVotes]);
                sqlite3_bind_int(compiledStatement2, 3, [sharedManager getUpVotePair:[sharedManager.user getCurrentSport] matchNumber:[_matchNumber intValue]]);
            }else{
               NSLog(@"Error: %s", sqlite3_errmsg(inAppDatabase));
            }
            if(sqlite3_step(compiledStatement2) == SQLITE_DONE)
                sqlite3_finalize(compiledStatement2);
        }
        sqlite3_close(inAppDatabase);
    }
}

@end
