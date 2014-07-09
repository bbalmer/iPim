//
//  LoginController.m
//  iPim
//
//  Created by Brad Balmer on 6/19/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import "LoginController.h"
#import "SSKeychain.h"
#import "HttpConnection.h"
#import "HomeController.h"

@interface LoginController ()
@end

@implementation LoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
    										 selector:@selector(keyboardWasShown:)
    											 name:UIKeyboardDidShowNotification
    										   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
    										 selector:@selector(keyboardWasHidden:)
    											 name:UIKeyboardDidHideNotification
    										   object:nil];
    
    _username.delegate = self;
    _password.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {

    NSString *pwdSvc = @"IM";
    NSString *acctId = [_username text];
    
    [SSKeychain setPassword:_password.text forService:pwdSvc account:acctId];

    //Store SSO ID in NSUserDefaults so Account can be easily loaded elsewhere
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:acctId forKey:@"IM_USERNAME"];
    [prefs synchronize];
    
    
    NSString *uri = [@"/user/" stringByAppendingString:acctId];
    NSString *loginResult = [HttpConnection GET:uri];
    BOOL invalidLogin = NO;
    if(loginResult) {
    
        NSError*e;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[loginResult dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&e];
        
        json = [json objectForKey:@"userModel"];
        if([json objectForKey:@"id"]) {
            [prefs setObject:json forKey:@"IM_USER"];
            [prefs synchronize];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        } else {
            invalidLogin = YES;
        }
    } else {
        invalidLogin = YES;
    }
    
    if(invalidLogin) {
    
        [prefs removeObjectForKey:@"IM_USERNAME"];
        [prefs synchronize];
        [SSKeychain deletePasswordForService:pwdSvc account:acctId];
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Invalid login"
                                                        message: @"Invalid username and/or password"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = nil;
    // Additional Code
}

- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if(!CGRectContainsPoint(aRect, activeField.frame.origin)) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

- (void)keyboardWasHidden:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}


@end

