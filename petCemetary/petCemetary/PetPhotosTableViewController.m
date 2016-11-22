//
//  PetPhotosTableViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/15/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PetPhotosTableViewController.h"
#import "PetPhotosTableViewCell.h"
#import "PCDataSource.h"
#import "Pet.h"
#import "PCImageLibraryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PetPhotosTableViewController () <UITableViewDelegate, UITableViewDataSource, PetPhotosTableViewCellDelegate, PCImageLibraryViewControllerDelegate>

@end

@implementation PetPhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PCDataSource *pc = [PCDataSource sharedInstance];
    pc.pptVC = self;
    //[pc retrievePhotoAlbums];
    self.title = @"Photo Album";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [self.tableView registerClass:[PetPhotosTableViewCell class] forCellReuseIdentifier:@"albumCell"];
    
    //check if any photo capabilities are available and if so add a camera button
    /*if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraPressed:)];
        self.navigationItem.rightBarButtonItem = cameraButton;
    }*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     NSLog(@"count of album items %@", self.pet);
    return self.pet.albumImageStrings.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PetPhotosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell.contentView layoutSubviews];
    
    // Configure the cell...
    cell.petAlbumItem  = self.pet;
   
   
    
    
    NSString *petPhotoUrlString = cell.petAlbumItem.albumImageStrings[indexPath.row];
    
    [cell.albumPhotoImageView sd_setImageWithURL:[NSURL URLWithString:petPhotoUrlString]
                         placeholderImage:[UIImage imageNamed:@"5.jpg"]];
   
    
    //TODO get the indiv image caption
    NSString *petCaptionString = cell.petAlbumItem.albumCaptionStrings[indexPath.row];
    cell.textLabel.text = petCaptionString;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Pet *pet = [PCDataSource sharedInstance].petAlbumItems[indexPath.row];
    UIImage *image = pet.albumImages[indexPath.row];
    
    if( pet.albumImage == nil) {
        NSString *imageName = [NSString stringWithFormat:@"5.jpg"];
        image = [UIImage imageNamed:imageName];
    }
     //CGFloat height =  [PetPhotosTableViewCell heightForPetItem:pet width:CGRectGetWidth(self.view.frame)];
    //TODO - need to impose a max height on all Table cells
    CGFloat height = 650;
    if (height > 50) {
        return height;
    } else {
        NSLog(@"bad height %f",height);
        return 100.0;
    }
}



#pragma mark - PCImageLibraryViewControllerDelegate
/*- (void) cameraPressed:(UIBarButtonItem *) sender {
    
    
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

- (void) imageLibraryViewController:(PCImageLibraryViewController *)imageLibraryViewController didCompleteWithImage:(UIImage *)image {
    [imageLibraryViewController dismissViewControllerAnimated:YES completion:^{
        if (image) {
            NSLog(@"Got an image!");
        } else {
            NSLog(@"Closed without an image.");
        }
    }];
}*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
