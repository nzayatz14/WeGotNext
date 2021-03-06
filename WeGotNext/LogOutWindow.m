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
    //disable the slide gestures so the user cannot access the side menus
    [self disableSlidePanGestureForLeftMenu];
    [self disableSlidePanGestureForRightMenu];
    [self removeLeftMenuButton];
    [self removeRightMenuButton];
    _lblLogOutStatus.text = _logOut;
}

-(void) viewDidAppear:(BOOL)animated{
    [self disableSlidePanGestureForLeftMenu];
    [self disableSlidePanGestureForRightMenu];
}

@end
