//
//  Owner+CoreDataProperties.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/10/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "Owner+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Owner (CoreDataProperties)

+ (NSFetchRequest<Owner *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Pet *> *pets;

@end

@interface Owner (CoreDataGeneratedAccessors)

- (void)addPetsObject:(Pet *)value;
- (void)removePetsObject:(Pet *)value;
- (void)addPets:(NSSet<Pet *> *)values;
- (void)removePets:(NSSet<Pet *> *)values;

@end

NS_ASSUME_NONNULL_END
