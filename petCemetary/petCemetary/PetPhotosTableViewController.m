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
#import <SDWebImage/UIImageView+WebCache.h>

@interface PetPhotosTableViewController () <UITableViewDelegate, UITableViewDataSource, PetPhotosTableViewCellDelegate>

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
    NSLog(@"cell.petAlbumItem %@", cell.petAlbumItem );
    cell.petAlbumItem = self.pet;//[PCDataSource sharedInstance].petAlbumItems[indexPath.row];
    
    NSString *petPhotoUrlString = cell.petAlbumItem.albumImageStrings[indexPath.row];
    //UIImage *image = cell.petAlbumItem.albumImages[indexPath.row];
    [cell.albumPhotoImageView sd_setImageWithURL:[NSURL URLWithString:petPhotoUrlString]
                         placeholderImage:[UIImage imageNamed:@"5.jpg"]];
   
    
    
    
    //[cell.albumPhotoImageView setImage:image];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Pet *pet = [PCDataSource sharedInstance].petAlbumItems[indexPath.row];
    UIImage *image = pet.albumImage;
    
    if( pet.albumImage == nil) {
        NSString *imageName = [NSString stringWithFormat:@"5.jpg"];
        image = [UIImage imageNamed:imageName];
    }
    CGFloat height = (image.size.height / image.size.width) * CGRectGetWidth(self.view.frame);
    
    if (height > 50) {
        return height;
    } else {
        NSLog(@"bad height %f",height);
        return 100.0;
    }
}


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
