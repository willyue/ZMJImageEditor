//
//  ImageUploadManager.m
//  ZMJImageEditor
//
//  Created by Will Choy on 5/11/18.
//

#import "ImageUploadManager.h"
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/ALAsset.h>
#import <QBImagePickerController/QBImagePickerController.h>
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>

#define kMaxFileSize 800
#define kMinimumRatio 0.8

@interface ImageUploadManager() <UINavigationControllerDelegate,UIImagePickerControllerDelegate, QBImagePickerControllerDelegate> {
    IDMPhoto *photo;
}
@property (nonatomic,strong) UIViewController *vc;
@property (nonatomic,strong) UIImage *image;
@end

@implementation ImageUploadManager

-(void)showActionSheetForVC:(UIViewController *)superVC withImage:(UIImage *)image {
    self.vc = superVC;
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if(!self.isViewOnly) {
        UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto];
        }];
        UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"Choose from Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(self.isMultipleSelection) {
                [self showMultiplePhotoLibrary];
            }else{
                [self showPhotoLibrary];
            }
        }];
        [actionSheetController addAction:takePhoto];
        [actionSheetController addAction:photoLibrary];
    }
    
    // Check Image
    if(image && image!=nil) {
        UIAlertAction *viewPhoto = [UIAlertAction actionWithTitle:@"View Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self->photo = [IDMPhoto photoWithImage:image];
            [self viewPhoto];
        }];
        
        [actionSheetController addAction:viewPhoto];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
    [actionSheetController addAction:cancel];
    
    [self.vc presentViewController:actionSheetController animated:YES completion:nil];
}

- (void)launchCamera:(UIViewController *)superVC {
    self.vc = superVC;
    [self takePhoto];
}

- (void)browseImages:(NSArray *)images forVC:(UIViewController *)superVC viewIndex:(NSInteger)index {
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:[IDMPhoto photosWithImages:images]];
    [browser setInitialPageIndex:index];
    browser.displayToolbar = NO;
    [superVC presentViewController:browser animated:YES completion:nil];
}

- (void)takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)])
    {
        //        [WAlertView showAlertWithTitle:@"Alert" message:@"No camera found on this device." withController:self.vc cancelButtonTitle:@"OK" otherButtonTitles:nil withCompletionBlock:nil andCancelBlock:nil];
    }else {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if(authStatus == AVAuthorizationStatusAuthorized) {
            UIImagePickerController *camera = [[UIImagePickerController alloc] init];
            camera.delegate = self;
            camera.sourceType = UIImagePickerControllerSourceTypeCamera;
            camera.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            camera.allowsEditing = NO;
            
            
            [self.vc presentViewController:camera animated:YES completion:nil];
        } else if(authStatus == AVAuthorizationStatusDenied){
            //            [WAlertView showAlertWithTitle:@"Camera Disabled" message:@"Please enable camera access from Settings." withController:self.vc cancelButtonTitle:@"OK" otherButtonTitles:nil withCompletionBlock:nil andCancelBlock:nil];
        } else if (authStatus == AVAuthorizationStatusNotDetermined){
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
                    camera.delegate = self;
                    camera.sourceType = UIImagePickerControllerSourceTypeCamera;
                    camera.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                    camera.allowsEditing = NO;
                    
                    [self.vc presentViewController:camera animated:YES completion:nil];
                }
            }];
        }
    }
}

- (void)showMultiplePhotoLibrary {
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.delegate = self;
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    imagePickerController.assetCollectionSubtypes = @[
                                                      @(PHAssetCollectionSubtypeSmartAlbumUserLibrary) // Camera Roll
                                                      ];

    [self.vc presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)showPhotoLibrary {
    UIImagePickerController *photoLibrary = [[UIImagePickerController alloc] init];
    photoLibrary.delegate = self;
    
    photoLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.vc presentViewController:photoLibrary animated:YES completion:nil];
}

- (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)viewPhoto {
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:@[photo]];
    browser.displayToolbar = NO;
    [self.vc presentViewController:browser animated:YES completion:nil];
}

- (UIImage *)mockPlaceholderText:(NSString *)message toImage:(UIImage *)image {
    image = [self imageWithImage:image scaledToWidth:1024];
    CGSize imageSize = image.size;
    CGFloat sideMargin = imageSize.width * 0.2;
    CGFloat viewWidth = imageSize.width - (sideMargin *2);
    //    CGFloat viewHeight =
    
    // Mock image
    UIView *mockView = [[UIView alloc] initWithFrame:CGRectMake(sideMargin, imageSize.height - 800, viewWidth, 150)];
    [mockView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f]];
    
    UILabel *lblMock = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mockView.frame.size.width, mockView.frame.size.height)];
    [lblMock setNumberOfLines:0];
    [lblMock setTextAlignment:NSTextAlignmentCenter];
    [lblMock setFont:[UIFont boldSystemFontOfSize:30.0f]];
    [lblMock setTextColor:[UIColor whiteColor]];
    [lblMock setText:message];
    [mockView addSubview:lblMock];
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, mockView.frame.origin.x, mockView.frame.origin.y);
    [mockView.layer renderInContext:context];
    CGContextRestoreGState(context);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)getImageInfo:(id)info forType:(UIImagePickerControllerSourceType)source withCompletion:(void (^)(NSString *results))completion {
    NSString *imageDateTime = @"";
    // Get timestamp from metadata
    if(source == UIImagePickerControllerSourceTypeCamera) {
        NSDictionary *metadataDictionary = (NSDictionary *)[info valueForKey:UIImagePickerControllerMediaMetadata];
        NSDictionary *tiffDict = [metadataDictionary objectForKey:@"{TIFF}"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
        NSDate *createdDate = [formatter dateFromString:[tiffDict objectForKey:@"DateTime"]];
        [formatter setDateFormat:@"dd/MM/yyyy hh:mm:ss a"];
        
        imageDateTime = [NSString stringWithFormat:@"%@ [CAMERA]",[formatter stringFromDate:createdDate]];
        NSLog(@"DateTime : %@ \n\n",imageDateTime);
        
        completion(imageDateTime);
    }else if(source == UIImagePickerControllerSourceTypePhotoLibrary) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
        [formatter setDateFormat:@"dd/MM/yyyy hh:mm:ss a"];
        
        PHAsset *asset = (PHAsset *)info;
        NSString *imageDateTime = [NSString stringWithFormat:@"%@ [GALLERY]",[formatter stringFromDate:asset.creationDate]];
        NSLog(@"DateTime :%@", imageDateTime);

        completion(imageDateTime);
        
//        NSURL *referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
//        if(referenceURL) {
//            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//            [library assetForURL:referenceURL resultBlock:^(ALAsset *asset) {
//                ALAssetRepresentation *rep = [asset defaultRepresentation];
//                NSDictionary *metadata = rep.metadata;
//                NSDictionary *tiffDict = [metadata objectForKey:@"{TIFF}"];
//                NSString *imageDateTime = [NSString stringWithFormat:@"%@ [GALLERY]",[tiffDict objectForKey:@"DateTime"]];
//                NSLog(@"DateTime :%@", imageDateTime);
//
//                completion(imageDateTime);
//
//            } failureBlock:^(NSError *error) {
//                // error handling
//            }];
//        }
    }
    
}

- (UIImage *)mockTimeStampInfo:(NSDictionary *)info toImage:(UIImage *)image forType:(UIImagePickerControllerSourceType)source{
    NSString *imageDateTime = @"";
    // Get timestamp from metadata
    if(source == UIImagePickerControllerSourceTypeCamera) {
        NSDictionary *metadataDictionary = (NSDictionary *)[info valueForKey:UIImagePickerControllerMediaMetadata];
        NSDictionary *tiffDict = [metadataDictionary objectForKey:@"{TIFF}"];
        imageDateTime = [NSString stringWithFormat:@"%@ [CAMERA]",[tiffDict objectForKey:@"DateTime"]];
        NSLog(@"DateTime : %@ \n\n",imageDateTime);
        
    }else if(source == UIImagePickerControllerSourceTypePhotoLibrary) {
        NSURL *referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        if(referenceURL) {
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library assetForURL:referenceURL resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                NSDictionary *metadata = rep.metadata;
                NSDictionary *tiffDict = [metadata objectForKey:@"{TIFF}"];
                NSString *imageDateTime = [NSString stringWithFormat:@"%@ [GALLERY]",[tiffDict objectForKey:@"DateTime"]];
                NSLog(@"DateTime :%@", imageDateTime);
                
            } failureBlock:^(NSError *error) {
                // error handling
            }];
        }
    }
    
    // If there are no timestamp, use current
    if([imageDateTime isEqualToString:@""]) {
        
    }
    
    return [self mockPlaceholderText:imageDateTime toImage:image];
}

#pragma mark UIImagePickerControllerDelegate Methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [self imageResizing:image];
    self.image = image;
    
    [self getImageInfo:info forType:picker.sourceType withCompletion:^(NSString *results) {
        self.image = [self mockPlaceholderText:results toImage:self.image];
        [self.delegate imageUploaded:self.image];
        [self.vc dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [self.delegate imageUploaded:nil];
    [self.vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    __weak typeof (self) weakSelf = self;
    __block int processCounter = 0;

//    [HUDManager addMBProgress:picker.view withText:LOADING_HUD];
    // Settings
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;

    CGSize targetSize = CGSizeMake(1024, 1024);
    PHImageManager *manager = [PHImageManager defaultManager];

    NSMutableArray *imageArray = [NSMutableArray array];
    for(PHAsset *asset in assets) {
        [manager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [self getImageInfo:asset forType:UIImagePickerControllerSourceTypePhotoLibrary withCompletion:^(NSString *results) {
                processCounter += 1;
                UIImage *selectedImage = result;
                selectedImage = [self mockPlaceholderText:results toImage:selectedImage];
                [imageArray addObject:selectedImage];

                // Check All Completed
                if(processCounter == [assets count]) {
                    if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(multipleImageUploaded:)]) {
                        [weakSelf.delegate multipleImageUploaded:imageArray];
                    }
                    //                [HUDManager removeMBProgress:picker.view];
                    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }];
    }
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self.vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper Methods
- (UIImage*)imageResizing:(UIImage*)imageResized{
    
    NSData *imgData = UIImageJPEGRepresentation(imageResized, 1); //1 it represents the quality of the image.
    
    float imgSize = [imgData length] / 1000;
    
    if(imgSize > kMaxFileSize) {
        float scaleRatio = (kMaxFileSize/imgSize);
        if(scaleRatio < kMinimumRatio) {
            scaleRatio = kMinimumRatio;
        }
        float newHeight = imageResized.size.height * scaleRatio;
        float newWidth = imageResized.size.width * scaleRatio;
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [imageResized drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIGraphicsEndImageContext();
    }
    
    
    imgData = UIImageJPEGRepresentation(imageResized,0.1);
    imageResized = [UIImage imageWithData:imgData];
    NSLog(@"Size of final Image(bytes):%lu",(unsigned long)[imgData length]);
    
    return imageResized ;
}

@end
