//
//  ChatWindow.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatWindow : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *myTitle;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (weak, nonatomic) IBOutlet UITextField *txtMessage;
- (IBAction)btnSend:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *messageTable;

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSNumber *messagesCount;

@end
