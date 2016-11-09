//
//  Photo+CoreDataProperties.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/9/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "Photo.h"

@implementation Photo (CoreDataProperties)

+ (NSFetchRequest<Photo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
}

@dynamic title;
@dynamic caption;
@dynamic image;
@dynamic imageUrl;
@dynamic dateUploaded;
@dynamic thumbnailImage;
@dynamic thumbnailImageUrl;
@dynamic treatsCount;
@dynamic treater;
@dynamic photos;

@end
