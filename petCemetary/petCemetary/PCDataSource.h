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


typedef void (^NewPetCompletionBlock)(NSError *error);


@interface PCDataSource : NSObject

@property (strong, nonatomic) FIRDatabaseReference *ref;
//singleton to access call [PCDataSource sharedInstance]

+(instancetype) sharedInstance;
@property (nonatomic, strong) NSMutableArray<Pet *> *petItems;
@property (nonatomic, strong) NSMutableArray<Pet *> *petsByOwner;
@property (nonatomic, strong, readonly) NSArray *petMedia;
@property (nonatomic, strong, readonly) NSArray *petAlbumItems;

@property (nonatomic, strong, readonly) NSArray *albumMedia;



//@property (nonatomic, strong) NSArray<Pet *> *pets;
@property (nonatomic, strong) Pet *pet;
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



-(NSString *)retrievePets;


-(void)deleteAlbumPhotoWithDataDictionary:(NSDictionary *)photoInfo;
-(void)deletePetWithDataDictionary:(NSDictionary *)petID andPet:(Pet*)pet;


-(void)addNewPetWithDataDictionary:(NSMutableDictionary *)addPetParameters andPet:(Pet*)pet;
-(void)editPetWithDataDictionary:(NSMutableDictionary *)editPetParameters;
-(void)addNewFeedPhotoWithDictionary :(NSDictionary *)addPetPhoto;
-(void)addImageWithDataDictionary:(NSDictionary*)parameters;






@end
