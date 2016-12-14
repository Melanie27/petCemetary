//
//  EditPetPhotosTableViewCell.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/28/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "EditPetPhotosTableViewCell.h"
#import "Pet.h"

@implementation EditPetPhotosTableViewCell

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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    if (!self.petAlbumItem) {
        return;
        
    }
    
    UIImage *image = self.petAlbumItem.albumImage;
    
    if( self.petAlbumItem.albumImage == nil) {
        NSString *imageName = [NSString stringWithFormat:@"1.jpg"];
        image = [UIImage imageNamed:imageName];
    }
    
    CGFloat imageHeight = image.size.height / image.size.width * CGRectGetWidth(self.contentView.bounds);
    
    self.albumPhotoImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), imageHeight);
    
    //self.albumPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
    //THIS allows to see entire delete button
    self.albumPhotoImageView.contentMode = UIViewContentModeScaleToFill;
    
    imageHeight = (imageHeight > 50.0) ? imageHeight : 100.0;
    
    self.textLabel.frame = CGRectMake(0, CGRectGetMaxY(self.albumPhotoImageView.frame), CGRectGetWidth(self.contentView.bounds),40);
    
}

+ (CGFloat) heightForPetItem:(Pet *)petAlbumItem width:(CGFloat)width {
    // Make a cell
    EditPetPhotosTableViewCell *layoutCell = [[EditPetPhotosTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editCell"];
    layoutCell.frame = CGRectMake(0, 0, width, CGFLOAT_MAX);
    layoutCell.petAlbumItem = petAlbumItem;
    
    [layoutCell layoutSubviews];
    return CGRectGetMaxY(layoutCell.textLabel.frame);
}


@end
