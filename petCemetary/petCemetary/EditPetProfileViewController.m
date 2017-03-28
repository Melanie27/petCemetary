//
//  EditPetProfileViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/22/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "EditPetProfileViewController.h"
#import "EditPetPhotosTableViewController.h"
#import "PCDataSource.h"
#import "Pet.h"


@interface EditPetProfileViewController () <UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSString *downloadURLString2;
@end

@implementation EditPetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"Edit Profile";
    PCDataSource *pc = [PCDataSource sharedInstance];
    pc.editProfileVC = self;
   
    self.petNameTextField.text = _pet.petName;
    //TODO - dates in a certain format - alert if entered incorrectly
    self.dobTextField.text = _pet.petDOB;
    self.dodTextField.text = _pet.petDOD;
    self.animalTypeTextField.text = _pet.petType;
    self.animalPersonalityTextView.text = _pet.petPersonality;
    self.ownerNameTextField.text = _pet.ownerName;
   
    
    
    NSString *petProfileString = _pet.feedImageString;
    NSURL *petProfileUrl=[NSURL URLWithString:petProfileString];
    UIImage *savedProfileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:petProfileUrl]];
    
    [self.uploadProfilePhotoButton setBackgroundImage:savedProfileImage forState:UIControlStateNormal];
     self.uploadProfilePhotoButton.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.animalPersonalityTextView setReturnKeyType:UIReturnKeyDone];
    self.animalPersonalityTextView.delegate = self;
    
}

/*- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}*/

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
    
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
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
        
        self.downloadURLString2 = downloadURLString;

    }];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}*/


-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)sender
{
    if ([sender isEqual:@"\n"])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= rect.size.height/2;
        rect.size.height += rect.size.height/2;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += rect.size.height/3;
        rect.size.height -= rect.size.height/3;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void)sendPetInfoToFirebase {
    NSMutableDictionary *editPetParameters = [@{} mutableCopy];
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
        
        [editPetParameters setObject:pc.pet.petID forKey:@"petID"];
        [editPetParameters setObject:self.petNameTextField.text forKey:@"petName"];
        [editPetParameters setObject:self.animalTypeTextField.text forKey:@"petType"];
        [editPetParameters setObject:self.dobTextField.text forKey:@"dob"];
        [editPetParameters setObject:self.dodTextField.text forKey:@"dod"];
        [editPetParameters setObject:self.animalPersonalityTextView.text forKey:@"personality"];
        [editPetParameters setObject:self.ownerNameTextField.text forKey:@"ownerName"];
         
        
        //IS this check even necessary - there should already be something in there even it is the placeholder
        //test if the image string changed and only edit if it did - right now saving changes deletes pet photo
        if ([self.downloadURLString2 length] != 0) {
            //if the image has been changed
            [editPetParameters setObject:self.downloadURLString2 forKey:@"feedPhoto"];
        }else {
            [editPetParameters setObject:pc.pet.feedImageString forKey:@"feedPhoto"];
            
        }
   
        [pc editPetWithDataDictionary:editPetParameters];
        UIAlertController *alertSaved = [UIAlertController
                                     alertControllerWithTitle: @"Updates to the profile are saved."
                                     message: @"Please add photos of your pet to its album."
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler: nil];
        [alertSaved addAction:cancel];
        [self presentViewController:alertSaved animated:YES completion:^(){
            //put your code here
            //TODO ... push to the photo album?
        }];
    }
    
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     if([segue.identifier isEqualToString:@"editPhotosSegue"]) {
         EditPetPhotosTableViewController *editPhotosVC = (EditPetPhotosTableViewController*)segue.destinationViewController;
         editPhotosVC.pet = self.pet;
         
     }
 }



- (IBAction)saveEditedProfile:(id)sender {
    [self sendPetInfoToFirebase];
    
}

@end
