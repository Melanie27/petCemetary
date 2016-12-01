//
//  PetListTableViewController.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/21/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Pet;

@protocol PetListTableViewControllerDelegate <NSObject>
//-(void)deleteItemViewController:(PetListTableViewController *)controller didFinishDeletingItem:(Pet *)pet;
@end

@interface PetListTableViewController : UITableViewController
@property (nonatomic, strong) Pet *pet;
@property (nonatomic, strong) NSString *ownerUID;
@property (nonatomic, strong) Pet *deletedPet;
@property (nonatomic) NSInteger petNumber;

@property (nonatomic, weak) id <PetListTableViewControllerDelegate> delegate;

@end
