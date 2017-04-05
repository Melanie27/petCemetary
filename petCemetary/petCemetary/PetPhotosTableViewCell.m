//
//  PetPhotosTableViewCell.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/15/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PetPhotosTableViewCell.h"
#import "Pet.h"

@implementation PetPhotosTableViewCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        //init code
        self.albumPhotoImageView = [[UIImageView alloc] init];
        for (UIView *view in @[self.albumPhotoImageView]) {
            [self.contentView addSubview:view];
        }
    }
    
    return self;
}

//layout views
-(void) layoutSubviews {
    [super layoutSubviews];
    
    if (!self.petAlbumItem) {
        return;
        
    }
    
    UIImage *image = self.petAlbumItem.albumImage;
    
    if( self.petAlbumItem.albumImage == nil) {
        NSString *imageName = [NSString stringWithFormat:@"1.jpg"];
        image = [UIImage imageNamed:imageName];
    } else {
        NSLog(@"got image w/ height %f",self.petAlbumItem.albumImage.size.height);
    }
    
    CGFloat imageHeight = image.size.height / image.size.width * CGRectGetWidth(self.contentView.bounds);
    self.albumPhotoImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), imageHeight);
    self.albumPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    imageHeight = (imageHeight > 50.0) ? imageHeight : 100.0;
    
    self.textLabel.frame = CGRectMake(5, CGRectGetMaxY(self.albumPhotoImageView.frame), CGRectGetWidth(self.contentView.bounds),40);
    
}

+ (CGFloat) heightForPetItem:(Pet *)petAlbumItem width:(CGFloat)width {
    // Make a cell
    PetPhotosTableViewCell *layoutCell = [[PetPhotosTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"albumCell"];
    
    // Set it to the given width, and the maximum possible height
    layoutCell.frame = CGRectMake(0, 0, width, CGFLOAT_MAX);
    
    // Give it the media item
    layoutCell.petAlbumItem = petAlbumItem;
    
    // Make it adjust the image view and labels
    [layoutCell layoutSubviews];
    
    // The height will be wherever the bottom of the comments label is
    return CGRectGetMaxY(layoutCell.textLabel.frame);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//override setter method to update the photo
/*-(void)setPetAlbumItem:(Pet*)petAlbumItem {
    _petAlbumItem = petAlbumItem;
    self.albumPhotoImageView.image = _petAlbumItem.albumImage;
 
}*/


@end
