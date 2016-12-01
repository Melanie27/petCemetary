//
//  PetListTableViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/21/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PetListTableViewController.h"
#import "PetListTableViewCell.h"
#import "EditPetProfileViewController.h"
#import "PCDataSource.h"
#import "Pet.h"
#import <SDWebImage/UIImageView+WebCache.h>

@import Firebase;
@import FirebaseDatabase;
@import FirebaseStorage;

@interface PetListTableViewController () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, PetListTableViewCellDelegate>
    @property (nonatomic, strong)Pet *passPetToProfile;
@end

@implementation PetListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PCDataSource *pc = [PCDataSource sharedInstance];
    
    pc.pltVC = self;
    [pc retrievePets];
    
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
   
    return [PCDataSource sharedInstance].petsByOwner.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    //PetListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath ];
    PetListTableViewCell *cell = [[PetListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:@"cell"];
    // Configure the cell...
    Pet *pet;
   
    NSArray *petsArray = [PCDataSource sharedInstance].petItems;
    NSLog(@"pets array %@", petsArray);
     self.petNumber =  [petsArray indexOfObject:_pet];
    
    
    //[PCDataSource sharedInstance].petNumber = [petsArray indexOfObject:_pet];
    NSLog(@"pets number %lu", pet.petNumber);
    
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.delegate = self;
        cell.pet = [PCDataSource sharedInstance].petsByOwner[indexPath.row];
        [cell.contentView layoutSubviews];
        
    
        cell.textLabel.text = cell.pet.petName;
        cell.detailTextLabel.text = cell.pet.petBreed;
        NSString *petFeedUrlString = cell.pet.feedImageString;
        UIImage *image = cell.pet.feedImage;
        [cell.petThumbnailView sd_setImageWithURL:[NSURL URLWithString:petFeedUrlString]
                                 placeholderImage:[UIImage imageNamed:@"5.jpg"]];
        
    
    if( cell.pet.feedImage == nil) {
            NSString *imageName = [NSString stringWithFormat:@"5.jpg"];
            image = [UIImage imageNamed:imageName];
        }
        
    

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Pet *pet = [PCDataSource sharedInstance].petsByOwner[indexPath.row];
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
    }
    
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Only pet name and feed image string are available here

    Pet *petListByOwner = [PCDataSource sharedInstance].petsByOwner[indexPath.row];
    self.passPetToProfile = petListByOwner;
   
    PCDataSource *pc = [PCDataSource sharedInstance];
    pc.pet = self.passPetToProfile;
    //NSLog(@"pc pet %@", pc.pet);
    
    [self performSegueWithIdentifier:@"editPetProfile" sender:self];
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
        // Delete the row from the data source Delete Pet
        PCDataSource *pc = [PCDataSource sharedInstance];
        Pet *pet = [pc.petItems objectAtIndex:[indexPath row]];
        //[[PCDataSource sharedInstance] deletePet:pet];
        
        [[PCDataSource sharedInstance]deletePet:pet andCompletion:^(NSDictionary *snapshotValue) {
            
            NSLog(@"snap from block %@", snapshotValue);
            //[cell.profilePhoto setImage:user.profilePicture forState:UIControlStateNormal];
            
            
        }];
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"editPetProfile"]){
        EditPetProfileViewController *editProfileVC = (EditPetProfileViewController*)segue.destinationViewController;
        editProfileVC.pet = self.passPetToProfile;
        NSLog(@"segue to edit pet");
    
    }
    
}


@end
