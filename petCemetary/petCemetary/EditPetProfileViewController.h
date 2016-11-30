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
@property (nonatomic) NSInteger petNumber;



- (IBAction)saveEditedProfile:(id)sender;


@end
