//
//  Person.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/9/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "Person.h"

@implementation Person

//default constructor with no parameters
-(id) init{
    userName = @"userName";
    firstName = @"FirstName";
    password = @"password";
    male = YES;
    
    NSDateFormatter *mmddyyyy = [[NSDateFormatter alloc] init];
    mmddyyyy.timeStyle = NSDateFormatterNoStyle;
    mmddyyyy.dateFormat = @"MM/dd/yyyy";
    
    birthday = [mmddyyyy dateFromString:@"01/01/0001"];
    
    return self;
    
}

//constructor with parameters used to create an account
-(id) initWithUserName:(NSString *) user FirstName:(NSString *) first Password:(NSString *) pass isMale:(BOOL) Male birthdate:(NSDate *) birth{
    userName = user;
    firstName = first;
    password = pass;
    male = Male;
    birthday = birth;
    
    return self;
}

-(void) setUserName:(NSString *) name{
    userName = name;
}

-(NSString *) getUserName{
    return userName;
}

-(void) setFirstName:(NSString *) name{
    firstName = name;
}

-(NSString *) getFirstName{
    return firstName;
}

-(void) setPassword:(NSString *) pass{
    password = pass;
}

-(NSString *) getPassword{
    return password;
}

-(void) setIsMale:(BOOL) Male{
    male = Male;
}

-(BOOL) isMale{
    return male;
}

-(void) setBirthday:(NSDate *) birth{
    birthday = birth;
}

-(NSDate *) getBirthday{
    return birthday;
}

-(void) setExperienceFromSport:(int) sp experienceNumber:(int) ex experience:(NSString *) exp{
    experience[sp][ex] = exp;
}

-(NSString *) getExperienceFromSport:(int) sp experienceNumber:(int) ex{
    return experience[sp][ex];
}

-(void) setProfPicFromSport:(int) sp picNumber:(int) picNum picture:(UIImage *) pic{
    profilePics[sp][picNum] = pic;
}

-(UIImage *) getProfPicFromSport:(int) sp picNumber:(int) picNum{
    return profilePics[sp][picNum];
}

@end
