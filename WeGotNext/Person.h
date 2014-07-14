//
//  Person.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/9/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/Mapkit.h>

#define IMAGE_COUNT 5 //how many images the user can have in 1 sport
#define SPORT_COUNT 5 //how many total sports we have
#define EXP_COUNT 3 //how many experiences the user can put
//0 = Basketball
//1 = Baseball
//2 = Soccer
//3 = Football
//4 = Lacrosse
@interface Person : NSObject{
    
    NSString *userName;
    NSString *firstName;
    NSString *password;
    BOOL male;
    NSDate *birthday;
    int upVotes;
    int totalVotes;
    int currentSport;
    CLLocation *currentLocation;
    
    //make these 2D arrays so the user can have experiences and pictures for each sport
    NSString *experience[SPORT_COUNT][EXP_COUNT];
    UIImage *profilePics[SPORT_COUNT][IMAGE_COUNT];
    
    //ex: to access the users 3rd picture from Lacrosse (sport number 4) you would get profilePics[4][3];
    
    //create an array of mutable arrays to hold the users matches for each sport
    NSMutableArray *matches[SPORT_COUNT];
    NSMutableArray *team[SPORT_COUNT];
    
}
-(id) init;
-(id) initWithUserName:(NSString *) user FirstName:(NSString *) first Password:(NSString *) pass isMale:(BOOL) Male birthdate:(NSDate *) birth upVotes:(int) up votes:(int) v;

-(void) copyPerson:(Person *) p;

-(void) setUserName:(NSString *) name;
-(NSString *) getUserName;

-(void) setFirstName:(NSString *) name;
-(NSString *) getFirstName;

-(void) setPassword:(NSString *) pass;
-(NSString *) getPassword;

-(void) setIsMale:(BOOL) Male;
-(BOOL) isMale;

-(void) setBirthday:(NSDate *) birth;
-(NSDate *) getBirthday;
-(int) getAge;

-(void) setExperienceFromSport:(int) sp experienceNumber:(int) ex experience:(NSString *) exp;
-(NSString *) getExperienceFromSport:(int) sp experienceNumber:(int) ex;

-(void) setProfPicFromSport:(int) sp picNumber:(int) picNum picture:(UIImage *) pic;
-(UIImage *) getProfPicFromSport:(int) sp picNumber:(int) picNum;
-(void) getProfPicsFromSport:(int) sp pics:(NSMutableArray *)array;

-(void) addMatchFromSport:(int) sport match:(Person *) p;
-(Person *) getMatchFromSport:(int) sport matchNumber:(int) match;
-(void) getMatchesFromSport:(int) sport matches:(NSMutableArray *) array;
-(void) removeMatchFromSport:(int) sp matchNumber:(int) number;
-(int) getNumberOfMatchesFromSport:(int) sp;

-(void) addUpVote;
-(void) addVote;
-(int) getUpVotes;
-(int) getVotes;
-(int) getCredibility;

-(void)setCurrentSport:(int) temp;
-(int) getCurrentSport;

-(void) addToTeamFromSport:(int) sport person:(Person *) p;
-(Person *) getTeammateFromSport:(int) sp teammateNumber:(int) match;
-(void) getTeamFromSport:(int) sport team:(NSMutableArray *) array;
-(void) removeTeammateFromSport:(int) sp teammateNumber:(int) number;
-(int) getNumberOfTeammatesFromSport:(int) sp;

-(void) setCurrentLocation:(CLLocation *) location;
-(CLLocation *) getCurrentLocation;


@end