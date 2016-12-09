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

    //@property (nonatomic, assign) BOOL isRefreshing;
    //@property (nonatomic, assign) BOOL isLoadingOlderItems;



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


-(NSString *)retrievePets {
    
    self.ref = [[FIRDatabase database] reference];
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    FIRDatabaseQuery *getPetQuery = [[self.ref queryOrderedByChild:@"/pets/"]queryLimitedToFirst:1000];
    NSMutableString *retrievedPets = [[NSMutableString alloc] init];
    
    [getPetQuery
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
       
         NSDictionary *allPets = snapshot.value[@"pets"];

             self.petItems = @[];
             self.albumPhotos = @[];
             self.petsByOwner = @[];

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
             NSArray *albumMedia = [elements valueForKey:@"photos"];
             NSArray *albumImageStrings = [albumMedia valueForKey:@"photoUrl"];
             NSArray *albumImageCaptions = [albumMedia valueForKey:@"caption"];
             
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
             pet.albumImageStrings = albumImageStrings;
             pet.albumCaptionStrings = albumImageCaptions;
             self.petsByOwner = [self.petsByOwner arrayByAddingObject:pet];
             self.albumPhotos = [self.albumPhotos arrayByAddingObject:pet];
             
             NSString *petString = [NSString stringWithFormat:@"%@", pet.ownerUID];
             NSString *currentUserString = [NSString stringWithFormat:@"%@", currentUser.uid];
             if( [petString isEqualToString:currentUserString]) {
                 

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
             
             self.petItems = [self.petItems arrayByAddingObject:pet];
             
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

-(void)deletePetWithDataDictionary:(NSDictionary *)petID {
     NSString *petIDString = [petID valueForKey:@"petID"];
     NSDictionary *childUpdates = @{
                                   [NSString stringWithFormat:@"/pets/%@/", petIDString
                                    
                                    ]:[NSNull null]
                                   };
    
    [self.ref updateChildValues:childUpdates];
    
}


-(void)addNewPetWithDataDictionary:(NSDictionary *)addPetParameters {
    NSString *key = [[self.ref child:@"pets"] childByAutoId].key;
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
                                [NSString stringWithFormat:@"/pets/%@/photos/%ld/photoUrl/", petIDString, self.pet.albumMedia.count]:downloadURLString,
                                [NSString stringWithFormat:@"/pets/%@/photos/%ld/caption/", petIDString, self.pet.albumMedia.count]:captionString,
                        };
                                               
                        [self.ref updateChildValues:childUpdates];
                    }
                }];
        }];
    }];

}




//TODO - leave in or take out?



/*-(void)requestNewPetsWithCompletionHandler:(NewPetCompletionBlock)completionHandler {
    
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
}*/


    

@end
