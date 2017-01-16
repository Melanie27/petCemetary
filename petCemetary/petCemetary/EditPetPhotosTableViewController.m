
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

#import <SDWebImage/UIImageView+WebCache.h>
#import <Photos/Photos.h>




@interface EditPetPhotosTableViewController () <UITableViewDelegate, UITableViewDataSource, EditPetPhotosTableViewCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIAlertController *alertVC;
@property (nonatomic, strong)NSString *petID;
@property (nonatomic, strong)NSString *photoID;
@property BOOL *needToReloadData;
@end

@implementation EditPetPhotosTableViewController
PCDataSource *pc;
Pet *pet;
- (void)viewDidLoad {
    [super viewDidLoad];
    pc = [PCDataSource sharedInstance];
    pc.editPhotosVC = self;
    
    self.title = @"Edit Photo Album";
    // Do any additional setup after loading the view.
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraPressed:)];
        self.navigationItem.rightBarButtonItem = cameraButton;
    }
    
    [self.tableView registerClass:[EditPetPhotosTableViewCell class] forCellReuseIdentifier:@"editCell"];
    
    //TODO add observer to the key?
    
    [[PCDataSource sharedInstance] addObserver:self forKeyPath:@"albumMedia" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Camera PCImageLibraryViewControllerDelegate

- (void) cameraPressed:(UIBarButtonItem *) sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        NSLog(@"sender %@", sender);
        //NSLog(@"pet id check from camera%@", pc.pet.petID);
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle: @"Add a caption for the image you just posted"
                                message: @"Captions are Optional"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action){
                                                   
                                                   //Pet *pet = self.pet;
                                                   UITextField *alertTextField = alert.textFields.firstObject;
                                                    NSMutableDictionary *parameters = [@{} mutableCopy];
                                                   //TODO CRASHING WHEN you add multiple photos, pet id not set second time
                                                   NSLog(@"pet id check %@", pc.pet.petID);
                                                   [parameters setObject:pc.pet.petID forKey:@"petID"];
                                                   
                                                   [parameters setObject:alertTextField.text forKey:@"photoCaption"];
                                                   [parameters setObject:[info objectForKey:@"UIImagePickerControllerReferenceURL"] forKey:@"petImageURL"];
                                                   
                                                   [pc addImageWithDataDictionary:parameters andPet:pet];
                                                   [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                                                }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                   handler: nil];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.placeholder = @"Text here";
        
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];

    [picker dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:alert animated:YES completion:nil];
        
       
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.pet.albumMedia.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    EditPetPhotosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell.contentView layoutSubviews];
    cell.petAlbumItem  = self.pet;
    
    NSString *petPhotoUrlString = cell.petAlbumItem.albumImageStrings[indexPath.row];
    
    [cell.albumPhotoImageView sd_setImageWithURL:[NSURL URLWithString:petPhotoUrlString]
                                placeholderImage:[UIImage imageNamed:@"5.jpg"]];
    
    NSString *petCaptionString = cell.petAlbumItem.albumCaptionStrings[indexPath.row];
    NSMutableAttributedString *petCaptionMutableString = [[NSMutableAttributedString alloc]initWithString:petCaptionString];
    UIFont *font=[UIFont fontWithName:@"Didot" size:12.0f];
    [petCaptionMutableString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, petCaptionString.length)];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.attributedText = petCaptionMutableString;
    self.pet.petType = cell.detailTextLabel.text;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Pet *pet = [PCDataSource sharedInstance].petItems[indexPath.row];
    
    UIImage *image = pet.albumImages[indexPath.row];
    
    if( self.pet.albumImage == nil) {
        NSString *imageName = [NSString stringWithFormat:@"5.jpg"];
        image = [UIImage imageNamed:imageName];
    }
    CGFloat height =  [EditPetPhotosTableViewCell heightForPetItem:self.pet width:CGRectGetWidth(self.view.frame)];
    //TODO - need to impose a max height on all Table cells
    
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
    [[PCDataSource sharedInstance] removeObserver:self forKeyPath:@"albumMedia"];
 }

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
   
    if (object == [PCDataSource sharedInstance] && [keyPath isEqualToString:@"albumMedia"]) {
        NSKeyValueChange kindOfChange = [change[NSKeyValueChangeKindKey] unsignedIntegerValue];
        NSString *oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        NSString *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        
            if (kindOfChange == NSKeyValueChangeRemoval) {
            // Someone set a brand new images array
                NSLog(@"item deleted");
                [self.tableView reloadData];
            }
        
            else if (kindOfChange == NSKeyValueChangeInsertion) {
                NSLog(@"item inserted");
                NSLog(@"Observed: %@ of %@ was changed from %@ to %@", keyPath, object, oldValue, newValue);
                [self.tableView reloadData];
            }
        }
    }

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        PCDataSource *pc = [PCDataSource sharedInstance];
       
        NSObject *mediaToDelete = [pc.albumMedia objectAtIndex:[indexPath row]];
        NSLog(@"media to delete %@", mediaToDelete);
        //TODO - getting the wrong key for deletion
        
        /*
        for (id key in pc.pet.albumMedia) {
            pc.pet.photoID = key;
            pc.pet.photoID = pc.albumMedia[indexPath.row].photoID;

            NSLog(@"key %@", key);
            
        }
        */
        //pc.pet.photoID = mediaToDelete
       
        
        NSMutableDictionary *photoInfo = [@{} mutableCopy];
        [photoInfo setObject:pc.pet.petID forKey:@"petID"];
        [photoInfo setObject:pc.pet.photoID forKey:@"photoID"];
        [pc deleteAlbumPhotoWithDataDictionary:photoInfo andPet:mediaToDelete];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
       
        
    
        
        
       
    }
     [tableView endUpdates];
     [tableView reloadData];
}


@end



