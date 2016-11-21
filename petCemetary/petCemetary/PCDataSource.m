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
    @property (nonatomic, strong) NSArray *petsByOwner;
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
             
             //TODO write to disc??
             /*- (nonnull FIRStorageDownloadTask *)
            writeToFile:(nonnull NSURL *)fileURL
            completion:(nullable void (^)(NSURL *_Nullable, NSError *_Nullable))completion;*/
             
             for (NSString *string in pet.albumImageStrings) {
                 pet.albumImageString = string;
                 FIRStorage *storage = [FIRStorage storage];
                 FIRStorageReference *httpsReference2 = [storage referenceForURL:pet.albumImageString];
                 
                 
                 [httpsReference2 downloadURLWithCompletion:^(NSURL* URL, NSError* error){
                     
                     [self.pptVC.tableView reloadData];
                     
                 }];
             }

             self.petItems = [self.petItems arrayByAddingObject:pet];
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

-(void)retrievePetWithUID:(NSString *)uid andCompletion:(PetRetrievalCompletionBlock)completion {
    Pet *pet = [[Pet alloc] init];
    
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    
    NSLog(@"currentUSer %@", currentUser.uid);
    
    NSString *currentUserString = [NSString stringWithFormat:@"%@", currentUser.uid];
    self.ref = [[FIRDatabase database] reference];
    FIRDatabaseQuery *getPetsByOwnerQuery = [[self.ref queryOrderedByChild:@"/pets/"]queryLimitedToFirst:100];
    
    [getPetsByOwnerQuery
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
        
        self.petsByOwner = @[];
         NSInteger numPets = [snapshot.value[@"pets"] count];
         //NSLog(@"numPets %ld", (long)numPets);
          for (NSInteger i = 0; i < numPets; i++) {
              pet.ownerUID = snapshot.value[@"pets"][i][@"UID"];
              NSString *petString = [NSString stringWithFormat:@"%@", pet.ownerUID];
              
             //GET the pets associated with the logged in user
              if( [petString isEqualToString:currentUserString]) {
                  //get all the info
                  pet.petName = snapshot.value[@"pets"][i][@"pet"];
                  pet.feedImageString = snapshot.value[@"pets"][i][@"feedPhoto"];
                  NSLog(@"petName %@", pet.petName);
                  NSLog(@"petimage %@", pet.feedImageString);
                  
                  for (NSString *string in pet.albumImageStrings) {
                      pet.albumImageString = string;
                      FIRStorage *storage = [FIRStorage storage];
                      FIRStorageReference *httpsReference2 = [storage referenceForURL:pet.albumImageString];
                      
                      
                      [httpsReference2 downloadURLWithCompletion:^(NSURL* URL, NSError* error){
                          if (error != nil) {
                              NSLog(@"download url error");
                          } else {
                              [self.pltVC.tableView reloadData];
                              completion(pet);
                          }
                      }];
                  }
                  
                  
              }
              
              
          }
         self.petsByOwner = [self.petItems arrayByAddingObject:pet];
         NSLog (@"pets by owner array %@", self.petsByOwner);
         NSLog (@"pc count %lu", self.petsByOwner.count);
        
         NSLog(@"complete?");
 
     }];
     
    
}

@end
