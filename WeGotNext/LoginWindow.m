//
//  LoginWindow.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "LoginWindow.h"
#import "MyManager.h"
#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>

@implementation LoginWindow

//function that is called when the window first loads
-(void)viewDidLoad{
    //delegate the text fields so they can be closed when necessary
    [self.txtUserName setDelegate:self];
    [self.txtPassword setDelegate:self];
    
    //set return key to 'done' key
    [self.txtUserName setReturnKeyType:UIReturnKeyDone];
    [self.txtPassword setReturnKeyType:UIReturnKeyDone];
    
    empty = -1;
    
    serviceName = @"High-Point-University.WeGotNext";
    
    [super viewDidLoad];
}

//function that is called each time the window loads
//check to see if there is a user currently logges in on the device, if there is,
//pass the user to the home screen and set the current users information to his/her information
-(void) viewWillAppear:(BOOL)animated{
    
    //get the file path of the database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
    
    sqlite3 *inAppDatabase;
    
    //open the database, if there is an error, print the error
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        //NSLog(@"Open Database to save info");
        
        //sql statement to get the length of the current user table
        //(if its 1 someone is logged in, if its 0 nobody is)
        const char *sqlCount = "SELECT COUNT(*) FROM currentUser";
        sqlite3_stmt *compiledCountStatement;
        
        //if the sql statement is valid, load the count, if not print an error
        if(sqlite3_prepare_v2(inAppDatabase, sqlCount, -1, &compiledCountStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(compiledCountStatement) == SQLITE_ROW){
                empty = sqlite3_column_int(compiledCountStatement, 0);
                //NSLog(@"%d Count", empty);
            }
        }else{
            NSLog(@"Error: %s", sqlite3_errmsg(inAppDatabase));
        }
        
        //finalize the statement after it is executed or an error occurs
        //NSLog(@"Done Count");
        sqlite3_finalize(compiledCountStatement);
        
    }else{
        NSLog(@"Error: %s", sqlite3_errmsg(inAppDatabase));
    }
    
    //close the database
    sqlite3_close(inAppDatabase);
    
    //if there is a current user AND the data is NOT ALREADY loaded (like when a new user is created)
    //load the data, and pass the user to the home window
    MyManager *sharedManager = [MyManager sharedManager];
    if(empty == 1 && [[sharedManager.user getUserName] isEqualToString:@"userName"]){
        [self loadUserInformation:filePath];
    }else if (empty == 1 && ![[sharedManager.user getUserName] isEqualToString:@"userName"]){
        [super performSegueWithIdentifier:@"btnLogin" sender:self];
    }
    
}

/* FUNCTION IS INCOMPLETE*/
//function called when the login button is clicked
- (IBAction)btnLoginClicked:(UIButton *)sender {
    
    //get the userName and password from the text boxes
    NSString *userName = self.txtUserName.text;
    NSString *password = self.txtPassword.text;
    
    
    //hide keyboards
    [_txtUserName resignFirstResponder];
    [_txtPassword resignFirstResponder];
    
    //find username
    //if username found, see if passwords match
    [self getUserFromOutsideDatabase:userName password:password];
    //if passwords match
    //load person's data from online
    
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user setUserName:userName];
    [sharedManager.user setPassword:password];
    
    //set the rest of the users data
    
    //add the person who just logged in as the current user
    //[self addPersonAsCurrentUser];
    
    //segue to main menu
    //[super performSegueWithIdentifier:@"btnLogin" sender:self];
}

-(void)getUserFromOutsideDatabase: (NSString*) username password: (NSString*) pass{
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM users WHERE username='%@'", username];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:query, @"query", nil];
    
    NSError *err = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    if (err)
    {
        NSLog(@"%s: JSON encode error: %@", __FUNCTION__, err);
    }
    
    // start request
    NSURL *url = [NSURL URLWithString:@"http://linus.highpoint.edu/~nzayatz/getUser.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    NSString *params = [NSString stringWithFormat:@"json=%@", [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *paramsData = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", query);
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:paramsData];
    
    // execute request
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
    if (err)
    {
        NSLog(@"%s: NSURLConnection error: %@", __FUNCTION__, err);
    }else{
        NSLog(@"Connection Success");
    }
    
}

//Initialize the data object
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Recieved response");
    _downloadedData = [[NSMutableData alloc] init];
}

//add the newly downloaded data to the object
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Recieved data");
    [_downloadedData appendData:data];
}

//after the data has been read in, set the current users data equal to the read in data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection finished loading");
    MyManager *sharedManager = [MyManager sharedManager];
    
    //Parse the JSON that came in
    //get the first (and should be only) json element in the array
    NSError *err;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&err];
    
    if(err){
        NSLog(@"error getting json array");
    }else{
        NSLog(@"getting array success %d", [jsonArray count]);
    }
    
    // set the user person objects properties to the JsonElements properties
    [sharedManager.user setUserName:jsonArray[@"userName"]];
    [sharedManager.user setFirstName:jsonArray[@"firstName"]];
    [sharedManager.user setIsMale:(BOOL)jsonArray[@"isMale"]];
    
    //also need to do birthday, upVotes, and totalVotes
    
    //add the newly logged in person as the current user to the in app database
    [self addPersonAsCurrentUser];
    
}

//if the create button is clicked, open the create user window
- (IBAction)btnCreateClicked:(UIButton *)sender {
    [super performSegueWithIdentifier:@"btnCreate" sender:self];
}

/*FUNCTION IS INCOMPLETE*/
//if the forgot password function is clicked
- (IBAction)btnForgotPasswordClicked:(UIButton *)sender {
    
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

//method called to hide keyboard when 'done' is clicked
-(BOOL)textFieldShouldReturn:(UITextField *)atextField{
    [atextField resignFirstResponder];
    return YES;
}

//adds the person who is just logging in as the current user in the inApp database
- (void) addPersonAsCurrentUser{
    //NSLog(@"Add to database");
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
    
    sqlite3 *inAppDatabase;
    
    //attempts to open the database. if there is a problem print an error, if not, continue.
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        //NSLog(@"Open Database to save info");
        
        //extra check to make sure the currentUser table is empty
        if(empty == 0){
            const char *sqlStatement = "INSERT INTO currentUser (userName, firstName, isMale, birthday, upVotes, totalVotes) VALUES (?,?,?,?,?,?)";
            sqlite3_stmt *compiledStatement;
            
            //attempt to compile the SQL statement. continue if it works, if not, print an error.
            if(sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                //save data
                //NSLog(@"saving data");
                
                sqlite3_bind_text(compiledStatement,1,[sharedManager.user.getUserName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement,2,[sharedManager.user.getFirstName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(compiledStatement, 3, [sharedManager.user isMale]);
                
                
                //save the rest of the users data (birthday)
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
                NSLog(@"Error 1: %s", sqlite3_errmsg(inAppDatabase));
            }
            if(sqlite3_step(compiledStatement) == SQLITE_DONE){
                //NSLog(@"Done save");
                sqlite3_finalize(compiledStatement);
            }
        }
        
    }else{
        NSLog(@"Error 0: %s", sqlite3_errmsg(inAppDatabase));
    }
    
    //write the users pairs, teammates, and experiences to the inApp database as well from online
    
    
    
    sqlite3_close(inAppDatabase);
    [super performSegueWithIdentifier:@"btnLogin" sender:self];
}

//this function is called if there is a current user logged in BUT the users
//information is not yet loaded into the app
//loads the data in from the inApp database into the app
-(void) loadUserInformation:(NSString *) filePath{
    
    sqlite3 *inAppDatabase;
    MyManager *sharedManager = [MyManager sharedManager];
    
    //attempts to open the database. if there is a problem print an error, if not, continue.
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        
        const char *sqlStatement = "SELECT * FROM currentUser";
        sqlite3_stmt *compiledStatement;
        
        //attempt to compile the SQL statement. continue if it works, if not, print an error.
        if( sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            //continue to load in data while the row is not the END row
            //(there will always be either 0 or 1 rows)
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                
                //read in the persons data
                NSString *userName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 1)];
                
                [sharedManager.user setUserName:userName];
                
                NSString *password;
                
                NSData *passwordData = [self searchKeychainCopyMatching:@"Password"];
                
                if (passwordData) {
                    password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
                }else{
                    NSLog(@"Error loading Password");
                }
                
                [sharedManager.user setPassword:password];
                
                NSString *firstName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 2)];
                
                BOOL male = sqlite3_column_int(compiledStatement, 3);
                
                NSString *birth = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 4)];
                
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *birthDate = [format dateFromString:birth];
                
                int up = sqlite3_column_int(compiledStatement, 5);
                int total = sqlite3_column_int(compiledStatement, 6);
                
                [sharedManager.user setFirstName:firstName];
                [sharedManager.user setIsMale:male];
                [sharedManager.user setBirthday:birthDate];
                [sharedManager.user setUpVotes:up];
                [sharedManager.user setVotes:total];
                //
            }
        }else{
            NSLog(@"Error 1: %s", sqlite3_errmsg(inAppDatabase));
        }
        
        //finalize the SQL statement
        sqlite3_finalize(compiledStatement);
    }else{
        NSLog(@"Error 0: %s", sqlite3_errmsg(inAppDatabase));
    }
    
    //close the database
    sqlite3_close(inAppDatabase);
    
    //call load user pairs, load user teams, and load user experiences (consecutively)
    //to load all of the information
    //start with loading the users pairs
    [self loadUserPairs:filePath];
}

//loads the users pairs from the inApp database to the app
-(void) loadUserPairs:(NSString *) filePath{
    
    sqlite3 *inAppDatabase;
    MyManager *sharedManager = [MyManager sharedManager];
    
    //attempts to open the database. if there is a problem print an error, if not, continue.
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        //NSLog(@"Opened Database!! :D");
        
        //run the code for each sport to load all pairs
        for(int i = 0;i <SPORT_COUNT;i++){
            NSString *temp = [[NSString alloc] initWithFormat:@"SELECT * FROM pairsCurrentUser%d", i];
            const char *sqlStatement = [temp UTF8String];
            sqlite3_stmt *compiledStatement;
            
            //attempt to compile the SQL statement. continue if it works, if not, print an error.
            if( sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                
                //int players = 0;
                
                //load the data until the end of the table is reached for each sport
                while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                    
                    //read in the persons data and set that data to a new person object
                    NSString *userName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 1)];
                    
                    //NSLog(@"%@",userName);
                    
                    Person *p = [[Person alloc] init];
                    [p setUserName:userName];
                    
                    NSString *firstName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 2)];
                    
                    BOOL male = sqlite3_column_int(compiledStatement, 3);
                    
                    NSString *birth = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 4)];
                    
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *birthDate = [format dateFromString:birth];
                    
                    int up = sqlite3_column_int(compiledStatement, 5);
                    int total = sqlite3_column_int(compiledStatement, 6);
                    
                    for(int j = 0;j<EXP_COUNT;j++){
                        NSString *exp = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 7+j)];
                        [p setExperienceFromSport:i experienceNumber:j experience:exp];
                    }
                    
                    BOOL upPair = sqlite3_column_int(compiledStatement, 10);
                    //NSLog(@"%d being loaded, %d isMale", upPair, male);
                    
                    [p setFirstName:firstName];
                    [p setIsMale:male];
                    [p setBirthday:birthDate];
                    [p setUpVotes:up];
                    [p setVotes:total];
                    //
                    
                    //add the newly created person to the users pairs
                    [sharedManager.user addMatchFromSport:i match:p];
                    [sharedManager addUpVotePair:i value:upPair];
                    //players++;
                }
                //NSLog(@"Players in sport %d: %d", i, players);
            }else{
                NSLog(@"Error 1: %s", sqlite3_errmsg(inAppDatabase));
            }
            
            //finalize the SQL statement
            sqlite3_finalize(compiledStatement);
        }
    }else{
        NSLog(@"Error 0: %s", sqlite3_errmsg(inAppDatabase));
    }
    
    //close the database
    sqlite3_close(inAppDatabase);
    
    //next, load the users teams
    [self loadUserTeams:filePath];
}

//load the users teams from the inApp database to the app
-(void) loadUserTeams:(NSString *) filePath{
    
    sqlite3 *inAppDatabase;
    MyManager *sharedManager = [MyManager sharedManager];
    
    //attempts to open the database. if there is a problem print an error, if not, continue.
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        //NSLog(@"Opened Database!! :D");
        
        //run the code for each sport to load all teams
        for(int i = 0;i <SPORT_COUNT;i++){
            NSString *temp = [[NSString alloc] initWithFormat:@"SELECT * FROM teamCurrentUser%d", i];
            const char *sqlStatement = [temp UTF8String];
            sqlite3_stmt *compiledStatement;
            
            //attempt to compile the SQL statement. continue if it works, if not, print an error.
            if( sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                
                //int players = 0;
                
                //load the data until the end of the table is reached for each sport
                while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                    
                    //read in the persons data and set that data to a new person object
                    NSString *userName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 1)];
                    
                    //NSLog(@"%@",userName);
                    
                    Person *p = [[Person alloc] init];
                    [p setUserName:userName];
                    
                    NSString *firstName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 2)];
                    
                    [p setFirstName:firstName];
                    
                    BOOL male = sqlite3_column_int(compiledStatement, 3);
                    
                    NSString *birth = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 4)];
                    
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *birthDate = [format dateFromString:birth];
                    
                    int up = sqlite3_column_int(compiledStatement, 5);
                    int total = sqlite3_column_int(compiledStatement, 6);
                    
                    for(int j = 0;j<EXP_COUNT;j++){
                        NSString *exp = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 7+j)];
                        [p setExperienceFromSport:i experienceNumber:j experience:exp];
                    }
                    
                    [p setFirstName:firstName];
                    [p setIsMale:male];
                    [p setBirthday:birthDate];
                    [p setUpVotes:up];
                    [p setVotes:total];
                    //
                    
                    //add the newly created person to users team
                    [sharedManager.user addToTeamFromSport:i person:p];
                    //players++;
                }
                //NSLog(@"Teammates in sport %d: %d", i, players);
            }else{
                NSLog(@"Error 1: %s",sqlite3_errmsg(inAppDatabase));
            }
            
            //finalize the SQL statement
            sqlite3_finalize(compiledStatement);
        }
    }else{
        NSLog(@"Error 0: %s", sqlite3_errmsg(inAppDatabase));
    }
    
    //close the database
    sqlite3_close(inAppDatabase);
    
    //next, load the users experiences
    [self loadUserExperiences:filePath];
}

/*FUNCTION IS INCOMPLETE*/
//loads the experiences of the current user from the inApp database
-(void) loadUserExperiences:(NSString *) filePath{
    
    sqlite3 *inAppDatabase;
    MyManager *sharedManager = [MyManager sharedManager];
    
    //attempts to open the database. if there is a problem print an error, if not, continue.
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        //NSLog(@"Opened Database!! :D");
        
        NSString *temp = [[NSString alloc] initWithFormat:@"SELECT * FROM currentUserExperience"];
        const char *sqlStatement = [temp UTF8String];
        sqlite3_stmt *compiledStatement;
        
        //attempt to compile the SQL statement. continue if it works, if not, print an error.
        if( sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            
            //int times = 0;
            //load the data until the end of the table is reached
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                
                //read in the persons data and set that data to a new person object
                int sport = sqlite3_column_int(compiledStatement, 0);
                int experienceNum = sqlite3_column_int(compiledStatement, 1);
                
                //times++;
                //NSLog(@"load user Experiences %d %d %d", sport, experienceNum, times);
                NSString *exp = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 2)];
                
                [sharedManager.user setExperienceFromSport:sport experienceNumber:experienceNum experience:exp];
            }
            //NSLog(@"Teammates in sport %d: %d", i, players);
        }else{
            NSLog(@"Error 1: %s",sqlite3_errmsg(inAppDatabase));
        }
        
        //finalize the SQL statement
        sqlite3_finalize(compiledStatement);
        
    }else{
        NSLog(@"Error 0: %s", sqlite3_errmsg(inAppDatabase));
    }
    
    //close the database
    sqlite3_close(inAppDatabase);
    
    
    
    [super performSegueWithIdentifier:@"btnLogin" sender:self];
}


//creates a new search key (identifier) to search the keychain with
- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    //NSLog(@"create new keychain identifier login");
    
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}

//search for the information stored under the "identifier" and returns 1 object
//(only storing 1 object at a time)
- (NSData *)searchKeychainCopyMatching:(NSString *)identifier {
    //NSLog(@"Get password from keychain");
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    
    // return only 1 object
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    // set return type
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    NSData *result = nil;
    CFTypeRef cfType = (__bridge CFTypeRef)result;
    
    OSStatus status = SecItemCopyMatching(((__bridge CFDictionaryRef)searchDictionary), &cfType);
    
    result = (__bridge NSData *)cfType;
    return result;
}

@end
