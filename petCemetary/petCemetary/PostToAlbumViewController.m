//
//  PostToAlbumViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/19/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//
#import <Photos/Photos.h>
#import "PostToAlbumViewController.h"
@import Firebase;
@import FirebaseDatabase;

@interface PostToAlbumViewController () <UIDocumentInteractionControllerDelegate>

    @property (nonatomic, strong) UIImage *sourceImage;
    @property (nonatomic, strong) UIImageView *previewImageView;

    @property (nonatomic, strong) UIButton *sendButton;
    @property (nonatomic, strong) UIBarButtonItem *sendBarButton;
    @property (nonatomic, strong) UIDocumentInteractionController *documentController;

    @property (nonatomic, strong) PHFetchResult *result;
    @property (strong, nonatomic) FIRDatabaseReference *ref;
    @property (strong, nonatomic) FIRStorage *storage;

@end

@implementation PostToAlbumViewController

- (instancetype) initWithImage:(UIImage *)sourceImage {
    self = [super init];
    
    if (self) {
        self.sourceImage = sourceImage;
        self.previewImageView = [[UIImageView alloc] initWithImage:self.sourceImage];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.sendButton.backgroundColor = [UIColor colorWithRed:0.62 green:0.138 blue:0.02 alpha:1]; /*#58516c*/
        self.sendButton.layer.cornerRadius = 5;
        [self.sendButton setAttributedTitle:[self sendAttributedString] forState:UIControlStateNormal];
        [self.sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.sendBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Send", @"Send button") style:UIBarButtonItemStyleDone target:self action:@selector(sendButtonPressed:)];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.previewImageView];
    //[self.view addSubview:self.filterCollectionView];
    
    if (CGRectGetHeight(self.view.frame) > 500) {
        [self.view addSubview:self.sendButton];
    } else {
        self.navigationItem.rightBarButtonItem = self.sendBarButton;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    self.navigationItem.title = @"Post to Pet Album";
    
    
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat edgeSize = MIN(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    
    self.previewImageView.frame = CGRectMake(0, self.topLayoutGuide.length, edgeSize, edgeSize);
    
    CGFloat buttonHeight = 70;
    CGFloat buffer = 20;
    
    
    if (CGRectGetHeight(self.view.frame) > 500) {
        self.sendButton.frame = CGRectMake(buffer, CGRectGetHeight(self.view.frame) - buffer - buttonHeight, CGRectGetWidth(self.view.frame) - 2 * buffer, buttonHeight);
        
        
    } else {
        
    }
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSAttributedString *) sendAttributedString {
    NSString *baseString = NSLocalizedString(@"Post To Album", @"post to album button text");
    NSRange range = [baseString rangeOfString:baseString];
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:baseString];
    
    [commentString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14] range:range];
    [commentString addAttribute:NSKernAttributeName value:@1.3 range:range];
    [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1] range:range];
    
    return commentString;
}

- (void) sendButtonPressed:(id)sender {
    
    //TODO Post image url to Firebase with the correct UID and includ ability to add a caption
    FIRUser *userAuth = [FIRAuth auth].currentUser;
    self.ref = [[FIRDatabase database] reference];
    
    PHAsset *asset = nil;
    
    //if (self.result[indexPath.row] != nil && self.result.count > 0) {
        //asset = self.result[indexPath.row];
    //}
    
    
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    [[PHImageManager defaultManager]
     requestImageDataForAsset:asset
     options:imageRequestOptions
     resultHandler:^(NSData *imageData, NSString *dataUTI,
                     UIImageOrientation orientation,
                     NSDictionary *info)
     {
         
         if ([info objectForKey:@"PHImageFileURLKey"]) {
             
             NSURL *localURL = [info objectForKey:@"PHImageFileURLKey"];
             NSString *localURLString = [localURL path];
             NSString *key = localURLString;
             NSString *theFileName = [[key lastPathComponent] stringByDeletingPathExtension];
             
             
             //UPLOAD TO FB
             FIRStorage *storage = [FIRStorage storage];
             FIRStorageReference *storageRef = [storage referenceForURL:@" gs://petcemetary-5fec2.appspot.com/petAlbums"];
             FIRStorageReference *albumRef = [storageRef child:theFileName];
             
             FIRStorageUploadTask *uploadTask = [albumRef putFile:localURL metadata:nil completion:^(FIRStorageMetadata* metadata, NSError* error) {
                 if (error != nil) {
                     // Uh-oh, an error occurred!
                     //NSLog(@"error %@", error);
                 } else {
                     // Metadata contains file metadata such as size, content-type, and download URL.
                     NSURL *downloadURL = metadata.downloadURL;
                     NSString *downloadURLString = [ downloadURL absoluteString];
                     
                     
                     //push the selected photo to database
                     FIRDatabaseQuery *pathStringQuery = [[self.ref child:[NSString stringWithFormat:@"/photos/%@/", userAuth.uid]] queryLimitedToFirst:100];
                     
                     [pathStringQuery
                      observeEventType:FIRDataEventTypeValue
                      withBlock:^(FIRDataSnapshot *snapshot) {
                          //TODO - not seeing the correct image --WHAT IS THIS CODE DOING?? DO I NEED IT?
                          //static NSInteger imageViewTag = 54321;
                          //UIImageView *imgView = (UIImageView*)[[collectionView cellForItemAtIndexPath:indexPath] viewWithTag:imageViewTag];
                          //UIImage *img = imgView.image;
                          //[[BLCDataSource sharedInstance] setUserImage:img];
                          
                          
                      }];
                     
                     NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/userData/%@/profile_picture/", userAuth.uid]:downloadURLString};
                     
                     [_ref updateChildValues:childUpdates];
                     
                     
                 }
             }];
             
             NSLog(@"uploadTask %@", uploadTask);
             
             
             
         }
     }];
    
    
    //[self cancelPressed:self.navigationItem.leftBarButtonItem];
    
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://location?id=1"];
    
    UIAlertController *alertVC;
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        alertVC = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Add a caption and send your image in the Instagram app.", @"send image instructions") preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = NSLocalizedString(@"Caption", @"Caption");
        }];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"cancel button") style:UIAlertActionStyleCancel handler:nil]];
        [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Send", @"Send button") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *textField = alertVC.textFields[0];
            [self sendImageToAlbumWithCaption:textField.text];
        }]];
    } else {
        alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"No Instagram App", nil) message:NSLocalizedString(@"Add a caption and send your image in the Instagram app.", @"send image instructions") preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK button") style:UIAlertActionStyleCancel handler:nil]];
    }
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void) sendImageToAlbumWithCaption:(NSString *)caption {
    NSData *imagedata = UIImageJPEGRepresentation(self.previewImageView.image, 0.9f);
    
    NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *fileURL = [[tmpDirURL URLByAppendingPathComponent:@"blocstagram"] URLByAppendingPathExtension:@"igo"];
    
    BOOL success = [imagedata writeToURL:fileURL atomically:YES];
    
    if (!success) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Couldn't save image", nil) message:NSLocalizedString(@"Your cropped and filtered photo couldn't be saved. Make sure you have enough disk space and try again.", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK button") style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    self.documentController.UTI = @"com.instagram.exclusivegram";
    self.documentController.delegate = self;
    
    if (caption.length > 0) {
        self.documentController.annotation = @{@"InstagramCaption": caption};
    }
    
    if (self.sendButton.superview) {
        [self.documentController presentOpenInMenuFromRect:self.sendButton.bounds inView:self.sendButton animated:YES];
    } else {
        [self.documentController presentOpenInMenuFromBarButtonItem:self.sendBarButton animated:YES];
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
