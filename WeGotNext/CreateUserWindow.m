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
#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>

//Constant to hold the height of the menu accessory for the datePicker for txtBirthday
#define DATE_PICKER_ACCESSORY_WIDTH 50
#define USER_NAME_MIN_LENGTH 1
#define PASSWORD_MIN_LENGTH 8

@implementation CreateUserWindow

-(void) viewDidLoad{
    
    serviceName = @"High-Point-University.WeGotNext";
    
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

//function called if the create button is clicked
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
    
    //check if information is valid. if it is, set the current users information
    //to the information that was just entered
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

//method called when 'done' button is clicked on a keyboard, hides the keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)atextField{
    
    [atextField resignFirstResponder];
    return YES;
}

/*FUNCTION IS INCOMPLETE*/
//adds the newly created user to the online database then sets the current users information
//in the database to the newly entered information
-(void) addPersonToOnlineDatabase{
    MyManager *sharedManager = [MyManager sharedManager];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *birthString = [format stringFromDate:[sharedManager.user getBirthday]];
    
    
    NSString *query = [[NSString alloc] initWithFormat:@"INSERT INTO users (userName, password, firstName ,isMale, birthday, upVotes, totalVotes) VALUES ('%@', '%@', '%@', %d, '%@', %d, %d)", [sharedManager.user getUserName], [sharedManager.user getPassword], [sharedManager.user getFirstName],[sharedManager.user isMale], birthString, [sharedManager.user getUpVotes], [sharedManager.user getVotes]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:query, @"query", nil];
    
    NSError *err = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (err)
    {
        NSLog(@"%s: JSON encode error: %@", __FUNCTION__, err);
    }
    
    // start request
    NSURL *url = [NSURL URLWithString:@"http://linus.highpoint.edu/~nzayatz/addUser.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    NSString *params = [NSString stringWithFormat:@"json=%@", [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *paramsData = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:paramsData];
    
    // execute request
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
    if (!connection)
    {
        NSLog(@"%s: NSURLConnection error: %@", __FUNCTION__, err);
    }else{
        NSLog(@"Connection Success!");
    }
    
    
    [self addPersonAsCurrentUser];
}

//Initialize the data object
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Recieved response");
}

//add the newly downloaded data to the object
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Recieved data");
    NSString *temp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",temp);
}

//after the data has been read in, set the current users data equal to the read in data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection finished loading");

    
}


//adds the newly entered information to the database as the current user
-(void) addPersonAsCurrentUser{
    //NSLog(@"Add person as current user");
    
    //get the path of the database
    MyManager *sharedManager = [MyManager sharedManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	NSString *documentsPath = [paths objectAtIndex:0];
    
	NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
    
    sqlite3 *inAppDatabase;
    
    //if the database is opened successfully, continue, if not, print the error
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        //NSLog(@"Open Database to save info");
        
        //sql statement to add user to current database
        const char *sqlStatement = "INSERT INTO currentUser (userName, firstName, isMale, birthday, upVotes, totalVotes) VALUES (?,?,?,?,?,?)";
        sqlite3_stmt *compiledStatement;
        
        //if the statement is legal, save the data. if not, print an error
        if(sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            //save data
            //NSLog(@"saving data");
            
            sqlite3_bind_text(compiledStatement,1,[sharedManager.user.getUserName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,2,[sharedManager.user.getFirstName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 3, [sharedManager.user isMale]);
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *birthString = [format stringFromDate:[sharedManager.user getBirthday]];
            
            sqlite3_bind_text(compiledStatement, 4, [birthString UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_int(compiledStatement, 5, 0);
            sqlite3_bind_int(compiledStatement, 6, 0);
            
            /*for(int i = 0;i<EXP_COUNT;i++){
             sqlite3_bind_text(compiledStatement,i+7,[[p getExperienceFromSport:sp experienceNumber:i] cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
             } */
            
            
        }else{
            NSLog(@"Error: %s", sqlite3_errmsg(inAppDatabase));
        }
        
        //end the statement once actions are completed or error is printed
        if(sqlite3_step(compiledStatement) == SQLITE_DONE){
            //NSLog(@"Done save");
            sqlite3_finalize(compiledStatement);
        }
        
    }else{
        NSLog(@"Error: %s", sqlite3_errmsg(inAppDatabase));
    }
    
    //close the database
    sqlite3_close(inAppDatabase);
    
    //save the password to the keychain
    [self createKeychainValue:_txtPassword.text forIdentifier:@"Password"];
    
    //create experiences for inApp database
    [self addUserExperiences: filePath];
}

/*FUNCTION IS INCOMPLETE*/
//checks to see if the users entered information is valid
-(BOOL) informationIsValid:(NSString *) userName password:(NSString *) pass confirmPassword:(NSString *) confirm firstName:(NSString *) first birthday:(NSDate *) age{
    
    //NSLog(@"%@", pass);
    //NSLog(@"%@", confirm);
    
    //the username cannot be equal to the string 'userName'
    if([userName isEqualToString:@"userName"]){
        //NSLog(@"userName is userName");
        return NO;
        
    }
    
    //the userName must be at least 1 character long
    if(userName.length <USER_NAME_MIN_LENGTH){
        //NSLog(@"userName is less than min");
        return NO;
        
    }
    
    //if userName cannot be already taken
    /*CHECK ONLINE DATABASE*/
    
    //the password must match the confirm password
    if(![pass isEqualToString:confirm]){
        //NSLog(@"passwords dont match");
        return NO;
        
    }
    
    //the password must be at least 8 characters long
    if(pass.length <PASSWORD_MIN_LENGTH){
        //NSLog(@"password less than min");
        return NO;
        
    }
    
    //if birthday is under age limit?
    
    return YES;
    
}

//saves the user experience information to the inApp database
-(void) addUserExperiences:(NSString *) filePath{
    
    //NSLog(@"Add user experiences");
    sqlite3 *inAppDatabase;
    
    //if the database is opened successfully, continue, if not, print the error
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        //NSLog(@"Open Database to save info");
        
        MyManager *sharedManager = [MyManager sharedManager];
        
        //int times = 0;
        for(int i = 0;i<SPORT_COUNT;i++){
            for(int j = 0;j<EXP_COUNT;j++){
                //sql statement to add user to current database
                const char *sqlStatement = "INSERT INTO currentUserExperience (sport, experienceNumber, experience) VALUES (?,?,?)";
                sqlite3_stmt *compiledStatement;
                
                //if the statement is legal, save the data. if not, print an error
                if(sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                    //save data
                    //NSLog(@"saving data");
                    
                    NSString *currentExperience = [sharedManager.user getExperienceFromSport:i experienceNumber:j];
                    //NSLog(@"%@", currentExperience);
                    
                    sqlite3_bind_int(compiledStatement, 1, i);
                    sqlite3_bind_int(compiledStatement, 2, j);
                    sqlite3_bind_text(compiledStatement,3,[currentExperience UTF8String], -1, SQLITE_TRANSIENT);
                    
                    //times++;
                    //NSLog(@"%d", times);
                }else{
                    NSLog(@"Error: %s", sqlite3_errmsg(inAppDatabase));
                }
                
                //end the statement once actions are completed or error is printed
                if(sqlite3_step(compiledStatement) == SQLITE_DONE){
                    //NSLog(@"Done save");
                    sqlite3_finalize(compiledStatement);
                }
            }
        }
        
    }else{
        NSLog(@"Error: %s", sqlite3_errmsg(inAppDatabase));
    }
    
    //close the database
    sqlite3_close(inAppDatabase);
    
    
    //dismiss the create user window
    [self dismissViewControllerAnimated:YES completion:nil];
}

//creates a new search key (identifier) to search the keychain with
- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    //NSLog(@"Create keychain identifier NewUser");
    
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}

//creates a value (password) under the given identifier (identifier)
- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    //NSLog(@"Add password to my keychain");
    
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

@end
