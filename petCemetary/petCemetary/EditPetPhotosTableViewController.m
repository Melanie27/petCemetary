//
//  EditPetPhotosTableViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/28/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "EditPetPhotosTableViewController.h"
#import "EditPetPhotosTableViewCell.h"
#import "PCDataSource.h"
#import "Pet.h"
#import "PCImageLibraryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface EditPetPhotosTableViewController () <UITableViewDelegate, UITableViewDataSource, PCImageLibraryViewControllerDelegate, EditPetPhotosTableViewCellDelegate>

@end

@implementation EditPetPhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PCDataSource *pc = [PCDataSource sharedInstance];
     pc.editPhotosVC = self;
    [pc retrievePets];
    self.title = @"Edit Photo Album";
    // Do any additional setup after loading the view.
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraPressed:)];
        self.navigationItem.rightBarButtonItem = cameraButton;
    }
    
     [self.tableView registerClass:[EditPetPhotosTableViewCell class] forCellReuseIdentifier:@"editCell"];
    
    [[PCDataSource sharedInstance] addObserver:self forKeyPath:@"albumPhotos" options:0 context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Camera PCImageLibraryViewControllerDelegate

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

- (void) imageLibraryViewController:(PCImageLibraryViewController *)imageLibraryViewController didCompleteWithImage:(UIImage *)image {
    [imageLibraryViewController dismissViewControllerAnimated:YES completion:^{
        if (image) {
            NSLog(@"Got an image!");
        } else {
            NSLog(@"Closed without an image.");
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.pet.albumImageStrings.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EditPetPhotosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell.contentView layoutSubviews];
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
    UIImage *image = pet.albumMedia[indexPath.row];
    
    if( pet.albumImage == nil) {
        NSString *imageName = [NSString stringWithFormat:@"5.jpg"];
        image = [UIImage imageNamed:imageName];
    }
   
    //TODO - need to impose a max height on all Table cells
    CGFloat height = 650;
    if (height > 50) {
        return height;
    } else {
        NSLog(@"bad height %f",height);
        return 100.0;
    }
}

#pragma mark - Swipe to delete and KVO

//KVO
- (void) dealloc {
    [[PCDataSource sharedInstance] removeObserver:self forKeyPath:@"albumPhotos"];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [PCDataSource sharedInstance] && [keyPath isEqualToString:@"albumPhotos"]) {
        NSKeyValueChange kindOfChange = [change[NSKeyValueChangeKindKey] unsignedIntegerValue];
        
        if (kindOfChange == NSKeyValueChangeRemoval) {
            // Someone set a brand new images array
            NSLog(@"item deleted");
            [self.tableView reloadData];
        }
        
        /*else if((kindOfChange = NSKeyValueChangeInsertion)) {
            NSLog(@"item inserted");
            [self.tableView reloadData];
        }*/
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //DELETE ALBUM PHOTO
        PCDataSource *pc = [PCDataSource sharedInstance];
        NSObject *petPhoto = [pc.albumPhotos objectAtIndex:[indexPath row]];
        [[PCDataSource sharedInstance] deleteAlbumPhoto:petPhoto];
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
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
