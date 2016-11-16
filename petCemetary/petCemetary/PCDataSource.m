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



-(NSString *)retrievePets {
    
    self.ref = [[FIRDatabase database] reference];
    NSLog(@"db ref %@", self.ref);
    FIRDatabaseQuery *getPetQuery = [[self.ref queryOrderedByChild:@"/pets/"]queryLimitedToFirst:1000];
    NSMutableString *retrievedPets = [[NSMutableString alloc] init];
    
    [getPetQuery
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
         //init the array
         NSLog(@"snapshot %@", snapshot);
         
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
             
             
             
             self.petItems = [self.petItems arrayByAddingObject:pet];
             
             
             
             if ([snapshot.value isKindOfClass:[NSDictionary class]]) {
                 //THIS IS THE STRING TO THE IMAGE WE WANT TO SEE
                 //petf.feedImageString = snapshot.value[@"profile_picture"];
                 
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
             
             
             //this gets all photos for all pets
             self.petAlbumItems = @[];
             NSInteger numAlbumPhotos = [snapshot.value[@"pets"][i][@"photos"] count];
             NSLog(@"num photos %ld", (long)numAlbumPhotos);
             pet.albumPhotos = snapshot.value[@"pets"][i][@"photos"];
             //NSLog(@"album photo array %@", pet.albumPhotos);
             
             NSArray *strings = [pet.albumPhotos valueForKey:@"photoUrl"];
             //NSLog(@"strings %@", strings);
             
             for( NSString *photoUrlString in strings) {
                 
                 FIRStorage *storage = [FIRStorage storage];
                 FIRStorageReference *httpsReference2 = [storage referenceForURL:photoUrlString];
                 NSLog(@"photoUrlString %@", photoUrlString);
                 if (photoUrlString != nil) {
                     
                     [httpsReference2 downloadURLWithCompletion:^(NSURL* URL, NSError* error){
                         if (error != nil) {
                             NSLog(@"download url error");
                             
                         } else {
                             NSLog(@"no download album url error %@", URL);
                             NSData *imageData = [NSData dataWithContentsOfURL:URL];
                             pet.albumImage = [UIImage imageWithData:imageData];
                             
                         }
                         [self.pptVC.tableView reloadData];
                         
                     }];
                 }
                 self.petAlbumItems = [self.petAlbumItems arrayByAddingObject:pet];
             }
             
             
             
         }

     }];
    
    
    return retrievedPets;
    
}

@end
