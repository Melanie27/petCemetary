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
    
    self.title = @"Photo Album";
    
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
    
       return self.pet.albumMedia.count;
    
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
   
    
    //TODO handle captions that go to a second line
    
    NSString *petCaptionString = cell.petAlbumItem.albumCaptionStrings[indexPath.row];
    
    NSMutableAttributedString *petCaptionMutableString = [[NSMutableAttributedString alloc]initWithString:petCaptionString];
    UIFont *font=[UIFont fontWithName:@"Didot" size:14.0f];
    [petCaptionMutableString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, petCaptionString.length)];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.attributedText = petCaptionMutableString;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    UIImage *image = self.pet.albumImages[indexPath.row];
    
    
    if( self.pet.albumImage == nil) {
        NSString *imageName = [NSString stringWithFormat:@"5.jpg"];
        image = [UIImage imageNamed:imageName];
    }
     CGFloat height =  [PetPhotosTableViewCell heightForPetItem:self.pet width:CGRectGetWidth(self.view.frame)];
    //TODO - need to impose a max height on all Table cells
    //NSLog(@"height %f", height);
    if (height > 50) {
        return height;
    } else {
        NSLog(@"bad height %f",height);
        return 400.0;
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
