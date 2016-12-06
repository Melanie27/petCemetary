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
    
    @property (nonatomic, strong) NSArray *petItems;
    @property (nonatomic, strong) NSArray *petMedia;
    @property (nonatomic, strong) NSArray *petsByOwner;
    @property (nonatomic, strong) NSArray *albumPhotos;
@property (nonatomic, strong) NSString *petNumberString;
    @property (nonatomic, assign) BOOL isRefreshing;
    @property (nonatomic, assign) BOOL isLoadingOlderItems;
 @property (nonatomic, assign) NSInteger petByNumber;


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

-(void)saveFeedPhoto {
    
}

-(void)editPetInfo {
    self.ref = [[FIRDatabase database] reference];
    /*NSDictionary *screenNameUpdates = @{
                                    [NSString stringWithFormat:@"/pets/%ld/pet/", self.petNumber]:self.petNameTextField.text,
                                        [NSString stringWithFormat:@"/pets/%ld/breed/",self.petNumber]:self.animalBreedTextField.text,
                                        [NSString stringWithFormat:@"/pets/%ld/animalType/",self.petNumber]:self.animalTypeTextField.text,
                                        [NSString stringWithFormat:@"/pets/%ld/dateOfBirth/",self.petNumber]:self.dobTextField.text,
                                        [NSString stringWithFormat:@"/pets/%ld/dateOfDeath/",self.petNumber]:self.dodTextField.text,
                                        [NSString stringWithFormat:@"/pets/%ld/ownerName/",self.petNumber]:self.ownerNameTextField.text
                                        };*/
    //[self.ref updateChildValues:screenNameUpdates];
}

-(NSString *)retrievePets {
    
    self.ref = [[FIRDatabase database] reference];
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    FIRDatabaseQuery *getPetQuery = [[self.ref queryOrderedByChild:@"/pets/"]queryLimitedToFirst:1000];
    NSMutableString *retrievedPets = [[NSMutableString alloc] init];
    
    [getPetQuery
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
         //init the array
         
         //TODO - what if someone deletes a pet how to prevent increment holes? 
         self.petItems = @[];
         //test if this exists
         self.albumPhotos = @[];
         self.petsByOwner = @[];
         
         NSInteger numPets = [snapshot.value[@"pets"] count];
         for (NSInteger i = 0; i < numPets; i++) {
             Pet *pet = [[Pet alloc] init];
             
             pet.petName = snapshot.value[@"pets"][i][@"pet"];
             pet.petDOB = snapshot.value[@"pets"][i][@"dateOfBirth"];
             pet.petDOD = snapshot.value[@"pets"][i][@"dateOfDeath"];
             pet.petType = snapshot.value[@"pets"][i][@"animalType"];
             pet.petBreed = snapshot.value[@"pets"][i][@"breed"];
             pet.petPersonality = snapshot.value[@"pets"][i][@"personality"];
             pet.ownerUID = snapshot.value[@"pets"][i][@"UID"];
             pet.ownerName = snapshot.value[@"pets"][i][@"ownerName"];
             pet.feedImageString = snapshot.value[@"pets"][i][@"feedPhoto"];
             pet.treatsNumberString = snapshot.value[@"pets"][i][@"treats"];
             pet.feedImageURL = snapshot.value[@"pets"][i][@"feedPhoto"];
             pet.albumMedia = snapshot.value[@"pets"][i][@"photos"];
             pet.albumImageStrings = [pet.albumMedia valueForKey:@"photoUrl"];
             pet.albumCaptionStrings = [pet.albumMedia valueForKey:@"caption"];
             pet.petID = snapshot.value[@"pets"];
             
             
             //create the array of photos
             self.albumPhotos = [self.albumPhotos arrayByAddingObject:pet];
             pet.petNumber = pet.petNumber++;
            
             NSString *petString = [NSString stringWithFormat:@"%@", pet.ownerUID];
             NSString *currentUserString = [NSString stringWithFormat:@"%@", currentUser.uid];
             
             if( [petString isEqualToString:currentUserString]) {
                Pet *pet = [[Pet alloc] init];
                 //get all the info
                 pet.petName = snapshot.value[@"pets"][i][@"pet"];
                 pet.feedImageString = snapshot.value[@"pets"][i][@"feedPhoto"];
                 pet.petPersonality = snapshot.value[@"pets"][i][@"personality"];
                 pet.ownerName = snapshot.value[@"pets"][i][@"ownerName"];
                 pet.petDOB = snapshot.value[@"pets"][i][@"dateOfBirth"];
                 pet.petDOD = snapshot.value[@"pets"][i][@"dateOfDeath"];
                 pet.petType = snapshot.value[@"pets"][i][@"animalType"];
                 pet.petBreed = snapshot.value[@"pets"][i][@"breed"];
                 pet.albumMedia = snapshot.value[@"pets"][i][@"photos"];
                 pet.albumImageStrings = [pet.albumMedia valueForKey:@"photoUrl"];
                 pet.albumCaptionStrings = [pet.albumMedia valueForKey:@"caption"];
                 pet.petNumber = pet.petNumber++;
                 self.petsByOwner = [self.petsByOwner arrayByAddingObject:pet];
                 
                 for (NSString *string in pet.albumImageStrings) {
                     pet.albumImageString = string;
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

             for (NSString *string in pet.albumImageStrings) {
                 pet.albumImageString = string;
                 FIRStorage *storage = [FIRStorage storage];
                 FIRStorageReference *httpsReference2 = [storage referenceForURL:pet.albumImageString];
                 
                 [httpsReference2 downloadURLWithCompletion:^(NSURL* URL, NSError* error){
                     
                     [self.pptVC.tableView reloadData];
                     
                 }];
             }

            
             self.petItems = [self.petItems arrayByAddingObject:pet];
            
             //THERES MY PET NUMBER
             pet.petNumber =  [self.petItems indexOfObject:pet];
             for (Pet *pet in self.petItems) {
                 self.petNumber = pet.petNumber;
                 
             }
             
             //self.petByNumber = pet.petNumber;
             NSLog(@"pet num no string ?%ld", (long)pet.petNumber);
             //NSLog(@"pet num MEL ?%ld", self.petByNumber);
            
             /*NSMutableArray *petItemsReversed = [NSMutableArray arrayWithCapacity:[self.petItems count]];
             NSEnumerator *enumerator = [self.petItems reverseObjectEnumerator];
             for (id element in enumerator) {
                 [petItemsReversed addObject:element];
             }
             self.petItems = petItemsReversed;
            NSLog(@"petITemsReverser %@", petItemsReversed);*/
             //TODO test if what user is uploading is a valid url format and send an alert if it is not
             if ([snapshot.value isKindOfClass:[NSDictionary class]] && (snapshot.value)) {
            
                 FIRStorage *storage = [FIRStorage storage];
                 //TODO need introspection here
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

                                               NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/pets/%ld/feedPhoto/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:downloadURLString};
                                               
                                               [self.ref updateChildValues:childUpdates];
                                           }
                                       }];
                                   }];
    }];
    
   }

-(void)editPetWithDataDictionary:(NSDictionary *)editPetParameters {
    NSString *petNameString = [editPetParameters valueForKey:@"petName"];
    NSString *petTypeString = [editPetParameters valueForKey:@"petType"];
    NSString *petBreedString = [editPetParameters valueForKey:@"petBreed"];
    NSString *petDobString = [editPetParameters valueForKey:@"dob"];
    NSString *petDodString = [editPetParameters valueForKey:@"dod"];
    NSString *petPersonalityString = [editPetParameters valueForKey:@"personality"];
    NSString *petOwnerString = [editPetParameters valueForKey:@"ownerName"];
    
    NSDictionary *petInfoEdits = @{
                                      [NSString stringWithFormat:@"/pets/5/pet"]:petNameString,
                                      [NSString stringWithFormat:@"/pets/5/animalType"]:petTypeString,
                                      [NSString stringWithFormat:@"/pets/5/breed"]:petBreedString,
                                      [NSString stringWithFormat:@"/pets/5/dateOfBirth"]:petDobString,
                                      [NSString stringWithFormat:@"/pets/5/dateOfDeath"]:petDodString,
                                      [NSString stringWithFormat:@"/pets/5/personality"]:petPersonalityString,
                                      [NSString stringWithFormat:@"/pets/5/ownerName"]:petOwnerString
                                      
                                      };
    
    
    [self.ref updateChildValues:petInfoEdits];
}

-(void)addNewPetWithDataDictionary:(NSDictionary *)addPetParameters {
    
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
                                      [NSString stringWithFormat:@"/pets/%ld/pet",(unsigned long)self.petItems.count]:petNameString,
                                      [NSString stringWithFormat:@"/pets/%ld/animalType",(unsigned long)self.petItems.count]:petTypeString,
                                      [NSString stringWithFormat:@"/pets/%ld/breed",(unsigned long)self.petItems.count]:petBreedString,
                                      [NSString stringWithFormat:@"/pets/%ld/dateOfBirth",(unsigned long)self.petItems.count]:petDobString,
                                      [NSString stringWithFormat:@"/pets/%ld/dateOfDeath",(unsigned long)self.petItems.count]:petDodString,
                                       [NSString stringWithFormat:@"/pets/%ld/personality",(unsigned long)self.petItems.count]:petPersonalityString,
                                       [NSString stringWithFormat:@"/pets/%ld/ownerName",(unsigned long)self.petItems.count]:petOwnerString,
                                       [NSString stringWithFormat:@"/pets/%ld/UID/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:userAuth.uid,
                                      [NSString stringWithFormat:@"/pets/%ld/feedPhoto/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:petPlaceholderImageString
                                      };
                                       
    
    [self.ref updateChildValues:petInfoCreation];
}


-(void)addImageWithDataDictionary:(NSDictionary *)parameters toCurrentPet:(Pet*)pet {
 
    NSAssert(self.ref != nil, @"self.ref should be defined by now");
    NSMutableDictionary *params = [parameters mutableCopy];
    NSString *captionString = [parameters valueForKey:@"photoCaption"];

    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[params[@"petImageURL"]] options:nil];
    
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        
        [asset requestContentEditingInputWithOptions:kNilOptions
                                   completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
                                       NSURL *imageURL = contentEditingInput.fullSizeImageURL;
                                       
                                       NSString *localURLString = [imageURL path];
                                       NSLog(@"uploading to album");
                                       NSString *theFileName = [[localURLString lastPathComponent] stringByDeletingPathExtension];
                                       
                                       FIRStorage *storage = [FIRStorage storage];
                                       FIRStorageReference *storageRef = [storage referenceForURL:@"gs://petcemetary-5fec2.appspot.com/petAlbums/"];
                                       FIRStorageReference *profileRef = [storageRef child:theFileName];
                                       NSLog(@"profileRef %@", profileRef);
                                       FIRStorageUploadTask *uploadTask = [profileRef putFile:imageURL metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
                                           if (error != nil) {
                                               // Uh-oh, an error occurred!
                                               NSLog(@"error %@", error);
                                           } else {
                                               NSURL *downloadURL = metadata.downloadURL;
                                               NSString *downloadURLString = [ downloadURL absoluteString];
                                               
                                               self.pet.petNumber = pet.petNumber;
                                               //NSLog(@"pet items from upload %ld"(long), self.pet.petNumber);
                                               
                                               
                                               //TODO - get the correct PET number
                                               //TODO - counting the right number - just going to wrong pet. always going to pet 0
                                                                                              NSDictionary *childUpdates = @{
                                                                              [NSString stringWithFormat:@"/pets/%ld/photos/%ld/photoUrl/", (unsigned long)self.pet.petNumber,(unsigned long)self.pet.albumMedia.count
                                                                              
                                                                               ]:downloadURLString,
                                                                               [NSString stringWithFormat:@"/pets/%ld/photos/%ld/caption/", (unsigned long)self.pet.petNumber,(unsigned long)self.pet.albumMedia.count]:captionString,
                                                                              };
                                               
                                               
                                               NSLog(@"child updates from edit%@", childUpdates);
                                               [self.ref updateChildValues:childUpdates];
                                               
                                               
                                           }
                                       }];
                                   }];
    }];

}




-(void)deletePet:(Pet *)pet andCompletion:(DeletionCompletionBlock)completion{
    //Pulling in the wrong pet
    NSLog(@"delete this pet");
    NSLog(@"delete this pet %@", pet);
    //NSObject *petToDelete = pet;
    
    //get the pet number
    
    self.ref = [[FIRDatabase database] reference];
    //[[self.ref child:pet] removeValue];
    
    
    /*[getPetQuery
     observeEventType:FIRDataEventTypeChildRemoved
     withBlock:^(FIRDataSnapshot *snapshot) {
    
         NSLog(@"log for deletion %@", snapshot.value);
         
     }];*/
}

-(void)deleteAlbumPhoto:(NSObject*)albumPhoto {
    self.ref = [[FIRDatabase database] reference];
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    FIRDatabaseQuery *getPetQuery = [[self.ref queryOrderedByChild:@"/pets/"]queryLimitedToFirst:1000];
    
    
    [getPetQuery
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
         self.petItems = @[];
         self.petsByOwner = @[];
         NSInteger numPets = [snapshot.value[@"pets"] count];
        
         for (NSInteger i = 0; i < numPets; i++) {
             Pet *pet = [[Pet alloc] init];
             pet.ownerUID = snapshot.value[@"pets"][i][@"UID"];
             NSString *petString = [NSString stringWithFormat:@"%@", pet.ownerUID];
             NSString *currentUserString = [NSString stringWithFormat:@"%@", currentUser.uid];
             self.albumPhotos = [[NSMutableArray alloc] init];
             if( [petString isEqualToString:currentUserString]) {
                 
                 pet.albumMedia = snapshot.value[@"pets"][i][@"photos"];
                 pet.albumImageStrings = [pet.albumMedia valueForKey:@"photoUrl"];
                 pet.albumCaptionStrings = [pet.albumMedia valueForKey:@"caption"];
                 
             }
             
             self.petItems = [self.petItems arrayByAddingObject:pet];
         }
     
     }];
    
    
    /*NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"albumPhotos"];
    if ([mutableArrayWithKVO count] != 0) {
        NSLog(@"array of photos %@",self.albumPhotos);
        NSLog(@"mutable array of photos %@", mutableArrayWithKVO);
        [mutableArrayWithKVO removeObject:albumPhoto];
        [self.albumPhotos removeObject:albumPhoto];
    
        //TODO Update database
        }*/
   // NSLog(@"array is null");
}





-(void)requestNewPetsWithCompletionHandler:(NewPetCompletionBlock)completionHandler {
    
    if(self.isRefreshing == NO) {
        self.isRefreshing = YES;
        
        Pet *pet = [[Pet alloc] init];
        pet.feedImage = [UIImage imageNamed:@"5.jpg"];
        pet.feedCaption = @"new feed caption";
        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"petItems"];
        [mutableArrayWithKVO insertObject:pet atIndex:0];
        
        self.isRefreshing = NO;
        
        if (completionHandler) {
            completionHandler(nil);
        }
        
    }
 
}

-(void)requestOldPetsWithCompletionHandler:(NewPetCompletionBlock)completionHandler {
    
    if (self.isLoadingOlderItems == NO) {
        self.isLoadingOlderItems = YES;
        
        Pet *pet = [[Pet alloc] init];
        pet.feedImage = [UIImage imageNamed:@"5.jpg"];
        pet.feedCaption = @"old feed caption";
        
        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"petItems"];
        [mutableArrayWithKVO addObject:pet];
        
        self.isLoadingOlderItems = NO;
        
        if (completionHandler) {
            completionHandler(nil);
        }
    }
}

//THIS WILL BE A PROBLEM IF ONE OWNER HAS MULTIPLE PETS
/*-(void)retrivePetWithUID:(NSString *)uid andCompletion:(PetRetrievalCompletionBlock)completion {
     Pet *thePet = [[Pet alloc] init];
     self.ref = [[FIRDatabase database] reference];
    
    FIRDatabaseQuery *getPetInfoQuery = [[self.ref child:[NSString stringWithFormat:@"/pets/%@/pet", uid]] queryLimitedToFirst:10];
    [getPetInfoQuery
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
         
         thePet.petName = snapshot.value[@"pet"];
         thePet.ownerUID = snapshot.value[@"UID"];
         
         FIRStorage *storage = [FIRStorage storage];
         FIRStorageReference *httpsReference = [storage referenceForURL:thePet.feedImageString];
         
         
         [httpsReference downloadURLWithCompletion:^(NSURL* URL, NSError* error){
             if (error != nil) {
                 NSLog(@"download url error");
             } else {
                 //NSLog(@"no download url error %@", URL);
                 NSData *imageData = [NSData dataWithContentsOfURL:URL];
                 thePet.feedImage = [UIImage imageWithData:imageData];
                 
                 completion(thePet);
             }
             
         }];
     
     }];
    
    
    
    
    
    
    
    
    
}*/














@end
