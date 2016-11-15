//
//  PetProfileViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/14/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PCDataSource.h"
#import "PetProfileViewController.h"
#import "Pet.h"
#import "Owner.h"

@interface PetProfileViewController ()

@end

@implementation PetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pet Profile Page";
    // Do any additional setup after loading the view.
    //PCDataSource *pc = [PCDataSource sharedInstance];
    self.animalNameLabel.text = _pet.petName;
    self.dateOfBirthLabel.text = _pet.petDOB;
    self.dateOfDeathLabel.text = _pet.petDOD;
    self.animalType.text = _pet.petType;
    self.animalBreed.text = _pet.petBreed;
    self.personalityTextView.text = _pet.petPersonality;
    self.ownerNameLabel.text = _pet.ownerName;
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

@end
