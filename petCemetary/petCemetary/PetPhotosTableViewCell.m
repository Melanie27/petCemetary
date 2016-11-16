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
    }
    
    CGFloat imageHeight = image.size.height / image.size.width * CGRectGetWidth(self.contentView.bounds);
    imageHeight = (imageHeight > 50.0) ? imageHeight : 100.0;
    self.albumPhotoImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), imageHeight);
    
    
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
    NSLog(@"pet %@", petAlbumItem);
    //NSLog(@"pet image %@", _petItem.feedImage);
    
    
}*/


@end
