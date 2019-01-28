//
//  ImageUploadManager.h
//  ZMJImageEditor
//
//  Created by Will Choy on 5/11/18.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <UIKit/UIKit.h>

//#import <CTAssetsPickerController/CTAssetsPickerController.h>

@protocol ImageUploadDelegate <NSObject>
@optional
- (void)imageUploaded:(UIImage *)image;
- (void)multipleImageUploaded:(NSArray *)imageArray;
@end

@interface ImageUploadManager : NSObject
@property (weak,nonatomic) NSObject <ImageUploadDelegate> *delegate;
@property (nonatomic) BOOL isViewOnly;

// Multiple Image Selections
@property (nonatomic) BOOL isMultipleSelection;
@property (nonatomic) NSInteger maxImagesCount;

/**
 Show gallery or camera actionsheet
 
 @param superVC ViewController that will be presenting action sheet
 @param image A image to be viewed in image viewer. Can be nil if no image
 */
-(void)showActionSheetForVC:(UIViewController*)superVC withImage:(UIImage *)image;

/**
 Launch Camera
 @param superVC ViewController that will be presenting camera view
 */
-(void)launchCamera:(UIViewController*)superVC;

/**
 View image
 
 @param superVC ViewController that will be presenting action sheet
 @param images Array of images to be viewed in image viewer
 @param index Current viewing index
 */
-(void)browseImages:(NSArray *)images forVC:(UIViewController *)superVC viewIndex:(NSInteger)index;



@end
