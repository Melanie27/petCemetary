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

@interface PetPhotosTableViewController () <PetPhotosTableViewCellDelegate>

@end

@implementation PetPhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PCDataSource *pc = [PCDataSource sharedInstance];
    pc.pptVC = self;
    [pc retrievePets];
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

    return [PCDataSource sharedInstance].petAlbumPhotos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PetPhotosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    // Configure the cell...
    cell.petAlbumItem = [PCDataSource sharedInstance].petItems[indexPath.row];
    
    UIImage *image = cell.petAlbumItem.albumImage;
    
    if( cell.petAlbumItem.albumImage == nil) {
        NSString *imageName = [NSString stringWithFormat:@"5.jpg"];
        image = [UIImage imageNamed:imageName];
    }
    
    
    
    [cell.albumPhotoImageView setImage:image];
    
    return cell;
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
