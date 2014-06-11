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
    
    upVotes = 0;
    totalVotes = 0;
    
    return self;
    
}

//constructor with parameters used to create an account
-(id) initWithUserName:(NSString *) user FirstName:(NSString *) first Password:(NSString *) pass isMale:(BOOL) Male birthdate:(NSDate *) birth upVotes:(int)up votes:(int)v{
    userName = user;
    firstName = first;
    password = pass;
    male = Male;
    birthday = birth;
    upVotes = up;
    totalVotes = v;
    
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

-(int) getAge{
    NSDate *now = [NSDate date];
    
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:birthday toDate: now options:0];
    
    NSInteger age = [ageComponents year];
    
    return (int)age;
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

-(void) addUpVote{
    upVotes++;
}

-(void) addVote{
    totalVotes++;
}

-(int) getCredibility{
    
    if(totalVotes == 0){
        return 100;
    }
    
    return (int)(((float)upVotes/(float)totalVotes)*100);
}

@end