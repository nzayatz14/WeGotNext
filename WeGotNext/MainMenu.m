//
//  MainMenu.m
//  WeGotNext
//
//  Created by Nick Zayatz on 5/29/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "MainMenu.h"

@implementation MainMenu

- (void) viewDidLoad{
    [super viewDidLoad];
}

-(NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath{
    NSString *identifier;
    
    switch (indexPath.row){
        case 0:
            identifier = @"btnHome";
            break;
        case 1:
            identifier = @"btnProfile";
            break;
        default:
            break;
    }
    
    return identifier;
}
@end
