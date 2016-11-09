//
//  PetsFeedTableViewController.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/9/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pet.h"

@interface PetsFeedTableViewController : UITableViewController<UIAlertViewDelegate>


@property (strong, nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic)NSFetchedResultsController *fetchedResultsController;

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
