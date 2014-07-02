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

+(id)sharedManager {
    static MyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{sharedMyManager = [[self alloc] init];});
    
    return sharedMyManager;
}

-(id) init {
    if(self = [super init]){
        user = [[Person alloc] init];
        _notifyNewPair = YES;
        _notifyNewPlayerMessage = YES;
        _notifyNewTeammateMessage = YES;
    }
    return self;
}

-(void) dealloc {
    
}

- (BOOL) isUserOnTeam:(Person *) p{
    NSString *userComparedName = [p getUserName];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [user getTeamFromSport:[user getCurrentSport] team:array];
    
    for(Person *pair in array){
        if([userComparedName isEqualToString:[pair getUserName]])
            return YES;
    }
    
    return NO;
}

- (void) addPersonToDatabase:(Person *) p sport:(int) sp{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

	NSString *documentsPath = [paths objectAtIndex:0];

	NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
    
    sqlite3 *inAppDatabase;
    
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        NSString *temp = [[NSString alloc] initWithFormat:@"INSERT INTO pairsCurrentUser%d (userName, firstName, isMale, birthday, upVotes, totalVotes) VALUES (?,?,?,?,?,?)", sp];
        const char *sqlStatement = [temp UTF8String];
        
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(inAppDatabase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            //save data
        }
        
        if(sqlite3_step(compiledStatement) == SQLITE_DONE)
            sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(inAppDatabase);
}

@end
