//
//  Profile.m
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import "Profile.h"
#import "MyManager.h"

//Constant to hold the height of the menu accessory for the textEditor
#define TEXT_EDITOR_ACCESSORY_WIDTH 40
#define EXP_COUNT 3 //how many experiences the user can put

@implementation Profile

-(void) viewDidLoad{
    //delegate the text fields so they can be closed when necessary
    [_txtExperience1 setDelegate:self];
    [_txtExperience2 setDelegate:self];
    [_txtExperience3 setDelegate:self];
    
    _editableColor = _txtExperience1.backgroundColor;
}

//initialize the labels and such when the view appears to the user
-(void) viewWillAppear:(BOOL)animated{
    
    //create the manager to access the users information
    MyManager *sharedManager = [MyManager sharedManager];
    
    //set the information of the profile menu equal to the information of the user
    
    _txtFirstName.text = [sharedManager.user getFirstName];
    _txtAge.text = [NSString stringWithFormat:@"%d", [sharedManager.user getAge]];
    
    _txtExperience1.text = [sharedManager.user getExperienceFromSport:[sharedManager.user getCurrentSport] experienceNumber:0];
    _txtExperience2.text = [sharedManager.user getExperienceFromSport:[sharedManager.user getCurrentSport] experienceNumber:1];
    _txtExperience3.text = [sharedManager.user getExperienceFromSport:[sharedManager.user getCurrentSport] experienceNumber:2];
    
    _picFrontProfilePicture.image = [sharedManager.user getProfPicFromSport:[sharedManager.user getCurrentSport] picNumber:0];
    [_picFrontProfilePicture sizeToFit];
    
    _txtCredibilityRating.text = [[NSString alloc]initWithFormat:@"%d",[[NSNumber numberWithInt:[sharedManager.user getCredibility]] intValue]];
    
    
    
    if([sharedManager.user isMale]){
        _txtGender.text = @"M";
    }else{
        _txtGender.text = @"F";
    }
    
    [_pgrCredibility setProgress:[[NSNumber numberWithInt:[sharedManager.user getCredibility]] floatValue]/100];
    
    //sets the view as not editable to start
    isEditable = NO;
    [self makeViewUneditable];
    
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
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.selectedImage = info[UIImagePickerControllerOriginalImage];
    [_picFrontProfilePicture setImage:self.selectedImage];
    
}

//if the user hits cancel in the pop up window, hide the pop up window
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//makes the users profile editable to the user
- (void) makeViewEditable{
    [_btnEdit setTitle:@"Done" forState:UIControlStateNormal];
    [_btnEdit setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _LongPressGestureRecognizer.enabled = YES;
    _txtExperience1.editable = YES;
    _txtExperience2.editable = YES;
    _txtExperience3.editable = YES;
    _txtExperience1.backgroundColor = _editableColor;
    _txtExperience2.backgroundColor = _editableColor;
    _txtExperience3.backgroundColor = _editableColor;
    
    //creates toolbar for textViews to hold the 'Done' button
    UIToolbar *helperToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, TEXT_EDITOR_ACCESSORY_WIDTH)];
    helperToolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closeTextView:)];
    [doneButton setWidth:65.0f];
    
    helperToolBar.items = [NSArray arrayWithObjects:doneButton, nil];
    
    [_txtExperience1 setInputAccessoryView:helperToolBar];
    [_txtExperience2 setInputAccessoryView:helperToolBar];
    [_txtExperience3 setInputAccessoryView:helperToolBar];
}

- (void) closeTextView:(id) sender{
    [_txtExperience1 resignFirstResponder];
    [_txtExperience2 resignFirstResponder];
    [_txtExperience3 resignFirstResponder];
}

//makes the users profile uneditable
- (void) makeViewUneditable{
    [_btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    [_btnEdit setTitleColor:nil forState:UIControlStateNormal];
    _LongPressGestureRecognizer.enabled = NO;
    _txtExperience1.editable = NO;
    _txtExperience2.editable = NO;
    _txtExperience3.editable = NO;
    _txtExperience1.backgroundColor = [UIColor clearColor];
    _txtExperience2.backgroundColor = [UIColor clearColor];
    _txtExperience3.backgroundColor = [UIColor clearColor];
}

/*FUNCITON IS INCOMPLETE*/
//saves the changes that the user made while editing the profile
- (void) saveChanges{
    MyManager *sharedManager = [MyManager sharedManager];
    [sharedManager.user setExperienceFromSport:[sharedManager.user getCurrentSport] experienceNumber:0 experience:[NSString stringWithFormat:@"%@", _txtExperience1.text]];
    [sharedManager.user setExperienceFromSport:[sharedManager.user getCurrentSport] experienceNumber:1 experience:[NSString stringWithFormat:@"%@", _txtExperience2.text]];
    [sharedManager.user setExperienceFromSport:[sharedManager.user getCurrentSport] experienceNumber:2 experience:[NSString stringWithFormat:@"%@", _txtExperience3.text]];
    
    //save these changes to database
    [self saveChangesToDatabase];
}

//toggles between editable and not editable views with button clicks
- (IBAction)btnEditClicked:(UIButton *)sender {
    if(isEditable == NO)
        isEditable = YES;
    else
        isEditable = NO;
    
    if(isEditable){
        [self makeViewEditable];
    }else{
        [self makeViewUneditable];
        [self saveChanges];
    }
}

-(void) saveChangesToDatabase{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"inAppStorage_WeGotNext.sqlite"];
    
    sqlite3 *inAppDatabase;
    
    //attempts to open the inApp database. if successful, continue, if not, print error.
    if(sqlite3_open([filePath UTF8String], &inAppDatabase) == SQLITE_OK){
        MyManager *sharedManager = [MyManager sharedManager];
        
        for(int i = 0;i<EXP_COUNT;i++){
            NSString *test = [[NSString alloc] initWithFormat:@"UPDATE currentUserExperience SET experience='%@' WHERE sport=%d AND experienceNumber=%d", [sharedManager.user getExperienceFromSport:[sharedManager.user getCurrentSport] experienceNumber:i],[sharedManager.user getCurrentSport],i];
            
            //NSLog(@"%@",test);
            
            const char *testChar = [test UTF8String];
            
            sqlite3_stmt *compiledStatement2;
            
            //attempts to compiled the SQL statement. if successful, continue, if not print error.
            if(sqlite3_prepare_v2(inAppDatabase, testChar, -1, &compiledStatement2, NULL) == SQLITE_OK){
                //NSLog(@"Update Success");
            }else{
                NSLog(@"Error 1: %s", sqlite3_errmsg(inAppDatabase));
            }
            
            //finalize the SQL statement
            if(sqlite3_step(compiledStatement2) == SQLITE_DONE)
                sqlite3_finalize(compiledStatement2);
        }
    }else{
        NSLog(@"Error 0: %s", sqlite3_errmsg(inAppDatabase));
        
    }
    
    //close the database
    sqlite3_close(inAppDatabase);
}
@end
