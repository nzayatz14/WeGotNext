//
//  Person.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/9/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IMAGE_COUNT 5
#define SPORT_COUNT 5
#define EXP_COUNT 3
//0 = Basketball
//1 = Baseball
//2 = Soccer
//3 = Football
//4 = Lacrosse
@interface Person : NSObject{
    //const int IMAGE_COUNT; //how many images the user can have in 1 sport
    //const int SPORT_COUNT; //how many total sports we have
    //const int EXP_COUNT; //how many experiences the user can put
    
    NSString *userName;
    NSString *firstName;
    NSString *password;
    BOOL male;
    NSDate *birthday;
    int upVotes;
    int totalVotes;
    
    //make these 2D arrays so the user can have experiences and pictures for each sport
    NSString *experience[SPORT_COUNT][EXP_COUNT];
    UIImage *profilePics[SPORT_COUNT][IMAGE_COUNT];
    
    //ex: to access the users 3rd picture from Lacrosse (sport number 4) you would get profilePics[4][3];
    
}
-(id) init;
-(id) initWithUserName:(NSString *) user FirstName:(NSString *) first Password:(NSString *) pass isMale:(BOOL) Male birthdate:(NSDate *) birth upVotes:(int) up votes:(int) v;

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

-(void) addUpVote;
-(void) addVote;
-(int) getCredibility;

@end