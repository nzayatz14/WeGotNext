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

@implementation TeamGraphics

-(void) viewDidLoad{
    _team = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    
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
    return [_numberOfTeammates integerValue];
}

/*FUNCTION IS INCOMPLETE*/
//set the information of each cell based on the information in the array of matches
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //set template of the cell
    static NSString *cellID = @"TeamCell";
    
    TeamCellType *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
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
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        teammateProfile *chat  = (teammateProfile*)[segue destinationViewController];
        
        chat.player = [[Person alloc] init];
        [chat.player copyPerson:(Person *) [_team objectAtIndex:indexPath.row]];
        
        chat.matchNumber = [[NSNumber alloc] initWithInteger:indexPath.row];
    }
}

@end
