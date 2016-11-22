//
//  PetsFeedTableViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/10/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PCDataSource.h"
#import "PetsFeedTableViewController.h"
#import "PetsFeedTableViewCell.h"
#import "PetProfileViewController.h"
#import "Pet.h"
#import "Owner.h"
#import <SDWebImage/UIImageView+WebCache.h>



@import Firebase;
@import FirebaseDatabase;
@import FirebaseStorage;

@interface PetsFeedTableViewController () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, PetsTableViewCellDelegate>

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRStorage *storageRef;
@property (nonatomic, strong)Pet *passPetToProfile;


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
    PCDataSource *ps = [PCDataSource sharedInstance];
    
    ps.pftVC = self;
    [ps retrievePets];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlDidFire:) forControlEvents:UIControlEventValueChanged];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    [self.tableView registerClass:[PetsFeedTableViewCell class] forCellReuseIdentifier:@"cell"];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) refreshControlDidFire:(UIRefreshControl *) sender {
    [[PCDataSource sharedInstance] requestNewPetsWithCompletionHandler:^(NSError *error) {
        [sender endRefreshing];
    }];
}

-(void) infiniteScrollIfNecessary {
    NSIndexPath *bottomIndexPath = [[self.tableView indexPathsForVisibleRows] lastObject];
    if(bottomIndexPath && bottomIndexPath.row == [PCDataSource sharedInstance].petItems.count - 1) {
        // The last cell is on screen
        [[PCDataSource sharedInstance] requestOldPetsWithCompletionHandler:nil];
        NSLog(@"infinite");
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self infiniteScrollIfNecessary];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [PCDataSource sharedInstance].petItems.count;
   

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    PetsFeedTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell.contentView layoutSubviews];
    cell.petItem = [PCDataSource sharedInstance].petItems[indexPath.row];
    
    
    //TODO SDWebImage and Caching
    NSString *petFeedUrlString = cell.petItem.feedImageString;
    UIImage *image = cell.petItem.feedImage;
    
    if( cell.petItem.feedImage == nil) {
        NSString *imageName = [NSString stringWithFormat:@"5.jpg"];
        image = [UIImage imageNamed:imageName];
    }

    
    [cell.petImageView sd_setImageWithURL:[NSURL URLWithString:petFeedUrlString]
                      placeholderImage:[UIImage imageNamed:@"5.jpg"]];
    
    cell.textLabel.text = cell.petItem.petName;
       return cell;
}



- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    Pet *pet = [PCDataSource sharedInstance].petItems[indexPath.row];
    UIImage *image = pet.feedImage;
    
    if( pet.feedImage == nil) {
        NSString *imageName = [NSString stringWithFormat:@"5.jpg"];
        image = [UIImage imageNamed:imageName];
    }
    
   
    CGFloat height =  [PetsFeedTableViewCell heightForPetItem:pet width:CGRectGetWidth(self.view.frame)];
    

    if (height > 50) {
        return height;
    } else {
        NSLog(@"bad height %f",height);
        return 100.0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PCDataSource *pc = [PCDataSource sharedInstance];
    NSInteger row = indexPath.row;
    Pet *p;
    p = pc.petItems[row];
    self.passPetToProfile = pc.petItems[row];
    pc.pet = self.passPetToProfile;
    
    [self performSegueWithIdentifier:@"showProfilePage" sender:self];
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


#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"showProfilePage"]) {
        NSLog(@"holla");
        PetProfileViewController *petProfileVC = (PetProfileViewController*)segue.destinationViewController;
        petProfileVC.pet = self.passPetToProfile;
       
    }
}


@end
