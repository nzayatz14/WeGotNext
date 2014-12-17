//
//  ChatWindow.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatController.h"

@interface ChatWindow : UIViewController <ChatControllerDelegate>

@property (nonatomic, strong) NSString *myTitle;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) ChatController * chatController;

@end
