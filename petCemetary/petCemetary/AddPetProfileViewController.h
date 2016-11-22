//
//  AddPetProfileViewController.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/15/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Pet;

@interface AddPetProfileViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *petNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *animalTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *animalBreedTextField;
@property (strong, nonatomic) IBOutlet UITextField *animalPersonalityTextField;
@property (strong, nonatomic) IBOutlet UITextField *ownerNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *uploadProfilePhotoButton;


- (IBAction)savePetProfile:(id)sender;
- (IBAction)uploadProfilePhoto:(id)sender;


@end
