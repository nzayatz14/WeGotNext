//
//  ChatWindow.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatWindow : UIViewController
- (IBAction)btnBackClicked:(UIBarButtonItem *)sender;
@property (nonatomic, strong) NSString *myTitle;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end
