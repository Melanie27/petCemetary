//
//  PetProfileViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/14/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PCDataSource.h"
#import "PetProfileViewController.h"
#import "PetPhotosTableViewController.h"
#import "Pet.h"




@interface PetProfileViewController ()
    @property (nonatomic, strong)Pet *passThisPet;
    @property (nonatomic, strong)NSArray *photoAlbumImages;
@end

@implementation PetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pet Profile Page";
    PCDataSource *pc = [PCDataSource sharedInstance];
    pc.profileVC = self;
    
    
    // Do any additional setup after loading the view.
   
    self.animalNameLabel.text = _pet.petName;
    self.dateOfBirthLabel.text = _pet.petDOB;
    self.dateOfDeathLabel.text = _pet.petDOD;
    self.animalType.text = _pet.petType;
    self.personalityTextView.text = _pet.petPersonality;
    self.ownerNameLabel.text = _pet.ownerName;
    self.photoAlbumImages = _pet.albumImageStrings;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)viewMorePhotos:(id)sender {
    [self performSegueWithIdentifier:@"albumSegue" sender:self];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"albumSegue"]) {
        PetPhotosTableViewController *petPhotosTVC = (PetPhotosTableViewController*)segue.destinationViewController;
        petPhotosTVC.pet = self.pet;
        
        
    }
}



@end
