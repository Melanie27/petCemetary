//
//  Pet+CoreDataProperties.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/10/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "Pet+CoreDataProperties.h"

@implementation Pet (CoreDataProperties)

+ (NSFetchRequest<Pet *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Pet"];
}

@dynamic name;
@dynamic animalType;
@dynamic whoOwns;

@end
