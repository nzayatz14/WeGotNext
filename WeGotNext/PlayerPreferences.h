//
//  PlayerPreferences.h
//  WeGotNext
//
//  Created by Nick Zayatz on 9/1/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerPreferences : UIViewController{
    BOOL save;
}

- (IBAction)swiMenClicked:(UISwitch *)sender;
- (IBAction)swiWomenClicked:(UISwitch *)sender;
- (IBAction)sldRangeChanged:(UISlider *)sender;
- (IBAction)sldAgeChanged:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UISwitch *swiMen;
@property (weak, nonatomic) IBOutlet UISwitch *swiWomen;
@property (weak, nonatomic) IBOutlet UISlider *sldRange;
@property (weak, nonatomic) IBOutlet UISlider *sldAge;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblAge;


@end
