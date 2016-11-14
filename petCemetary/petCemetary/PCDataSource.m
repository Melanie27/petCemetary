//
//  PCDataSource.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/11/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PCDataSource.h"
#import "PetsFeedTableViewController.h"
#import "Pet.h"
#import "Owner.h"

@interface PCDataSource ()
    @property (nonatomic, strong) NSArray *pets;
    @property (nonatomic, strong) NSArray *petItems;

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
        [self addRandomData];
    }
    
    return self;
}


- (void) addRandomData {
    NSMutableArray *randomMediaItems = [NSMutableArray array];
    
    for (int i = 1; i <= 10; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i];
        UIImage *image = [UIImage imageNamed:imageName];
        
        if (image) {
            Pet *pet = [[Pet alloc] init];
            pet.feedImage = image;
            
            [randomMediaItems addObject:pet];
        }
    }
    
    self.petItems = randomMediaItems;
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
         
         self.pets = @[];
         NSInteger numPets = [snapshot.value[@"pets"] count];
         for (NSInteger i = 0; i < numPets; i++) {
             Pet *pet = [[Pet alloc] init];
             NSLog(@"url %@", snapshot.value[@"pets"][i][@"feedPhoto"]);
             pet.petName = snapshot.value[@"pets"][i][@"pet"];
             pet.ownerUID = snapshot.value[@"pets"][i][@"UID"];
             pet.feedImageString = snapshot.value[@"pets"][i][@"feedPhoto"];
             self.pets = [self.pets arrayByAddingObject:pet];
             
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
                     
                 }];
                 
                 
             }
             
         }
         
         
         
         
         NSLog(@"retrieved pets %@", retrievedPets);
         //[self.pftVC.tableView reloadData];
        
         
     }];
    
    
    return retrievedPets;
    
}

@end
