//
//  LoginViewController.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/11/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@import FirebaseDatabase;

@interface LoginViewController : UIViewController


@property (strong, nonatomic) FIRDatabaseReference *ref;


- (IBAction)didCreateAccount:(id)sender;

- (IBAction)didTapEmailLogin:(id)sender;

- (IBAction)didTapSignOut:(id)sender;

- (IBAction)IBActiondidRequestPasswordReset:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *emailField;

@property (nonatomic, strong) IBOutlet UIButton *createAccount;

@property (nonatomic, strong) IBOutlet UIButton *submitAccount;

@property (nonatomic, strong) IBOutlet UIButton *logoutAccount;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic)IBOutlet UIViewController *questionsVC;
@property IBOutlet UIButton *questionsButton;


@end
