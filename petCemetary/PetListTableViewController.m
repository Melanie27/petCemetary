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
    [[PCDataSource sharedInstance] addObserver:self forKeyPath:@"petItems" options:0 context:nil];
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
        cell.detailTextLabel.text = cell.pet.petType;
    //cell.detailTextLabel.text = cell.pet.petID;
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


- (void) dealloc {
    [[PCDataSource sharedInstance] removeObserver:self forKeyPath:@"petItems"];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [PCDataSource sharedInstance] && [keyPath isEqualToString:@"petItems"]) {
        NSKeyValueChange kindOfChange = [change[NSKeyValueChangeKindKey] unsignedIntegerValue];
        
        if (kindOfChange == NSKeyValueChangeRemoval) {
            // Someone set a brand new images array
            [self.tableView reloadData];
        } else if (kindOfChange == NSKeyValueChangeInsertion ||
                     kindOfChange == NSKeyValueChangeRemoval ||
                     kindOfChange == NSKeyValueChangeReplacement) {
            // We have an incremental change: inserted, deleted, or replaced images
            
            // Get a list of the index (or indices) that changed
            NSIndexSet *indexSetOfChanges = change[NSKeyValueChangeIndexesKey];
            
            // #1 - Convert this NSIndexSet to an NSArray of NSIndexPaths (which is what the table view animation methods require)
            NSMutableArray *indexPathsThatChanged = [NSMutableArray array];
            [indexSetOfChanges enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [indexPathsThatChanged addObject:newIndexPath];
            }];
            
            // #2 - Call `beginUpdates` to tell the table view we're about to make changes
            [self.tableView beginUpdates];
            
            // Tell the table view what the changes are
            if (kindOfChange == NSKeyValueChangeInsertion) {
                [self.tableView insertRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            } else if (kindOfChange == NSKeyValueChangeRemoval) {
                [self.tableView deleteRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            } else if (kindOfChange == NSKeyValueChangeReplacement) {
                [self.tableView reloadRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            // Tell the table view that we're done telling it about changes, and to complete the animation
            [self.tableView endUpdates];
        }
    }

}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        // Delete the row from the data source Delete Pet - this is working but it doesnt immediately disappear
       //Pet: 0x600000383dc0>
        NSMutableDictionary *petID = [@{} mutableCopy];
        [petID setObject:self.petID forKey:@"petID"];
        PCDataSource *pc = [PCDataSource sharedInstance];
        Pet *pet = [pc.petsByOwner objectAtIndex:[indexPath row]];
        NSLog(@"pet to delete %@", pet);
        [pc deletePetWithDataDictionary:petID andPet:pet];
        
       
        
        
       
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
