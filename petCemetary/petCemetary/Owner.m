//
//  Owner+CoreDataProperties.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/9/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "Owner.h"

@implementation Owner (CoreDataProperties)

+ (NSFetchRequest<Owner *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Owner"];
}

@dynamic ownerName;
@dynamic ownerID;
@dynamic pet;
@dynamic whoOwns;

@end
