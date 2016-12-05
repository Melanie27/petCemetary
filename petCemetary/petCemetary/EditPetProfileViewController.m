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

@interface EditPetProfileViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate>
//@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation EditPetProfileViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PCDataSource sharedInstance]retrievePets];
    NSArray *petsArray = [PCDataSource sharedInstance].petItems;
    NSUInteger index;
    /*for (Pet *pet in petsArray) {
        index = [petsArray indexOfObject:pet];
        self.petNumber = index;
        //NSLog(@"petindex %lu", (unsigned long)index);
        //NSLog(@" addpet %ld", pet.petNumber);
        pet.petNumber = self.petNumber;
    }*/
    //NSLog(@"melpets addpet %ld", self.petNumber);
    // Do any additional setup after loading the view.
    self.title = @"Edit Profile";
    PCDataSource *pc = [PCDataSource sharedInstance];
    pc.editProfileVC = self;
    //[[PCDataSource sharedInstance] retrievePets];
    self.petNameTextField.text = _pet.petName;
    self.dobTextField.text = _pet.petDOB;
    self.dodTextField.text = _pet.petDOD;
    self.animalTypeTextField.text = _pet.petType;
    self.animalBreedTextField.text = _pet.petBreed;
    self.animalPersonalityTextView.text = _pet.petPersonality;
    self.ownerNameTextField.text = _pet.ownerName;
    
   
    //NSLog(@"pet.petName %@", _pet.petName);
    //NSLog(@"pet.petNumber %lu", _pet.petNumber);
    //self.petNumber = _pet.petNumber;
    //NSLog(@"pet.petNumber take 2 %lu", self.petNumber);
   
    self.petNumber = pc.petNumber;
    NSLog(@"pet number from edit %ld", self.petNumber);
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        //save text to Firebase
        
        
        return YES;
    }
    
    return YES;
}




//TODO MOVE TO MODEL
-(void)sendPersonalityToFirebase {
    //FIRUser *userAuth = [FIRAuth auth].currentUser;
    self.ref = [[FIRDatabase database] reference];
    
    NSDictionary *descriptionUpdates = @{[NSString stringWithFormat:@"/pets/%ld/personality/", self.petNumber]:self.animalPersonalityTextView.text};
    [self.ref updateChildValues:descriptionUpdates];
    
    
}

-(void)sendPetInfoToFirebase {
    //[[PCDataSource sharedInstance] editPetInfo];
    
    self.ref = [[FIRDatabase database] reference];
    
    NSDictionary *screenNameUpdates = @{
        [NSString stringWithFormat:@"/pets/5/pet/"]:self.petNameTextField.text,
        [NSString stringWithFormat:@"/pets/5/breed/"]:self.animalBreedTextField.text,
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
         
         
         
         editPhotosVC.pet = self.pet;
         
     }
 }

-(void)viewWillAppear:(BOOL)animated {
    self.animalBreedTextField.text = _pet.petBreed;
}


- (IBAction)saveEditedProfile:(id)sender {
     NSLog(@"save everything at once edit");
    [self sendPetInfoToFirebase];
    [self sendPersonalityToFirebase];
   
}

@end
