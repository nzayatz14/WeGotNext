//  Matches.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "MatchesGraphics.h"
#import "MatchCellType.h"
#import "Person.h"
#import "MyManager.h"

@implementation MatchesGraphics

-(void)viewWillAppear:(BOOL)animated{
    MyManager *sharedManager = [MyManager sharedManager];
    
    [sharedManager.user getMatchesFromSport:[sharedManager.user getCurrentSport] matches:_matches];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_numberOfMatches integerValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"MatchCell";
    
    MatchCellType *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil){
        cell = [[MatchCellType alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.lblName.text = [(Person *)[_matches objectAtIndex: [indexPath row]] getFirstName];
    
    return cell;
}


@end
