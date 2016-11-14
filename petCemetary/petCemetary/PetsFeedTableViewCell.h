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


@property (strong, nonatomic) IBOutlet UILabel *petNameLabel;

@property (nonatomic, strong) IBOutlet UIButton *petImageButton;



@property (nonatomic, weak) id <PetsTableViewCellDelegate> delegate;

@end
