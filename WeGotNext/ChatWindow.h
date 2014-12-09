//
//  ChatWindow.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Message : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *time;

-(void) setText:(NSString *)Text;
-(void) setTime:(NSDate *)time;
@end

@interface ChatWindow : UIViewController
@property (nonatomic, strong) NSString *myTitle;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (weak, nonatomic) IBOutlet UITextField *txtMessage;
- (IBAction)btnSend:(UIButton *)sender;


@property (nonatomic, strong) NSMutableArray *messages;

@end
