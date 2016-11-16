//
//  PetPhotosTableViewController.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/15/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pet.h"
@class Pet;

@interface PetPhotosTableViewController : UITableViewController
    @property (nonatomic, strong) Pet *pet;
@end
