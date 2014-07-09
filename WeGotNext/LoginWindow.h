//
//  LoginWindow.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyManager.h"

@interface LoginWindow : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)btnLoginClicked:(UIButton *)sender;
- (IBAction)btnCreateClicked:(UIButton *)sender;
- (void) addPersonAsCurrentUser;
@end
