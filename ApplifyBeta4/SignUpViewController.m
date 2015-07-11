//
//  SignUpViewController.m
//  ApplifyBeta4
//
//  Created by Michael Sevy on 6/30/15.
//  Copyright (c) 2015 Michael Sevy. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameSignUpText;
@property (weak, nonatomic) IBOutlet UITextField *passwordSignUpText;
@property (weak, nonatomic) IBOutlet UITextField *emailSignUpText;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.usernameSignUpText.delegate = self;
    self.passwordSignUpText.delegate = self;
    self.emailSignUpText.delegate = self;


    self.backgroundView.image = [UIImage imageNamed:@"Applify"];
    self.backgroundView.alpha = .045;
}


- (IBAction)onSignUpButtonTapped:(UIButton *)sender {

    NSString *username = [self.usernameSignUpText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordSignUpText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailSignUpText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([username length] == 0 || [password length] == 0 || [email length] == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please fill out all fields ;)" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];

        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];

    } else{
        //set up user as a PF object
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;

        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Parse Messaging Error" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                }];

                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];

            } else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];

    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end




