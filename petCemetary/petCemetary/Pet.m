//
//  Pet+CoreDataProperties.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/9/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "Pet.h"

@implementation Pet (CoreDataProperties)

+ (NSFetchRequest<Pet *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Pet"];
}

@dynamic ownerID;
@dynamic name;
@dynamic dateOfBirth;
@dynamic dateOfDeath;
@dynamic dateCreated;
@dynamic animalType;
@dynamic breed;
@dynamic personality;
@dynamic anecdote;
@dynamic pet;
@dynamic petPhotographed;

@end
