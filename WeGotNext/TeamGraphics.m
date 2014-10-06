//
//  TeamGraphics.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "TeamGraphics.h"
#import "MyManager.h"
#import "TeamCellType.h"
#import "teammateProfile.h"
#import "UIViewController+AMSlideMenu.h"

@implementation TeamGraphics

-(void) viewDidLoad{
    _team = [[NSMutableArray alloc] init];
    _searchResults = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    
    //[self addLeftMenuButton];
    //[self addRightMenuButton];
    
    //copy array of matches over from the user to the graphics class
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user getTeamFromSport:[sharedManager.user getCurrentSport] team:_team];
    _numberOfTeammates = [NSNumber numberWithInteger:[_team count]];
    [self.tableView reloadData];
}

//returns the number of sections in the table
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//returns the number of rows in the table
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [_searchResults count];
    }else{
        return [_numberOfTeammates integerValue];
    }
}

/*FUNCTION IS INCOMPLETE*/
//set the information of each cell based on the information in the array of matches
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //set template of the cell
    static NSString *cellID = @"TeamCell";
    
    TeamCellType *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil){
        cell = [[TeamCellType alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    //set label text (also need to do picture)
    cell.lblName.text = [(Person *)[_team objectAtIndex: [indexPath row]] getFirstName];
    
    return cell;
}

//when a cell is selected, open the teammate profile of that selected player
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
    
    [self performSegueWithIdentifier:@"teammateSelected" sender:self];
}

//passes data through the segue when the user clicks on one of the chat menu items
-(void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id)sender{
    
    //if the segue is for a chat window
    if([segue.identifier isEqualToString:@"teammateSelected"]){
        
        //get which position was clicked on, set 'player' you are chatting with
        //and set the match number that that player is
        teammateProfile *chat  = (teammateProfile*)[segue destinationViewController];
        
        if(self.searchDisplayController.active){
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            chat.player = [[Person alloc] init];
            [chat.player copyPerson:(Person *) [_searchResults objectAtIndex:indexPath.row]];
            
            chat.matchNumber = [[NSNumber alloc] initWithInteger:indexPath.row];
        }else{
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            chat.player = [[Person alloc] init];
            [chat.player copyPerson:(Person *) [_team objectAtIndex:indexPath.row]];
            
            chat.matchNumber = [[NSNumber alloc] initWithInteger:indexPath.row];
        }
        
        [_txtSearch resignFirstResponder];
        [self.searchDisplayController setActive:NO];
    }
}

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope{
    
    NSPredicate *results = [NSPredicate predicateWithFormat:@"%K contains[c] %@", @"firstName", searchText];
    _searchResults = [[_team filteredArrayUsingPredicate:results] mutableCopy];
    
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
