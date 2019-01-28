//
//  ImageManagerVC.m
//  ZMJImageEditor
//
//  Created by Will Choy on 5/11/18.
//

#import "ImageManagerVC.h"
#import "ImageManagerCell.h"
#import "ImageUploadManager.h"

@interface ImageManagerVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ImageUploadDelegate> {
    ImageUploadManager *uploadManager;
    CGFloat cellWidth;
}
@property (weak, nonatomic) IBOutlet UICollectionView *cvImages;

@end

@implementation ImageManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self setupInterfaceValues:size];
    [self.cvImages reloadData];
}


- (void)setupInterface {
    // Init Upload manager
    uploadManager = [[ImageUploadManager alloc] init];
//    uploadManager.isMultipleSelection = YES;
    uploadManager.delegate = self;
    
    // Setup CollectionView
    [self.cvImages registerClass:[ImageManagerCell class] forCellWithReuseIdentifier:@"ImageManagerCell"];
    
    [self setupInterfaceValues:[[UIScreen mainScreen] bounds].size];
}

- (void)setupInterfaceValues:(CGSize)size {
    // Get Cell Width
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        cellWidth = size.width/4;
    }else {
        cellWidth = size.width/2;
    }
}


#pragma mark - Action Methods
- (IBAction)btnBackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnAddPressed:(id)sender {
//    [uploadManager showActionSheetForVC:self withImage:nil];
    [uploadManager launchCamera:self];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageManagerCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageManagerCell" forIndexPath:indexPath];
    [imageCell.imgThumbnail setImage:[self.images objectAtIndex:indexPath.row]];
    
    return imageCell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [uploadManager browseImages:self.images forVC:self viewIndex:indexPath.row];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat size = cellWidth -1;
    
    return CGSizeMake(size, size);
}

#pragma mark - ImageUploadDelegate
- (void)imageUploaded:(UIImage *)image {
    if(image) {
        [self.images addObject:image];
        [self.cvImages reloadData];
    }
}

- (void)multipleImageUploaded:(NSArray *)imageArray {
    if([imageArray count] > 0) {
        [self.images addObjectsFromArray:imageArray];
        [self.cvImages reloadData];
    }
}


@end
