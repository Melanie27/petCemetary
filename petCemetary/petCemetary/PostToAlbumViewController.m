//
//  PostToAlbumViewController.m
//  petCemetary
//
//  Created by MELANIE MCGANNEY on 11/19/16.
//  Copyright © 2016 melaniemcganney.com. All rights reserved.
//

#import "PostToAlbumViewController.h"

@interface PostToAlbumViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIDocumentInteractionControllerDelegate>

    @property (nonatomic, strong) UIImage *sourceImage;
    @property (nonatomic, strong) UIImageView *previewImageView;
    //@property (nonatomic, strong) NSOperationQueue *photoFilterOperationQueue;
    //@property (nonatomic, strong) UICollectionView *filterCollectionView;
    @property (nonatomic, strong) UIButton *sendButton;
    @property (nonatomic, strong) UIBarButtonItem *sendBarButton;
    @property (nonatomic, strong) UIDocumentInteractionController *documentController;

@end

@implementation PostToAlbumViewController

- (instancetype) initWithImage:(UIImage *)sourceImage {
    self = [super init];
    
    if (self) {
        self.sourceImage = sourceImage;
        self.previewImageView = [[UIImageView alloc] initWithImage:self.sourceImage];
        
        //self.photoFilterOperationQueue = [[NSOperationQueue alloc] init];
        
        //UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //flowLayout.itemSize = CGSizeMake(44, 64);
        //flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //flowLayout.minimumInteritemSpacing = 10;
        //flowLayout.minimumLineSpacing = 10;
        
        //self.filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        //self.filterCollectionView.dataSource = self;
        //self.filterCollectionView.delegate = self;
        //self.filterCollectionView.showsHorizontalScrollIndicator = NO;
        
        //self.filterImages = [NSMutableArray arrayWithObject:sourceImage];
        //self.filterTitles = [NSMutableArray arrayWithObject:NSLocalizedString(@"None", @"Label for when no filter is applied to a photo")];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.sendButton.backgroundColor = [UIColor colorWithRed:0.345 green:0.318 blue:0.424 alpha:1]; /*#58516c*/
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
    
    //[self.filterCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.filterCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = NSLocalizedString(@"Apply Filter", @"apply filter view title");
    
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat edgeSize = MIN(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    
    self.previewImageView.frame = CGRectMake(0, self.topLayoutGuide.length, edgeSize, edgeSize);
    
    CGFloat buttonHeight = 50;
    CGFloat buffer = 10;
    
    CGFloat filterViewYOrigin = CGRectGetMaxY(self.previewImageView.frame) + buffer;
    CGFloat filterViewHeight;
    
    if (CGRectGetHeight(self.view.frame) > 500) {
        self.sendButton.frame = CGRectMake(buffer, CGRectGetHeight(self.view.frame) - buffer - buttonHeight, CGRectGetWidth(self.view.frame) - 2 * buffer, buttonHeight);
        
        filterViewHeight = CGRectGetHeight(self.view.frame) - filterViewYOrigin - buffer - buffer - CGRectGetHeight(self.sendButton.frame);
    } else {
        filterViewHeight = CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.previewImageView.frame) - buffer - buffer;
    }
    
    //self.filterCollectionView.frame = CGRectMake(0, filterViewYOrigin, CGRectGetWidth(self.view.frame), filterViewHeight);
    
    //UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.filterCollectionView.collectionViewLayout;
    //flowLayout.itemSize = CGSizeMake(CGRectGetHeight(self.filterCollectionView.frame) - 20, CGRectGetHeight(self.filterCollectionView.frame));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSAttributedString *) sendAttributedString {
    NSString *baseString = NSLocalizedString(@"Post To Album", @"post to album button text");
    NSRange range = [baseString rangeOfString:baseString];
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:baseString];
    
    [commentString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13] range:range];
    [commentString addAttribute:NSKernAttributeName value:@1.3 range:range];
    [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1] range:range];
    
    return commentString;
}

- (void) sendButtonPressed:(id)sender {
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
            //[self sendImageToInstagramWithCaption:textField.text];
        }]];
    } else {
        alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"No Instagram App", nil) message:NSLocalizedString(@"Add a caption and send your image in the Instagram app.", @"send image instructions") preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK button") style:UIAlertActionStyleCancel handler:nil]];
    }
    
    [self presentViewController:alertVC animated:YES completion:nil];
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
