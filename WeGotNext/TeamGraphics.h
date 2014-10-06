//
//  TeamGraphics.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamGraphics : UITableViewController

@property (nonatomic, strong) NSNumber *numberOfTeammates;
@property (nonatomic, strong) NSMutableArray *team;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *txtSearch;

@end
