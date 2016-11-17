//
//  PCFullScreenViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/17/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PCFullScreenViewController.h"
#import "Pet.h"

@interface PCFullScreenViewController () <UIScrollViewDelegate>

//add properties for gesture recognizer
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;

@end

@implementation PCFullScreenViewController

- (instancetype) initWithPet:(Pet *)pet; {
    self = [super init];
    
    if (self) {
        self.pet = pet;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // #1
    //create and configures a scroll view and add it as the only subview of self.view
    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    
    // #2
    //creat an image view, set the image and add it as a subview of scrollview
    self.imageView = [UIImageView new];
    self.imageView.image = self.pet.albumImage;
    
    [self.scrollView addSubview:self.imageView];
    
    // #3
    //size of content view - whatever is being scrolled around
    self.scrollView.contentSize = self.pet.albumImage.size;
    
    //init gesture recognizers
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapFired:)];
    self.doubleTap.numberOfTapsRequired = 2;
    
    [self.tap requireGestureRecognizerToFail:self.doubleTap];
    
    [self.scrollView addGestureRecognizer:self.tap];
    [self.scrollView addGestureRecognizer:self.doubleTap];
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self recalculateZoomScale];
}



-(void) recalculateZoomScale {
    //#4 set the scroll view's frame to the view's bounds - make it full size
    self.scrollView.frame = self.view.bounds;
    
    //#5
    CGSize scrollViewFrameSize = self.scrollView.frame.size;
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    
    //divide the size dimensions by self.scrollView.zoomscale - allows subclasses to recalc for zoomed out views
    scrollViewContentSize.height /= self.scrollView.zoomScale;
    scrollViewContentSize.width /= self.scrollView.zoomScale;
    
    //ratio of scroll view's width to the image's width
    CGFloat scaleWidth = scrollViewFrameSize.width / scrollViewContentSize.width;
    //ratio of scroll view's height to the image's height
    CGFloat scaleHeight = scrollViewFrameSize.height / scrollViewContentSize.height;
    
    //whichever ratio is smaller will become the minimum zoom scale, prevents user from pinching image so small we waste screen space
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1;
    
}

- (void)centerScrollView {
    [self.imageView sizeToFit];
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - CGRectGetWidth(contentsFrame)) / 2;
    } else {
        contentsFrame.origin.x = 0;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - CGRectGetHeight(contentsFrame)) / 2;
    } else {
        contentsFrame.origin.y = 0;
    }
    
    self.imageView.frame = contentsFrame;
}

#pragma mark - UIScrollViewDelegate
// #6 tells the scroll view which view to zoom in and out
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

// #7 calls center scroll view after the user has changed the zoom level
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollView];
}

//make sure image starts out centered
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self centerScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture Recognizers

- (void) tapFired:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//when the user double taps, adjust the zoom level
- (void) doubleTapFired:(UITapGestureRecognizer *)sender {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        // #8
        CGPoint locationPoint = [sender locationInView:self.imageView];
        
        CGSize scrollViewSize = self.scrollView.bounds.size;
        
        CGFloat width = scrollViewSize.width / self.scrollView.maximumZoomScale;
        CGFloat height = scrollViewSize.height / self.scrollView.maximumZoomScale;
        CGFloat x = locationPoint.x - (width / 2);
        CGFloat y = locationPoint.y - (height / 2);
        
        [self.scrollView zoomToRect:CGRectMake(x, y, width, height) animated:YES];
    } else {
        // #9
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
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
