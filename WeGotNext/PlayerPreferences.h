//
//  PlayerPreferences.h
//  WeGotNext
//
//  Created by Nick Zayatz on 9/1/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerPreferences : UIViewController
- (IBAction)swiMen:(UISwitch *)sender;
- (IBAction)swiWomen:(UISwitch *)sender;
- (IBAction)sldRange:(UISlider *)sender;
- (IBAction)sldAge:(UISlider *)sender;

@end
