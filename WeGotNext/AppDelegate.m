//
//  AppDelegate.m
//  WeGotNext
//
//  Created by Nick Zayatz on 5/29/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "AppDelegate.h"
#import "MyManager.h"
#include <FacebookSDK/FacebookSDK.h>
#define SPORT_COUNT 5

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSString *filePath = [self copyDatabaseToDocuments];
    //[self readInformationFromDatabaseWithPath:filePath];
    
    [FBLoginView class];
    
    return YES;
}

//load facebook log in if
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//if the database is not already in the documents folder, copy it
//there so the database tables are able to be edited
- (NSString *)copyDatabaseToDocuments{
    //NSLog(@"Copy Database to Documents");
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //get the file path of where the database should be
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
    
    //if the file does not exist at that path, copy it there
    if(![fileManager fileExistsAtPath:filePath]){
        NSLog(@"Copy");
        NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
        [fileManager copyItemAtPath:bundlePath toPath:filePath error:nil];
    }
    
    return filePath;
}


/*FUNCTION IS NOT IN USE RIGHT NOW, DOES NOT NEED TO BE CALLED ON EVERY START UP SO IT WAS PUT ELSEWHERE */
//Reads in the information from the database's tables and loads the arrays with that information
- (void) readInformationFromDatabaseWithPath:(NSString *) filePath{
    sqlite3 *inAppDatabase;
    MyManager *sharedManager = [MyManager sharedManager];
    
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        //NSLog(@"Opened Database!! :D");
        
        for(int i = 0;i <SPORT_COUNT;i++){
            NSString *temp = [[NSString alloc] initWithFormat:@"SELECT * FROM pairsCurrentUser%d", i];
            const char *sqlStatement = [temp UTF8String];
            sqlite3_stmt *compiledStatement;
            
           if( sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                
                int players = 0;
                while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                    
                    NSString *userName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 1)];
                    
                    //NSLog(@"%@",userName);
                    
                    Person *p = [[Person alloc] init];
                    [p setUserName:userName];
                    
                    //read in the rest of the persons data
                    NSString *firstName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 2)];
                    
                    [p setFirstName:firstName];
                    //
                    
                    [sharedManager.user addMatchFromSport:i match:p];
                    players++;
                }
                //NSLog(@"Players in sport %d: %d", i, players);
           }else{
               NSLog(@"Error 1: %s",sqlite3_errmsg(inAppDatabase));
           }
            sqlite3_finalize(compiledStatement);
        }
    }else{
        NSLog(@"Error 0: %s",sqlite3_errmsg(inAppDatabase));
    }
    
    sqlite3_close(inAppDatabase);
}

@end
