//
//  ChatWindow.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "ChatWindow.h"
#import "ChatViewCell.h"
#import "Message.h"
#import "MyManager.h"


@implementation ChatWindow

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    if (!_chatController)
        _chatController = [ChatController new];
    
    _chatController.delegate = self;
    
    self.navigationController.navigationBar.translucent = NO;
    _chatController.navigationItem.hidesBackButton = YES;
    
    _chatController.isNavigationControllerVersion = YES;
    
    NSLog(@"%@", _myTitle);
    
    _chatController.chatTitle = [[NSString alloc] initWithFormat:@"%@",_myTitle];
    _chatController.opponentImg = [sharedManager.user getProfPicFromSport:[sharedManager.user getCurrentSport] picNumber:0];
    
    [self.navigationController pushViewController:_chatController animated:YES];
}

// Will be called when user presses send
- (void) chatController:(ChatController *)chatController didSendMessage:(NSMutableDictionary *)message {
    // Messages come prepackaged with the contents of the message and a timestamp in milliseconds
    NSLog(@"Message Contents: %@", message[kMessageContent]);
    NSLog(@"Timestamp: %@", message[kMessageTimestamp]);
    
    // Evaluate or add to the message here for example, if we wanted to assign the current userId:
    message[@"sentByUserId"] = @"currentUserId";
    
    // Must add message to controller for it to show
    [_chatController addNewMessage:message];
}

@end
