//
//  Profile.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "Profile.h"
#import "MyManager.h"

@implementation Profile

//initialize the labels and such when the view appears to the user
-(void) viewWillAppear:(BOOL)animated{
    
    //create the manager to access the users information
    MyManager *sharedManager = [MyManager sharedManager];
    
    //set the information of the profile menu equal to the information of the user
    //(strong variables then weak variables)
    
    //also need to set picture(s)

    _txtFirstName.text = [sharedManager.user getFirstName];
    _txtAge.text = [NSString stringWithFormat:@"%d", [sharedManager.user getAge]];
    _txtExperience1.text = [[NSString alloc] initWithFormat:@"Exp 1"];
    _txtExperience2.text = [[NSString alloc] initWithFormat:@"Exp 2"];
    _txtExperience3.text = [[NSString alloc] initWithFormat:@"Exp 3"];
    _txtCredibilityRating.text = [[NSString alloc]initWithFormat:@"%d",[[NSNumber numberWithInt:[sharedManager.user getCredibility]] intValue]];
    
    if([sharedManager.user isMale]){
        _txtGender.text = [[NSString alloc] initWithFormat:@"M"];
    }else{
        _txtGender.text = [[NSString alloc] initWithFormat:@"F"];
    }
    
    [_pgrCredibility setProgress:[[NSNumber numberWithInt:[sharedManager.user getCredibility]] floatValue]/100];
    
   /* _txtFirstName.text = _First;
    _txtAge.text = _Age;
    _txtGender.text = _Gender;
    
    _txtExperience1.text = _Exp1;
    _txtExperience2.text = _Exp2;
    _txtExperience3.text = _Exp3;
    
    _txtCredibilityRating.text = [[NSString alloc] initWithFormat:@"%d", [_credibility intValue]];
    */
    
}

//function performs if the user holds onto the front profile picture
- (IBAction)holdProfilePicture:(UILongPressGestureRecognizer *)sender {
    
    //statement to make sure only 1 action sheet appears
    if(sender.state == UIGestureRecognizerStateBegan){
    //Declase action sheet (pop up window on the bottom)
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Select From Library", nil];
    
    //show pop up window
    [actionSheet showInView:self.view];
    }
}

//function preforms if the user makes a selection in the pop up window
- (void)actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //decide which option is taken, option 1 is display the camera, option 2 is go to the devices library
    //create an image picker for whichever option is taken and set it equal to the windows imagePicker
    switch(buttonIndex){
        case 0:
        {
            self.imagePicker = [[UIImagePickerController alloc] init];
            self.imagePicker.delegate = self;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }
            break;
        case 1:
        {
            self.imagePicker = [[UIImagePickerController alloc] init];
            self.imagePicker.delegate = self;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
            
    }
}

//when the user decides on a picture to use, hide the pop up window and set the profile
//picture to be that newly selected picture
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    self.selectedImage = info[UIImagePickerControllerOriginalImage];
    [self.picFrontProfilePicture setImage:self.selectedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];

}

//if the user hits cancel in the pop up window, hide the pop up window
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];

}
@end
