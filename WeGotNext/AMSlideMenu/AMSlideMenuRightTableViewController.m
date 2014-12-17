//
//  AMSlideMenuRightTableViewController.m
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

#import "AMSlideMenuRightTableViewController.h"

#import "AMSlideMenuMainViewController.h"

#import "AMSlideMenuContentSegue.h"

#import "ChatWindow.h"
#import "MyManager.h"
#import "RightSlideMenuCellType.h"
#import "Person.h"

#define TITLE_WIDTH 50

@interface AMSlideMenuRightTableViewController ()

@end

@implementation AMSlideMenuRightTableViewController

/*----------------------------------------------------*/
#pragma mark - Lifecycle -
/*----------------------------------------------------*/

- (void)viewDidLoad
{
    UIView *tableTitle = [[UIView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, TITLE_WIDTH)];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10,15,[UIScreen mainScreen].bounds.size.width,25)];
    
    title.text = @"Players";
    
    [tableTitle addSubview:title];
    
    //self.tableView.tableHeaderView = tableTitle;
    
    _matches = [[NSMutableArray alloc] init];
    _searchResults = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
}

-(void)loadMatches{
    //copy array of matches over from the user to the graphics class
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user getMatchesFromSport:[sharedManager.user getCurrentSport] matches:_matches];
    _numberOfMatches = [NSNumber numberWithInteger:[_matches count]];
    [self.tableView reloadData];
}

- (void)openContentNavigationController:(UINavigationController *)nvc
{
#ifdef AMSlideMenuWithoutStoryboards
    NSLog(@"Appear");
    AMSlideMenuContentSegue *contentSegue = [[AMSlideMenuContentSegue alloc] initWithIdentifier:@"contentSegue" source:self destination:nvc];
    [contentSegue perform];
#else
    NSLog(@"This methos is only for NON storyboard use! You must define AMSlideMenuWithoutStoryboards \n (e.g. #define AMSlideMenuWithoutStoryboards)");
#endif
}

/*----------------------------------------------------*/
#pragma mark - TableView delegate -
/*----------------------------------------------------*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* if ([self.mainVC respondsToSelector:@selector(navigationControllerForIndexPathInRightMenu:)]) {
     UINavigationController *navController = [self.mainVC navigationControllerForIndexPathInRightMenu:indexPath];
     AMSlideMenuContentSegue *segue = [[AMSlideMenuContentSegue alloc] initWithIdentifier:@"ContentSugue" source:self destination:navController];
     [segue perform];
     } else {
     NSString *segueIdentifier = [self.mainVC segueIdentifierForIndexPathInRightMenu:indexPath];
     if (segueIdentifier && segueIdentifier.length > 0)
     {
     [self performSegueWithIdentifier:segueIdentifier sender:self];
     }
     } */
    
    [self performSegueWithIdentifier:@"btnChat" sender:self];
}

//passes data through the segue when the user clicks on one of the chat menu items
-(void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id)sender{
    
    //if the segue is for a chat window
    if([segue.identifier isEqualToString:@"btnChat"]){
        
        //get which position was clicked on and set the title of the window to the name of the match where # is the number of which row was clicked
        ChatWindow *chat  = (ChatWindow*)[[segue destinationViewController] topViewController];
        chat.myTitle = [[NSString alloc] init];
        
        if(self.searchDisplayController.active){
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            if(_numberOfMatches >0)
                chat.myTitle = [(Person *)[_searchResults objectAtIndex: [indexPath row]] getFirstName];
            else
                chat.myTitle = [[NSString alloc] initWithFormat:@"Chat"];
            
        }else{
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            if(_numberOfMatches >0)
                chat.myTitle = [(Person *)[_matches objectAtIndex: [indexPath row]] getFirstName];
            else
                chat.myTitle = [[NSString alloc] initWithFormat:@"Chat"];
        }
        
        [_txtSearch resignFirstResponder];
        [self.searchDisplayController setActive:NO];
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [_searchResults count];
    }else{
        return [_numberOfMatches integerValue];
    }
}

//set the information of each cell based on the information in the array of matches
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // NSLog(@"Cell For Row");
    
    //set template of the cell
    static NSString *cellID = @"RightMenuCell";
    
    
    RightSlideMenuCellType *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil){
        cell = [[RightSlideMenuCellType alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    //set label text (also need to do picture)
    if (tableView == self.searchDisplayController.searchResultsTableView){
        
        cell.lblName.text = [(Person *)[_searchResults objectAtIndex: [indexPath row]] getFirstName];
    }else{
        
        cell.lblName.text = [(Person *)[_matches objectAtIndex: [indexPath row]] getFirstName];
    }
    
    return cell;
}

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope{
    
    NSPredicate *results = [NSPredicate predicateWithFormat:@"%K contains[c] %@", @"firstName", searchText];
    _searchResults = [[_matches filteredArrayUsingPredicate:results] mutableCopy];
    
    //NSLog(@"Searched: %lu", (unsigned long)[_searchResults count]);
    /*[_matches enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
     Person *p = obj;
     
     if([[p getFirstName] isEqualToString:searchText])
     [_searchResults addObject:p];
     
     }]; */
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    //NSLog(@"Display");
    
    [self filterContentForSearchText:searchString scope:[self.searchDisplayController.searchBar.scopeButtonTitles objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

@end
