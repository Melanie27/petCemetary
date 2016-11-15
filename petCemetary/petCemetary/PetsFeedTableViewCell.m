//
//  PetsFeedTableViewCell.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/11/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PetsFeedTableViewCell.h"
#import "Pet.h"
#import "Owner.h"

@interface PetsFeedTableViewCell ()

//@property (nonatomic, strong) UIImageView *petImageView;


@end

@implementation PetsFeedTableViewCell


-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        //init code
       self.petImageView = [[UIImageView alloc] init];
        for (UIView *view in @[self.petImageView]) {
            [self.contentView addSubview:view];
        }
    
        
    }
    
    return self;
}

//layout views
-(void) layoutSubviews {
    [super layoutSubviews];
    
    if (!self.petItem) {
        return;
        
    }
    UIImage *image = self.petItem.feedImage;
    
    if( self.petItem.feedImage == nil) {
        NSString *imageName = [NSString stringWithFormat:@"1.jpg"];
        image = [UIImage imageNamed:imageName];
    }

    CGFloat imageHeight = image.size.height / image.size.width * CGRectGetWidth(self.contentView.bounds);
    imageHeight = (imageHeight > 50.0) ? imageHeight : 100.0;
    self.petImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), imageHeight);
    
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
-(void)setPetItem:(Pet*)petItem {
    _petItem = petItem;
    self.petImageView.image = _petItem.feedImage;
    //NSLog(@"pet %@", petItem);
    //NSLog(@"pet image %@", _petItem.feedImage);
    
    
}

@end