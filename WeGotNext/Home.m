//
//  Home.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "Home.h"
#import "MyManager.h"
#import "UIViewController+AMSlideMenu.h"
#define METERS_PER_MILE 1609.344

@implementation Home

//function that is called when the window first loads
-(void) viewDidLoad{
    _Map.delegate = self;
}

//function that is called each time the window loads
-(void) viewWillAppear:(BOOL)animated{
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    //add left and right menu buttons to the screen
    [self addLeftMenuButton];
    [self addRightMenuButton];
    
    
    
    //TESTING: ADDS A PERSON AS A PAIR EACH TIME THE HOME SCREEN IS REACHED
    
    
    Person * temp = [[Person alloc] init];
    [temp setFirstName:[[NSString alloc] initWithFormat:@"FirstName%d", [sharedManager.user getNumberOfMatchesFromSport:[sharedManager.user getCurrentSport]]]];
    [temp setUserName:[[NSString alloc] initWithFormat:@"UserName%d", [sharedManager.user getNumberOfMatchesFromSport:[sharedManager.user getCurrentSport]]]];
    //[temp setIsMale:NO];
    [temp addUpVote];
    [temp addVote];
    //NSLog(@"%@", [temp getFirstName]);
    
    [sharedManager.user addMatchFromSport:[sharedManager.user getCurrentSport] match:temp];
    
    //IMPORTANT: WITH EVERY MATCH MADE, AUTOMATTICALLY ADD AN UPVOTE TO PREVENT NEGATIVE MATCHES
    [sharedManager addUpVotePair:[sharedManager.user getCurrentSport] value:YES];
    
    [sharedManager addPersonToDatabase:temp sport:[sharedManager.user getCurrentSport]];
    //[sharedManager.user addToTeamFromSport:[sharedManager.user getCurrentSport] person:temp];
}

-(void) viewDidAppear:(BOOL)animated{
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    //Sets the current location of the map to center at the users location
    CLLocation *zoomLocation = [[_Map userLocation] location];
    [sharedManager.user setCurrentLocation:zoomLocation];
}

//call this method once the map finishes loading so the location can be set to the users current location
- (void)mapViewDidFinishLoadingMap:(MKMapView*)mapView {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([[[_Map userLocation] location] coordinate], 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    [_Map setRegion:viewRegion animated:NO];
}
@end
