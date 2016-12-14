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


@interface EditPetProfileViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation EditPetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"Edit Profile";
    PCDataSource *pc = [PCDataSource sharedInstance];
    pc.editProfileVC = self;
   //NSLog(@"pc.petNumber edit %ld", pc.pet.petNumber);
    self.petNameTextField.text = _pet.petName;
    //TODO - dates in a certain format - alert if entered incorrectly
    self.dobTextField.text = _pet.petDOB;
    self.dodTextField.text = _pet.petDOD;
    self.animalTypeTextField.text = _pet.petType;
    self.animalBreedTextField.text = _pet.petBreed;
    self.animalPersonalityTextView.text = _pet.petPersonality;
    self.ownerNameTextField.text = _pet.ownerName;
    
    NSString *petProfileString = _pet.feedImageString;
    NSURL *petProfileUrl=[NSURL URLWithString:petProfileString];
    UIImage *savedProfileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:petProfileUrl]];
    
    [self.uploadProfilePhotoButton setBackgroundImage:savedProfileImage forState:UIControlStateNormal];
     self.uploadProfilePhotoButton.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return YES;
    }
    
    return YES;
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
        //TODO sometimes when I get here pet ID looks like 0x0000608000054eb0, which crashes
        //[editPetParameters setObject:pc.pet.photoID forKey:@"photoID"];
        [editPetParameters setObject:pc.pet.petID forKey:@"petID"];
        [editPetParameters setObject:self.petNameTextField.text forKey:@"petName"];
        [editPetParameters setObject:self.animalTypeTextField.text forKey:@"petType"];
        [editPetParameters setObject:self.animalBreedTextField.text forKey:@"petBreed"];
        [editPetParameters setObject:self.dobTextField.text forKey:@"dob"];
        [editPetParameters setObject:self.dodTextField.text forKey:@"dod"];
        [editPetParameters setObject:self.animalPersonalityTextView.text forKey:@"personality"];
        [editPetParameters setObject:self.ownerNameTextField.text forKey:@"ownerName"];
    
   
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
