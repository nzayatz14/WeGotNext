//
//  AMSlideMenuLeftTableViewController.m
//  AMSlideMenu
//
// The MIT License (MIT)
//
// Created by : arturdev
// Copyright (c) 2014 SocialObjects Software. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE

#import "AMSlideMenuLeftTableViewController.h"

#import "AMSlideMenuMainViewController.h"

#import "AMSlideMenuContentSegue.h"
#import "LogOutWindow.h"
#define TITLE_WIDTH 50

//#import "Profile.h"
//#import "MyManager.h"
//#import "MatchesGraphics.h"

@interface AMSlideMenuLeftTableViewController ()

@end

@implementation AMSlideMenuLeftTableViewController

/*----------------------------------------------------*/
#pragma mark - Lifecycle -
/*----------------------------------------------------*/

- (void)viewDidLoad
{
    UIView *tableTitle = [[UIView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, TITLE_WIDTH)];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10,15,[UIScreen mainScreen].bounds.size.width,25)];
    
    title.text = @"We Got Next";
    title.textColor = [UIColor orangeColor];
    
    [tableTitle addSubview:title];
    
    self.tableView.tableHeaderView = tableTitle;
    
    UIView *background = [[UIView alloc] initWithFrame:self.tableView.bounds];
    background.backgroundColor = [UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1.0f];
    self.tableView.backgroundView = background;
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1.0f]];
    
    [super viewDidLoad];
}

- (void)openContentNavigationController:(UINavigationController *)nvc
{
#ifdef AMSlideMenuWithoutStoryboards
    AMSlideMenuContentSegue *contentSegue = [[AMSlideMenuContentSegue alloc] initWithIdentifier:@"contentSegue" source:self destination:nvc];
    [contentSegue perform];
#else
    NSLog(@"This methos is only for NON storyboard use! You must define AMSlideMenuWithoutStoryboards \n (e.g. #define AMSlideMenuWithoutStoryboards)");
#endif
}


/*----------------------------------------------------*/
#pragma mark - TableView Delegate -
/*----------------------------------------------------*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.mainVC respondsToSelector:@selector(navigationControllerForIndexPathInLeftMenu:)]) {
        UINavigationController *navController = [self.mainVC navigationControllerForIndexPathInLeftMenu:indexPath];
        AMSlideMenuContentSegue *segue = [[AMSlideMenuContentSegue alloc] initWithIdentifier:@"ContentSugue" source:self destination:navController];
        [segue perform];
    } else {
        NSString *segueIdentifier = [self.mainVC segueIdentifierForIndexPathInLeftMenu:indexPath];
        if (segueIdentifier && segueIdentifier.length > 0)
        {
            [self performSegueWithIdentifier:segueIdentifier sender:self];
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setBackgroundColor:[UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1.0f]];
}

//passes data through the segue when the user clicks on the log out menu item
-(void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id)sender{
    
    //if the segue is for a chat window
    if([segue.identifier isEqualToString:@"btnLogOut"]){
        
        //get which position was clicked on and set the title of the window to "Chat #" where # is the number of which row was clicked
        LogOutWindow *chat  = (LogOutWindow*)[[segue destinationViewController] topViewController];
        NSLog(@"%@", chat);
        NSLog(@"%@", chat.logOut);
        if(YES) // if there was no problem logging out
            chat.logOut = [[NSString alloc] initWithFormat:@"Log Out Successful!"];
        else
            chat.logOut = [[NSString alloc] initWithFormat:@"Uh Oh! There was a problem."]; 
    }
}

@end
