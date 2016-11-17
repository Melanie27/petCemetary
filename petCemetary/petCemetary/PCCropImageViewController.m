//
//  PCCropImageViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/17/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PCCropImageViewController.h"
#import "CropBox.h"
#import "Pet.h"
#import "UIImage+PCImageUtilities.h"

@interface PCCropImageViewController ()
    @property (nonatomic, strong) CropBox *cropBox;
    @property (nonatomic, assign) BOOL hasLoadedOnce;
@end

@implementation PCCropImageViewController

-(instancetype) initWithImage:(UIImage *)sourceImage {
    self = [super init];
    
    if(self) {
        //create new media item from the image
        self.pet = [[Pet alloc] init];
        self.pet.albumImage = sourceImage;
        
        //init cropBox
        self.cropBox = [CropBox new];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //so the crop image doesn't overlap other controllers during nav controller transitions
    self.view.clipsToBounds = YES;
    //add the crop box to the view hierarchy
    [self.view addSubview:self.cropBox];
    //create crop image button in nav bar
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Crop", @"Crop command") style:UIBarButtonItemStyleDone target:self action:@selector(cropPressed:)];
    self.navigationItem.title = NSLocalizedString(@"Crop Image", nil);
    self.navigationItem.rightBarButtonItem = rightButton;
    //disable UINavigationController's behavior of automatically adjusting scroll view insets
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //sizes and centers CropBox
    CGRect cropRect = CGRectNull;
    
    CGFloat edgeSize = MIN(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    cropRect.size = CGSizeMake(edgeSize, edgeSize);
    
    CGSize size = self.view.frame.size;
    
    self.cropBox.frame = cropRect;
    self.cropBox.center = CGPointMake(size.width / 2, size.height / 2);
    self.scrollView.frame = self.cropBox.frame;
    
    //disable so the user can still see image outside crop box
    self.scrollView.clipsToBounds = NO;
    
    [self recalculateZoomScale];
    
    if (self.hasLoadedOnce == NO) {
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
        self.hasLoadedOnce = YES;
    }
}


-(void) cropPressed:(UIBarButtonItem *)sender {
    CGRect visibleRect;
    //create the rect based on the scroll view's panned and zoomed location
    //TODO is the problem with the image property on Pet Object?
    float scale = 1.0f / self.scrollView.zoomScale / self.pet.albumImage.scale;
    visibleRect.origin.x = self.scrollView.contentOffset.x * scale;
    visibleRect.origin.y = self.scrollView.contentOffset.y * scale;
    visibleRect.size.width = self.scrollView.bounds.size.width * scale;
    visibleRect.size.height = self.scrollView.bounds.size.height * scale;
    
    //pass cropped image into old method
    UIImage *scrollViewCrop = [self.pet.albumImage imageWithFixedOrientation];
    scrollViewCrop = [scrollViewCrop imageCroppedToRect:visibleRect];
    
    //call the delegate
    [self.delegate cropControllerFinishedWithImage:scrollViewCrop];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
