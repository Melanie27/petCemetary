//
//  PetProfileViewController.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/14/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PetProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *morePhotosButton;
@property (strong, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateOfDeathLabel;

@property (strong, nonatomic) IBOutlet UITextView *personalityTextView;




@property (strong, nonatomic) IBOutlet UILabel *animalType;
@property (strong, nonatomic) IBOutlet UILabel *animalBreed;

@property (strong, nonatomic) IBOutlet UILabel *ownerNameLabel;

@end
