//
//  PCDataSource.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/11/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PCDataSource.h"
#import "PetsFeedTableViewController.h"
#import "PetPhotosTableViewController.h"
#import "PetListTableViewController.h"
#import "Pet.h"
#import "Owner.h"
#import <Photos/Photos.h>
@import Firebase;
@import FirebaseDatabase;
@import FirebaseStorage;

@interface PCDataSource ()

    
    @property (nonatomic, strong) NSArray *petMedia;
    @property (nonatomic, strong) NSArray *petAlbumItems;
    @property (nonatomic, strong) NSArray *albumPhotos;
    //@property (nonatomic, strong) NSArray *albumImageList;
    @property (nonatomic, strong) NSDictionary *albumMediaValues;


@end

@implementation PCDataSource

+(instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(instancetype) init {
    self = [super init];
    
    if (self) {
    
        [self retrievePets];
    }
    
    return self;
}
#pragma mark - Key/Value Observing

- (NSUInteger) countOfPetItems {
    return self.petItems.count;
}

- (id) objectInPetItemsAtIndex:(NSUInteger)index {
    return [self.petItems objectAtIndex:index];
}

- (NSArray *) petItemsAtIndexes:(NSIndexSet *)indexes {
    return [self.petItems objectsAtIndexes:indexes];
}

- (void) insertObject:(Pet *)object inPetItemsAtIndex:(NSUInteger)index {
    [_petItems insertObject:object atIndex:index];
}


- (void) removeObjectFromPetItemsAtIndex:(NSUInteger)index {
    [_petItems removeObjectAtIndex:index];
}

- (void) replaceObjectInPetItemsAtIndex:(NSUInteger)index withObject:(id)object {
    [_petItems replaceObjectAtIndex:index withObject:object];
}


-(NSString *)retrievePets {
    
    self.ref = [[FIRDatabase database] reference];
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    FIRDatabaseQuery *getPetQuery = [[self.ref queryOrderedByChild:@"/pets/"]queryLimitedToFirst:1000];
    NSMutableString *retrievedPets = [[NSMutableString alloc] init];
    
    [getPetQuery
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
         //NSString *keyPetName = [[self.ref child:@"pet"] childByAutoId].key;
         NSDictionary *allPets = snapshot.value[@"pets"];
         self.petItems =  [NSMutableArray new];
         self.albumPhotos = @[];
         self.petsByOwner = @[];
         self.petAlbumItems = @[];
         
         for (NSString *keyPath in allPets) {
            Pet *pet = [[Pet alloc] init];

            NSDictionary *elements = [allPets valueForKey:keyPath];
            NSString *animalName = [elements valueForKey:@"pet"];
            NSString *animalType = [elements valueForKey:@"animalType"];
            NSString *animalDob = [elements valueForKey:@"dateOfBirth"];
            NSString *animalDod = [elements valueForKey:@"dateOfDeath"];
            NSString *animalBreed = [elements valueForKey:@"animalBreed"];
            NSString *animalPersonality = [elements valueForKey:@"personality"];
            NSString *ownerUID = [elements valueForKey:@"UID"];
            NSString *ownerName = [elements valueForKey:@"ownerName"];
            NSString *feedImageString = [elements valueForKey:@"feedPhoto"];
            NSDictionary *albumMedia = [elements valueForKey:@"photos"];
             
            pet.petID =  keyPath;
            pet.petName = animalName;
            pet.petType = animalType;
            pet.petDOB = animalDob;
            pet.petDOD = animalDod;
            pet.petBreed = animalBreed;
            pet.petPersonality = animalPersonality;
            pet.ownerUID = ownerUID;
            pet.ownerName = ownerName;
            pet.feedImageString = feedImageString;
            pet.albumMedia = albumMedia;
             
            
             
             
            self.petAlbumItems = [self.petAlbumItems arrayByAddingObject:pet];
            self.albumPhotos = [self.albumPhotos arrayByAddingObject:pet];
             
             
            pet.albumCaptionStrings = @[];
            pet.albumImageStrings = @[];
            for (id key in pet.albumMedia) {
                 id value = [pet.albumMedia objectForKey:key];
                 NSLog(@"value %@", value);
                 self.albumMediaValues = [[NSDictionary alloc] initWithDictionary:value];
                 pet.albumImageString = [ self.albumMediaValues valueForKey:@"photoUrl"];
                 pet.albumImageStrings = [pet.albumImageStrings arrayByAddingObject:pet.albumImageString];
                 pet.albumCaptionString = [ self.albumMediaValues valueForKey:@"caption"];
                 pet.albumCaptionStrings = [pet.albumCaptionStrings arrayByAddingObject:pet.albumCaptionString];
                 
                 
                 self.albumPhotos = [self.albumPhotos arrayByAddingObject:pet];

                 
            }
             
            
            NSString *petString = [NSString stringWithFormat:@"%@", pet.ownerUID];
            NSString *currentUserString = [NSString stringWithFormat:@"%@", currentUser.uid];
            if( [petString isEqualToString:currentUserString]) {
                Pet *pet = [[Pet alloc] init];
                pet.petID =  keyPath;
                pet.petName = animalName;
                pet.petType = animalType;
                pet.petDOB = animalDob;
                pet.petDOD = animalDod;
                pet.petBreed = animalBreed;
                pet.petPersonality = animalPersonality;
                pet.ownerUID = ownerUID;
                pet.ownerName = ownerName;
                pet.feedImageString = feedImageString;
                pet.albumMedia = albumMedia;

                self.petsByOwner = [self.petsByOwner arrayByAddingObject:pet];
                pet.albumCaptionStrings = @[];
                pet.albumImageStrings = @[];
                for (id key in pet.albumMedia) {
                    id value = [pet.albumMedia objectForKey:key];
                    NSLog(@"value %@", value);
                    self.albumMediaValues = [[NSDictionary alloc] initWithDictionary:value];
                    pet.albumImageString = [ self.albumMediaValues valueForKey:@"photoUrl"];
                    pet.albumImageStrings = [pet.albumImageStrings arrayByAddingObject:pet.albumImageString];
                    pet.albumCaptionString = [ self.albumMediaValues valueForKey:@"caption"];
                    pet.albumCaptionStrings = [pet.albumCaptionStrings arrayByAddingObject:pet.albumCaptionString];
                    self.albumPhotos = [self.albumPhotos arrayByAddingObject:pet];
                    
                }

                for (NSString *string in pet.albumImageStrings) {
                    pet.albumImageString = string;
                    if (!(pet.albumImageString == nil)) {
                        FIRStorage *storage = [FIRStorage storage];
                        FIRStorageReference *httpsReference3 = [storage referenceForURL:pet.albumImageString];
                        [httpsReference3 downloadURLWithCompletion:^(NSURL* URL, NSError* error){
                            if (error != nil) {
                                NSLog(@"download url error");
                            } else {
                                [self.pltVC.tableView reloadData];
                            }
                        }];
                     }
                 }
             }
             
             for (NSString *string in pet.albumImageStrings) {
                 pet.albumImageString = string;
                 FIRStorage *storage = [FIRStorage storage];
                 FIRStorageReference *httpsReference2 = [storage referenceForURL:pet.albumImageString];
                 
                 [httpsReference2 downloadURLWithCompletion:^(NSURL* URL, NSError* error){
                     
                     [self.pptVC.tableView reloadData];
                     
                 }];
             }
              [self.petItems addObject:pet];
            
            
            if ([snapshot.value isKindOfClass:[NSDictionary class]] && (snapshot.value)) {
                 
                FIRStorage *storage = [FIRStorage storage];
                FIRStorageReference *httpsReference = [storage referenceForURL:pet.feedImageString];
                [httpsReference downloadURLWithCompletion:^(NSURL* URL, NSError* error){
                     
                    [self.pftVC.tableView reloadData];
                     
                }];
             }
         }
     }];
    
    
    return retrievedPets;
    
}

/*- (NSArray *)reversedArray {
    NSMutableArray *petItemsReversed = [NSMutableArray arrayWithCapacity:[_petItems count]];
    NSEnumerator *enumerator = [_petItems reverseObjectEnumerator];
    for (id element in enumerator) {
        [petItemsReversed addObject:element];
    }
    return petItemsReversed;
}*/

-(void)addNewFeedPhotoWithDictionary :(NSDictionary *)addPetPhoto {
    //TODO should be able to post to current pet so doesnt interfere with adding info
    NSString *key = [[self.ref child:@"pets"] childByAutoId].key;
    NSMutableDictionary *params = [addPetPhoto mutableCopy];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[params[@"petImageURL"]] options:nil];
    
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        
        [asset requestContentEditingInputWithOptions:kNilOptions
                                   completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
                                       NSURL *imageURL = contentEditingInput.fullSizeImageURL;
                                       NSString *localURLString = [imageURL path];
                                       NSString *theFileName = [[localURLString lastPathComponent] stringByDeletingPathExtension];
                                       
                                       
                                       FIRStorage *storage = [FIRStorage storage];
                                       FIRStorageReference *storageRef = [storage referenceForURL:@"gs://petcemetary-5fec2.appspot.com/petFeed/"];
                                       FIRStorageReference *profileRef = [storageRef child:theFileName];
                                       NSLog(@"profileRef %@", profileRef);
                                       FIRStorageUploadTask *uploadTask = [profileRef putFile:imageURL metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
                                           if (error != nil) {
                                               // Uh-oh, an error occurred!
                                               NSLog(@"error %@", error);
                                           } else {
                                               NSURL *downloadURL = metadata.downloadURL;
                                               NSString *downloadURLString = [ downloadURL absoluteString];

                                               NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/pets/%@/feedPhoto/", key]:downloadURLString};
                                               
                                               [self.ref updateChildValues:childUpdates];
                                           }
                                       }];
                                   }];
    }];
    
   }

-(void)editPetWithDataDictionary:(NSDictionary *)editPetParameters {
   //NSString *petPhotoString = [editPetParameters valueForKey:@"petPhoto"];
    NSString *petIDString = [editPetParameters valueForKey:@"petID"];
    NSString *petNameString = [editPetParameters valueForKey:@"petName"];
    NSString *petTypeString = [editPetParameters valueForKey:@"petType"];
    NSString *petBreedString = [editPetParameters valueForKey:@"petBreed"];
    NSString *petDobString = [editPetParameters valueForKey:@"dob"];
    NSString *petDodString = [editPetParameters valueForKey:@"dod"];
    NSString *petPersonalityString = [editPetParameters valueForKey:@"personality"];
    NSString *petOwnerString = [editPetParameters valueForKey:@"ownerName"];
    
    NSDictionary *petInfoEdits = @{
                                      [NSString stringWithFormat:@"/pets/%@/pet", petIDString]:petNameString,
                                      [NSString stringWithFormat:@"/pets/%@/animalType", petIDString]:petTypeString,
                                      [NSString stringWithFormat:@"/pets/%@/breed", petIDString]:petBreedString,
                                      [NSString stringWithFormat:@"/pets/%@/dateOfBirth", petIDString]:petDobString,
                                      [NSString stringWithFormat:@"/pets/%@/dateOfDeath", petIDString]:petDodString,
                                      [NSString stringWithFormat:@"/pets/%@/personality", petIDString]:petPersonalityString,
                                      [NSString stringWithFormat:@"/pets/%@/ownerName", petIDString]:petOwnerString
                                      
                                      };
    
    
    [self.ref updateChildValues:petInfoEdits];
}

-(void)deleteAlbumPhotoWithDataDictionary:(NSDictionary *)photoInfo {
    NSString *petIDString = [photoInfo valueForKey:@"petID"];
    NSString *photoIDString = [photoInfo valueForKey:@"photoID"];
    NSDictionary *childUpdates = @{
                                   [NSString stringWithFormat:@"/pets/%@/photos/%@", petIDString, photoIDString
                                    
                                    ]:[NSNull null]
                                   };
    
    
    
    [self.ref updateChildValues:childUpdates];
    
}

-(void)deletePetWithDataDictionary:(NSDictionary *)petID andPet:(Pet*)pet {
    
    NSString *petIDString = [petID valueForKey:@"petID"];
    NSLog(@"petIDString %@", petIDString);
     NSDictionary *childUpdates = @{
                                   [NSString stringWithFormat:@"/pets/%@/", petIDString
                                    
                                    ]:[NSNull null]
                                   };
    NSLog(@"child updates %@", childUpdates);
    [self.ref updateChildValues:childUpdates];
    
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"petItems"];
    [mutableArrayWithKVO removeObject:pet];
    NSLog(@"mutable array with KVO %@", mutableArrayWithKVO);
    [_petItems removeObject:pet];
    
}


-(void)addNewPetWithDataDictionary:(NSDictionary *)addPetParameters {
    NSString *key = [[self.ref child:@"pets"] childByAutoId].key;
    //NSString *key = [addPetParameters valueForKey:@"petID"];
    
    NSString *petNameString = [addPetParameters valueForKey:@"petName"];
    NSString *petTypeString = [addPetParameters valueForKey:@"petType"];
    NSString *petBreedString = [addPetParameters valueForKey:@"petBreed"];
    NSString *petDobString = [addPetParameters valueForKey:@"dob"];
    NSString *petDodString = [addPetParameters valueForKey:@"dod"];
    NSString *petPersonalityString = [addPetParameters valueForKey:@"personality"];
    NSString *petOwnerString = [addPetParameters valueForKey:@"ownerName"];
    NSString *petPlaceholderImageString = [addPetParameters valueForKey:@"placeholderImage"];
    FIRUser *userAuth = [FIRAuth auth].currentUser;
    NSDictionary *petInfoCreation = @{
                                      [NSString stringWithFormat:@"/pets/%@/pet",key]:petNameString,
                                      [NSString stringWithFormat:@"/pets/%@/animalType",key]:petTypeString,
                                      [NSString stringWithFormat:@"/pets/%@/breed",key]:petBreedString,
                                      [NSString stringWithFormat:@"/pets/%@/dateOfBirth",key]:petDobString,
                                      [NSString stringWithFormat:@"/pets/%@/dateOfDeath",key]:petDodString,
                                       [NSString stringWithFormat:@"/pets/%@/personality",key]:petPersonalityString,
                                       [NSString stringWithFormat:@"/pets/%@/ownerName",key]:petOwnerString,
                                       [NSString stringWithFormat:@"/pets/%@/UID/", key]:userAuth.uid,
                                      [NSString stringWithFormat:@"/pets/%@/feedPhoto/", key]:petPlaceholderImageString
                                      };
                                       
    
    [self.ref updateChildValues:petInfoCreation];
}


-(void)addImageWithDataDictionary:(NSDictionary *)parameters  {
    
    NSString *photoKey = [[self.ref child:@"photos"] childByAutoId].key;
    self.pet.photoID = photoKey;
    //NSLog(@"photo key? %@", photoKey);
    NSAssert(self.ref != nil, @"self.ref should be defined by now");
    NSMutableDictionary *params = [parameters mutableCopy];
    NSString *captionString = [parameters valueForKey:@"photoCaption"];
    NSString *petIDString = [parameters valueForKey:@"petID"];
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[params[@"petImageURL"]] options:nil];
    
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        
        [asset requestContentEditingInputWithOptions:kNilOptions
                                   completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
                                       NSURL *imageURL = contentEditingInput.fullSizeImageURL;
                                       NSString *localURLString = [imageURL path];
                                       NSString *theFileName = [[localURLString lastPathComponent] stringByDeletingPathExtension];
                                       
                                       FIRStorage *storage = [FIRStorage storage];
                                       FIRStorageReference *storageRef = [storage referenceForURL:@"gs://petcemetary-5fec2.appspot.com/petAlbums/"];
                                       FIRStorageReference *profileRef = [storageRef child:theFileName];
                                      
                                       FIRStorageUploadTask *uploadTask = [profileRef putFile:imageURL metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
                                           if (error != nil) {
                                               // Uh-oh, an error occurred!
                                               NSLog(@"error %@", error);
                                           } else {
                                               NSURL *downloadURL = metadata.downloadURL;
                                               NSString *downloadURLString = [ downloadURL absoluteString];
          
                        NSDictionary *childUpdates = @{
                                [NSString stringWithFormat:@"/pets/%@/photos/%@/photoUrl/", petIDString, photoKey]:downloadURLString,
                                [NSString stringWithFormat:@"/pets/%@/photos/%@/caption/", petIDString, photoKey]:captionString,
                        };
                                               
                        [self.ref updateChildValues:childUpdates];
                       
                    }
                }];
                                        
        }];
    }];

}




    

@end
