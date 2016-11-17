//
//  PCImageLibraryViewController.h
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/16/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PCImageLibraryViewController;

@protocol PCImageLibraryViewControllerDelegate <NSObject>

- (void) imageLibraryViewController:(PCImageLibraryViewController*) imageLibraryViewController didCompleteWithImage:(UIImage *)image;

@end



@interface PCImageLibraryViewController : UICollectionViewController

@property (nonatomic, weak) NSObject <PCImageLibraryViewControllerDelegate> *delegate;


@end
