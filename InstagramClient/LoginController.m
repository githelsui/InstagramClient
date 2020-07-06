//
//  LoginController.m
//  InstagramClient
//
//  Created by Githel Lynn Suico on 7/6/20.
//  Copyright © 2020 Githel Lynn Suico. All rights reserved.
//

#import "LoginController.h"
#import <Parse/Parse.h>

@interface LoginController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)signUp:(id)sender {
    BOOL emptyString = [self.usernameField.text isEqual:@""];
    if(emptyString){
        [self showAlert:@"Username cannot be empty." subtitle:@""];
    } else {
        PFUser *newUser = [PFUser user];
        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self showAlert:error.localizedDescription subtitle:@""];
            } else {
                NSLog(@"User registered successfully");
                [self performSegueWithIdentifier:@"LoggedSegue" sender:nil];
            }
        }];
    }
}

- (IBAction)logIn:(id)sender {
    BOOL emptyString = [self.usernameField.text isEqual:@""];
    if(emptyString){
        [self showAlert:@"Username cannot be empty." subtitle:@""];
    } else {
        NSString *username = self.usernameField.text;
        NSString *password = self.passwordField.text;
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
                [self showAlert:error.localizedDescription subtitle:@""];
            } else {
                NSLog(@"User logged in successfully");
                [self performSegueWithIdentifier:@"LoggedSegue" sender:nil];
            }
        }];
    }
}

- (void)showAlert:(NSString *)title subtitle:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{}];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
