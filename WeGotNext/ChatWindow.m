//
//  ChatWindow.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "ChatWindow.h"

@implementation ChatWindow

-(void)viewDidLoad{
    //load old messages into the chat

}

- (IBAction)btnSend:(UIButton *)sender {
    NSString *thisMessage = [[NSString alloc] initWithString:[_txtMessage text]];
    NSDate *now = [NSDate date];
    
    Message *newMessage = [[Message alloc] init];
    [newMessage setText:thisMessage];
    [newMessage setTime:now];
    
}

@end

@implementation Message

-(void) setText:(NSString *)text{
    _text = text;
}


-(void) setTime:(NSDate *)time{
    _time = time;
}
@end
