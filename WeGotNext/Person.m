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
    
    currentSport = 0;
    
    //initialize all arrays and current user location
    for(int i = 0;i<SPORT_COUNT;i++){
        for(int j = 0;j<EXP_COUNT;j++){
            experience[i][j] = [NSString stringWithFormat:@"%d%d", i, j];
        }
    }
    
    for(int i = 0;i<SPORT_COUNT;i++){
        for(int j = 0;j<IMAGE_COUNT;j++){
            profilePics[i][j] = [[UIImage alloc] init];
            profilePics[i][j] = [UIImage imageNamed:@"defaultProfile.png"];
        }
    }
    
    for(int i = 0;i<SPORT_COUNT; i++){
        matches[i] = [[NSMutableArray alloc] init];
    }
    
    for(int i = 0;i<SPORT_COUNT; i++){
        team[i] = [[NSMutableArray alloc] init];
    }
    
    currentLocation = [[CLLocation alloc] init];
    
    findMen = YES;
    findWomen = NO;
    distance = 50;
    minAge = 18;
    maxAge = 50;
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
    
    currentSport = 0;
    
    //initialize all arrays and current user location
    for(int i = 0;i<SPORT_COUNT;i++){
        for(int j = 0;j<EXP_COUNT;j++){
            experience[i][j] = [NSString stringWithFormat:@"%d%d", i, j];
        }
    }
    
    for(int i = 0;i<SPORT_COUNT;i++){
        for(int j = 0;j<IMAGE_COUNT;j++){
            profilePics[i][j] = [[UIImage alloc] init];
            profilePics[i][j] = [UIImage imageNamed:@"defaultProfile.png"];
        }
    }
    
    for(int i = 0;i<SPORT_COUNT; i++){
        matches[i] = [[NSMutableArray alloc] init];
    }
    
    for(int i = 0;i<SPORT_COUNT; i++){
        team[i] = [[NSMutableArray alloc] init];
    }
    
    currentLocation = [[CLLocation alloc] init];
    
    findMen = male;
    findWomen = (!male);
    distance = 50;
    minAge = 18;
    maxAge = 50;
    
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

-(void) addMatchFromSport:(int) sport match:(Person *) p{
    [matches[sport] addObject:p];
}

-(Person *) getMatchFromSport:(int) sport matchNumber:(int) match{
    return [matches[sport] objectAtIndex:match];
}

-(void) getMatchesFromSport:(int) sport matches:(NSMutableArray *) array{
    [array removeAllObjects];
    
    for(Person* p in matches[sport]){
        [array addObject:p];
    }
}

-(void) removeMatchFromSport:(int) sp matchNumber:(int) number{
    [matches[sp] removeObjectAtIndex:number];
}

-(int) getNumberOfMatchesFromSport:(int) sp{
    return (int)[matches[sp] count];
}

-(void)setCurrentSport:(int) temp{
    currentSport = temp;
}

-(int) getCurrentSport{
    return currentSport;
}

-(void) addToTeamFromSport:(int) sport person:(Person *) p{
    [team[sport] addObject:p];
}

-(Person *) getTeammateFromSport:(int) sp teammateNumber:(int) match{
    return [team[sp] objectAtIndex:match];
}

-(void) getTeamFromSport:(int) sport team:(NSMutableArray *) array{
    [array removeAllObjects];
    
    for(Person *p in team[sport]){
        [array addObject:p];
    }
}

-(void) getProfPicsFromSport:(int) sp pics:(NSMutableArray *)array{
    [array removeAllObjects];
    
    for(int i = 0;i<IMAGE_COUNT;i++){
        [array addObject:profilePics[sp][i]];
    }
}

-(void) removeTeammateFromSport:(int) sp teammateNumber:(int) number{
    [team[sp] removeObjectAtIndex:number];
}

-(int) getNumberOfTeammatesFromSport:(int) sp{
    return (int)[team[sp] count];
}

- (BOOL) isUserOnTeam:(Person *) p{
    NSString *userComparedName = [p getUserName];
    
    for(Person *pair in team[currentSport]){
        if([userComparedName isEqualToString:[pair getUserName]])
            return YES;
    }
    
    return NO;
}

-(int) getUpVotes{
    return upVotes;
}

-(int) getVotes{
    return totalVotes;
}

//copies a person p into this person object
-(void) copyPerson:(Person *) p{
    userName = [p getUserName];
    firstName = [p getFirstName];
    password = [p getPassword];
    male = [p isMale];
    birthday = [p getBirthday];
    upVotes = [p getUpVotes];
    totalVotes = [p getVotes];
    
    currentSport = [p getCurrentSport];
    
    for(int i = 0;i<SPORT_COUNT; i++){
        [p getMatchesFromSport:i matches:matches[i]];
    }
    
    for(int i = 0;i<SPORT_COUNT; i++){
        [p getTeamFromSport:i team:team[i]];
    }
    
    for(int i=  0;i<SPORT_COUNT; i++){
        for(int j = 0;j<EXP_COUNT; j++){
            experience[i][j] = [p getExperienceFromSport:i experienceNumber:j];
        }
    }
    
    for(int i=  0;i<SPORT_COUNT; i++){
        for(int j = 0;j<IMAGE_COUNT; j++){
            profilePics[i][j] = [p getProfPicFromSport:i picNumber:j];
        }
    }
    
    currentLocation = [p getCurrentLocation];
}

-(void) setCurrentLocation:(CLLocation *) location{
    currentLocation = location;
    //NSLog(@"%g, %g", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
}

-(CLLocation *) getCurrentLocation{
    return currentLocation;
}

-(void) subtractUpVote{
    upVotes--;
}

-(void) subtractVote{
    totalVotes--;
}

-(void) setMatchFromSport:(int) sport matchNumber:(int) match person:(Person *) p{
    [matches[sport] replaceObjectAtIndex:match withObject:p];
}

-(void) setTeammateFromSport:(int) sport teammateNumber:(int) teammate person:(Person *) p{
    [team[sport] replaceObjectAtIndex:teammate withObject:p];
}

//returns the number in the array the supplied person p is in the team array from the sport sp
//returns -1 if the teammate is not found
-(int) getTeammateNumber:(Person *) p inSport:(int) sp{
    for(int i = 0;i<[team[sp] count];i++){
        Person *temp = (Person *)[team[sp] objectAtIndex:i];
        
        if([[temp getUserName] isEqualToString:[p getUserName]]){
            return i;
        }
    }
    
    return -1;
}

-(void) setUpVotes: (int) v{
    upVotes = v;
}

-(void) setVotes: (int) v{
    totalVotes = v;
}

-(void) setFindMale:(BOOL) find{
    findMen = find;
}

-(BOOL) getFindMale{
    return findMen;
}

-(void) setFindFemale:(BOOL) find{
    findWomen = find;
}

-(BOOL) getFindFemale{
    return findWomen;
}

-(void) setFindDistance:(int) dist{
    distance = dist;
}

-(int) getFindDistance{
    return distance;
}

-(void) setMinAge:(int) age{
    minAge = age;
}

-(int) getMinAge{
    return minAge;
}

-(void) setMaxAge:(int) age{
    maxAge = age;
}

-(int) getMaxAge{
    return maxAge;
}

@end
