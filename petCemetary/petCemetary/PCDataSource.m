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
         self.pets = @[];
         NSInteger numPets = [snapshot.value[@"pets"] count];
         for (NSInteger i = 0; i < numPets; i++) {
             Pet *pet = [[Pet alloc] init];
             pet.petName = snapshot.value[@"pets"][i][@"pet"];
             pet.ownerUID = snapshot.value[@"pets"][i][@"UID"];
             self.pets = [self.pets arrayByAddingObject:pet];
         }
         NSLog(@"retrieved pets %@", retrievedPets);
         [self.pftVC.tableView reloadData];
        
         
     }];
    
    
    return retrievedPets;
    
}

@end
