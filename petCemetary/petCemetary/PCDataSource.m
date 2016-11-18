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
#import "Pet.h"
#import "Owner.h"

@interface PCDataSource ()
    
    @property (nonatomic, strong) NSArray *petItems;
    @property (nonatomic, strong) NSArray *petAlbumItems;

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


//TODO - this code is cycling through all pet album photos and then displaying the last one
-(NSString *)retrievePhotoAlbums {
     self.ref = [[FIRDatabase database] reference];
    
    FIRDatabaseQuery *getAlbumQuery =  [[self.ref queryOrderedByChild:@"/pets/"]queryLimitedToFirst:10];
    
    NSMutableString *retrievedPhotoAlbums = [[NSMutableString alloc] init];
    
    [getAlbumQuery
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
        
         NSLog(@"snapshot %@", snapshot);
         
        self.petAlbumItems = @[];
        //self.petItems = @[];
         //NSInteger numPets = [snapshot.value[@"pets"] count];
         
        // [self retrievePhotoAlbumForPet:];
         for (NSInteger i = 0; i < numPets; i++) {
             Pet *pet = [[Pet alloc] init];
             //NSInteger numAlbumPhotos = [snapshot.value[@"photos"] count];
         //NSLog(@"num photos %ld", (long)numAlbumPhotos);
             pet.albumImages = snapshot.value[@"photos"];
             NSLog(@"album photo array %@", pet.albumImages);
             
             NSInteger numAlbumPhotos = [snapshot.value[@"pets"][i][@"photos"] count];
             NSLog(@"num photos %ld", (long)numAlbumPhotos);
             pet.albumImages = snapshot.value[@"pets"][i][@"photos"];
             //NSLog(@"album photo array %@", pet.albumPhotos);
             
             NSArray *strings = [pet.albumImages valueForKey:@"photoUrl"];
             NSLog(@"strings %@", strings);
             
             for( NSString *photoUrlString in strings) {
                 Pet *pet = [[Pet alloc] init];
                 FIRStorage *storage = [FIRStorage storage];
                 FIRStorageReference *httpsReference2 = [storage referenceForURL:photoUrlString];
                 NSLog(@"photoUrlString %@", photoUrlString);
                 if (photoUrlString != nil) {
                     
                     /*
                      - (nonnull FIRStorageDownloadTask *)
                 writeToFile:(nonnull NSURL *)fileURL
                 completion:(nullable void (^)(NSURL *_Nullable, NSError *_Nullable))completion;
                      */
                     
                     [httpsReference2 downloadURLWithCompletion:^(NSURL* URL, NSError* error){
                         if (error != nil) {
                             NSLog(@"download url error");
                             
                         } else {
                             NSLog(@"no download album url error %@", URL);
                             NSData *imageData = [NSData dataWithContentsOfURL:URL];
                             pet.albumImages = [pet.albumImages arrayByAddingObject:[UIImage imageWithData:imageData]];
                         }
                         
                         if (self.pptVC) {
                             [self.pptVC.tableView reloadData];
                         }
                         
                     }];
                 
                 
                 }
                 self.petAlbumItems = [self.petAlbumItems arrayByAddingObject:pet];
                 
             }
             
             
         }
         
     }];
    
    return retrievedPhotoAlbums;
}

-(NSString *)retrievePets {
    
    self.ref = [[FIRDatabase database] reference];
    //NSLog(@"db ref %@", self.ref);
    FIRDatabaseQuery *getPetQuery = [[self.ref queryOrderedByChild:@"/pets/"]queryLimitedToFirst:1000];
    NSMutableString *retrievedPets = [[NSMutableString alloc] init];
    
    [getPetQuery
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
         //init the array
         //NSLog(@"snapshot %@", snapshot);
         
         self.petItems = @[];
         NSInteger numPets = [snapshot.value[@"pets"] count];
         for (NSInteger i = 0; i < numPets; i++) {
             Pet *pet = [[Pet alloc] init];
             NSLog(@"url %@", snapshot.value[@"pets"][i][@"feedPhoto"]);
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
             
             
             pet.albumImages = snapshot.value[@"pets"][i][@"photos"];
             pet.albumImageStrings = [pet.albumImages valueForKey:@"photoUrl"];
             NSLog(@"pet album image strings %@", pet.albumImageStrings);
             for (NSString *string in pet.albumImageStrings) {
                 pet.albumImageString = string;
                 FIRStorage *storage = [FIRStorage storage];
                 FIRStorageReference *httpsReference2 = [storage referenceForURL:pet.albumImageString];
                 NSLog(@"photo string %@", pet.albumImageString);
                 NSLog(@"httpsReference2 %@", httpsReference2);
             }
             
             
             
             
             self.petItems = [self.petItems arrayByAddingObject:pet];
             if ([snapshot.value isKindOfClass:[NSDictionary class]]) {
                 //THIS IS THE STRING TO THE IMAGE WE WANT TO SEE
                 
                 FIRStorage *storage = [FIRStorage storage];
                 FIRStorageReference *httpsReference = [storage referenceForURL:pet.feedImageString];
                 
                 
                 [httpsReference downloadURLWithCompletion:^(NSURL* URL, NSError* error){
                     if (error != nil) {
                         NSLog(@"download url error");
                     } else {
                         //NSLog(@"no download url error %@", URL);
                         NSData *imageData = [NSData dataWithContentsOfURL:URL];
                         pet.feedImage = [UIImage imageWithData:imageData];
                     }
                     [self.pftVC.tableView reloadData];

                 }];
                 
                 
             }
             
         }

     }];
    
    
    return retrievedPets;
    
}

@end
