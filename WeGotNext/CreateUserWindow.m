//
//  CreateUserWindow.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/6/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "CreateUserWindow.h"

@implementation CreateUserWindow

-(void) viewDidLoad{
    //delegate the text fields so they can be closed when necessary
    [self.txtUserName setDelegate:self];
    [self.txtPassword setDelegate:self];
    [self.txtConfirmPassword setDelegate:self];
    [self.txtFirstName setDelegate:self];
    [self.txtBirthday setDelegate:self];
    
    //set return key to 'done' on the text fields
    [self.txtUserName setReturnKeyType:UIReturnKeyDone];
    [self.txtPassword setReturnKeyType:UIReturnKeyDone];
    [self.txtConfirmPassword setReturnKeyType:UIReturnKeyDone];
    [self.txtFirstName setReturnKeyType:UIReturnKeyDone];
    [self.txtBirthday setReturnKeyType:UIReturnKeyDone];
    
    [super viewDidLoad];
    
}
- (IBAction)btnCreateClicked:(UIButton *)sender {
    
    //hide keyboards
    [_txtUserName resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtConfirmPassword resignFirstResponder];
    [_txtFirstName resignFirstResponder];
    [_txtBirthday resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnCancelClicked:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//method called when 'done' button is clicked on keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)atextField{
    [atextField resignFirstResponder];
    return YES;
}

@end
