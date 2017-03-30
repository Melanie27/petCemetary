//
//  MainViewController.m
//  BloQuery
//
//  Created by MELANIE MCGANNEY on 7/11/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+Alerts.h"
#import "AppDelegate.h"
#import "PetsFeedTableViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@import Firebase;

//@import FBSDKCoreKit;
//@import FBSDKLoginKit;
//@import TwitterKit;

static const int kSectionToken = 3;
static const int kSectionProviders = 2;
static const int kSectionUser = 1;
static const int kSectionSignIn = 0;

typedef enum : NSUInteger {
    AuthEmail,
    AuthAnonymous,
    AuthFacebook,
    AuthGoogle,
    AuthTwitter,
    AuthCustom
} AuthProvider;

/*! @var kOKButtonText
 @brief The text of the "OK" button for the Sign In result dialogs.
 */
static NSString *const kOKButtonText = @"OK";

/*! @var kTokenRefreshedAlertTitle
 @brief The title of the "Token Refreshed" alert.
 */
static NSString *const kTokenRefreshedAlertTitle = @"Token";

/*! @var kTokenRefreshErrorAlertTitle
 @brief The title of the "Token Refresh error" alert.
 */
static NSString *const kTokenRefreshErrorAlertTitle = @"Get Token Error";

/** @var kSetDisplayNameTitle
 @brief The title of the "Set Display Name" error dialog.
 */
static NSString *const kSetDisplayNameTitle = @"Set Display Name";

/** @var kUnlinkTitle
 @brief The text of the "Unlink from Provider" error Dialog.
 */
static NSString *const kUnlinkTitle = @"Unlink from Provider";

/** @var kChangeEmailText
 @brief The title of the "Change Email" button.
 */
static NSString *const kChangeEmailText = @"Change Email";

/** @var kChangePasswordText
 @brief The title of the "Change Password" button.
 */
static NSString *const kChangePasswordText = @"Change Password";

@interface LoginViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordField.secureTextEntry = YES;
    //FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    //loginButton.center = self.view.center;
    //[self.view addSubview:loginButton];
   // if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        
    //}
    
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
                if (error == nil) {
                    FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                                     credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                                     .tokenString];
                    [[FIRAuth auth] signInWithCredential:credential
                                              completion:^(FIRUser *user, NSError *error) {
                                                  UIAlertController *picker = [UIAlertController alertControllerWithTitle:@"Select Provider"
                                                                                                                  message:nil
                                                                                                           preferredStyle:UIAlertControllerStyleActionSheet];
                                                  UIAlertAction *action;
                                                  action = [UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                      FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                                                      [loginManager logInWithReadPermissions:@[ @"public_profile", @"email" ]fromViewController:self
                                                                                     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                                                                         if (error) {
                                                                                             [self showMessagePrompt:error.localizedDescription];
                                                                                         } else if (result.isCancelled) {
                                                                                             NSLog(@"FBLogin cancelled");
                                                                                         } else {
                                                                                             // [START headless_facebook_auth]
                                                                                             FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                                                                                                              credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
                                                                                             // [END headless_facebook_auth]
                                                                                             [self firebaseLoginWithCredential:credential];
                                                                                         }
                                                                                     }];
                                                      
                                                  }];
                                                   [picker addAction:action];
                                                  [self.questionsButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                                              
                                                  if (error) {
                                                      // ...
                                                      return;
                                                  }
                                              }
                     ];
                }
                 else {
                    NSLog(@"%@", error.localizedDescription);
                }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)didTapEmailLogin:(id)sender {
    //keep this here for now so don't have to login every time
   
            //[self.questionsButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    
    
    //comment this in later
    [self showSpinner:^{
        // [START headless_email_auth]
        [[FIRAuth auth] signInWithEmail:_emailField.text
                               password:_passwordField.text
                             completion:^(FIRUser *user, NSError *error) {
                                 // [START_EXCLUDE]
                                 [self hideSpinner:^{
                                     
                                     if (error) {
                                         [self showMessagePrompt:error.localizedDescription];
                                         return;
                                     }
                                     //NSLog(@"success2, %@", user);
                                     [self.questionsButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                                 }];
                                 // [END_EXCLUDE]
                             }];
        // [END headless_email_auth]
        
    }];
}

/** @fn requestPasswordReset
 @brief Requests a "password reset" email be sent.
 */
- (IBAction)didRequestPasswordReset:(id)sender {
    [self
     showTextInputPromptWithMessage:@"Email:"
     completionBlock:^(BOOL userPressedOK, NSString *_Nullable userInput) {
         if (!userPressedOK || !userInput.length) {
             return;
         }
         
         [self showSpinner:^{
             // [START password_reset]
             [[FIRAuth auth]
              sendPasswordResetWithEmail:userInput
              completion:^(NSError *_Nullable error) {
                  // [START_EXCLUDE]
                  [self hideSpinner:^{
                      if (error) {
                          [self
                           showMessagePrompt:error
                           .localizedDescription];
                          return;
                      }
                      
                      [self showMessagePrompt:@"Sent"];
                  }];
                  // [END_EXCLUDE]
              }];
             // [END password_reset]
         }];
     }];
}

/** @fn getProvidersForEmail
 @brief Prompts the user for an email address, calls @c FIRAuth.getProvidersForEmail:callback:
 and displays the result.
 */
- (IBAction)didGetProvidersForEmail:(id)sender {
    [self
     showTextInputPromptWithMessage:@"Email:"
     completionBlock:^(BOOL userPressedOK, NSString *_Nullable userInput) {
         if (!userPressedOK || !userInput.length) {
             return;
         }
         
         [self showSpinner:^{
             // [START get_providers]
             [[FIRAuth auth]
              fetchProvidersForEmail:userInput
              completion:^(NSArray<NSString *> *_Nullable providers,
                           NSError *_Nullable error) {
                  // [START_EXCLUDE]
                  [self hideSpinner:^{
                      if (error) {
                          [self showMessagePrompt:error.localizedDescription];
                          return;
                      }
                      
                      [self showMessagePrompt:
                       [providers componentsJoinedByString:@", "]];
                  }];
                  // [END_EXCLUDE]
              }];
             // [END get_providers]
         }];
     }];
}

- (IBAction)didCreateAccount:(id)sender {
    [self
     showTextInputPromptWithMessage:@"Email:"
     completionBlock:^(BOOL userPressedOK, NSString *_Nullable email) {
         if (!userPressedOK || !email.length) {
             return;
         }
         
         [self
          showTextInputPromptWithMessage:@"Password:"
          completionBlock:^(BOOL userPressedOK,
                            NSString *_Nullable password) {
              if (!userPressedOK || !password.length) {
                  return;
              }
              
              [self showSpinner:^{
                  // [START create_user]
                  [[FIRAuth auth]
                   createUserWithEmail:email
                   password:password
                   completion:^(FIRUser *_Nullable user,
                                NSError *_Nullable error) {
                       // [START_EXCLUDE]
                       [self hideSpinner:^{
                           if (error) {
                               [self
                                showMessagePrompt:
                                error
                                .localizedDescription];
                               return;
                           }
                           //NSLog(@"%@ created", user.email);
                           [self.navigationController popViewControllerAnimated:YES];
                       }];
                       // [END_EXCLUDE]
                   }];
                  // [END create_user]
              }];
          }];
     }];
}

- (void)firebaseLoginWithCredential:(FIRAuthCredential *)credential {
    [self showSpinner:^{
        if ([FIRAuth auth].currentUser) {
            // [START link_credential]
            [[FIRAuth auth]
             .currentUser linkWithCredential:credential
             completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                 // [START_EXCLUDE]
                 [self hideSpinner:^{
                     if (error) {
                         [self showMessagePrompt:error.localizedDescription];
                         return;
                     }
                 }];
                 // [END_EXCLUDE]
             }];
            // [END link_credential]
        } else {
            // [START signin_credential]
            [[FIRAuth auth] signInWithCredential:credential
                                      completion:^(FIRUser *user, NSError *error) {
                                          // [START_EXCLUDE]
                                          [self hideSpinner:^{
                                              if (error) {
                                                  [self showMessagePrompt:error.localizedDescription];
                                                  return;
                                              }
                                          }];
                                          // [END_EXCLUDE]
                                      }];
            // [END signin_credential]
        }
    }];
    NSLog(@"firebaseLoginWithCredential");
}

- (void)showAuthPicker: (NSArray<NSNumber *>*) providers {
    UIAlertController *picker = [UIAlertController alertControllerWithTitle:@"Select Provider"
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSNumber *provider in providers) {
        UIAlertAction *action;
        switch (provider.unsignedIntegerValue) {
            case AuthEmail:
            {
                action = [UIAlertAction actionWithTitle:@"Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self performSegueWithIdentifier:@"email" sender:nil];
                }];
            }
                break;
            case AuthCustom:
            {
                action = [UIAlertAction actionWithTitle:@"Custom" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self performSegueWithIdentifier:@"customToken" sender:nil];
                }];
            }
                break;
                
                 case AuthFacebook: {
                     action = [UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                         FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                         [loginManager logInWithReadPermissions:@[ @"public_profile", @"email" ]fromViewController:self
                                                        handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                                            if (error) {
                                                                [self showMessagePrompt:error.localizedDescription];
                                                            } else if (result.isCancelled) {
                                                                NSLog(@"FBLogin cancelled");
                                                            } else {
                                                                // [START headless_facebook_auth]
                                                                FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                                                                                 credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
                                                                // [END headless_facebook_auth]
                                                                [self firebaseLoginWithCredential:credential];
                                                            }
                                                        }];
                 
                                                    }];
                                            }
                 break;
                 /*case AuthGoogle: {
                 action = [UIAlertAction actionWithTitle:@"Google" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
                 [GIDSignIn sharedInstance].uiDelegate = self;
                 [GIDSignIn sharedInstance].delegate = self;
                 [[GIDSignIn sharedInstance] signIn];
                 
                 }];
                 }*/
                 break;
            case AuthAnonymous: {
                action = [UIAlertAction actionWithTitle:@"Anonymous" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self showSpinner:^{
                        // [START firebase_auth_anonymous]
                        [[FIRAuth auth]
                         signInAnonymouslyWithCompletion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                             // [START_EXCLUDE]
                             [self hideSpinner:^{
                                 if (error) {
                                     [self showMessagePrompt:error.localizedDescription];
                                     return;
                                 }
                             }];
                             // [END_EXCLUDE]
                         }];
                        // [END firebase_auth_anonymous]
                    }];
                }];
            }
                break;
        }
        [picker addAction:action];
    }
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [picker addAction:cancel];
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)didTapSignIn:(id)sender {
    [self showAuthPicker:@[@(AuthEmail),
                           @(AuthAnonymous),
                           @(AuthGoogle),
                           @(AuthFacebook),
                           @(AuthTwitter),
                           @(AuthCustom)]];
}

- (IBAction)didTapLink:(id)sender {
    NSMutableArray *providers = [@[@(AuthGoogle),
                                   @(AuthFacebook),
                                   @(AuthTwitter)] mutableCopy];
    
    // Remove any existing providers. Note that this is not a complete list of
    // providers, so always check the documentation for a complete reference:
    // https://firebase.google.com/docs/auth
    for (id<FIRUserInfo> userInfo in [FIRAuth auth].currentUser.providerData) {
        if ([userInfo.providerID isEqualToString:FIRFacebookAuthProviderID]) {
            [providers removeObject:@(AuthFacebook)];
        } else if ([userInfo.providerID isEqualToString:FIRGoogleAuthProviderID]) {
            [providers removeObject:@(AuthGoogle)];
        } else if ([userInfo.providerID isEqualToString:FIRTwitterAuthProviderID]) {
            [providers removeObject:@(AuthTwitter)];
        }
    }
    [self showAuthPicker:providers];
}

- (IBAction)didTapSignOut:(id)sender {
    // [START signout]
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    } else {
        NSLog(@"signed out");
    }
    // [END signout]
}

- (IBAction)IBActiondidRequestPasswordReset:(id)sender {
}

// [START headless_google_auth]
/*- (void)signIn:(GIDSignIn *)signIn
 didSignInForUser:(GIDGoogleUser *)user
 withError:(NSError *)error {
 if (error == nil) {
 GIDAuthentication *authentication = user.authentication;
 FIRAuthCredential *credential =
 [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
 accessToken:authentication.accessToken];
 // [START_EXCLUDE]
 [self firebaseLoginWithCredential:credential];
 // [END_EXCLUDE]
 } else
 // [START_EXCLUDE]
 [self showMessagePrompt:error.localizedDescription];
 // [END_EXCLUDE]
 }*/
// [END headless_google_auth]

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.handle = [[FIRAuth auth]
                   addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
                       [self setTitleDisplay:user];
                   }];
}

- (void)setTitleDisplay: (FIRUser *)user {
    if (user) {
        //self.navigationItem.title = [NSString stringWithFormat:@"Welcome %@", user.email];
        self.navigationItem.title = [NSString stringWithFormat:@"Welcome!"];
        //skip launch screen
        //UIViewController *vc = [[PetsFeedTableViewController alloc] init];
       
        
    } else {
        self.navigationItem.title = @"Login or Signup";
        
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[FIRAuth auth] removeAuthStateDidChangeListener:_handle];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kSectionSignIn) {
        return 1;
    } else if (section == kSectionUser || section == kSectionToken) {
        if ([FIRAuth auth].currentUser) {
            return 1;
        } else {
            return 0;
        }
    } else if (section == kSectionProviders) {
        return [[FIRAuth auth].currentUser.providerData count];
    }
    NSAssert(NO, @"Unexpected section");
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == kSectionSignIn) {
        if ([FIRAuth auth].currentUser) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SignOut"];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SignIn"];
        }
    } else if (indexPath.section == kSectionUser) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Profile"];
        FIRUser *user = [FIRAuth auth].currentUser;
        UILabel *emailLabel = [(UILabel *)cell viewWithTag:1];
        UILabel *userIDLabel = [(UILabel *)cell viewWithTag:2];
        UIImageView *profileImageView = [(UIImageView *)cell viewWithTag:3];
        emailLabel.text = user.email;
        userIDLabel.text = user.uid;
        
        NSURL *photoURL = user.photoURL;
        static NSURL *lastPhotoURL = nil;
        lastPhotoURL = photoURL;  // to prevent earlier image overwrites later one.
        if (photoURL) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^() {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
                dispatch_async(dispatch_get_main_queue(), ^() {
                    if (photoURL == lastPhotoURL) {
                        profileImageView.image = image;
                    }
                });
            });
        } else {
            profileImageView.image = [UIImage imageNamed:@"ic_account_circle"];
        }
    } else if (indexPath.section == kSectionProviders) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Provider"];
        id<FIRUserInfo> userInfo = [FIRAuth auth].currentUser.providerData[indexPath.row];
        cell.textLabel.text = [userInfo providerID];
        cell.detailTextLabel.text = [userInfo uid];
    } else if (indexPath.section == kSectionToken) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Token"];
        UIButton *requestEmailButton = [(UIButton *)cell viewWithTag:4];
        requestEmailButton.enabled = [FIRAuth auth].currentUser.email ? YES : NO;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Unlink";
}

// Swipe to delete.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *providerID = [[FIRAuth auth].currentUser.providerData[indexPath.row] providerID];
        [self showSpinner:^{
            // [START unlink_provider]
            [[FIRAuth auth]
             .currentUser unlinkFromProvider:providerID
             completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                 // [START_EXCLUDE]
                 [self hideSpinner:^{
                     if (error) {
                         [self showMessagePrompt:error.localizedDescription];
                         return;
                     }
                     //      [self.tableView reloadData];
                 }];
                 // [END_EXCLUDE]
             }];
            // [END unlink_provider]
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kSectionUser) {
        return 200;
    }
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (IBAction)didTokenRefresh:(id)sender {
    FIRAuthTokenCallback action = ^(NSString *_Nullable token, NSError *_Nullable error) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:kOKButtonText
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             NSLog(kOKButtonText);
                                                         }];
        if (error) {
            UIAlertController *alertController =
            [UIAlertController alertControllerWithTitle:kTokenRefreshErrorAlertTitle
                                                message:error.localizedDescription
                                         preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        // Log token refresh event to Analytics.
        [FIRAnalytics logEventWithName:@"tokenrefresh" parameters:nil];
        
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:kTokenRefreshedAlertTitle
                                            message:token
                                     preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    };
    // [START token_refresh]
    [[FIRAuth auth].currentUser getTokenForcingRefresh:YES completion:action];
    // [END token_refresh]
}


/** @fn setDisplayName
 @brief Changes the display name of the current user.
 */
- (IBAction)didSetDisplayName:(id)sender {
    [self showTextInputPromptWithMessage:@"Display Name:"
                         completionBlock:^(BOOL userPressedOK, NSString *_Nullable userInput) {
                             if (!userPressedOK || !userInput.length) {
                                 return;
                             }
                             
                             [self showSpinner:^{
                                 // [START profile_change]
                                 FIRUserProfileChangeRequest *changeRequest =
                                 [[FIRAuth auth].currentUser profileChangeRequest];
                                 changeRequest.displayName = userInput;
                                 [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                                     // [START_EXCLUDE]
                                     [self hideSpinner:^{
                                         [self showTypicalUIForUserUpdateResultsWithTitle:kSetDisplayNameTitle
                                                                                    error:error];
                                         [self setTitleDisplay:[FIRAuth auth].currentUser];
                                     }];
                                     // [END_EXCLUDE]
                                 }];
                                 // [END profile_change]
                             }];
                         }];
}

/** @fn requestVerifyEmail
 @brief Requests a "verify email" email be sent.
 */
- (IBAction)didRequestVerifyEmail:(id)sender {
    [self showSpinner:^{
        // [START send_verification_email]
        [[FIRAuth auth]
         .currentUser sendEmailVerificationWithCompletion:^(NSError *_Nullable error) {
             // [START_EXCLUDE]
             [self hideSpinner:^{
                 if (error) {
                     [self showMessagePrompt:error.localizedDescription];
                     return;
                 }
                 
                 [self showMessagePrompt:@"Sent"];
             }];
             // [END_EXCLUDE]
         }];
        // [END send_verification_email]
    }];
}

/** @fn changeEmail
 @brief Changes the email address of the current user.
 */
- (IBAction)didChangeEmail:(id)sender {
    [self showTextInputPromptWithMessage:@"Email Address:"
                         completionBlock:^(BOOL userPressedOK, NSString *_Nullable userInput) {
                             if (!userPressedOK || !userInput.length) {
                                 return;
                             }
                             
                             [self showSpinner:^{
                                 // [START change_email]
                                 [[FIRAuth auth]
                                  .currentUser
                                  updateEmail:userInput
                                  completion:^(NSError *_Nullable error) {
                                      // [START_EXCLUDE]
                                      [self hideSpinner:^{
                                          [self
                                           showTypicalUIForUserUpdateResultsWithTitle:kChangeEmailText
                                           error:error];
                                          
                                      }];
                                      // [END_EXCLUDE]
                                  }];
                                 // [END change_email]
                             }];
                         }];
}

/** @fn changePassword
 @brief Changes the password of the current user.
 */
- (IBAction)didChangePassword:(id)sender {
    [self showTextInputPromptWithMessage:@"New Password:"
                         completionBlock:^(BOOL userPressedOK, NSString *_Nullable userInput) {
                             if (!userPressedOK || !userInput.length) {
                                 return;
                             }
                             
                             [self showSpinner:^{
                                 // [START change_password]
                                 [[FIRAuth auth]
                                  .currentUser
                                  updatePassword:userInput
                                  completion:^(NSError *_Nullable error) {
                                      // [START_EXCLUDE]
                                      [self hideSpinner:^{
                                          [self showTypicalUIForUserUpdateResultsWithTitle:
                                           kChangePasswordText
                                                                                     error:error];
                                      }];
                                      // [END_EXCLUDE]
                                  }];
                                 // [END change_password]
                             }];
                         }];
}

/** @fn showTypicalUIForUserUpdateResultsWithTitle:error:
 @brief Shows a @c UIAlertView if error is non-nil with the localized description of the error.
 @param resultsTitle The title of the @c UIAlertView
 @param error The error details to display if non-nil.
 */
- (void)showTypicalUIForUserUpdateResultsWithTitle:(NSString *)resultsTitle error:(NSError *)error {
    if (error) {
        NSString *message = [NSString stringWithFormat:@"%@ (%ld)\n%@", error.domain, (long)error.code,
                             error.localizedDescription];
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle: resultsTitle
                                    message: message
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:kOKButtonText style:UIAlertActionStyleCancel
                                                       handler: nil];
        
        [alert addAction:ok];
        
        return;
    }
    //    [self.tableView reloadData];
}

@end
