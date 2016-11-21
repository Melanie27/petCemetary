//
//  PetListTableViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/21/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PetListTableViewController.h"
#import "PetListTableViewCell.h"
#import "PCDataSource.h"
#import "Pet.h"
#import <SDWebImage/UIImageView+WebCache.h>

@import Firebase;
@import FirebaseDatabase;
@import FirebaseStorage;

@interface PetListTableViewController () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, PetListTableViewCellDelegate>

@end

@implementation PetListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PCDataSource *pc = [PCDataSource sharedInstance];
    
    pc.pltVC = self;
     [[PCDataSource sharedInstance]retrievePetWithUID:(NSString *)_ownerUID andCompletion:^(Pet *pet) {
         
     }];
    //[ps retrievePets];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
     [self.tableView registerClass:[PetListTableViewCell class] forCellReuseIdentifier:@"cell"];
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
    NSLog(@"pets by owner count %lu",  (unsigned long)[PCDataSource sharedInstance].petsByOwner.count);
         return [PCDataSource sharedInstance].petsByOwner.count;
    
    
    
    //return [PCDataSource sharedInstance].petItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PetListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //cell.delegate = self;
    //[cell.contentView layoutSubviews];
    //cell.pet = [PCDataSource sharedInstance].petsByOwner[indexPath.row];
    //NSLog(@"cell pets %@", cell.pet);
    // Configure the cell...
   
   
    [[PCDataSource sharedInstance]retrievePetWithUID:(NSString *)cell.pet.ownerUID andCompletion:^(Pet *pet) {
        NSLog(@"hello");
        cell.pet = [PCDataSource sharedInstance].petsByOwner[indexPath.row];
        NSLog(@"cell pet %@", cell.pet);
        cell.textLabel.text = cell.pet.petName;
       
        NSString *petFeedUrlString = cell.pet.feedImageString;
        UIImage *image = cell.pet.feedImage;
        [cell.petThumbnailView sd_setImageWithURL:[NSURL URLWithString:petFeedUrlString]
                                 placeholderImage:[UIImage imageNamed:@"5.jpg"]];
        
        if( cell.pet.feedImage == nil) {
            NSString *imageName = [NSString stringWithFormat:@"5.jpg"];
            image = [UIImage imageNamed:imageName];
        }
    }];
    
    
    
    
    
   
    //cell.imageView.image = [UIImage imageNamed:@"5.jpg"];
    
    //cell.textLabel.text = @"Edit Your pet's album";
    //cell.detailTextLabel.text = @"pet name";
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*Pet *pet = [PCDataSource sharedInstance].petItems[indexPath.row];
    UIImage *image = pet.feedImage;
    
    if( pet.feedImage == nil) {
        NSString *imageName = [NSString stringWithFormat:@"5.jpg"];
        image = [UIImage imageNamed:imageName];
    }
    
    
    CGFloat height =  [PetListTableViewCell heightForPetItem:pet width:CGRectGetWidth(self.view.frame)];
    
    
    if (height > 50) {
        return height;
    } else {
        NSLog(@"bad height %f",height);
        return 100.0;
    }*/
    
    return 150;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
