//
//  Pet+CoreDataClass.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/10/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Owner;

NS_ASSUME_NONNULL_BEGIN

@interface Pet : NSManagedObject
    // insert pet to database

+(Pet*)petWithInfo:(NSDictionary*)petDictionary
    inManagedObjectContext:(NSManagedObjectContext *)context;




@end

NS_ASSUME_NONNULL_END

#import "Pet+CoreDataProperties.h"
