//
//  EditPetProfileViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/22/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "EditPetProfileViewController.h"
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
    //self.ownerNameTextField.text = _pet.ownerName;
    _pet.ownerName = self.ownerNameTextField.text;
    NSLog(@"pet name  on edit %@", _pet.petName);
    NSLog(@"pet name  on edit %@", _pet.petDOB);
    NSLog(@"pet name  on edit %@", _pet.petPersonality);
    NSString *petProfileString = _pet.feedImageString;
    NSURL *petProfileUrl=[NSURL URLWithString:petProfileString];
    UIImage *savedProfileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:petProfileUrl]];
    
    [self.uploadProfilePhotoButton setBackgroundImage:savedProfileImage forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated {
    self.animalBreedTextField.text = _pet.petBreed;
}

@end
