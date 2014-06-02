//
//  LoginWindow.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "LoginWindow.h"

@implementation LoginWindow



- (IBAction)btnLoginClicked:(UIButton *)sender {
    [super performSegueWithIdentifier:@"btnLogin" sender:self];
}


@end
