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


-(void)sendPetInfoToFirebase {
    self.ref = [[FIRDatabase database] reference];
    NSMutableDictionary *addPetParameters = [@{} mutableCopy];
    [addPetParameters setObject:self.petNameTextField.text forKey:@"petName"];
    [addPetParameters setObject:self.animalTypeTextField.text forKey:@"petType"];
     [addPetParameters setObject:self.animalBreedTextField.text forKey:@"petBreed"];
    [addPetParameters setObject:self.dobTextField.text forKey:@"dob"];
    [addPetParameters setObject:self.dodTextField.text forKey:@"dod"];
    
    [addPetParameters setObject:self.animalPersonalityTextView.text forKey:@"personality"];
    [addPetParameters setObject:self.ownerNameTextField.text forKey:@"ownerName"];
    
    NSString *petImageString = @"https://firebasestorage.googleapis.com/v0/b/petcemetary-5fec2.appspot.com/o/petFeed%2Fspooky.png?alt=media&token=58e1b0af-a087-4028-a208-90ff8622f850";
    [addPetParameters setObject:petImageString forKey:@"placeholderImage"];
    
    PCDataSource *pc = [PCDataSource sharedInstance];
    [pc addNewPetWithDataDictionary:addPetParameters];
    
}


- (IBAction)savePetProfile:(id)sender {
    //TODO check if pet name exists otherwise send alert
    NSLog(@"this method should save the pet to the logged in user");
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSMutableDictionary *parameters = [@{} mutableCopy];
    [parameters setObject:[info objectForKey:@"UIImagePickerControllerReferenceURL"] forKey:@"petImageURL"];
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.uploadProfilePhotoButton setBackgroundImage:chosenImage forState:UIControlStateNormal];
    
    PCDataSource *pc = [PCDataSource sharedInstance];
    [pc addNewFeedPhotoWithDictionary:parameters];

}
@end
