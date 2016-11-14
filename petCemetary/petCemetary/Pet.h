//
//  Pet.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/11/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pet : NSObject

@property (nonatomic, assign) NSInteger *petNumber;
@property (nonatomic, strong) NSString *petName;
@property (nonatomic, strong) NSString *ownerUID;

- (NSString *) newPet;

@end
