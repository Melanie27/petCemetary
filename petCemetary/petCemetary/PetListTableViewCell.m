//
//  PetListTableViewCell.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/21/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PetListTableViewCell.h"
#import "Pet.h"

@implementation PetListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        //init code
        self.petThumbnailView = [[UIImageView alloc] init];
        for (UIView *view in @[self.petThumbnailView]) {
            [self.contentView addSubview:view];
        }
        
        
    }
    
    return self;
}

//layout views
-(void) layoutSubviews {
    [super layoutSubviews];
    
    if (!self.pet) {
        return;
        
    }
    
    
    UIImage *image = self.pet.feedImage;
    if( self.pet.feedImage == nil) {
        NSString *imageName = [NSString stringWithFormat:@"1.jpg"];
        image = [UIImage imageNamed:imageName];
    }
    
    CGFloat imageHeight = image.size.height / image.size.width * CGRectGetWidth(self.contentView.bounds);
    self.petThumbnailView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), imageHeight);
    
    
    imageHeight = (imageHeight > 50.0) ? imageHeight : 100.0;
    self.petThumbnailView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), imageHeight);
    
    self.textLabel.frame = CGRectMake(0, CGRectGetMaxY(self.petThumbnailView.frame), CGRectGetWidth(self.contentView.bounds),40);
    
}

+ (CGFloat) heightForPetItem:(Pet *)pet width:(CGFloat)width {
    // Make a cell
    PetListTableViewCell *layoutCell = [[PetListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    // Set it to the given width, and the maximum possible height
    layoutCell.frame = CGRectMake(0, 0, width, CGFLOAT_MAX);
    
    // Give it the media item
    layoutCell.pet = pet;
    //layoutCell.petsByOwner = petByOwner;
    
    // Make it adjust the image view and labels
    [layoutCell layoutSubviews];
    
    // The height will be wherever the bottom of the comments label is
    return CGRectGetMaxY(layoutCell.textLabel.frame);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//override setter method to update the photo
-(void)setPet:(Pet*)pet {
    _pet = pet;
    self.petThumbnailView.image = _pet.feedImage;
   
    
    
}





@end
