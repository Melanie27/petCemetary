//
//  Owner+CoreDataProperties.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/9/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "Owner+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Owner (CoreDataProperties)

+ (NSFetchRequest<Owner *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *ownerName;
@property (nullable, nonatomic, copy) NSString *ownerID;
@property (nullable, nonatomic, copy) NSString *pet;
@property (nullable, nonatomic, retain) NSSet<Pet *> *whoOwns;

@end

@interface Owner (CoreDataGeneratedAccessors)

- (void)addWhoOwnsObject:(Pet *)value;
- (void)removeWhoOwnsObject:(Pet *)value;
- (void)addWhoOwns:(NSSet<Pet *> *)values;
- (void)removeWhoOwns:(NSSet<Pet *> *)values;

@end

NS_ASSUME_NONNULL_END
