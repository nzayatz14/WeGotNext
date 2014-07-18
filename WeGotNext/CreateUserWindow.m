//
//  CreateUserWindow.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/6/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "CreateUserWindow.h"
#import "MyManager.h"
#import <sqlite3.h>

//Constant to hold the height of the menu accessory for the datePicker for txtBirthday
#define DATE_PICKER_ACCESSORY_WIDTH 50
#define USER_NAME_MIN_LENGTH 1
#define PASSWORD_MIN_LENGTH 8

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
    NSString *confirmedPassword = _txtConfirmPassword.text;
    NSString *firstName = _txtFirstName.text;
    BOOL male = (!_sldGender.on);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterNoStyle;
    formatter.dateFormat = @"MM/dd/yyyy";
    NSDate *birthday = [formatter dateFromString:_txtBirthday.text];
    
    //check if information is valid
    if([self informationIsValid:userName password:password confirmPassword:confirmedPassword firstName:firstName birthday:birthday]){
            MyManager *sharedManager = [MyManager sharedManager];
            [sharedManager.user setUserName:userName];
            [sharedManager.user setPassword:password];
            [sharedManager.user setFirstName:firstName];
            [sharedManager.user setIsMale:male];
            [sharedManager.user setBirthday:birthday];
            [self addPersonToOnlineDatabase];
    }
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

-(void) addPersonToOnlineDatabase{
    
    [self addPersonAsCurrentUser];
}

-(void) addPersonAsCurrentUser{
    NSLog(@"Add to database");
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	NSString *documentsPath = [paths objectAtIndex:0];
    
	NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
    
    sqlite3 *inAppDatabase;
    
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        NSLog(@"Open Database to save info");
        
        const char *sqlStatement = "INSERT INTO currentUser (userName, password, firstName, isMale, birthday, upVotes, totalVotes) VALUES (?,?,?,?,?,?,?)";
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            //save data
            NSLog(@"saving data");
            
            sqlite3_bind_text(compiledStatement,1,[sharedManager.user.getUserName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,2,[sharedManager.user.getPassword UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,3,[sharedManager.user.getFirstName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 4, [sharedManager.user isMale]);
            
            //save the rest of the users data (birthday)
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *birthString = [format stringFromDate:[sharedManager.user getBirthday]];
            
            sqlite3_bind_text(compiledStatement, 5, [birthString UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_int(compiledStatement, 6, 0);
            sqlite3_bind_int(compiledStatement, 7, 0);
            
            /*for(int i = 0;i<EXP_COUNT;i++){
                sqlite3_bind_text(compiledStatement,i+7,[[p getExperienceFromSport:sp experienceNumber:i] cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            } */
            
            
        }else{
            NSLog(@"Error: %s", sqlite3_errmsg(inAppDatabase));
        }
        if(sqlite3_step(compiledStatement) == SQLITE_DONE){
            NSLog(@"Done save");
            sqlite3_finalize(compiledStatement);
        }
        
    }else{
        NSLog(@"Error: %s", sqlite3_errmsg(inAppDatabase));
    }
    
    sqlite3_close(inAppDatabase);
    
    //dismiss the create user window
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) informationIsValid:(NSString *) userName password:(NSString *) pass confirmPassword:(NSString *) confirm firstName:(NSString *) first birthday:(NSDate *) age{
    
    NSLog(@"%@", pass);
    NSLog(@"%@", confirm);
    
    if([userName isEqualToString:@"userName"]){
        NSLog(@"userName is userName");
        return NO;
        
    }
    
    if(userName.length <USER_NAME_MIN_LENGTH){
        NSLog(@"userName is less than min");
        return NO;
        
    }
    
    //if userName is already taken
    
    if(![pass isEqualToString:confirm]){
        NSLog(@"passwords dont match");
        return NO;
        
    }
    
    if(pass.length <PASSWORD_MIN_LENGTH){
        NSLog(@"password less than min");
        return NO;
        
    }
    
    //if birthday is under age limit
    
    return YES;
    
}

@end
