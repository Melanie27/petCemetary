//
//  PetsFeedTableViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/10/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PCDataSource.h"
#import "PetsFeedTableViewController.h"
//#import "PetsFeedTableViewCell.h"
#import "Pet.h"
#import "Owner.h"



//@import Firebase;
//@import FirebaseDatabase;
//@import FirebaseStorage;

@interface PetsFeedTableViewController () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

//@property (strong, nonatomic) FIRDatabaseReference *ref;
//@property (strong, nonatomic) FIRStorage *storageRef;


@end

@implementation PetsFeedTableViewController

//Override the table view controller's initializer to create an empty array
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[PCDataSource sharedInstance].pftVC = self;
    //[[PCDataSource sharedInstance] retrievePets];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PetCell"];
    
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
    
    return [PCDataSource sharedInstance].petItems.count;
   
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PetCell" forIndexPath:indexPath];
 
    //PetsFeedTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    //cell.delegate = self;
    
    //[cell.contentView layoutSubviews];
    //cell.pet = [PCDataSource sharedInstance].pets[indexPath.row];
 
    
    // Configure the cell...
    static NSInteger imageViewTag = 1234;
    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:imageViewTag];
    
    // #3
    if (!imageView) {
        // This is a new cell, it doesn't have an image view yet
        imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        imageView.frame = cell.contentView.bounds;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        imageView.tag = imageViewTag;
        [cell.contentView addSubview:imageView];
    }
    
    Pet *pet = [PCDataSource sharedInstance].petItems[indexPath.row];
    imageView.image = pet.feedImage;

    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    Pet *pet = [PCDataSource sharedInstance].petItems[indexPath.row];
    UIImage *image = pet.feedImage;
    return image.size.height / image.size.width * CGRectGetWidth(self.view.frame);
    
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
