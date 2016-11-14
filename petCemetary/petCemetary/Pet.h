//
//  Pet.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/11/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Owner;

@interface Pet : NSObject

@property (nonatomic, assign) NSInteger *petNumber;
@property (nonatomic, strong) NSString *petName;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *ownerUID;
 @property (nonatomic, strong) Owner *owner;
@property (nonatomic, strong) NSURL *feedMediaURL;
@property (nonatomic, strong) UIImage *feedImage;
@property (nonatomic, strong) NSString *feedCaption;

- (NSString *) newPet;

@end
