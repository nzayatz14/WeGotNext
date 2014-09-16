//
//  MainMenu.m
//  WeGotNext
//
//  Created by Nick Zayatz on 5/29/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "MainMenu.h"
#import "LoginWindow.h"
#import <sqlite3.h>
#define SPORT_COUNT 5

@implementation MainMenu

- (void) viewDidLoad{
    didClickLogOut = NO;
    
    serviceName = @"com.WeGotNext.WeGotNextKeys";
    
    [super viewDidLoad];
    
    //[segueWithIdentifier: @"btnHome"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//decides which window to show when one of the options on the left menu is clicked
-(NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath{
    NSString *identifier;
    
    //depending on the option selected perform the respective segue.
    //if the log out button is clicked, print the warning.
    switch (indexPath.row){
        case 0:
            identifier = @"btnHome";
            break;
        case 1:
            identifier = @"btnProfile";
            break;
        case 2:
            identifier = @"btnMatches";
            break;
        case 3:
            identifier = @"btnTeam";
            break;
        case 4:
            identifier = @"btnSettings";
            break;
        case 5:
            identifier = @"btnSwitchSports";
            break;
        case 6:
            identifier = @"btnPlayerPreferences";
            break;
        case 7:
        { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait" message:@"After logging out, players will still be able to see your account at the location of last log in." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log Out", nil];
            [alert show];
        }
            break;
        default:
            identifier = @"btnHome";
            break;
    }
    
    return identifier;
}

//if any option is selected in the right menu, go to the chat window
-(NSString *)segueIdentifierForIndexPathInRightMenu:(NSIndexPath *)indexPath{
    
    return @"btnChat";
}


//sets depth percetion when loading left or right menus
-(BOOL)deepnessForLeftMenu{
    return YES;
}

-(BOOL)deepnessForRightMenu{
    return YES;
}

//decides what to do when an option on the warning menu is clicked after hitting the log out button
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //if delete is clicked
    if(buttonIndex == 1){
        
        //send screen to the logout page and disable user interaction with the page
        [self.leftMenu performSegueWithIdentifier:@"btnLogOut" sender:self];
        self.view.userInteractionEnabled = NO;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsPath = [paths objectAtIndex:0];
        
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
        
        sqlite3 *inAppDatabase;
        
        //atempt to open the in-app database to delete user info, if attempt fails, print error
        if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
            //NSLog(@"Open Database to delete info");
            
            //delete all users from inApp pairs tables
            for(int i = 0;i<SPORT_COUNT;i++){
                NSString *temp = [[NSString alloc] initWithFormat:@"DELETE FROM pairsCurrentUser%d", i];
                const char *sqlStatement = [temp UTF8String];
                
                sqlite3_stmt *compiledStatement;
                
                //attempt to compile the SQL statement. continue if it works, if not, print an error.
                if(sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                    //delete data
                    //NSLog(@"deleting data pairs");
                }else{
                    NSLog(@"Error 1: %s", sqlite3_errmsg(inAppDatabase));
                }
                
                if(sqlite3_step(compiledStatement) == SQLITE_DONE)
                    sqlite3_finalize(compiledStatement);
                
            }
            
            //delete all users from inApp teams tables
            for(int i = 0;i<SPORT_COUNT;i++){
                NSString *temp = [[NSString alloc] initWithFormat:@"DELETE FROM teamCurrentUser%d", i];
                const char *sqlStatement = [temp UTF8String];
                
                sqlite3_stmt *compiledStatement;
                
                //attempt to compile the SQL statement. continue if it works, if not, print an error.
                if(sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                    //delete data
                    //NSLog(@"deleting data teams");
                }else{
                    NSLog(@"Error 2: %s", sqlite3_errmsg(inAppDatabase));
                }
                
                if(sqlite3_step(compiledStatement) == SQLITE_DONE)
                    sqlite3_finalize(compiledStatement);
                
            }
            
            
            //delete current user information
            const char *sqlStatementPlayer = "DELETE FROM currentUser";
            
            sqlite3_stmt *compiledStatementPlayer;
            
            //attempt to compile the SQL statement. continue if it works, if not, print an error.
            if(sqlite3_prepare_v2(inAppDatabase, sqlStatementPlayer, -1, &compiledStatementPlayer, NULL) == SQLITE_OK){
                //delete data
                //NSLog(@"deleting data currentUser");
            }else{
                NSLog(@"Error 3: %s", sqlite3_errmsg(inAppDatabase));
            }
            
            if(sqlite3_step(compiledStatementPlayer) == SQLITE_DONE)
                sqlite3_finalize(compiledStatementPlayer);
            
            
            
            //delete current user experience information
            const char *sqlStatementExperience = "DELETE FROM currentUserExperience";
            
            sqlite3_stmt *compiledStatementExperience;
            
            //attempt to compile the SQL statement. continue if it works, if not, print an error.
            if(sqlite3_prepare_v2(inAppDatabase, sqlStatementExperience, -1, &compiledStatementExperience, NULL) == SQLITE_OK){
                //delete data
                //NSLog(@"deleting data currentUserExperience");
            }else{
                NSLog(@"Error 4: %s", sqlite3_errmsg(inAppDatabase));
            }
            
            if(sqlite3_step(compiledStatementExperience) == SQLITE_DONE)
                sqlite3_finalize(compiledStatementExperience);
        }else{
            NSLog(@"Error 0: %s", sqlite3_errmsg(inAppDatabase));
        }
        
        //close the database
        sqlite3_close(inAppDatabase);
        
        //delete the value of the password stored in the keychain
        [self deleteKeychainValue:@"Password"];
    }
    
    //self.window.rootViewController = [[LoginWindow alloc] initWithNibName:nil bundle:nil];
}

//creates a new search key (identifier) to search the keychain with
- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    //NSLog(@"Create kaychain identifier logout");
    
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}

//deletes the current value stored in the keychain
- (void)deleteKeychainValue:(NSString *)identifier {
    //NSLog(@"Delete keychain values");
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    SecItemDelete((__bridge CFDictionaryRef)searchDictionary);
}

-(void) configureLeftMenuButton:(UIButton *)button{
    CGRect btnFrame = button.frame;
    btnFrame.origin = (CGPoint){0,0};
    btnFrame.size = (CGSize){70,40};
    button.frame = btnFrame;
    
    [button setTitle:@"Menu" forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}

-(void) configureRightMenuButton:(UIButton *)button{
    CGRect btnFrame = button.frame;
    btnFrame.origin = (CGPoint){0,0};
    btnFrame.size = (CGSize){70,40};
    button.frame = btnFrame;
    
    [button setTitle:@"Chat" forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}
@end
