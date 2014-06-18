//
//  CreateUserWindow.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/6/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "CreateUserWindow.h"

//Constant to hold the height of the menu accessory for the datePicker for txtBirthday
#define DATE_PICKER_ACCESSORY_WIDTH 50

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
    
    //set birthdays responder to be a datePicker instead of a keyboard
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    //creates toolbar for date picker to hold the 'Done' button
    UIToolbar *pickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, DATE_PICKER_ACCESSORY_WIDTH)];
    pickerToolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closeTextField:)];
    [doneButton setWidth:65.0f];
    
    pickerToolBar.items = [NSArray arrayWithObjects:doneButton, nil];
    
    [_txtBirthday setInputView:datePicker];
    [_txtBirthday setInputAccessoryView:pickerToolBar];
    
    [super viewDidLoad];
    
}

//sets the date in txtBirthday to the current date value in the datePicker while
//the datePicker is being used
-(void)updateTextField:(id)sender{
    if([_txtBirthday isFirstResponder]){
        UIDatePicker *picker = (UIDatePicker *)_txtBirthday.inputView;
        NSDateFormatter *mmddyyyy = [[NSDateFormatter alloc] init];
        mmddyyyy.timeStyle = NSDateFormatterNoStyle;
        mmddyyyy.dateFormat = @"MM/dd/yyyy";
        _txtBirthday.text = [mmddyyyy stringFromDate:picker.date];
    }
}

//sets the date in txtBirthday to the last date value in the datePicker before
//clicking the 'Done' button
-(void)closeTextField:(id)sender{
    if([_txtBirthday isFirstResponder]){
        UIDatePicker *picker = (UIDatePicker *)_txtBirthday.inputView;
        NSDateFormatter *mmddyyyy = [[NSDateFormatter alloc] init];
        mmddyyyy.timeStyle = NSDateFormatterNoStyle;
        mmddyyyy.dateFormat = @"MM/dd/yyyy";
        _txtBirthday.text = [mmddyyyy stringFromDate:picker.date];
    }
    [_txtBirthday resignFirstResponder];
}

- (IBAction)btnCreateClicked:(UIButton *)sender {
    
    //hide keyboards
    [_txtUserName resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtConfirmPassword resignFirstResponder];
    [_txtFirstName resignFirstResponder];
    [_txtBirthday resignFirstResponder];
    
    //get text from text fields, birthday, and boolean from switch for gender
    NSString *userName = _txtUserName.text;
    NSString *password = _txtPassword.text;
    NSString *confirmedPassword = _txtPassword.text;
    NSString *firstName = _txtFirstName.text;
    BOOL male = (!_sldGender.on);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterNoStyle;
    formatter.dateFormat = @"MM/dd/yyyy";
    NSDate *birthday = [formatter dateFromString:_txtBirthday.text];
    
    //if username is available, print error
    
    //check if passwords equal
    if([password isEqualToString:confirmedPassword]){
        
    }else{
        
    }
    
    //dismiss the create user window
    [self dismissViewControllerAnimated:YES completion:nil];
}

//if cancel is clicked go back to the login window
- (IBAction)btnCancelClicked:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//checks to make sure no invalid characters can be entered into the textfield
//(only letters, numbers, and underscores)
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"];
    
    if([[string stringByTrimmingCharactersInSet:set] length] >0){
        return NO;
    }else{
        return YES;
    }
    
}

//method called when 'done' button is clicked on a keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)atextField{
    
    [atextField resignFirstResponder];
    return YES;
}

@end
