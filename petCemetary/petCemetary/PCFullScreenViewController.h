//
//  PCFullScreenViewController.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/17/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Pet;

@interface PCFullScreenViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

//property to store the pet object - in header now so that subclass can access it
@property (nonatomic, strong) Pet *pet;

//custom initializer you pass media object to display
- (instancetype) initWithPet:(Pet *)pet;

- (void) centerScrollView;

//add a method to allow subclasses to request recalculation of the zoom scales
-(void) recalculateZoomScale;
@end
