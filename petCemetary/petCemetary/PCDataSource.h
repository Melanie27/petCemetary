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
#import "EditPetProfileViewController.h"

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
typedef void(^ImagePickerCompletionBlock)(NSDictionary *info);

@interface PCDataSource : NSObject

@property (strong, nonatomic) FIRDatabaseReference *ref;
//singleton to access call [PCDataSource sharedInstance]

+(instancetype) sharedInstance;
@property (nonatomic, strong, readonly) NSArray<Pet *> *petItems;
@property (nonatomic, strong, readonly) NSArray *petsByOwner;
@property (nonatomic, strong, readonly) NSArray *petMedia;
@property (nonatomic, strong, readonly) NSArray *petAlbumItems;
@property (nonatomic, strong, readonly) NSArray *albumPhotos;
@property (nonatomic, strong, readonly) NSArray *albumMedia;



@property (nonatomic, strong, readonly) NSArray<Pet *> *pets;
@property (nonatomic, strong) Pet *pet;
//@property (atomic, strong) Pet* currentPet;
@property (nonatomic, assign) NSInteger petNumber;
@property (nonatomic, weak) PetsFeedTableViewController *pftVC;
@property (nonatomic, weak) PetPhotosTableViewController *pptVC;
@property (nonatomic, weak) PetProfileViewController *profileVC;
@property (nonatomic, weak) PetListTableViewController *pltVC;
@property (nonatomic, weak) EditPetProfileViewController *editProfileVC;
@property (nonatomic, weak) EditPetPhotosTableViewController *editPhotosVC;

//Properties for saving and editing
@property (nonatomic, strong) NSString *addPetName;
@property (nonatomic, strong) NSString *addPetType;
@property (nonatomic, strong) NSString *addPetBreed;
@property (nonatomic, strong) NSString *addPetDOB;
@property (nonatomic, strong) NSString *addPetDOD;
@property (nonatomic, strong) NSString *addOwnerName;
@property (nonatomic, strong) NSString *addPersonality;
@property (nonatomic) NSInteger addPetNumber;
@property (strong) UIImage *addPetImage;

-(NSString *)retrievePets;


-(void)deleteAlbumPhoto:(NSObject *)albumPhoto;
-(void)deletePet:(Pet*)pet andCompletion:(DeletionCompletionBlock)completion;


-(void)addNewPetWithDataDictionary:(NSMutableDictionary *)addPetParameters;
-(void)editPetWithDataDictionary:(NSMutableDictionary *)editPetParameters;
-(void)addNewFeedPhotoWithDictionary :(NSDictionary *)addPetPhoto;
-(void)addImageWithDataDictionary:(NSDictionary*)parameters toCurrentPet:(Pet*)pet;





//handle the situation when new pets are posted
- (void) requestNewPetsWithCompletionHandler:(NewPetCompletionBlock)completionHandler;
//infinite scrolling
 - (void) requestOldPetsWithCompletionHandler:(NewPetCompletionBlock)completionHandler;
@end
