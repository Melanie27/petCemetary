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
@property (nonatomic, strong)NSString *petID;
@end

@implementation PetListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PCDataSource *pc = [PCDataSource sharedInstance];
    //pc.pet.petID = self.petID;
    
    pc.pltVC = self;
   
   
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
  
        PetListTableViewCell *cell = [[PetListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:@"cell"];
    // Configure the cell...
   
    
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.delegate = self;
        cell.pet = [PCDataSource sharedInstance].petsByOwner[indexPath.row];
        [cell.contentView layoutSubviews];
        
    
        cell.textLabel.text = cell.pet.petName;
        //cell.detailTextLabel.text = cell.pet.petBreed;
    cell.detailTextLabel.text = cell.pet.petID;
    self.petID = cell.detailTextLabel.text;
       NSLog(@"pc.pet.petID %@", cell.pet.petID);
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
    

    Pet *petListByOwner = [PCDataSource sharedInstance].petsByOwner[indexPath.row];
    self.passPetToProfile = petListByOwner;
   
    PCDataSource *pc = [PCDataSource sharedInstance];
    pc.pet = self.passPetToProfile;
    
    
    [self performSegueWithIdentifier:@"editPetProfile" sender:self];
}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source Delete Pet
        NSMutableDictionary *petID = [@{} mutableCopy];
        [petID setObject:self.petID forKey:@"petID"];
        PCDataSource *pc = [PCDataSource sharedInstance];
        [pc deletePetWithDataDictionary:petID];
        
        
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"editPetProfile"]){
        EditPetProfileViewController *editProfileVC = (EditPetProfileViewController*)segue.destinationViewController;
        editProfileVC.pet = self.passPetToProfile;
        
    
    }
    
}


@end
