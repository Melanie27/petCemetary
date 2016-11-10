//
//  AppDelegate.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/9/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PetsFeedTableViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic)NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic)NSManagedObjectModel *managedObjectModel;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic, strong) PetsFeedTableViewController *pftVC;
@property(nonatomic, strong) UINavigationController *navigationController;

- (void)saveContext;


@end

