//
//  NSObject+Message.h
//  WeGotNext
//
//  Created by Nick Zayatz on 12/9/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSString *sender;

-(void) setText:(NSString *)Text;
-(NSString *) getText;
-(void) setTime:(NSDate *)time;
-(NSDate *) getTime;
-(void) setSender:(NSString *)sender;
-(NSString *) getSender;
@end
