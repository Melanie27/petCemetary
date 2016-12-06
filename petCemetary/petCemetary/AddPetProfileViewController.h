//
//  AddPetProfileViewController.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/15/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h> 
@import Firebase;
@import FirebaseDatabase;
@import FirebaseStorage;
@class Pet;

@interface AddPetProfileViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *petNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *animalTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *animalBreedTextField;

@property (strong, nonatomic) IBOutlet UITextView *animalPersonalityTextView;
@property (strong, nonatomic) IBOutlet UITextField *ownerNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *uploadProfilePhotoButton;
@property (strong, nonatomic) IBOutlet UITextField *dobTextField;
@property (strong, nonatomic) IBOutlet UITextField *dodTextField;
@property (nonatomic) NSInteger petNumber;

@property (strong, nonatomic) NSURL *petImageURL;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRStorage *storage;


- (IBAction)savePetProfile:(id)sender;


- (IBAction)uploadProfilePhoto:(id)sender;


@end
