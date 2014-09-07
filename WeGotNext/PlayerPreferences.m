//
//  PlayerPreferences.m
//  WeGotNext
//
//  Created by Nick Zayatz on 9/1/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "PlayerPreferences.h"
#import "MyManager.h"

@implementation PlayerPreferences

/*FUNCTION IS INCOMPLETE*/
-(void) viewDidLoad{
    MyManager *sharedManager = [MyManager sharedManager];
    
    [_swiMen setOn:[sharedManager.user getFindMale]];
    [_swiWomen setOn:[sharedManager.user getFindFemale]];
    
    //set the rest of the initial values
    
    save = NO;

}

//if the switch changes value, set the new value to the BOOL in the person class and set 'save' to YES
- (IBAction)swiMenClicked:(UISwitch *)sender {
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user setFindMale:[_swiMen isOn]];
    
    save = YES;
}

//if the switch changes value, set the new value to the BOOL in the person class and set 'save' to YES
- (IBAction)swiWomenClicked:(UISwitch *)sender {
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user setFindFemale:[_swiWomen isOn]];
    
    save = YES;
}

/*FUNCTION IS INCOMPLETE*/
//if the slider changes values, set the new value to the int in the person class and set 'save' to YES
- (IBAction)sldRangeChanged:(UISlider *)sender {
    save = YES;
}

/*FUNCTION IS INCOMPLETE*/
//if the slider changes values, set the new value to the int in the person class and set 'save' to YES
- (IBAction)sldAgeChanged:(UISlider *)sender {
    save = YES;
}

/*FUNCTION IS INCOMPLETE*/
-(void) viewWillDisappear:(BOOL)animated{
    if(save){
        //save these changes to the database
    }
}
@end
