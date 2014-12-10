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

//Constant to hold the height of the menu accessory for the textEditor
#define TEXT_EDITOR_ACCESSORY_WIDTH 40

@implementation ChatWindow

-(void)viewDidLoad{
    //load old messages into the chat
    _messages = [[NSMutableArray alloc] init];
    _messagesCount = [NSNumber numberWithInteger:[_messages count]];
    
    [self.messageTable.delegate self];
    self.messageTable.dataSource = self;
    
    //creates toolbar for textViews to hold the 'Done' button
    UIToolbar *helperToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, TEXT_EDITOR_ACCESSORY_WIDTH)];
    helperToolBar.barStyle = UIBarStyleDefault;
    
    //UITextView *textViewOnKeyboard = [[UITextView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width-70, TEXT_EDITOR_ACCESSORY_WIDTH-10)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(btnSend:)];
    [doneButton setWidth:65.0f];
    
    helperToolBar.items = [NSArray arrayWithObjects:doneButton, nil];
    
    [_txtMessage setInputAccessoryView:helperToolBar];
}

- (IBAction)btnSend:(UIButton *)sender {
    
    if([_txtMessage.text length] > 0){
        MyManager *sharedManager = [MyManager sharedManager];
        
        NSString *thisMessage = [[NSString alloc] initWithString:[_txtMessage text]];
        NSDate *now = [NSDate date];
        
        Message *newMessage = [[Message alloc] init];
        [newMessage setText:thisMessage];
        [newMessage setTime:now];
        [newMessage setSender:[sharedManager.user getUserName]];
        
        [_messages addObject:newMessage];
        
        NSMutableArray *arrayOfIndexPaths = [[NSMutableArray alloc] init];
        
        //for(int i = 0; i<[_messages count]; i++){
            NSIndexPath *path = [NSIndexPath indexPathForRow:[_messages count]-1 inSection:0];
            [arrayOfIndexPaths addObject:path];
        //}
        
        [self.messageTable beginUpdates];
        [self.messageTable insertRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
        [self.messageTable endUpdates];
        
        _txtMessage.text=@"";
        [_txtMessage resignFirstResponder];
    }
    
    [_txtMessage resignFirstResponder];
    
}


//returns how many sections in the table there are
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

//returns how many rows in the table there are
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [_messages count];
}

//set the information of each cell based on the information in the array of matches
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    //set template of the cell
    static NSString *cellID = @"ChatCell";
    
    ChatViewCell *cell = [self.messageTable dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[ChatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
   //set label text (also need to do picture)
    if ([[(Message *)[_messages objectAtIndex: [indexPath row]] getSender]  isEqualToString:[sharedManager.user getUserName]]){
        cell.txtYou.text = [(Message *)[_messages objectAtIndex: [indexPath row]] getText];
        cell.txtThem.text = @"";
    }else{
        cell.txtThem.text = [(Message *)[_messages objectAtIndex: [indexPath row]] getText];
        cell.txtYou.text = @"";
    }
    
    return cell;
}

@end
