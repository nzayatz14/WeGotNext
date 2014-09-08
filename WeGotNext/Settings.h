//
//  Settings.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController <UIAlertViewDelegate>
- (IBAction)sldPlayerPaired:(UISwitch *)sender;
- (IBAction)sldPlayerMsg:(UISwitch *)sender;
- (IBAction)sldTeammateMsg:(UISwitch *)sender;
- (IBAction)sldLikedPhotosClicked:(UISwitch *)sender;

@property (weak, nonatomic) IBOutlet UISwitch *sldPlayerPairedObj;
@property (weak, nonatomic) IBOutlet UISwitch *sldPlayerMsgObj;
@property (weak, nonatomic) IBOutlet UISwitch *sldTeammateMsgObj;
@property (weak, nonatomic) IBOutlet UISwitch *sldLikedPhotos;


- (IBAction)btnDeleteAccountClicked:(id)sender;

@end
