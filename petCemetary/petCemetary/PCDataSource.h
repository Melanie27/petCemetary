//
//  PCDataSource.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/11/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@import FirebaseDatabase;
@import FirebaseStorage;

@class PetsFeedTableViewController;
@class PetsFeedTableViewCell;
@class Pet;
@class Owner;


@interface PCDataSource : NSObject

@property (strong, nonatomic) FIRDatabaseReference *ref;
//singleton to access call [PCDataSource sharedInstance]

+(instancetype) sharedInstance;
@property (nonatomic, strong, readonly) NSArray *petItems;
@property (nonatomic, strong, readonly) NSArray *pets;


//@property (nonatomic, strong, readonly) NSArray<Pet *> *pets;
@property (nonatomic, strong) Pet *pet;
@property (nonatomic, assign) NSInteger petNumber;
@property (nonatomic, weak) PetsFeedTableViewController *pftVC;

-(NSString *)retrievePets;
@end