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
#import <Photos/Photos.h>
@import Firebase;
@import FirebaseDatabase;
@import FirebaseStorage;

@interface PCDataSource ()

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

- (NSUInteger) countOfPetsByOwner {
    return self.petsByOwner.count;
}

- (id) objectInPetsByOwnerAtIndex:(NSUInteger)index {
    return [self.petsByOwner objectAtIndex:index];
}

- (NSArray *) petsByOwnerAtIndexes:(NSIndexSet *)indexes {
    return [self.petsByOwner objectsAtIndexes:indexes];
}

- (void) insertObject:(Pet *)object inPetsByOwnerAtIndex:(NSUInteger)index {
    [_petsByOwner insertObject:object atIndex:index];
}


- (void) removeObjectFromPetsByOwnerAtIndex:(NSUInteger)index {
    [_petsByOwner removeObjectAtIndex:index];
}

- (void) replaceObjectInPetsByOwnerAtIndex:(NSUInteger)index withObject:(id)object {
    [_petsByOwner replaceObjectAtIndex:index withObject:object];
}

- (NSUInteger) countOfAlbumMedia {
    return self.albumMedia.count;
}

- (id) objectInAlbumMediaAtIndex:(NSUInteger)index {
    return [self.albumMedia objectAtIndex:index];
}

- (NSArray *) albumMediaAtIndexes:(NSIndexSet *)indexes {
    return [self.albumMedia objectsAtIndexes:indexes];
}

- (void) insertObject:(Pet *)object inAlbumMediaAtIndex:(NSUInteger)index {
    [_albumMedia insertObject:object atIndex:index];
}


- (void) removeObjectFromAlbumMediaAtIndex:(NSUInteger)index {
    [_albumMedia removeObjectAtIndex:index];
}

- (void) replaceObjectInAlbumMediaAtIndex:(NSUInteger)index withObject:(id)object {
    [_albumMedia replaceObjectAtIndex:index withObject:object];
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
         self.petsByOwner = [NSMutableArray new];
         self.albumMedia = [NSMutableArray new];
         self.albumMediaKeys = [NSMutableArray new];
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
            NSMutableDictionary *albumMedia = [elements valueForKey:@"photos"];
             
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

            pet.albumCaptionStrings = @[];
            pet.albumImageStrings = @[];
            for (id key in pet.albumMedia) {
                 id value = [pet.albumMedia objectForKey:key];
                 //NSLog(@"value from retrieve pets %@", value);
                 self.albumMediaValues = [[NSDictionary alloc] initWithDictionary:value];
                 pet.albumImageString = [ self.albumMediaValues valueForKey:@"photoUrl"];
                 pet.albumImageStrings = [pet.albumImageStrings arrayByAddingObject:pet.albumImageString];
                 pet.albumCaptionString = [ self.albumMediaValues valueForKey:@"caption"];
                 pet.albumCaptionStrings = [pet.albumCaptionStrings arrayByAddingObject:pet.albumCaptionString];
                
                
                
            }
            
            
             //TODO Introspection here incase there are no album photos
             //[self.albumMedia addObject:pet.albumMedia];
                          
             for (NSString *string in pet.albumImageStrings) {
                 pet.albumImageString = string;
                 FIRStorage *storage = [FIRStorage storage];
                 FIRStorageReference *httpsReference2 = [storage referenceForURL:pet.albumImageString];
                 
                 [httpsReference2 downloadURLWithCompletion:^(NSURL* URL, NSError* error){
                     
                     [self.pptVC.tableView reloadData];
                     
                 }];
             }

             
            NSString *petString = [NSString stringWithFormat:@"%@", pet.ownerUID];
            NSString *currentUserString = [NSString stringWithFormat:@"%@", currentUser.uid];
            if( [petString isEqualToString:currentUserString]) {
               

                [self.petsByOwner addObject:pet];

             }
             
             
             [self.petItems addObject:pet];
             
            
             if (pet.feedImageString == nil) {
                 NSLog(@"no feed image string");
             }
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


/*-(void)addNewFeedPhotoWithDictionary :(NSDictionary *)addPetPhoto {
    NSMutableDictionary *parameters = [addPetPhoto mutableCopy];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[parameters[@"petImageURL"]] options:nil];
    
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        
        [asset requestContentEditingInputWithOptions:kNilOptions
                                   completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
                                       NSURL *imageURL = contentEditingInput.fullSizeImageURL;
                                       NSString *localURLString = [imageURL path];
                                       NSString *theFileName = [[localURLString lastPathComponent] stringByDeletingPathExtension];
                                       
                                       FIRStorage *storage = [FIRStorage storage];
                                       FIRStorageReference *storageRef = [storage referenceForURL:@"gs://petcemetary-5fec2.appspot.com/petAlbums/"];
                                       FIRStorageReference *profileRef = [storageRef child:theFileName];
                                       
                                       
                                       [profileRef putFile:imageURL metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
                                           if (error != nil) {
                                               // Uh-oh, an error occurred!
                                               NSLog(@"error %@", error);
                                           } else {
                                               NSURL *downloadURL = metadata.downloadURL;
                                               NSString *downloadURLString = [ downloadURL absoluteString];
                                               //TODO - pass the variable back to AddpetProfileVC
                                               //self.downloadURLString = downloadURLString;
                                           }
                                       }];
                                       
                                   }];
    }];
    
   }*/

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

-(void)deleteAlbumPhotoWithDataDictionary:(NSDictionary *)photoInfo andPet:(NSObject*)petMedia{
    NSString *petIDString = [photoInfo valueForKey:@"petID"];
    NSString *photoIDString = [photoInfo valueForKey:@"photoID"];
    NSDictionary *childUpdates = @{
                                   [NSString stringWithFormat:@"/pets/%@/photos/%@", petIDString, photoIDString
                                    
                                    ]:[NSNull null]
                                   };
    
    
    
    [self.ref updateChildValues:childUpdates];
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"albumMedia"];
    
    //TODO not sure why this isn't working
    NSLog(@"pet we are working with %@", petMedia);
     NSLog(@"mutableArrayWithKVO %@", mutableArrayWithKVO);
    
    [mutableArrayWithKVO removeObject:petMedia];
    [self.pet.albumMedia removeObjectForKey:photoIDString];
    
}

-(void)deletePetWithDataDictionary:(NSDictionary *)petID andPet:(Pet*)pet {
    
    NSString *petIDString = [petID valueForKey:@"petID"];
    
     NSDictionary *childUpdates = @{
                                   [NSString stringWithFormat:@"/pets/%@/", petIDString
                                    
                                    ]:[NSNull null]
                                   };
   
    [self.ref updateChildValues:childUpdates];
    
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"petsByOwner"];
    
    [mutableArrayWithKVO removeObject:pet];
   
    [_petsByOwner removeObject:pet];
    
}


-(void)addNewPetWithDataDictionary:(NSDictionary *)addPetParameters andPet:(Pet*)pet {
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
    
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"petsByOwner"];
    [mutableArrayWithKVO addObject:pet];
    [_petsByOwner addObject:pet];
}


-(void)addImageWithDataDictionary:(NSDictionary *)parameters andPet:(NSObject*)petMedia {
    
    
    //NSString *key = [self.ref child:@"pets" ] queryEqualToValue:<#(nullable id)#> childKey:<#(nullable NSString *)#>];
    NSString *photoKey = [[self.ref child:@"photos"] childByAutoId].key;
    self.pet.photoID = photoKey;
    //NSLog(@"photo key? %@", photoKey);
    //NSLog(@"pet key? %@", key);
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
                                      
                                       
                                       [profileRef putFile:imageURL metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
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
    
    //NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"albumMedia"];
    
    //[mutableArrayWithKVO addObject:petMedia];
    //[_albumMedia addObject:petMedia];

}




    

@end
