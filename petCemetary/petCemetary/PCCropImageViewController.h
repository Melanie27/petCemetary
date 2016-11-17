//
//  PCCropImageViewController.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/17/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PCFullScreenViewController.h"

@class PCCropImageViewController;

@protocol PCCropImageViewControllerDelegate <NSObject>

//user will size and crop image and controller will pass cropped UIImage back to its delegate
-(void) cropControllerFinishedWithImage:(UIImage *)croppedImage;

@end


@interface PCCropImageViewController : PCFullScreenViewController

//another controller will pass this VC a UI image and set itself as the crop controller's delegate
-(instancetype) initWithImage:(UIImage *)sourceImage;

@property(nonatomic, weak) NSObject <PCCropImageViewControllerDelegate> *delegate;

@end
