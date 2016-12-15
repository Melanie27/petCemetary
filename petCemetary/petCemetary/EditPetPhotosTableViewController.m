
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
@import FirebaseDatabase;



@interface EditPetPhotosTableViewController () <UITableViewDelegate, UITableViewDataSource, EditPetPhotosTableViewCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIAlertController *alertVC;
@property (strong, nonatomic) FIRDatabaseReference *ref;
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
                                                   
                                                   
                                                   UITextField *alertTextField = alert.textFields.firstObject;
                                                    NSMutableDictionary *parameters = [@{} mutableCopy];
                                                    [parameters setObject:pc.pet.petID forKey:@"petID"];
                                                   
                                                   [parameters setObject:alertTextField.text forKey:@"photoCaption"];
                                                   [parameters setObject:[info objectForKey:@"UIImagePickerControllerReferenceURL"] forKey:@"petImageURL"];
                                                    [pc addImageWithDataDictionary:parameters];
                                                                                                      
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
    //[[PCDataSource sharedInstance] addImageWithDataDictionary:];
    EditPetPhotosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell.contentView layoutSubviews];
    cell.petAlbumItem  = self.pet;
    
    NSString *petPhotoUrlString = cell.petAlbumItem.albumImageStrings[indexPath.row];
    
    [cell.albumPhotoImageView sd_setImageWithURL:[NSURL URLWithString:petPhotoUrlString]
                                placeholderImage:[UIImage imageNamed:@"5.jpg"]];
    
    
    //TODO get the indiv image caption
    NSString *petCaptionString = cell.petAlbumItem.albumCaptionStrings[indexPath.row];
    NSMutableAttributedString *petCaptionMutableString = [[NSMutableAttributedString alloc]initWithString:petCaptionString];
    UIFont *font=[UIFont fontWithName:@"Didot" size:12.0f];
    [petCaptionMutableString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, petCaptionString.length)];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.attributedText = petCaptionMutableString;
    
    //cell.detailTextLabel.text = cell.pet.petID;
    self.pet.petType = cell.detailTextLabel.text;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Pet *pet = [PCDataSource sharedInstance].petItems[indexPath.row];
    
    UIImage *image = pet.albumImages[indexPath.row];
    
    if( pet.albumImage == nil) {
        NSString *imageName = [NSString stringWithFormat:@"5.jpg"];
        image = [UIImage imageNamed:imageName];
    }
    CGFloat height =  [EditPetPhotosTableViewCell heightForPetItem:pet width:CGRectGetWidth(self.view.frame)];
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
        NSLog(@"Observed: %@ of %@ was changed from %@ to %@", keyPath, object, oldValue, newValue);
            if (kindOfChange == NSKeyValueChangeRemoval) {
            // Someone set a brand new images array
                NSLog(@"item deleted");
                [self.tableView reloadData];
            }
        }
    }

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Do whatever data deletion you need to do...
        // Delete the row from the data source
        PCDataSource *pc = [PCDataSource sharedInstance];
        
        for (id key in pc.pet.albumMedia) {
            
            pc.pet.photoID = key;
            
        }
       
        
        NSMutableDictionary *photoInfo = [@{} mutableCopy];
        [photoInfo setObject:pc.pet.petID forKey:@"petID"];
        [photoInfo setObject:pc.pet.photoID forKey:@"photoID"];
        [pc deleteAlbumPhotoWithDataDictionary:photoInfo];
        
       
        
    
        
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
       
    }
     [tableView endUpdates];
  
}


@end



