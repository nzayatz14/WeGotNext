//
//  Person.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/9/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <Foundation/Foundation.h>
extern const int IMAGE_COUNT = 5; //how many images the user can have in 1 sport
extern const int SPORT_COUNT = 5; //how many total sports we have
extern const int EXP_COUNT = 3; //how many experiences the user can put

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
    
    //make these 2D arrays so the user can have experiences and pictures for each sport
    NSString *experience[SPORT_COUNT][EXP_COUNT];
    UIImage *profilePics[SPORT_COUNT][IMAGE_COUNT];
    
    //ex: to access the users 3rd picture from Lacrosse (sport number 4) you would get profilePics[4][3];
    
}
-(id) init;
-(id) initWithUserName:(NSString *) user FirstName:(NSString *) first Password:(NSString *) pass isMale:(BOOL) Male birthdate:(NSDate *) birth;

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

-(void) setExperienceFromSport:(int) sp experienceNumber:(int) ex experience:(NSString *) exp;
-(NSString *) getExperienceFromSport:(int) sp experienceNumber:(int) ex;

-(void) setProfPicFromSport:(int) sp picNumber:(int) picNum picture:(UIImage *) pic;
-(UIImage *) getProfPicFromSport:(int) sp picNumber:(int) picNum;
@end
