//  Matches.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "MatchesGraphics.h"
#import "MatchCellType.h"
#import "MyManager.h"
#import "userProfile.h"
#import "UIViewController+AMSlideMenu.h"

@implementation MatchesGraphics

-(void) viewDidLoad{
    //initialize the local array of matches
    _matches = [[NSMutableArray alloc] init];
    _searchResults = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    
    //[self addLeftMenuButton];
    //[self addRightMenuButton];
    
    //copy array of matches over from the user to the graphics class
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user getMatchesFromSport:[sharedManager.user getCurrentSport] matches:_matches];
    _numberOfMatches = [NSNumber numberWithInteger:[_matches count]];
    
}

//returns how many sections in the table there are
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//returns how many rows in the table there are
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [_searchResults count];
    }else{
        return [_numberOfMatches integerValue];
    }
}

//set the information of each cell based on the information in the array of matches
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //set template of the cell
    static NSString *cellID = @"MatchCell";
    
    MatchCellType *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil){
        cell = [[MatchCellType alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    //set label text (also need to do picture)
    if (tableView == self.searchDisplayController.searchResultsTableView){
        
        cell.lblName.text = [(Person *)[_searchResults objectAtIndex: [indexPath row]] getFirstName];
    }else{
        
        cell.lblName.text = [(Person *)[_matches objectAtIndex: [indexPath row]] getFirstName];
    }
    
    return cell;
}

//if a cell is selected in the table, open the userProfile window
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
    
    [self performSegueWithIdentifier:@"pairSelected" sender:self];
}

//passes data through the segue when the user clicks on one of the chat menu items
-(void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id)sender{
    
    //if the segue is for a chat window
    if([segue.identifier isEqualToString:@"pairSelected"]){
        
        //get which position was clicked on and set the title of the window to "Chat #" where # is the number of which row was clicked
        userProfile *chat  = (userProfile*)[segue destinationViewController];
        
        if(self.searchDisplayController.active){
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            chat.player = [[Person alloc] init];
            [chat.player copyPerson:(Person *) [_searchResults objectAtIndex:indexPath.row]];
            
            chat.matchNumber = [[NSNumber alloc] initWithInteger:indexPath.row];
        }else{
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            chat.player = [[Person alloc] init];
            [chat.player copyPerson:(Person *) [_matches objectAtIndex:indexPath.row]];
            
            chat.matchNumber = [[NSNumber alloc] initWithInteger:indexPath.row];
        }
        
        [_txtSearch resignFirstResponder];
        [self.searchDisplayController setActive:NO];
    }
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
