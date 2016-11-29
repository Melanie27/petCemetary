//
//  PetsFeedTableViewCell.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/11/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Pet;

@protocol PetsTableViewCellDelegate <NSObject>

@end

@interface PetsFeedTableViewCell : UITableViewCell

@property (nonatomic, strong) Pet *petItem;
+ (CGFloat) heightForPetItem:(Pet *)petItem width:(CGFloat)width;


@property (strong, nonatomic) IBOutlet UILabel *petNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *petImageView;
@property (nonatomic, weak) id <PetsTableViewCellDelegate> delegate;

@end
