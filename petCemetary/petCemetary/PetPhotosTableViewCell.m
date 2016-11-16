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
       
        
        
    }
    
    return self;
}

//layout views
-(void) layoutSubviews {
    [super layoutSubviews];
    
    /*if (!self.petAlbumItem) {
        return;
        
    }*/
    
    
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
