//
//  Photo+CoreDataProperties.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/9/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "Photo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

+ (NSFetchRequest<Photo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *caption;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, copy) NSString *imageUrl;
@property (nullable, nonatomic, copy) NSDate *dateUploaded;
@property (nullable, nonatomic, retain) NSData *thumbnailImage;
@property (nullable, nonatomic, copy) NSString *thumbnailImageUrl;
@property (nonatomic) int64_t treatsCount;
@property (nullable, nonatomic, copy) NSString *treater;
@property (nullable, nonatomic, retain) Pet *photos;

@end

NS_ASSUME_NONNULL_END
