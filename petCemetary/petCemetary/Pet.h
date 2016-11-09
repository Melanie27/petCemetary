//
//  Pet+CoreDataProperties.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/9/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "Pet+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Pet (CoreDataProperties)

+ (NSFetchRequest<Pet *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *ownerID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *dateOfBirth;
@property (nullable, nonatomic, copy) NSDate *dateOfDeath;
@property (nullable, nonatomic, copy) NSDate *dateCreated;
@property (nullable, nonatomic, copy) NSString *animalType;
@property (nullable, nonatomic, copy) NSString *breed;
@property (nullable, nonatomic, copy) NSString *personality;
@property (nullable, nonatomic, copy) NSString *anecdote;
@property (nullable, nonatomic, retain) Owner *pet;
@property (nullable, nonatomic, retain) NSSet<Photo *> *petPhotographed;

@end

@interface Pet (CoreDataGeneratedAccessors)

- (void)addPetPhotographedObject:(Photo *)value;
- (void)removePetPhotographedObject:(Photo *)value;
- (void)addPetPhotographed:(NSSet<Photo *> *)values;
- (void)removePetPhotographed:(NSSet<Photo *> *)values;

@end

NS_ASSUME_NONNULL_END
