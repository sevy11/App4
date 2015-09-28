//
//  LogInViewController.m
//  ApplifyBeta4
//
//  Created by Michael Sevy on 6/29/15.
//  Copyright (c) 2015 Michael Sevy. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>

@interface LogInViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;

    self.backgroundImage.image = [UIImage imageNamed:@"Applify"];
    self.backgroundImage.alpha = .045;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setHidden:YES];

}

- (IBAction)onLogInButtonTapped:(UIButton *)sender {

    NSString *username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([username length] == 0 || [password length] == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please complete both username and password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    } else{
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error){
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Username or Password is incorrect" preferredStyle:UIAlertControllerStyleAlert];
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

    return  YES;
}





@end





