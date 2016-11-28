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
@property (nonatomic, assign) NSString *petDOB;
@property (nonatomic, assign) NSString *petDOD;
@property (nonatomic, strong) NSString *petName;
@property (nonatomic, strong) NSString *petType;
@property (nonatomic, strong) NSString *petBreed;
@property (nonatomic, strong) NSString *petPersonality;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *ownerUID;
 @property (nonatomic, strong) Owner *owner;
@property (nonatomic, strong) NSURL *feedImageURL;
@property (nonatomic, strong) NSString *feedImageString;
@property (nonatomic, strong) UIImage *feedImage;
@property (nonatomic, strong) NSString *feedCaption;
@property (nonatomic, strong) NSNumber *treatsNumber;
@property (nonatomic, strong) NSString *treatsNumberString;



@property (nonatomic, strong) NSArray *albumCaptionStrings;
@property (nonatomic, strong) NSArray *albumImageStrings;
@property (nonatomic, strong) NSString *albumImageString;
@property (nonatomic, strong) UIImage *albumImage;
@property (nonatomic, strong) NSArray *albumMedia;
@property (nonatomic, strong) NSObject *albumMediaObject;

- (NSString *) newPet;

@end
