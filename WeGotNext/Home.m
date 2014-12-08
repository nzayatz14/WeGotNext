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
#import <Parse/Parse.h>
#define METERS_PER_MILE 1609.344

@implementation Home

//function that is called when the window first loads
-(void) viewDidLoad{
    
    _Map.delegate = self;
    _Map.showsPointsOfInterest = NO;
    
    CLLocationManager *locationManager;
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    _Map.showsUserLocation = YES;
    [locationManager startUpdatingLocation];
    
    currentLocation = [[CLLocation alloc] init];
    
    currentLocation = [locationManager location];
}

//function that is called each time the window loads
-(void) viewWillAppear:(BOOL)animated{
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    //add left and right menu buttons to the screen
    [self addLeftMenuButton];
    [self addRightMenuButton];
    
    [_Map setCenterCoordinate:[[[_Map userLocation] location] coordinate] animated:NO];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *birthString = [format stringFromDate:[sharedManager.user getBirthday]];
    
    /*PFObject *userTest = [PFObject objectWithClassName:@"user"];
    userTest[@"userName"] = [sharedManager.user getUserName];
    userTest[@"firstName"] = [sharedManager.user getFirstName];
    userTest[@"password"] = @"nope";
    userTest[@"isMale"] = @[[NSNumber numberWithBool:[sharedManager.user isMale]]];
    userTest[@"birthday"] = birthString;
    userTest[@"upVotes"] = @[[NSNumber numberWithInt:[sharedManager.user getUpVotes]]];
    userTest[@"totalVotes"] = @[[NSNumber numberWithInt:[sharedManager.user getVotes]]];
    [userTest saveInBackground];*/
    
    
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

//call this method once the map finishes loading so the location can be set to the users current location
- (void)mapViewDidFinishLoadingMap:(MKMapView*)mapView {
    
    //currentLocation = [[mapView userLocation] location];
    viewRegion = MKCoordinateRegionMakeWithDistance([currentLocation coordinate], 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    [_Map setRegion:viewRegion animated:NO];
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    //Sets the current location of the map to center at the users location
    [sharedManager.user setCurrentLocation:currentLocation];
    //NSLog(@"%g", currentLocation.coordinate.latitude);
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    NSLog(@"Failed to load map");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    currentLocation = oldLocation;
    viewRegion = MKCoordinateRegionMakeWithDistance([currentLocation coordinate], 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    [_Map setRegion:viewRegion animated:NO];
}
@end
