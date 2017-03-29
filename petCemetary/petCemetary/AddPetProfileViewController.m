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

@interface AddPetProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSString *downloadURLString2;
@property (nonatomic, strong) NSMutableDictionary *addPetParameters;

@end

@implementation AddPetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Add Pet";
    [self.animalPersonalityTextView setReturnKeyType:UIReturnKeyDone];
    self.animalPersonalityTextView.delegate = self;

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
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
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


- (void)viewWillAppear:(BOOL)animated
{
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
        if ([self.downloadURLString2 length] == 0) {
            
            self.downloadURLString2 = @"https://firebasestorage.googleapis.com/v0/b/petcemetary-5fec2.appspot.com/o/petFeed%2FprofilePlaceholder.png?alt=media&token=c5d106a3-d5d0-4d69-8732-a29bf1f3542c";
            [addPetParameters setObject:self.downloadURLString2 forKey:@"feedPhoto"];
        }else {
            [addPetParameters setObject:self.downloadURLString2 forKey:@"feedPhoto"];
        }
       
        [pc addNewPetWithDataDictionary:addPetParameters andPet:pet];
        UIAlertController *alertSaved = [UIAlertController
                                    alertControllerWithTitle: @"THANK YOU!"
                                    message: @"Go Back to add some photos to your pet's album"
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler: nil];
        [alertSaved addAction:cancel];
        [self presentViewController:alertSaved animated:YES completion:^(){
            //dispatch_async(dispatch_get_main_queue(), ^{
                //[self.navigationController popViewControllerAnimated:YES];
            //});
        }];
        
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
        
        self.downloadURLString2 = downloadURLString;
        //NSLog(@"completion? %@", downloadURLString);
       

    }];
    
    
    
    
   

}
@end
