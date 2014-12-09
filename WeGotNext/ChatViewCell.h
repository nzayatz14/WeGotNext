//
//  ChatViewCell.h
//  WeGotNext
//
//  Created by Nick Zayatz on 12/8/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewCell: UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *txtThem;
@property (weak, nonatomic) IBOutlet UITextView *txtYou;

@end
