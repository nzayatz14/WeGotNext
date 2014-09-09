//
//  Settings.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "Settings.h"
#import "MyManager.h"
#import "UIViewController+AMSlideMenu.h"

@implementation Settings

/*FUNCTION IS INCOMPLETE*/
//sets the slide switches to the users options on each subject
-(void) viewWillAppear:(BOOL)animated{
    
    //[self addLeftMenuButton];
    //[self addRightMenuButton];
    
    MyManager *sharedManager = [MyManager sharedManager];
    [_sldPlayerPairedObj setOn:sharedManager.notifyNewPair];
    [_sldPlayerMsgObj setOn:sharedManager.notifyNewPlayerMessage];
    [_sldTeammateMsgObj setOn:sharedManager.notifyNewTeammateMessage];
}

//function called when the notification switch for a new player pair is switched
- (IBAction)sldPlayerPaired:(UISwitch *)sender {
    MyManager *sharedManager = [MyManager sharedManager];
    sharedManager.notifyNewPair = [sender isOn];
}

//function called when the notification switch for a pair message is switched
- (IBAction)sldPlayerMsg:(UISwitch *)sender {
    MyManager *sharedManager = [MyManager sharedManager];
    sharedManager.notifyNewPlayerMessage = [sender isOn];
}

//function called when the notification switch for a teammate message is switched
- (IBAction)sldTeammateMsg:(UISwitch *)sender {
    MyManager *sharedManager = [MyManager sharedManager];
    sharedManager.notifyNewTeammateMessage = [sender isOn];
}

/*FUNCTION IS INCOMPLETE*/
//function called when the liked photos switch is switched
- (IBAction)sldLikedPhotosClicked:(UISwitch *)sender {
    
}

//function called when the delete account button is clicked
- (IBAction)btnDeleteAccountClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait" message:@"Are you sure you want to delete your account? This action cannot be undone." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
}

/*FUNCTION IS INCOMPLETE*/
//decides what to do based on the option selected from the alert view window
//created by clicking the delete account window
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //if delete is clicked
    if(buttonIndex == 1){
        
    }
}

@end
