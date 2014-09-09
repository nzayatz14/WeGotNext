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
    return [_numberOfMatches integerValue];
}

//set the information of each cell based on the information in the array of matches
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //set template of the cell
    static NSString *cellID = @"MatchCell";
    
    MatchCellType *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil){
        cell = [[MatchCellType alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    //set label text (also need to do picture)
    cell.lblName.text = [(Person *)[_matches objectAtIndex: [indexPath row]] getFirstName];
    
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
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        userProfile *chat  = (userProfile*)[segue destinationViewController];
        
        chat.player = [[Person alloc] init];
        [chat.player copyPerson:(Person *) [_matches objectAtIndex:indexPath.row]];
        
        chat.matchNumber = [[NSNumber alloc] initWithInteger:indexPath.row];
    }
}


@end
