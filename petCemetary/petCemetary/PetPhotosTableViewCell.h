//
//  PetPhotosTableViewCell.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/15/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Pet;

@protocol PetPhotosTableViewCellDelegate <NSObject>

@end

@interface PetPhotosTableViewCell : UITableViewCell

@property Pet *petAlbumItem;

@property (strong, nonatomic) IBOutlet UIImageView *albumPhotoImageView;
+ (CGFloat) heightForPetItem:(Pet *)petAlbumItem width:(CGFloat)width;

@property (nonatomic, weak) id <PetPhotosTableViewCellDelegate> delegate;
@end
