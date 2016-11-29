//
//  AddPetProfileViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/15/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "AddPetProfileViewController.h"
#import "PCDataSource.h"
#import <Photos/Photos.h>
#import "Pet.h"

@interface AddPetProfileViewController () <UIImagePickerControllerDelegate> {
    UIDatePicker *datePicker;
    
}
@end

@implementation AddPetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Add Pet";
    [[PCDataSource sharedInstance]retrievePets];
    
    
    self.dobTextField.delegate = self;
    
    //init date picker and optionally set its initial state
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDate:[NSDate date]];
    // the date formatter used to convert string to date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // the specific format to use
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    // converting string to date
    // set the mode
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    // update the textfield with the date everytime it changes with selector defined below
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    
}


#pragma mark - date picker

-(void)updateTextField:(id)sender {
    
    UIDatePicker *picker = (UIDatePicker*)self.dobTextField.inputView;
    self.dobTextField.text = [self formatDate:picker.date];
    NSLog(@"dob text %@", self.dobTextField.text);
    
}

-(NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
   
    
    
    
   
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

//TODO if certain fields are empty don't save
//TODO check if this pet already exists before adding it
//TODO - need to notify the feed when this happens
- (IBAction)savePetProfile:(id)sender {
    
    NSLog(@"this method should save the pet to the logged in user");
    NSString *savedPetName = self.petNameTextField.text;
    NSString *savedAnimalType = self.animalTypeTextField.text;
    NSString *savedAnimalBreed = self.animalBreedTextField.text;
    NSString *savedPersonality = self.animalPersonalityTextField.text;
    NSString *savedOwnerName = self.ownerNameTextField.text;
    NSString *petImageString = @"https://firebasestorage.googleapis.com/v0/b/petcemetary-5fec2.appspot.com/o/petFeed%2Fspooky.png?alt=media&token=58e1b0af-a087-4028-a208-90ff8622f850";
    self.ref = [[FIRDatabase database] reference];
    FIRUser *userAuth = [FIRAuth auth].currentUser;
    NSDictionary *childUpdates = @{
                                   
                                   [NSString stringWithFormat:@"/pets/%ld/pet/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:savedPetName,
                                   [NSString stringWithFormat:@"/pets/%ld/animalType/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:savedAnimalType,
                                   [NSString stringWithFormat:@"/pets/%ld/breed/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:savedAnimalBreed,
                                   [NSString stringWithFormat:@"/pets/%ld/personality/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:savedPersonality,
                                   [NSString stringWithFormat:@"/pets/%ld/ownerName/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:savedOwnerName,
                                   [NSString stringWithFormat:@"/pets/%ld/feedPhoto/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:petImageString,
                                   [NSString stringWithFormat:@"/pets/%ld/UID/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:userAuth.uid
                                   };
    
    [_ref updateChildValues:childUpdates];
    
    
}

#pragma mark - UIImagePicker Delegate Methods

- (IBAction)uploadProfilePhoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
        NSLog(@"trigger the image library");
    }
   
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
     NSLog(@"pick an image %@",info);
    [self.uploadProfilePhotoButton setBackgroundImage:chosenImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:NULL];
  
    
    
    NSURL *petImageURL = info[UIImagePickerControllerReferenceURL];
    NSLog(@"pet image url %@", petImageURL);
    NSString *imagePath = [petImageURL path];
    NSLog(@"path %@",imagePath);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imagePath];
     NSLog(@"get image path %@",getImagePath);
    //NSURL *docPathUrl = [NSURL URLWithString:getImagePath];
    NSURL *docPathUrl = [NSURL fileURLWithPath:getImagePath];
     NSLog(@"doc path url %@",docPathUrl);
     FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage referenceForURL:@"gs://petcemetary-5fec2.appspot.com/petFeed/"];
   
    
    NSString *localURLString = [docPathUrl path];
    NSString *theFileName = [[localURLString lastPathComponent] stringByDeletingPathExtension];
   
    FIRStorageReference *profileRef = [storageRef child:theFileName];
     NSLog(@"profileRef %@", profileRef);
     //FIRStorageUploadTask *uploadTask = [storageRef putFile:docPathUrl metadata:nil];
    //NSLog(@"upload tast %@", uploadTask);
    
    /*FIRStorageUploadTask *uploadTask = [profileRef putFile:docPathUrl metadata:metadata completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error != nil) {
            // Uh-oh, an error occurred!
            NSLog(@"error %@", error);
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            //NSURL *downloadURL = metadata.downloadURL;
            NSLog(@"no error %@", metadata);
        }
    }];*/
    
    //NSString *petImagePath  = [NSString stringWithFormat:@"%@", petImageURL];
     //NSLog(@"pet string %@",petImagePath);
    /*NSDictionary *childUpdates = @{
     
                                   [NSString stringWithFormat:@"/pets/%ld/feedPhoto/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:petImageURL,
                                   [NSString stringWithFormat:@"/pets/%ld/UID/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:userAuth.uid
                                   };
    
    [_ref updateChildValues:childUpdates];*/
   
}
@end
