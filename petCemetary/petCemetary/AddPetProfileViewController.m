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
    
    PCDataSource *pc = [PCDataSource sharedInstance];
    self.petNumber = pc.petNumber;
    NSLog(@"pet number %ld", self.petNumber);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    

}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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
//TODO check if this pet already exists before adding it - need unique id for pets


-(void)sendPetInfoToFirebase {
    self.ref = [[FIRDatabase database] reference];
    //NSMutableDictionary *addPetParameters = [@{} mutableCopy];
    //[addPetParameters setObject:self.petNameTextField.text forKey:@"pet"];
    
    //PCDataSource *pc = [PCDataSource sharedInstance];
    //[pc addNewPetWithDataDictionary:addPetParameters];
    
    NSString *savedPetName = self.petNameTextField.text;
    NSLog(@"saved pet name %@", savedPetName);
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
                                        [NSString stringWithFormat:@"/pets/%ld/pet/",[PCDataSource sharedInstance].petItems.count]:savedPetName,
                                        [NSString stringWithFormat:@"/pets/%ld/breed/",[PCDataSource sharedInstance].petItems.count]:savedAnimalBreed,
                                        [NSString stringWithFormat:@"/pets/%ld/animalType/",[PCDataSource sharedInstance].petItems.count]:savedAnimalType,
                                        [NSString stringWithFormat:@"/pets/%ld/dateOfBirth/",[PCDataSource sharedInstance].petItems.count]:savedDOB,
                                        [NSString stringWithFormat:@"/pets/%ld/dateOfDeath/",[PCDataSource sharedInstance].petItems.count]:savedDOD,
                                        [NSString stringWithFormat:@"/pets/%ld/ownerName/",[PCDataSource sharedInstance].petItems.count]:savedOwnerName,
                                        [NSString stringWithFormat:@"/pets/%ld/personality/",[PCDataSource sharedInstance].petItems.count]:savedPersonality,
                                        [NSString stringWithFormat:@"/pets/%ld/UID/", [PCDataSource sharedInstance].petItems.count]:userAuth.uid,
                                         [NSString stringWithFormat:@"/pets/%ld/feedPhoto/", [PCDataSource sharedInstance].petItems.count]:petImageString
                                       
                                        
                                        };
    [self.ref updateChildValues:petInfoCreation];
}




- (IBAction)savePetProfile:(id)sender {
    //TODO check if pet name exists otherwise send alert
    NSLog(@"this method should save the pet to the logged in user");
    [self sendPetInfoToFirebase];
    //[self sendPhotoToFirebase];
    
}

-(void)sendPhotoToFirebase {
    //NSMutableDictionary *parameters = [@{} mutableCopy];
    //[parameters setObject:[info objectForKey:@"UIImagePickerControllerReferenceURL"] forKey:@"petImageURL"];
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
    NSMutableDictionary *parameters = [@{} mutableCopy];
    [parameters setObject:[info objectForKey:@"UIImagePickerControllerReferenceURL"] forKey:@"petImageURL"];
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.uploadProfilePhotoButton setBackgroundImage:chosenImage forState:UIControlStateNormal];
    
    PCDataSource *pc = [PCDataSource sharedInstance];
    [pc addNewFeedPhotoWithDictionary:parameters];
    
    
    
    
    

}
@end
