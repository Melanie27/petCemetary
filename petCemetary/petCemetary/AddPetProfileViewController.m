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

@interface AddPetProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate> {
    

    
}
@end

@implementation AddPetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Add Pet";
    [[PCDataSource sharedInstance]retrievePets];
    NSArray *petsArray = [PCDataSource sharedInstance].petItems;
    NSUInteger index;
    for (Pet *pet in petsArray) {
        index = [petsArray indexOfObject:pet];
        self.petNumber = index;
        NSLog(@"petindex %lu", (unsigned long)index);
        NSLog(@" addpet %ld", pet.petNumber);
        pet.petNumber = self.petNumber;
    }
    NSLog(@"melpets addpet %ld", self.petNumber);
    self.newPetNumber = self.petNumber + 1;
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - date picker



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

//TODO if certain fields are empty don't save
//TODO check if this pet already exists before adding it - need unique id for pets


-(void)sendPetInfoToFirebase {
    self.ref = [[FIRDatabase database] reference];
    
    NSString *savedPetName = self.petNameTextField.text;
    NSString *savedAnimalType = self.animalTypeTextField.text;
    NSString *savedAnimalBreed = self.animalBreedTextField.text;
    NSString *savedDOB = self.dobTextField.text;
    NSString *savedDOD = self.dodTextField.text;
    NSString *savedPersonality = self.animalPersonalityTextView.text;
    NSString *savedOwnerName = self.ownerNameTextField.text;
    NSString *petImageString = @"https://firebasestorage.googleapis.com/v0/b/petcemetary-5fec2.appspot.com/o/petFeed%2Fspooky.png?alt=media&token=58e1b0af-a087-4028-a208-90ff8622f850";
    FIRUser *userAuth = [FIRAuth auth].currentUser;
    
    self.ref = [[FIRDatabase database] reference];
    NSDictionary *petInfoCreation = @{
                                        [NSString stringWithFormat:@"/pets/%ld/pet/",(unsigned long)self.newPetNumber]:savedPetName,
                                        [NSString stringWithFormat:@"/pets/%ld/breed/",(unsigned long)self.newPetNumber]:savedAnimalBreed,
                                        [NSString stringWithFormat:@"/pets/%ld/animalType/",(unsigned long)self.newPetNumber]:savedAnimalType,
                                        [NSString stringWithFormat:@"/pets/%ld/dateOfBirth/",(unsigned long)self.newPetNumber]:savedDOB,
                                        [NSString stringWithFormat:@"/pets/%ld/dateOfDeath/",(unsigned long)self.newPetNumber]:savedDOD,
                                        [NSString stringWithFormat:@"/pets/%ld/ownerName/",(unsigned long)self.newPetNumber]:savedOwnerName,
                                        [NSString stringWithFormat:@"/pets/%ld/personality/",(unsigned long)(unsigned long)self.newPetNumber]:savedPersonality,
                                        [NSString stringWithFormat:@"/pets/%ld/UID/", (unsigned long)(unsigned long)self.newPetNumber]:userAuth.uid,
                                         [NSString stringWithFormat:@"/pets/%ld/feedPhoto/", (unsigned long)self.newPetNumber]:petImageString
                                       
                                        
                                        };
    [self.ref updateChildValues:petInfoCreation];
}



- (IBAction)savePetProfile:(id)sender {
    NSLog(@"this method should save the pet to the logged in user");
    [self sendPetInfoToFirebase];
    [self sendPhotoToFirebase];
    
}

-(void)sendPhotoToFirebase {
    
    /*PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[self.petImageURL] options:nil];
    
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        
        [asset requestContentEditingInputWithOptions:kNilOptions
                                   completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
                                       NSURL *imageURL = contentEditingInput.fullSizeImageURL;
                                       NSLog(@"imageURL %@", imageURL );
                                       NSString *localURLString = [imageURL path];
                                       NSLog(@"local url string %@", localURLString);
                                       NSString *theFileName = [[localURLString lastPathComponent] stringByDeletingPathExtension];
                                       [[PCDataSource sharedInstance]saveFeedPhoto];
                                       //MOVE THIS STUFF
                                       
                                       
                                       FIRStorage *storage = [FIRStorage storage];
                                       FIRStorageReference *storageRef = [storage referenceForURL:@"gs://petcemetary-5fec2.appspot.com/petFeed/"];
                                       FIRStorageReference *profileRef = [storageRef child:theFileName];
                                       NSLog(@"profileRef %@", profileRef);
                                       FIRStorageUploadTask *uploadTask = [profileRef putFile:imageURL metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
                                           if (error != nil) {
                                               // Uh-oh, an error occurred!
                                               NSLog(@"error %@", error);
                                           } else {
                                               NSURL *downloadURL = metadata.downloadURL;
                                               NSString *downloadURLString = [ downloadURL absoluteString];
                                               
                                               //push the selected photo to database
                                               FIRDatabaseQuery *pathStringQuery = [[self.ref child:[NSString stringWithFormat:@"/pets/%ld/", (unsigned long)[PCDataSource sharedInstance].petItems.count]] queryLimitedToFirst:1000];
                                               
                                               [pathStringQuery
                                                observeEventType:FIRDataEventTypeValue
                                                withBlock:^(FIRDataSnapshot *snapshot) {
                                                    //TODO - not seeing the correct image --WHAT IS THIS CODE DOING?? DO I NEED IT?
                                                    //static NSInteger imageViewTag = 54321;
                                                    //UIImageView *imgView = (UIImageView*)[[collectionView cellForItemAtIndexPath:indexPath] viewWithTag:imageViewTag];
                                                    //UIImage *img = imgView.image;
                                                    //[[BLCDataSource sharedInstance] setUserImage:img];
                                                    
                                                    
                                                }];
                                               
                                               NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/pets/%ld/feedPhoto/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:downloadURLString};
                                               
                                               [self.ref updateChildValues:childUpdates];
                                               
                                               
                                           }
                                       }];
                                   }];
        
    }];*/
}

#pragma mark - UIImagePicker Delegate Methods

- (IBAction)uploadProfilePhoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
        //NSLog(@"trigger the image library");
    }
   
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.ref = [[FIRDatabase database] reference];
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self.uploadProfilePhotoButton setBackgroundImage:chosenImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:NULL];
  
    self.petImageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[self.petImageURL] options:nil];
    
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        
        [asset requestContentEditingInputWithOptions:kNilOptions
                                   completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
                                       NSURL *imageURL = contentEditingInput.fullSizeImageURL;
                                       NSLog(@"imageURL %@", imageURL );
                                       NSString *localURLString = [imageURL path];
                                       NSLog(@"local url string %@", localURLString);
                                       NSString *theFileName = [[localURLString lastPathComponent] stringByDeletingPathExtension];
                                       [[PCDataSource sharedInstance]saveFeedPhoto];
                                       //MOVE THIS STUFF
                                       
                                       
                                       FIRStorage *storage = [FIRStorage storage];
                                       FIRStorageReference *storageRef = [storage referenceForURL:@"gs://petcemetary-5fec2.appspot.com/petFeed/"];
                                       FIRStorageReference *profileRef = [storageRef child:theFileName];
                                       NSLog(@"profileRef %@", profileRef);
                                       FIRStorageUploadTask *uploadTask = [profileRef putFile:imageURL metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
                                           if (error != nil) {
                                               // Uh-oh, an error occurred!
                                               NSLog(@"error %@", error);
                                           } else {
                                               NSURL *downloadURL = metadata.downloadURL;
                                               NSString *downloadURLString = [ downloadURL absoluteString];
                                               
                                               //push the selected photo to database
                                               FIRDatabaseQuery *pathStringQuery = [[self.ref child:[NSString stringWithFormat:@"/pets/%ld/", (unsigned long)[PCDataSource sharedInstance].petItems.count]] queryLimitedToFirst:1000];
                                               
                                               [pathStringQuery
                                                observeEventType:FIRDataEventTypeValue
                                                withBlock:^(FIRDataSnapshot *snapshot) {
                                                    //TODO - not seeing the correct image --WHAT IS THIS CODE DOING?? DO I NEED IT?
                                                    //static NSInteger imageViewTag = 54321;
                                                    //UIImageView *imgView = (UIImageView*)[[collectionView cellForItemAtIndexPath:indexPath] viewWithTag:imageViewTag];
                                                    //UIImage *img = imgView.image;
                                                    //[[BLCDataSource sharedInstance] setUserImage:img];
                                                    
                                                    
                                                }];
                                               
                                               NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/pets/%ld/feedPhoto/", (unsigned long)[PCDataSource sharedInstance].petItems.count]:downloadURLString};
                                               
                                               [self.ref updateChildValues:childUpdates];
                                               
                                               
                                           }
                                       }];
                                   }];
        
    }];
    

}
@end
