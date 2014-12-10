//
//  NSObject+Message.m
//  WeGotNext
//
//  Created by Nick Zayatz on 12/9/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "Message.h"

@implementation Message

-(void) setText:(NSString *)text{
    _text = text;
}

-(NSString *) getText{
    return _text;
}

-(void) setTime:(NSDate *)time{
    _time = time;
}

-(NSDate *) getTime{
    return _time;
}

-(void) setSender:(NSString *)sender{
    _sender = sender;
}

-(NSString *) getSender{
    return _sender;
}

@end
