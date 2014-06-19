//  Matches.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "MatchesGraphics.h"
#import "MatchCellType.h"
#import "MyManager.h"
#import "ChatWindow.h"

@implementation MatchesGraphics

-(void) viewDidLoad{
    _matches = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    
    //copy array of matches over from the user to the graphics class
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user getMatchesFromSport:[sharedManager.user getCurrentSport] matches:_matches];
    _numberOfMatches = [NSNumber numberWithInteger:[_matches count]];
    
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


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
    
    [self performSegueWithIdentifier:@"btnMatchChat" sender:self];
}

//passes data through the segue when the user clicks on one of the chat menu items
-(void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id)sender{
    //if the segue is for a chat window
    if([segue.identifier isEqualToString:@"btnMatchChat"]){
        
        //get which position was clicked on and set the title of the window to "Chat #" where # is the number of which row was clicked
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ChatWindow *chat  = (ChatWindow*)[[segue destinationViewController] topViewController];
        
        if(_numberOfMatches >0)
            chat.navItem.title = [(Person *)[_matches objectAtIndex: [indexPath row]] getFirstName];
        else
            chat.navItem.title = [[NSString alloc] initWithFormat:@"Chat"];
    }
}


@end
