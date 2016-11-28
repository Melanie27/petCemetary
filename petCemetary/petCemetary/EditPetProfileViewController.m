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
@interface EditPetProfileViewController ()

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
    self.animalPersonalityTextField.text = _pet.petPersonality;
    self.ownerNameTextField.text = _pet.ownerName;
   
    NSString *petProfileString = _pet.feedImageString;
    NSURL *petProfileUrl=[NSURL URLWithString:petProfileString];
    UIImage *savedProfileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:petProfileUrl]];
    
    [self.uploadProfilePhotoButton setBackgroundImage:savedProfileImage forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     if([segue.identifier isEqualToString:@"editPhotosSegue"]) {
         EditPetPhotosTableViewController *editPhotosVC = (EditPetPhotosTableViewController*)segue.destinationViewController;
         NSLog(@"segue to album");
         
         
         editPhotosVC.pet = self.pet;
         NSLog(@"vc  %@", editPhotosVC.pet);
         NSLog(@"self.pet %@", self.pet.petName);
     }
 }

-(void)viewWillAppear:(BOOL)animated {
    self.animalBreedTextField.text = _pet.petBreed;
}

@end
