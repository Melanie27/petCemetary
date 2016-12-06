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
//#import "PCImageLibraryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
//#import <Photos/Photos.h>
//@import Firebase;
//@import FirebaseDatabase;
//@import FirebaseStorage;

@interface EditPetPhotosTableViewController () <UITableViewDelegate, UITableViewDataSource, EditPetPhotosTableViewCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRStorage *storage;

@property (strong, nonatomic) UIAlertController *alertVC;
@property (strong, nonatomic) NSString *photoCaption;
@property (strong, nonatomic) UITextField *captionTextfield;
typedef void (^CaptionCompletionBlock)(NSString *photoCaption);
@end

@implementation EditPetPhotosTableViewController
PCDataSource *pc;
- (void)viewDidLoad {
    [super viewDidLoad];
   
     pc.editPhotosVC = self;
    //[pc retrievePets];
    self.title = @"Edit Photo Album";
    // Do any additional setup after loading the view.
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraPressed:)];
        self.navigationItem.rightBarButtonItem = cameraButton;
    }
    
     [self.tableView registerClass:[EditPetPhotosTableViewCell class] forCellReuseIdentifier:@"editCell"];
    
    [[PCDataSource sharedInstance] addObserver:self forKeyPath:@"albumPhotos" options:0 context:nil];

}


-(void)dealloc {
   
   
    //[[PCDataSource sharedInstance] removeObserver:self forKeyPath:@"albumPhotos"];
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

- (void) showViewController:(UIViewController *)vc andGetCaption:(NSString *)photoCaption {
    //TODO introspection
    
    self.alertVC = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Add a caption for the image you just posted.", @"send image instructions") preferredStyle:UIAlertControllerStyleAlert];
    
    [self.alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Caption", @"Caption");
    }];
    
    [self presentViewController:self.alertVC animated:YES completion:nil];
    [self.alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"cancel button") style:UIAlertActionStyleCancel handler:nil]];
    [self.alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Send", @"Send button") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.captionTextfield = self.alertVC.textFields[0];
        //NSLog(@"textfield text %@", self.captionTextfield);
        self.photoCaption = self.captionTextfield.text;
        //NSLog(@"textfield  %@", self.photoCaption);

        
    }]];
    
    //NSLog(@"photocap  %@", self.photoCaption);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  
    NSMutableDictionary *parameters = [@{} mutableCopy];
    [self showViewController:self.alertVC sender:picker];
    
    ////////
    
    
    //TODO show caption while image still on screen
    [picker dismissViewControllerAnimated:YES completion:^{
        [self showViewController:self.alertVC andGetCaption:self.photoCaption];
        if ((self.photoCaption == nil)) {
            self.photoCaption = @"";
            NSLog(@"photo caption in completion %@", self.photoCaption);
        }

        [parameters setObject:self.photoCaption forKey:@"photoCaption"];
        [parameters setObject:[info objectForKey:@"UIImagePickerControllerReferenceURL"] forKey:@"petImageURL"];

        [pc addImageWithDataDictionary:parameters];
        
    }];
    
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.pet.albumImageStrings.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Pet *pet = [PCDataSource sharedInstance].albumPhotos[indexPath.row];
    Pet *petPlaceholders = [PCDataSource sharedInstance].petItems[indexPath.row];
    //no album image property on photoAlbums so use the main object for placeholder
    UIImage *image= petPlaceholders.albumImage;
    
    if( petPlaceholders.albumImage == nil) {
        NSString *imageName = [NSString stringWithFormat:@"5.jpg"];
        image = [UIImage imageNamed:imageName];
    }
   CGFloat height =  [EditPetPhotosTableViewCell heightForPetItem:pet width:CGRectGetWidth(self.view.frame)];
    //TODO - need to impose a max height on all Table cells
    
    if (height > 50) {
        return height;
    } else {
        //NSLog(@"bad height %f",height);
        return 100.0;
    }
}

#pragma mark - Swipe to delete and KVO

//KVO
/*- (void) dealloc {
    [[PCDataSource sharedInstance] removeObserver:self forKeyPath:@"albumPhotos"];
}*/

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [PCDataSource sharedInstance] && [keyPath isEqualToString:@"albumPhotos"]) {
        NSKeyValueChange kindOfChange = [change[NSKeyValueChangeKindKey] unsignedIntegerValue];
        
        if (kindOfChange == NSKeyValueChangeRemoval) {
            // Someone set a brand new images array
            NSLog(@"item deleted");
            [self.tableView reloadData];
        }
        
        /*else if((kindOfChange = NSKeyValueChangeInsertion)) {
            NSLog(@"item inserted");
            [self.tableView reloadData];
        }*/
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //DELETE ALBUM PHOTO
        PCDataSource *pc = [PCDataSource sharedInstance];
        NSObject *petPhoto = [pc.albumPhotos objectAtIndex:[indexPath row]];
        [[PCDataSource sharedInstance] deleteAlbumPhoto:petPhoto];
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
