//
//  MyManager.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/11/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "MyManager.h"

@implementation MyManager

@synthesize user;

//call to make sure this is the only manager in the program to be created
+(id)sharedManager {
    static MyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{sharedMyManager = [[self alloc] init];});
    
    return sharedMyManager;
}

//initialize the person object (user) for myManager
-(id) init {
    if(self = [super init]){
        user = [[Person alloc] init];
        _notifyNewPair = YES;
        _notifyNewPlayerMessage = YES;
        _notifyNewTeammateMessage = YES;
        
        for(int i = 0;i<SPORT_COUNT; i++){
            upVotePairs[i] = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

-(void) dealloc {
    
}

//checks to see if the person p is on the users team for the current sport
- (BOOL) isUserOnTeam:(Person *) p{
    NSString *userComparedName = [p getUserName];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [user getTeamFromSport:[user getCurrentSport] team:array];
    
    //run through the list of teammates from that sport to see if he/she is already on a team
    for(Person *pair in array){
        if([userComparedName isEqualToString:[pair getUserName]])
            return YES;
    }
    
    return NO;
}

//adds a newly paired player p into the inApp pairs database for the sport sp
- (void) addPersonToDatabase:(Person *) p sport:(int) sp{
    
    NSLog(@"Add to person database %@", [p getUserName]);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

	NSString *documentsPath = [paths objectAtIndex:0];

	NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
    
    sqlite3 *inAppDatabase;
    
    //attempts to open the inApp database. if successful, continue, if not, print error.
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        //NSLog(@"Open Database to save info");
        
        NSString *temp = [[NSString alloc] initWithFormat:@"INSERT INTO pairsCurrentUser%d (userName, firstName, isMale, birthday, upVotes, totalVotes, experience1, experience2, experience3, upVotePair) VALUES (?,?,?,?,?,?,?,?,?,?)", sp];
        const char *sqlStatement = [temp UTF8String];
        
        sqlite3_stmt *compiledStatement;
        
        //attempts to compiled the SQL statement. if successful, continue, if not print error.
        if(sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            //save data
            //NSLog(@"saving data");
            
            sqlite3_bind_text(compiledStatement,1,[p.getUserName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,2,[p.getFirstName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 3, [p isMale]);
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *birthString = [format stringFromDate:[p getBirthday]];
            
            sqlite3_bind_text(compiledStatement, 4, [birthString UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_int(compiledStatement, 5, [p getUpVotes]);
            sqlite3_bind_int(compiledStatement, 6, [p getVotes]);
            
            for(int i = 0;i<EXP_COUNT;i++){
                sqlite3_bind_text(compiledStatement,i+7,[[p getExperienceFromSport:sp experienceNumber:i] cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            }
            
            //NSLog(@"%d being saved", [p isMale]);
            
            sqlite3_bind_int(compiledStatement, 10, 1);

        }else{
            NSLog(@"Error 1: %s", sqlite3_errmsg(inAppDatabase));
        }
        
        //finalize the SQL statement
        if(sqlite3_step(compiledStatement) == SQLITE_DONE)
            sqlite3_finalize(compiledStatement);
    }else{
        NSLog(@"Error 0: %s", sqlite3_errmsg(inAppDatabase));
    }
    
    //close the database
    sqlite3_close(inAppDatabase);
}

//adds a newly made teammate player p into the inApp team database for the sport sp
-(void) addTeammateToDatabase:(Person *) p sport:(int) sp{
    
    //NSLog(@"Add to teammate database");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	NSString *documentsPath = [paths objectAtIndex:0];
    
	NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
    
    sqlite3 *inAppDatabase;
    
    //attempts to open the inApp database. if successful, continue, if not, print error.
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        //NSLog(@"Open Database to save info");
        
        NSString *temp = [[NSString alloc] initWithFormat:@"INSERT INTO teamCurrentUser%d (userName, firstName, isMale, birthday, upVotes, totalVotes, experience1, experience2, experience3) VALUES (?,?,?,?,?,?,?,?,?)", sp];
        const char *sqlStatement = [temp UTF8String];
        
        sqlite3_stmt *compiledStatement;
        
        //attempts to compiled the SQL statement. if successful, continue, if not print error.
        if(sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            //save data
            //NSLog(@"saving data");
            
            sqlite3_bind_text(compiledStatement,1,[p.getUserName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,2,[p.getFirstName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 3, [p isMale]);
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *birthString = [format stringFromDate:[p getBirthday]];
            
            sqlite3_bind_text(compiledStatement, 4, [birthString UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_int(compiledStatement, 5, [p getUpVotes]);
            sqlite3_bind_int(compiledStatement, 6, [p getVotes]);
            
            for(int i = 0;i<EXP_COUNT;i++){
                sqlite3_bind_text(compiledStatement,i+7,[[p getExperienceFromSport:sp experienceNumber:i] cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
            }
            
        }else{
            NSLog(@"Error 1: %s", sqlite3_errmsg(inAppDatabase));
        }
        
        //finalize the SQL statement
        if(sqlite3_step(compiledStatement) == SQLITE_DONE)
            sqlite3_finalize(compiledStatement);
    }else{
        NSLog(@"Error 0: %s", sqlite3_errmsg(inAppDatabase));
    }
    
    //close the database
    sqlite3_close(inAppDatabase);
}

//removes player p from the team of the sport sp
-(void) removeTeammateFromDatabase:(Person *) p sport:(int) sp{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
    
    sqlite3 *inAppDatabase;
    
    //open the in-app database to delete user info
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        NSString *temp = [[NSString alloc] initWithFormat:@"DELETE FROM teamCurrentUser%d WHERE userName='%@'", sp, [p getUserName]];
        const char *sqlStatement = [temp UTF8String];
        
        sqlite3_stmt *compiledStatement;
        
        //attempts to compiled the SQL statement. if successful, continue, if not print error.
        if(sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            //delete data
            //NSLog(@"deleting data teammate");
        }else{
            NSLog(@"Error 1: %s", sqlite3_errmsg(inAppDatabase));
        }
        
        //finalize the SQL statement
        if(sqlite3_step(compiledStatement) == SQLITE_DONE)
            sqlite3_finalize(compiledStatement);
    }else{
        NSLog(@"Error 0: %s", sqlite3_errmsg(inAppDatabase));
    }
    
    //close the database
    sqlite3_close(inAppDatabase);
}

//sets the users vote on the 'match'-numbered pair in the 'sport' sport to the boolean 'up'
//(up vote if true, down vote if false)
-(void) setUpVotePair:(int) sport matchNumber:(int) match value:(BOOL) up{
    [upVotePairs[sport] replaceObjectAtIndex:match withObject:[NSNumber numberWithBool:up]];
}

//returns the users vote on the 'match'-numbered pair in the 'sport' as a boolean
//(up vote if true, down vote if false)
-(BOOL) getUpVotePair:(int) sport matchNumber:(int) match{
    return [[upVotePairs[sport] objectAtIndex:match] boolValue];
}

//creates a new voteable object each time a new pair is made
-(void) addUpVotePair:(int) sport value:(BOOL) up{
    [upVotePairs[sport] addObject:[NSNumber numberWithBool:up]];
}

-(void) loadPairsFromOutsideDatabase: (NSString*) username{
    
    NSString *matchString = [[NSString alloc] initWithFormat:@"Matches%@", username];
    PFQuery *pairsQuery = [PFQuery queryWithClassName:matchString];
    
    [pairsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            NSLog(@"Loading Data :D");
            
            for(PFObject *obj in objects){
                //NSLog(@"%d",[obj[@"sportNumber"] intValue]);
                //int sportNumber = [obj[@"sportNumber"] intValue];
                NSString *userName = obj[@"userName"];
                NSString *firstName =obj[@"firstName"];
                //BOOL isMale = [obj[@"isMale"] boolValue];
                //int totalVotes = [obj[@"totalVotes"] intValue];
                //int upVotes = [obj[@"upVotes"] intValue];
                NSString *birthday = obj[@"birthday"];
                
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *birthDate = [format dateFromString:birthday];
                
                
                Person *p = [[Person alloc] initWithUserName:userName FirstName:firstName Password:@"" isMale:YES birthdate:birthDate upVotes:1 votes:1];
                
                [user addMatchFromSport:0 match:p];
                [self addPersonToDatabase:p sport:0];
            }
        }else{
            NSLog(@"Error loading data.");
        }
    }];
    
    
    [self loadTeammatesFromOutsideDatabase:username];
}

-(void) loadTeammatesFromOutsideDatabase: (NSString*) username{
    [self loadUserExperiencesFromOutsideDatabase:username];
}

-(void) loadUserExperiencesFromOutsideDatabase: (NSString*) username{
    
}

@end
