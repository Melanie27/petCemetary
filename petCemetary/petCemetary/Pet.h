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

@property  float timeStamp;




@property (nonatomic, assign) NSString *petID;
@property (nonatomic, assign) NSString *photoID;


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



//ALBUM MEDIA
@property (nonatomic, strong) NSArray *albumCaptionStrings;
@property (nonatomic, strong) NSString *albumCaptionString;
@property (nonatomic, strong) NSArray *albumImageStrings;
@property (nonatomic, strong) NSString *albumImageString;
@property (nonatomic, strong) UIImage *albumImage;
@property (nonatomic, strong) NSArray *albumImages;
@property (nonatomic, strong) NSMutableDictionary *albumMedia;
@property (nonatomic, strong) NSString *photoIDString;




- (NSString *) newPet;

@end
