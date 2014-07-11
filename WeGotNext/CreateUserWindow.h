//
//  CreateUserWindow.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/6/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateUserWindow : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtBirthday;
@property (weak, nonatomic) IBOutlet UISwitch *sldGender;


- (IBAction)btnCreateClicked:(UIButton *)sender;
- (IBAction)btnCancelClicked:(UIBarButtonItem *)sender;
-(void) addPersonToOnlineDatabase;
-(void) addPersonAsCurrentUser;


@end
