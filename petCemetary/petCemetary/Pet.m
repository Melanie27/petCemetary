//
//  Pet.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/11/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "Pet.h"
#import "Owner.h"

@implementation Pet
- (instancetype)init
{
    self = [super init];
    if (self) {
        _albumMedia = @[];
    }
    return self;
}
- (NSString *) newPet {
    
    return @"";
}

@end
