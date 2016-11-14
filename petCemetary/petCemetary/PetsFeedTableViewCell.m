//
//  PetsFeedTableViewCell.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/11/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PetsFeedTableViewCell.h"
#import "Pet.h"

@implementation PetsFeedTableViewCell
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
    }
    
    return self;
}

//layout views
-(void) layoutSubviews {
    [super layoutSubviews];
    
    if (!self.pet) {
        return;
        
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//override setter method to update the question text whenever a new question is set
-(void)setPet:(Pet*)pet {
    _pet = pet;
    //[self.petName sizeToFit];
    //self.questionTextView.text = self.question.questionText;
    
}

@end
