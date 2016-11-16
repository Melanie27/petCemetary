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
//@property (nonatomic, strong) Pet *petItem;
//@property (strong, nonatomic) IBOutlet UILabel *photoCaptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *albumPhotoImageView;

//@property (nonatomic, strong) IBOutlet UIImageView *petImageView;
@property (nonatomic, weak) id <PetPhotosTableViewCellDelegate> delegate;
@end
