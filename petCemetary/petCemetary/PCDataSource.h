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
@import FirebaseAuth;

@class PetsFeedTableViewController;
@class PetsFeedTableViewCell;
@class PetPhotosTableViewController;
@class PetProfileViewController;
@class PetListTableViewController;
@class EditPetProfileViewController;
@class EditPetPhotosTableViewController;
@class Pet;
@class Owner;

typedef void(^PetRetrievalCompletionBlock)(Pet *pet);
typedef void (^NewPetCompletionBlock)(NSError *error);
typedef void(^DeletionCompletionBlock)(NSDictionary *snapshotValue);
@interface PCDataSource : NSObject

@property (strong, nonatomic) FIRDatabaseReference *ref;
//singleton to access call [PCDataSource sharedInstance]

+(instancetype) sharedInstance;
@property (nonatomic, strong, readonly) NSArray *petItems;
@property (nonatomic, strong, readonly) NSArray *petsByOwner;
@property (nonatomic, strong, readonly) NSArray<Pet*> *petAlbumItems;
@property (nonatomic, strong) NSMutableArray *albumPhotos;


//@property (nonatomic, strong, readonly) NSArray<Pet *> *pets;
@property (nonatomic, strong) Pet *pet;
@property (nonatomic, assign) NSInteger petNumber;
@property (nonatomic, weak) PetsFeedTableViewController *pftVC;
@property (nonatomic, weak) PetPhotosTableViewController *pptVC;
@property (nonatomic, weak) PetProfileViewController *profileVC;
@property (nonatomic, weak) PetListTableViewController *pltVC;
@property (nonatomic, weak) EditPetProfileViewController *editProfileVC;
@property (nonatomic, weak) EditPetPhotosTableViewController *editPhotosVC;

-(NSString *)retrievePets;
-(void)deleteAlbumPhoto:(NSObject *)albumPhoto;
-(void)deletePet:(Pet*)pet andCompletion:(DeletionCompletionBlock)completion;
//-(void)addNewPet;
//-(void)retrievePetWithUID:(NSString *)uid andCompletion:(PetRetrievalCompletionBlock)completion;





//handle the situation when new pets are posted
- (void) requestNewPetsWithCompletionHandler:(NewPetCompletionBlock)completionHandler;
//infinite scrolling
 - (void) requestOldPetsWithCompletionHandler:(NewPetCompletionBlock)completionHandler;
@end
