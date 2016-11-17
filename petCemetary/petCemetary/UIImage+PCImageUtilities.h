//
//  UIImage+PCImageUtilities.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/16/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PCImageUtilities)
-(UIImage *) imageWithFixedOrientation;
-(UIImage *) imageResizedToMatchAspectRatio:(CGSize)size;
-(UIImage *) imageCroppedToRect:(CGRect)cropRect;
@end
