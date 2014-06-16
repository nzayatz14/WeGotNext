//
//  SwitchSports.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "SwitchSports.h"
#import "MyManager.h"

@implementation SwitchSports


//selects which sport the user is looking at and places a check mark at the
//appropriate box for the time being
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user setCurrentSport:(int)indexPath.row];
    
    if(self.checkedIndexPath){
        UITableViewCell *selected = [tableView cellForRowAtIndexPath:self.checkedIndexPath];
        selected.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.checkedIndexPath = indexPath;
}
@end
