//
//  LoginWindow.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "LoginWindow.h"
#import "MyManager.h"

@implementation LoginWindow

-(void)viewDidLoad{
    //delegate the text fields so they can be closed when necessary
    [self.txtUserName setDelegate:self];
    [self.txtPassword setDelegate:self];
    
    //set return key to 'done' key
    [self.txtUserName setReturnKeyType:UIReturnKeyDone];
    [self.txtPassword setReturnKeyType:UIReturnKeyDone];
    
    [super viewDidLoad];
}

- (IBAction)btnLoginClicked:(UIButton *)sender {
    NSString *userName = self.txtUserName.text;
    NSString *password = self.txtPassword.text;
    
    
    //hide keyboards
    [_txtUserName resignFirstResponder];
    [_txtPassword resignFirstResponder];
    
    //find username
    //if username found, see if passwords match
    
    //if passwords match
        //load person's data
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user setUserName:userName];
    [sharedManager.user setPassword:password];
    
    [super performSegueWithIdentifier:@"btnLogin" sender:self];
}

- (IBAction)btnCreateClicked:(UIButton *)sender {
    [super performSegueWithIdentifier:@"btnCreate" sender:self];
}

//method called to hide keyboard when 'done' is clicked
-(BOOL)textFieldShouldReturn:(UITextField *)atextField{
    [atextField resignFirstResponder];
    return YES;
}

@end
