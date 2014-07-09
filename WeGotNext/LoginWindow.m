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
    //load person's data from online
    
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user setUserName:userName];
    [sharedManager.user setPassword:password];
    
    [self addPersonAsCurrentUser];
}

- (IBAction)btnCreateClicked:(UIButton *)sender {
    [super performSegueWithIdentifier:@"btnCreate" sender:self];
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
        
        const char *sqlCount = "SELECT COUNT(*) FROM currentUser";
        sqlite3_stmt *compiledCountStatement;
        
        int empty = -1;
        
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
    
    sqlite3_close(inAppDatabase);
    [super performSegueWithIdentifier:@"btnLogin" sender:self];
}

@end
