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
    
    empty = -1;
    
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	NSString *documentsPath = [paths objectAtIndex:0];
    
	NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
    
    sqlite3 *inAppDatabase;
    
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        NSLog(@"Open Database to save info");
        
        const char *sqlCount = "SELECT COUNT(*) FROM currentUser";
        sqlite3_stmt *compiledCountStatement;
        
        if(sqlite3_prepare_v2(inAppDatabase, sqlCount, -1, &compiledCountStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(compiledCountStatement) == SQLITE_ROW){
                empty = sqlite3_column_int(compiledCountStatement, 0);
                NSLog(@"%d Count", empty);
            }
        }else{
            NSLog(@"Error: %s", sqlite3_errmsg(inAppDatabase));
        }
        
        NSLog(@"Done Count");
        sqlite3_finalize(compiledCountStatement);
    }
    sqlite3_close(inAppDatabase);
    
    MyManager *sharedManager = [MyManager sharedManager];
    if(empty == 1 && [[sharedManager.user getUserName] isEqualToString:@"userName"]){
        [self loadUserInformation:filePath];
    }else if (empty == 1 && ![[sharedManager.user getUserName] isEqualToString:@"userName"]){
        [super performSegueWithIdentifier:@"btnLogin" sender:self];
    }

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
    //load person's data from online
    
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user setUserName:userName];
    [sharedManager.user setPassword:password];
    
    //set the rest of the users data
    
    [self addPersonAsCurrentUser];
}

- (IBAction)btnCreateClicked:(UIButton *)sender {
    [super performSegueWithIdentifier:@"btnCreate" sender:self];
}

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

- (void) addPersonAsCurrentUser{
    NSLog(@"Add to database");
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	NSString *documentsPath = [paths objectAtIndex:0];
    
	NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
    
    sqlite3 *inAppDatabase;
    
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        NSLog(@"Open Database to save info");
        
        if(empty == 0){
            const char *sqlStatement = "INSERT INTO currentUser (userName, password, firstName, isMale) VALUES (?,?,?,?)";
            sqlite3_stmt *compiledStatement;
            
            if(sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                //save data
                NSLog(@"saving data");
                
                sqlite3_bind_text(compiledStatement,1,[sharedManager.user.getUserName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement,2,[sharedManager.user.getPassword UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement,3,[sharedManager.user.getFirstName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(compiledStatement, 4, [sharedManager.user isMale]);
                
            }else{
                NSLog(@"Error: %s", sqlite3_errmsg(inAppDatabase));
            }
            if(sqlite3_step(compiledStatement) == SQLITE_DONE){
                NSLog(@"Done save");
                sqlite3_finalize(compiledStatement);
            }
        }
        
    }else{
        NSLog(@"Error: %s", sqlite3_errmsg(inAppDatabase));
    }
    
    //write the users pairs, teammates, and experiences to the inApp database as well
    
    
    
    sqlite3_close(inAppDatabase);
    [super performSegueWithIdentifier:@"btnLogin" sender:self];
}

-(void) loadUserInformation:(NSString *) filePath{
    
    sqlite3 *inAppDatabase;
    MyManager *sharedManager = [MyManager sharedManager];
    
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        
            const char *sqlStatement = "SELECT * FROM currentUser";
            sqlite3_stmt *compiledStatement;
            
            if( sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                    
                    NSString *userName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 1)];
                    
                    [sharedManager.user setUserName:userName];
                    
                    //read in the rest of the persons data
                    NSString *password = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 2)];
                    
                    [sharedManager.user setPassword:password];
                    
                    NSString *firstName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 3)];
                    
                    [sharedManager.user setFirstName:firstName];
                    //
                }
            }else{
                NSLog(@"Perpare Error #%i: %s",0,sqlite3_errmsg(inAppDatabase));
            }
            sqlite3_finalize(compiledStatement);
    }else{
        NSLog(@"Failed to open database :(");
    }
    
    sqlite3_close(inAppDatabase);
    
    [self loadUserPairs:filePath];
}

-(void) loadUserPairs:(NSString *) filePath{
    
    sqlite3 *inAppDatabase;
    MyManager *sharedManager = [MyManager sharedManager];
    
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        NSLog(@"Opened Database!! :D");
        
        for(int i = 0;i <SPORT_COUNT;i++){
            NSString *temp = [[NSString alloc] initWithFormat:@"SELECT * FROM pairsCurrentUser%d", i];
            const char *sqlStatement = [temp UTF8String];
            sqlite3_stmt *compiledStatement;
            
            if( sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                
                int players = 0;
                while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                    
                    NSString *userName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 1)];
                    
                    NSLog(@"%@",userName);
                    
                    Person *p = [[Person alloc] init];
                    [p setUserName:userName];
                    
                    //read in the rest of the persons data
                    NSString *firstName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 2)];
                    
                    [p setFirstName:firstName];
                    //
                    
                    [sharedManager.user addMatchFromSport:i match:p];
                    players++;
                }
                NSLog(@"Players in sport %d: %d", i, players);
            }else{
                NSLog(@"Perpare Error #%i: %s",0,sqlite3_errmsg(inAppDatabase));
            }
            sqlite3_finalize(compiledStatement);
        }
    }else{
        NSLog(@"Failed to open database :(");
    }
    
    sqlite3_close(inAppDatabase);
    
    [self loadUserTeams:filePath];
}

-(void) loadUserTeams:(NSString *) filePath{
    
    sqlite3 *inAppDatabase;
    MyManager *sharedManager = [MyManager sharedManager];
    
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        NSLog(@"Opened Database!! :D");
        
        for(int i = 0;i <SPORT_COUNT;i++){
            NSString *temp = [[NSString alloc] initWithFormat:@"SELECT * FROM teamCurrentUser%d", i];
            const char *sqlStatement = [temp UTF8String];
            sqlite3_stmt *compiledStatement;
            
            if( sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                
                int players = 0;
                while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                    
                    NSString *userName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 1)];
                    
                    NSLog(@"%@",userName);
                    
                    Person *p = [[Person alloc] init];
                    [p setUserName:userName];
                    
                    //read in the rest of the persons data
                    NSString *firstName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 2)];
                    
                    [p setFirstName:firstName];
                    //
                    
                    [sharedManager.user addToTeamFromSport:i person:p];
                    players++;
                }
                NSLog(@"Teammates in sport %d: %d", i, players);
            }else{
                NSLog(@"Perpare Error #%i: %s",0,sqlite3_errmsg(inAppDatabase));
            }
            sqlite3_finalize(compiledStatement);
        }
    }else{
        NSLog(@"Failed to open database :(");
    }
    
    sqlite3_close(inAppDatabase);
    
    [self loadUserExperiences:filePath];
}

-(void) loadUserExperiences:(NSString *) filePath{
    
    [super performSegueWithIdentifier:@"btnLogin" sender:self];
}

@end
