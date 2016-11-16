//
//  PetProfileViewController.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/14/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Pet;

@interface PetProfileViewController : UIViewController
@property (nonatomic, strong) Pet *pet;
@property (nonatomic, assign) NSInteger petNumber;

@property (strong, nonatomic) IBOutlet UIButton *morePhotosButton;
@property (strong, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateOfDeathLabel;

@property (strong, nonatomic) IBOutlet UITextView *personalityTextView;

@property (strong, nonatomic) IBOutlet UILabel *animalNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *animalType;
@property (strong, nonatomic) IBOutlet UILabel *animalBreed;

@property (strong, nonatomic) IBOutlet UILabel *ownerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *treatCountLabel;

- (IBAction)addTreat:(id)sender;

- (IBAction)viewMorePhotos:(id)sender;

@end
