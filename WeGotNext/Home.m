//
//  Home.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "Home.h"
#import "MyManager.h"

@implementation Home

-(void) viewWillAppear:(BOOL)animated{
    MyManager *sharedManager = [MyManager sharedManager];
    
    Person * temp = [[Person alloc] init];
    [temp setFirstName:[[NSString alloc] initWithFormat:@"FirstName%d", [sharedManager.user getNumberOfMatchesFromSport:[sharedManager.user getCurrentSport]]]];
    [temp setUserName:[[NSString alloc] initWithFormat:@"UserName%d", [sharedManager.user getNumberOfMatchesFromSport:[sharedManager.user getCurrentSport]]]];
    //NSLog(@"%@", [temp getFirstName]);
    
    [sharedManager.user addMatchFromSport:[sharedManager.user getCurrentSport] match:temp];
    //[sharedManager.user addToTeamFromSport:[sharedManager.user getCurrentSport] person:temp];
    
    //NSLog(@"Add Person");
    //NSLog(@"%d", [sharedManager.user getNumberOfMatchesFromSport:[sharedManager.user getCurrentSport]]);
   // NSLog(@"%d", [sharedManager.user getCurrentSport]);
}

@end
