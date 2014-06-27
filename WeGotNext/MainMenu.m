//
//  MainMenu.m
//  WeGotNext
//
//  Created by Nick Zayatz on 5/29/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "MainMenu.h"
#import "LoginWindow.h"

@implementation MainMenu

- (void) viewDidLoad{
    [super viewDidLoad];
    
//[segueWithIdentifier: @"btnHome"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        case 2:
            identifier = @"btnMatches";
            break;
        case 3:
            identifier = @"btnTeam";
            break;
        case 4:
            identifier = @"btnSettings";
            break;
        case 5:
            identifier = @"btnSwitchSports";
            break;
        case 6:
        { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait" message:@"After logging out, players will still be able to see your account at the location of last log in." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log Out", nil];
            [alert show];
        }
            break;
        default:
            identifier = @"btnHome";
            break;
    }
    
    return identifier;
}

-(NSString *)segueIdentifierForIndexPathInRightMenu:(NSIndexPath *)indexPath{
    //int personNumber = indexPath.row;
    
    return @"btnChat";
}



-(BOOL)deepnessForLeftMenu{
    return YES;
}

-(BOOL)deepnessForRightMenu{
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //if delete is clicked
    if(buttonIndex == 1){
        /*LoginWindow *back = [[LoginWindow alloc] initWithNibName:@"LoginWindow" bundle:nil];
        NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [vcs insertObject:back atIndex:[vcs count] -1];
        [self.navigationController setViewControllers:vcs];
        [self.navigationController popToViewController:self animated:YES];*/
    }
}
@end
