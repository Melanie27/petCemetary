//
//  EditPetProfileViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/22/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "EditPetProfileViewController.h"
#import "EditPetPhotosTableViewController.h"
#import "PCDataSource.h"
#import "Pet.h"
@import Firebase;
@import FirebaseDatabase;

@interface EditPetProfileViewController ()
//@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation EditPetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    self.title = @"Edit Profile";
    PCDataSource *pc = [PCDataSource sharedInstance];
    pc.editProfileVC = self;
    [[PCDataSource sharedInstance] retrievePets];
    self.petNameTextField.text = _pet.petName;
    self.dobTextField.text = _pet.petDOB;
    self.dodTextField.text = _pet.petDOD;
    self.animalTypeTextField.text = _pet.petType;
    self.animalBreedTextField.text = _pet.petBreed;
    self.animalPersonalityTextView.text = _pet.petPersonality;
    self.ownerNameTextField.text = _pet.ownerName;
    
    //TODO get current pet number
    self.petNumber = pc.petNumber;
    NSLog(@"pet number %ld", _petNumber);
   
    NSString *petProfileString = _pet.feedImageString;
    NSURL *petProfileUrl=[NSURL URLWithString:petProfileString];
    UIImage *savedProfileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:petProfileUrl]];
    
    [self.uploadProfilePhotoButton setBackgroundImage:savedProfileImage forState:UIControlStateNormal];
     self.uploadProfilePhotoButton.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) textViewDidBeginEditing:(UITextView *) textView {
    [textView setText:@""];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        //save text to Firebase
        
        
        return YES;
    }
    
    return YES;
}

//Enters Optional Pet Name
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    
   
    return YES;
}


//TODO MOVE TO MODEL
-(void)sendPersonalityToFirebase {
    //FIRUser *userAuth = [FIRAuth auth].currentUser;
    self.ref = [[FIRDatabase database] reference];
    
    NSDictionary *descriptionUpdates = @{[NSString stringWithFormat:@"/pets/%ld/personality/", _petNumber]:self.animalPersonalityTextView.text};
    [self.ref updateChildValues:descriptionUpdates];
    
    
}

-(void)sendPetNameToFirebase {
    
    self.ref = [[FIRDatabase database] reference];
    
    NSDictionary *screenNameUpdates = @{
        [NSString stringWithFormat:@"/pets/%ld/pet/", self.petNumber]:self.petNameTextField.text,
        [NSString stringWithFormat:@"/pets/%ld/breed/",self.petNumber]:self.animalBreedTextField.text,
        [NSString stringWithFormat:@"/pets/%ld/animalType/",self.petNumber]:self.animalTypeTextField.text,
        [NSString stringWithFormat:@"/pets/%ld/dateOfBirth/",self.petNumber]:self.dobTextField.text,
        [NSString stringWithFormat:@"/pets/%ld/dateOfDeath/",self.petNumber]:self.dodTextField.text,
        [NSString stringWithFormat:@"/pets/%ld/ownerName/",self.petNumber]:self.ownerNameTextField.text
                                        };
    [self.ref updateChildValues:screenNameUpdates];
    
}




#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     if([segue.identifier isEqualToString:@"editPhotosSegue"]) {
         EditPetPhotosTableViewController *editPhotosVC = (EditPetPhotosTableViewController*)segue.destinationViewController;
         NSLog(@"segue to album");
         
         
         editPhotosVC.pet = self.pet;
         //NSLog(@"vc  %@", editPhotosVC.pet);
         //NSLog(@"self.pet %@", self.pet.petName);
     }
 }

-(void)viewWillAppear:(BOOL)animated {
    self.animalBreedTextField.text = _pet.petBreed;
}


- (IBAction)saveEditedProfile:(id)sender {
    [self sendPetNameToFirebase];
    [self sendPersonalityToFirebase];
    NSLog(@"save everything at once");
}

@end
