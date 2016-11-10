//
//  Pet+CoreDataProperties.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/10/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "Pet+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Pet (CoreDataProperties)

+ (NSFetchRequest<Pet *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *animalType;
@property (nullable, nonatomic, retain) Owner *whoOwns;

@end

NS_ASSUME_NONNULL_END
