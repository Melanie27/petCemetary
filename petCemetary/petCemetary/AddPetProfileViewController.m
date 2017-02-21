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
#import "EditPetPhotosTableViewController.h"

@interface AddPetProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSString *downloadURLString2;
@property (nonatomic, strong) NSMutableDictionary *addPetParameters;

@end

@implementation AddPetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Add Pet";

}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.view.frame;
    CGRect keyboardFrameEnd = [self.view convertRect:keyboardEndFrame toView:nil];
    CGRect keyboardFrameBegin = [self.view convertRect:keyboardBeginFrame toView:nil];
    
    newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y);
    self.view.frame = newFrame;
    
    [UIView commitAnimations];
}


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


-(void)sendPetInfoToFirebase {
    
    NSMutableDictionary *addPetParameters = [@{} mutableCopy];
    PCDataSource *pc = [PCDataSource sharedInstance];
    
    if ( self.petNameTextField.text.length == 0) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle: @"Please add a pet name"
                                    message: @""
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler: nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
         
    } else {
       
        Pet *pet = [[Pet alloc] init];
        
        [addPetParameters setObject:self.petNameTextField.text forKey:@"petName"];
        [addPetParameters setObject:self.animalTypeTextField.text forKey:@"petType"];
       
        [addPetParameters setObject:self.dobTextField.text forKey:@"dob"];
        [addPetParameters setObject:self.dodTextField.text forKey:@"dod"];
        
        [addPetParameters setObject:self.animalPersonalityTextView.text forKey:@"personality"];
        [addPetParameters setObject:self.ownerNameTextField.text forKey:@"ownerName"];
        //[addPetParameters setObject:self.downloadURLString forKey:@"feedPhoto"];
        NSString *petImageString = self.downloadURLString2;
        if ([self.downloadURLString2 length] == 0) {
            //NSLog(@"no image was uploaded" );
            petImageString = @"https://firebasestorage.googleapis.com/v0/b/petcemetary-5fec2.appspot.com/o/petFeed%2FprofilePlaceholder.png?alt=media&token=c5d106a3-d5d0-4d69-8732-a29bf1f3542c";
            [addPetParameters setObject:petImageString forKey:@"placeholderImage"];
        }
        
        [addPetParameters setObject:petImageString forKey:@"placeholderImage"];
        [pc addNewPetWithDataDictionary:addPetParameters andPet:pet];
        UIAlertController *alertSaved = [UIAlertController
                                    alertControllerWithTitle: @"Thank you for starting your pet's memorial"
                                    message: @"Please add photos of your pet to its album."
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler: nil];
        [alertSaved addAction:cancel];
        [self presentViewController:alertSaved animated:YES completion:^(){
            //TODO pop back a level
            //[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
           
        }];
        //[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    
    
 
}


- (IBAction)savePetProfile:(id)sender {
    
    [self sendPetInfoToFirebase];

}




#pragma mark - UIImagePicker Delegate Methods

- (IBAction)uploadProfilePhoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
   
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    
    //NSMutableDictionary *parameters = [@{} mutableCopy];
    //[parameters setObject:[info objectForKey:@"UIImagePickerControllerReferenceURL"] forKey:@"petImageURL"];

    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSLog(@"print info %@", originalImage);
    
    UIImage *editedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage *selectedImageFromPicker;
    
    if(editedImage) {
        selectedImageFromPicker = editedImage;
        
        
    } else {
        selectedImageFromPicker = originalImage;
        
    }
    
    
    
    [self.uploadProfilePhotoButton setBackgroundImage:selectedImageFromPicker forState:UIControlStateNormal];
    
    [[PCDataSource sharedInstance]addNewFeedPhotoWithStorageRefURL:@"gs://petcemetary-5fec2.appspot.com///petAlbums/" andUploadDataSelectedImage:selectedImageFromPicker andCompletion:^(NSString *downloadURLString)  {
        NSLog(@"completion?");
        downloadURLString = self.downloadURLString2;
    }];
    
    
    
    /*FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage referenceForURL:@"gs://petcemetary-5fec2.appspot.com/petAlbums/"];
    
    NSString *imageID = [[NSUUID UUID] UUIDString];
    NSString *imageName = [NSString stringWithFormat:@"Profile Pictures/%@.jpg",imageID];
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
             //NSLog(@"no error printe metadata %@", metadata);
            
             
         }
     }];*/
    
   

}
@end
