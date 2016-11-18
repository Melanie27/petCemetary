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
#import "Owner.h"

@import Firebase;
@import FirebaseDatabase;
@import FirebaseStorage;

@interface PetProfileViewController ()
    @property (strong, nonatomic) FIRDatabaseReference *ref;
    @property (nonatomic, strong)Pet *passThisPet;
    @property (nonatomic, strong)NSArray *photoAlbumImages;
@end

@implementation PetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pet Profile Page";
    PCDataSource *pc = [PCDataSource sharedInstance];
    pc.profileVC = self;
    [pc retrievePets];
    
    // Do any additional setup after loading the view.
   
    self.animalNameLabel.text = _pet.petName;
    self.dateOfBirthLabel.text = _pet.petDOB;
    self.dateOfDeathLabel.text = _pet.petDOD;
    self.animalType.text = _pet.petType;
    self.animalBreed.text = _pet.petBreed;
    self.personalityTextView.text = _pet.petPersonality;
    self.ownerNameLabel.text = _pet.ownerName;
    //self.photoAlbumImages = _pet.albumImageStrings;
    //self.treatCountLabel.text = _pet.treatsNumberString;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addTreat:(id)sender {
    NSLog(@"leaving treats");
    
    FIRUser *userAuth = [FIRAuth auth].currentUser;
    self.ref = [[FIRDatabase database] reference];
    
    FIRDatabaseQuery *treaterQuery = [[self.ref child:[NSString stringWithFormat:@"/pets/%ld/treater/", (long)self.petNumber ]] queryLimitedToFirst:1000];
    [treaterQuery observeSingleEventOfType:FIRDataEventTypeValue
                                       withBlock:^(FIRDataSnapshot *snapshot) {
        
        NSLog(@"snapshot treaters %@", snapshot.value);
        NSUInteger upvoteUIDCount = (unsigned long)snapshot.childrenCount;
        NSString *regEx = [NSString stringWithFormat:@"%@", userAuth.uid];
        BOOL exists = [snapshot.value objectForKey:regEx] != nil;
                                           
        if (exists == 0) {
        // Add Vote
                                               
        self.ref = [[FIRDatabase database] reference];
        FIRDatabaseQuery *petToTreatQuery = [[self.ref child:[NSString stringWithFormat:@"/pets/%ld/", (long)self.petNumber]] queryLimitedToFirst:1000];
                                               
            [petToTreatQuery observeSingleEventOfType:FIRDataEventTypeValue
                                    withBlock:^(FIRDataSnapshot *snapshot) {
                                    NSInteger retrievingUpvotesInt = upvoteUIDCount;
                                    NSInteger incrementUpvote = retrievingUpvotesInt + 1;
                                    NSNumber *theUpvotesNumber = @(incrementUpvote);
                                    NSDictionary *upvoteUpdates = @{
                                                                                                                     
                                    [NSString stringWithFormat:@"/questions/%ld/treats/", (long)self.petNumber]:theUpvotesNumber,
                                    [NSString stringWithFormat:@"/questions/%ld/treater/%@/", (long)self.petNumber, userAuth.uid]:@"yes"
                                                                                                                     
                                    };
                                                                                     
                                                                                     
                                    [_ref updateChildValues:upvoteUpdates ];
                                                                                     
                                    //[self.voteButton setTitle:@"downvote" forState:UIControlStateNormal];
                                    //[self.voteButton setNeedsLayout];
                                                                                     
            }];
                                               
                                               
        }
                                           
                                           
                                           
    }];
    
}

- (IBAction)viewMorePhotos:(id)sender {
    //UIButton *theButton = (UIButton *)sender;
    
    //PCDataSource *pc = [PCDataSource sharedInstance];
    //Pet *p;
    //p = pc.petAlbumPhotos[theButton.tag];
    //self.passThisPet = pc.petAlbumPhotos[theButton.tag];
    //pc.pet = self.passThisPet;
    [self performSegueWithIdentifier:@"albumSegue" sender:self];
    NSLog(@"this pet for album %@", self.passThisPet);
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"albumSegue"]) {
        PetPhotosTableViewController *petPhotosTVC = (PetPhotosTableViewController*)segue.destinationViewController;
        NSLog(@"segue to album");
        

        petPhotosTVC.pet = self.pet;
    }
}


@end
