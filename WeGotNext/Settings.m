//
//  Settings.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "Settings.h"
#import "MyManager.h"

@implementation Settings

-(void) viewWillAppear:(BOOL)animated{
    MyManager *sharedManager = [MyManager sharedManager];
    [_sldPlayerPairedObj setOn:sharedManager.notifyNewPair];
    [_sldPlayerMsgObj setOn:sharedManager.notifyNewPlayerMessage];
    [_sldTeammateMsgObj setOn:sharedManager.notifyNewTeammateMessage];
}

- (IBAction)sldPlayerPaired:(UISwitch *)sender {
    MyManager *sharedManager = [MyManager sharedManager];
    sharedManager.notifyNewPair = [sender isOn];
}

- (IBAction)sldPlayerMsg:(UISwitch *)sender {
    MyManager *sharedManager = [MyManager sharedManager];
    sharedManager.notifyNewPlayerMessage = [sender isOn];
}

- (IBAction)sldTeammateMsg:(UISwitch *)sender {
    MyManager *sharedManager = [MyManager sharedManager];
    sharedManager.notifyNewTeammateMessage = [sender isOn];
}

- (IBAction)btnDeleteAccountClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait" message:@"Are you sure you want to delete your account? This action cannot be undone." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //if delete is clicked
    if(buttonIndex == 1){
        
    }
}

@end
