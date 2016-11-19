//
//  ownerPetPhotosTableViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/19/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "ownerPetPhotosTableViewController.h"
#import "OwnerTableViewCell.h"
#import "PetPhotosTableViewCell.h"
#import "PCDataSource.h"
#import "Pet.h"
#import "PCImageLibraryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PostToAlbumViewController.h"


@interface ownerPetPhotosTableViewController () <UITableViewDelegate, UITableViewDataSource, PetPhotosTableViewCellDelegate, PCImageLibraryViewControllerDelegate>

@end

@implementation ownerPetPhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    PCDataSource *pc = [PCDataSource sharedInstance];
    pc.pptVC = self;
    [pc retrievePets];
    self.title = @"Owners Editable Album";
    
     [self.tableView registerClass:[OwnerTableViewCell class] forCellReuseIdentifier:@"albumCell"];
    //check if any photo capabilities are available and if so add a camera button
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraPressed:)];
        self.navigationItem.rightBarButtonItem = cameraButton;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}




#pragma mark - PCImageLibraryViewControllerDelegate
- (void) cameraPressed:(UIBarButtonItem *) sender {
    
    
    UIViewController *imageVC;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        PCImageLibraryViewController *imageLibraryVC = [[PCImageLibraryViewController alloc] init];
        imageLibraryVC.delegate = self;
        imageVC = imageLibraryVC;
    }
    
    if (imageVC) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imageVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    return;
}



#pragma mark - handle image

- (void) handleImage:(UIImage *)image withNavigationController:(UINavigationController *)nav {
    if (image) {
        PostToAlbumViewController *postVC = [[PostToAlbumViewController alloc] initWithImage:image];
        NSLog(@"show me post vc");
        [nav pushViewController:postVC animated:YES];
    } else {
        [nav dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) imageLibraryViewController:(PCImageLibraryViewController *)imageLibraryViewController didCompleteWithImage:(UIImage *)image {
    
    [self handleImage:image withNavigationController:imageLibraryViewController.navigationController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
