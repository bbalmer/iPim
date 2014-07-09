//
//  LoginController.h
//  iPim
//
//  Created by Brad Balmer on 6/19/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginController : UIViewController <UITextFieldDelegate> {
    UITextField *activeField;
    BOOL keyboardShown;
    BOOL viewMoved;
}
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)login:(id)sender;
@end
