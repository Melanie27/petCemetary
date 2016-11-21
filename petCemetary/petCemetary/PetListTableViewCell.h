//
//  PetListTableViewCell.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/21/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Pet;

@protocol PetListTableViewCellDelegate <NSObject>

@end

@interface PetListTableViewCell : UITableViewCell

@property (nonatomic, strong) Pet *petByOwner;
@property (strong, nonatomic) IBOutlet UILabel *petNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *petThumbnailView;
+ (CGFloat) heightForPetItem:(Pet *)petItem width:(CGFloat)width;
@property (nonatomic, weak) id <PetListTableViewCellDelegate> delegate;

@end
