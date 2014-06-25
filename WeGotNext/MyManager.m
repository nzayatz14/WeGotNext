//
//  MyManager.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/11/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "MyManager.h"

@implementation MyManager

@synthesize user;

+(id)sharedManager {
    static MyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{sharedMyManager = [[self alloc] init];});
    
    return sharedMyManager;
}

-(id) init {
    if(self = [super init]){
        user = [[Person alloc] init];
        _notifyNewPair = YES;
        _notifyNewPlayerMessage = YES;
        _notifyNewTeammateMessage = YES;
    }
    return self;
}

-(void) dealloc {
    
}
@end
