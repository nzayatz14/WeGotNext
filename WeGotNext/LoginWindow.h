//
//  LoginWindow.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "MyManager.h"

@interface LoginWindow : UIViewController <UITextFieldDelegate, FBLoginViewDelegate>{
    int empty;
    NSString *serviceName;
}

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) NSMutableData *downloadedData;

@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

- (IBAction)btnLoginClicked:(UIButton *)sender;
- (IBAction)btnCreateClicked:(UIButton *)sender;
- (IBAction)btnForgotPasswordClicked:(UIButton *)sender;


- (void) addPersonAsCurrentUser;
-(void) loadUserInformation:(NSString *) filePath;
-(void) loadUserPairs:(NSString *) filePath;
-(void) loadUserTeams:(NSString *) filePath;
-(void) loadUserExperiences:(NSString *) filePath;


@end
