
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


@import Firebase;
@import FirebaseDatabase;
@import FirebaseStorage;




@interface EditPetPhotosTableViewController () <UITableViewDelegate, UITableViewDataSource, EditPetPhotosTableViewCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIAlertController *alertVC;
@property (nonatomic, strong)NSString *petID;
@property (nonatomic, strong)NSString *photoID;
@property BOOL *needToReloadData;
@property (nonatomic, strong) NSString *downloadURLString;
@property (strong, nonatomic) FIRDatabaseReference *ref;
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
                                                   
                                                   
                                                   UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
                                                   
                                                   UIImage *editedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
                                                   
                                                   [self dismissViewControllerAnimated:YES completion:NULL];
                                                   
                                                   UIImage *selectedImageFromPicker;
                                                   
                                                   if(editedImage) {
                                                       selectedImageFromPicker = editedImage;
                                                       
                                                       
                                                   } else {
                                                       selectedImageFromPicker = originalImage;
                                                       
                                                   }
                                                   
                                                  
                                                   
                                                   FIRStorage *storage = [FIRStorage storage];
                                                   FIRStorageReference *storageRef = [storage referenceForURL:@"gs://petcemetary-5fec2.appspot.com/petAlbums/"];
                                                   
                                                   NSString *imageID = [[NSUUID UUID] UUIDString];
                                                   NSString *imageName = [NSString stringWithFormat:@"%@.jpg",imageID];
                                                   FIRStorageReference *profileRef = [storageRef child:imageName];
                                                   FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
                                                   metadata.contentType = @"image/jpeg";
                                                   NSData *uploadData = UIImageJPEGRepresentation(selectedImageFromPicker, 0.8);
                                                   
                                                   
                                                   
                                                   [profileRef putData:uploadData metadata:metadata completion:^
                                                    (FIRStorageMetadata *metadata, NSError *error) {
                                                        if (error != nil) {
                                                            // Uh-oh, an error occurred!
                                                            NSLog(@"Firebase Image Storage error %@", error);
                                                        } else {
                                                            
                                                            NSURL *downloadURL = metadata.downloadURL;
                                                            NSString *downloadURLString = [ downloadURL absoluteString];
                                                            self.downloadURLString = downloadURLString;
                                                            NSLog(@"no error printe metadata %@", metadata);
                                                            //TODO Dismiss view controller back to pet list
                                                            self.ref = [[FIRDatabase database] reference];

                                                            NSString *photoKey = [[self.ref child:@"photos"] childByAutoId].key;
                                                            self.pet.photoID = photoKey;
                                                            //NSMutableDictionary *params = [parameters mutableCopy];
                                                            NSString *captionString = [parameters valueForKey:@"photoCaption"];
                                                            NSString *petIDString = [parameters valueForKey:@"petID"];
                                                            NSDictionary *childUpdates = @{
                                                                                           [NSString stringWithFormat:@"/pets/%@/photos/%@/photoUrl/", petIDString, photoKey]:downloadURLString,
                                                                                           [NSString stringWithFormat:@"/pets/%@/photos/%@/caption/", petIDString, photoKey]:captionString,
                                                                                           };
                                                            
                                                            [self.ref updateChildValues:childUpdates];
                                                        }
                                                    }];
                                                   
                                                //[pc addImageWithDataDictionary:parameters andPet:pet];
                                                   

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
    UIFont *font=[UIFont fontWithName:@"Didot" size:14.0f];
    [petCaptionMutableString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, petCaptionString.length)];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.attributedText = petCaptionMutableString;
    self.pet.petType = cell.detailTextLabel.text;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        return 400.0;
    }
}

#pragma mark - Swipe to delete


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        PCDataSource *pc = [PCDataSource sharedInstance];
              NSArray *keys = [pc.pet.albumMedia allKeys];
        NSObject *mediaToDelete = [keys objectAtIndex:[indexPath row]];
                pc.pet.photoIDString =[NSString stringWithFormat:@"%@", mediaToDelete];
        
        NSMutableDictionary *photoInfo = [@{} mutableCopy];
        [photoInfo setObject:pc.pet.petID forKey:@"petID"];
        [photoInfo setObject:pc.pet.photoIDString forKey:@"photoID"];
        [pc deleteAlbumPhotoWithDataDictionary:photoInfo andPet:mediaToDelete];
        
         [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  
    }
    
     [tableView reloadData];
}


@end



