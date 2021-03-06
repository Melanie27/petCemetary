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
@class AddPetProfilePhotoViewController;
@class Pet;



typedef void (^RetrivePhotoURLCompletionBlock)(NSString *downloadURLString);


@interface PCDataSource : NSObject

@property (strong, nonatomic) FIRDatabaseReference *ref;
//singleton to access call [PCDataSource sharedInstance]

+(instancetype) sharedInstance;
@property (nonatomic, strong) NSMutableArray<Pet *> *petItems;
@property (nonatomic, strong) NSMutableArray<Pet *> *petsByOwner;
@property (nonatomic, strong) NSMutableDictionary *albumMedia;
@property (nonatomic, strong) NSMutableArray *albumMediaKeys;




@property (nonatomic, strong) Pet *pet;
@property (nonatomic, weak) PetsFeedTableViewController *pftVC;
@property (nonatomic, weak) PetPhotosTableViewController *pptVC;
@property (nonatomic, weak) PetProfileViewController *profileVC;
@property (nonatomic, weak) PetListTableViewController *pltVC;
@property (nonatomic, weak) EditPetProfileViewController *editProfileVC;
@property (nonatomic, weak) EditPetPhotosTableViewController *editPhotosVC;
@property (nonatomic, weak) AddPetProfilePhotoViewController *appVC;
//Properties for saving and editing
@property (nonatomic, strong) NSString *addPetName;
@property (nonatomic, strong) NSString *addPetType;
@property (nonatomic, strong) NSString *addPetDOB;
@property (nonatomic, strong) NSString *addPetDOD;
@property (nonatomic, strong) NSString *addOwnerName;
@property (nonatomic, strong) NSString *addPersonality;



-(NSString *)retrievePets;
-(void)deletePetWithDataDictionary:(NSDictionary *)petID andPet:(Pet*)pet;
-(void)addNewPetWithDataDictionary:(NSMutableDictionary *)addPetParameters andPet:(Pet*)pet;



-(void)deleteAlbumPhotoWithDataDictionary:(NSDictionary *)photoInfo andPet:(NSObject*)petMedia;
-(void)editPetWithDataDictionary:(NSMutableDictionary *)editPetParameters;
-(void)addNewFeedPhotoWithStorageRefURL:(NSString*)refURL andUploadDataSelectedImage:(UIImage *)selectedImage andCompletion:(RetrivePhotoURLCompletionBlock)completion;
-(void)addImageWithDataDictionary:(NSDictionary*)parameters andPet:(NSObject*)petMedia;

@end
