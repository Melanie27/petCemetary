//
//  EditPetPhotosTableViewCell.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/28/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pet.h"
@class Pet;

@protocol EditPetPhotosTableViewCellDelegate <NSObject>

@end
@interface EditPetPhotosTableViewCell : UITableViewCell
@property Pet *petAlbumItem;

@property (strong, nonatomic) IBOutlet UIImageView *albumPhotoImageView;
+ (CGFloat) heightForPetItem:(Pet *)petAlbumItem width:(CGFloat)width;
@property (strong, nonatomic) IBOutlet UILabel *petCaptionLabel;

@property (nonatomic, weak) id <EditPetPhotosTableViewCellDelegate> delegate;
@end
