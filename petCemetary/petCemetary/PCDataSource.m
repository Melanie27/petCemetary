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

@interface PCDataSource ()
    
    @property (nonatomic, strong) NSArray *petItems;
    @property (nonatomic, strong) NSArray *petMedia;
    @property (nonatomic, strong) NSArray *petsByOwner;
    @property (nonatomic, strong) NSArray *albumPhotos;

    @property (nonatomic, assign) BOOL isRefreshing;
    @property (nonatomic, assign) BOOL isLoadingOlderItems;


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
         //init the array
         //NSLog(@"snapshot %@", snapshot);
         //TODO - what if someone deletes a pet how to prevent increment holes? 
         self.petItems = @[];
         self.albumPhotos = @[];
         NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
         self.petsByOwner = @[];
         //NSInteger numPetsPhotos = [snapshot.value[@"pets"][i][@"feedPhoto"]count];
         NSInteger numPets = [snapshot.value[@"pets"] count];
         for (NSInteger i = 0; i < numPets; i++) {
             Pet *pet = [[Pet alloc] init];
             NSLog(@"url from datasource %@", snapshot.value[@"pets"][i][@"feedPhoto"]);
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
             
            
             
             //create the array of photos
             NSInteger numPhotos = pet.albumMedia.count;
             self.petNumber =  numPhotos;
             //for(NSInteger i = 0; i < numPhotos; i++) {
                
                 
                 NSURL *imageURL = [NSURL URLWithString:pet.albumImageString];
                 NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                 pet.albumImage = [UIImage imageWithData:imageData];
                 self.albumPhotos = [self.albumPhotos arrayByAddingObject:pet];
                 NSLog (@"media count %@", self.albumPhotos);
            // }
             
             //TODO write to disc??
             /*- (nonnull FIRStorageDownloadTask *)
            writeToFile:(nonnull NSURL *)fileURL
            completion:(nullable void (^)(NSURL *_Nullable, NSError *_Nullable))completion;*/
            
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
                 //pet.petNumber = snapshot.value[@"pets"][i];
                  //NSInteger numPhotos = [snapshot.value[@"photos"]count];
                 //NSLog(@"num photos inner %ld", (long)numPhotos);
                 //GET A COUNT OF THE NUMBER OF PHOTOS BELONING TO EACH PET
                 //NSNumber *photosCount = [pet.albumImageString count];
                 
                 /**/
                 
                 
                 
                 self.petsByOwner = [self.petsByOwner arrayByAddingObject:pet];
                 
                 NSLog(@"array pets %@", self.petsByOwner);
                 for (NSString *string in pet.albumImageStrings) {
                     pet.albumImageString = string;
                     FIRStorage *storage = [FIRStorage storage];
                     FIRStorageReference *httpsReference3 = [storage referenceForURL:pet.albumImageString];
                     
                     
                     [httpsReference3 downloadURLWithCompletion:^(NSURL* URL, NSError* error){
                         if (error != nil) {
                             NSLog(@"download url error");
                         } else {
                             [self.pltVC.tableView reloadData];
                             //[self.editPhotosVC.tableView reloadData];
                            
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
             
             
             //TODO test if what user is uploading is a valid url format and send an alert if it is not
             if ([snapshot.value isKindOfClass:[NSDictionary class]]) {
                
                 
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
-(void)addImageToAlbum: (UIImage*)newPetImage andCompletion:(ImagePickerCompletionBlock)completion {

    
    NSLog(@"Got an image!");
    //TODO pull this info from the EditPetPhotosTableViewController
    
    /*UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSURL *petImageURL = info[UIImagePickerControllerReferenceURL];
    NSString *imagePath = [petImageURL path];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imagePath];
    NSURL *docPathUrl = [NSURL fileURLWithPath:getImagePath];
    NSLog(@"docPathUrl %@", docPathUrl);
    //FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage referenceForURL:@"gs://petcemetary-5fec2.appspot.com/petAlbums"];

    NSString *localURLString = [docPathUrl path];
    NSString *theFileName = [[localURLString lastPathComponent] stringByDeletingPathExtension];
    FIRStorageReference *profileRef = [storageRef child:theFileName];
    NSLog(@"profileRef %@", profileRef);
    
    FIRStorageUploadTask *uploadTask = [profileRef putFile:docPathUrl metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error != nil) {
            // Uh-oh, an error occurred!
            NSLog(@"error %@", error);
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            NSURL *downloadURL = metadata.downloadURL;
            NSLog(@"no error %@", downloadURL);
        }
    }];
    
    
    Pet *pet = [[Pet alloc]init];
    
    NSDictionary *childUpdates = @{
                                   
                                   [NSString stringWithFormat:@"/pets/%ld/photos/%ld/", (unsigned long)pet.petNumber, (unsigned long)pet.photoNumber]:petImageURL
                                   
                                   };
    
    [_ref updateChildValues:childUpdates];*/
   

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
                 //[self.albumPhotos arrayByAddingObject:pet.albumMedia];
                 NSLog(@"album media array %@", pet.albumMedia);
                 //NSLog(@"album photos array %@", self.albumPhotos);
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


/*-(void)addNewPet {
    Pet *pet = [[Pet alloc] init];
    NSString *savedPetName = self.petNameTextField.text;
    NSString *savedAnimalType = self.animalTypeTextField.text;
    NSString *savedAnimalBreed = self.animalBreedTextField.text;
    NSString *savedPersonality = self.animalPersonalityTextField.text;
    NSString *savedOwnerName = self.ownerNameTextField.text;
    NSString *petImageString = @"https://firebasestorage.googleapis.com/v0/b/petcemetary-5fec2.appspot.com/o/petFeed%2Fspooky.png?alt=media&token=58e1b0af-a087-4028-a208-90ff8622f850";
    self.ref = [[FIRDatabase database] reference];
    FIRUser *userAuth = [FIRAuth auth].currentUser;
    NSDictionary *childUpdates = @{
                                   
                                   [NSString stringWithFormat:@"/pets/%ld/pet/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:savedPetName,
                                   [NSString stringWithFormat:@"/pets/%ld/animalType/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:savedAnimalType,
                                   [NSString stringWithFormat:@"/pets/%ld/breed/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:savedAnimalBreed,
                                   [NSString stringWithFormat:@"/pets/%ld/personality/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:savedPersonality,
                                   [NSString stringWithFormat:@"/pets/%ld/ownerName/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:savedOwnerName,
                                   [NSString stringWithFormat:@"/pets/%ld/feedPhoto/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:petImageString,
                                   [NSString stringWithFormat:@"/pets/%ld/UID/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:userAuth.uid
                                   };
    
    [_ref updateChildValues:childUpdates];
}*/





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


@end
