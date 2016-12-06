//
//  EditPetProfileViewController.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/22/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "AddPetProfileViewController.h"
@class Pet;
@interface EditPetProfileViewController : AddPetProfileViewController
@property (nonatomic, strong) Pet *pet;
//@property (nonatomic) NSInteger petNumber;
@property (nonatomic, strong) NSString *petNumberString;


- (IBAction)saveEditedProfile:(id)sender;
- (IBAction)uploadProfilePhoto:(id)sender;

@end
