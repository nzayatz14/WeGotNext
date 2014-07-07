//
//  LogOutWindow.m
//  WeGotNext
//
//  Created by Nick Zayatz on 7/7/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "LogOutWindow.h"

@implementation LogOutWindow

-(void) viewWillAppear:(BOOL)animated{
    _lblLogOutStatus.text = _logOut;
}

@end
