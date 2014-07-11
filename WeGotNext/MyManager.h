//
//  MyManager.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/11/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Person.h"

@interface MyManager : NSObject{
    Person *user;
}

@property (nonatomic, retain) Person *user;

@property (nonatomic, assign) BOOL notifyNewPair;
@property (nonatomic, assign) BOOL notifyNewPlayerMessage;
@property (nonatomic, assign) BOOL notifyNewTeammateMessage;

+(id)sharedManager;
- (BOOL) isUserOnTeam:(Person *) p;
- (void) addPersonToDatabase:(Person *) p sport:(int) sp;
- (void) addTeammateToDatabase:(Person *) p sport:(int) sp;

@end
