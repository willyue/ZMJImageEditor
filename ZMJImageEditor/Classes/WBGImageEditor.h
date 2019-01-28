//
//  WBGImageEditor.h
//  Trader
//
//  Created by Jason on 2017/3/13.
//
//

#import <UIKit/UIKit.h>

@protocol WBGImageEditorDelegate, WBGImageEditorTransitionDelegate, WBGImageEditorDataSource, WBGActionIndicatorDataSource;
@class WBGMoreKeyboardItem;

typedef NS_OPTIONS(NSInteger, WBGImageEditorComponent) {
    WBGImageEditorDrawComponent = 1 << 0,
    WBGImageEditorTextComponent = 1 << 1,
    WBGImageEditorClipComponent = 1 << 2,
    WBGImageEditorPaperComponent = 1 << 3,
    WBGImageEditorColorPanComponent = 1 << 4,
    WBGImageEditorIndicatorComponent = 1 << 5,
    //all
    WBGImageEditorWholeComponent = WBGImageEditorDrawComponent
                                 | WBGImageEditorTextComponent
                                 | WBGImageEditorClipComponent
                                 | WBGImageEditorPaperComponent
                                 | WBGImageEditorColorPanComponent
};

@interface WBGImageEditor : UIViewController

@property (nonatomic, weak) id<WBGImageEditorDelegate> delegate;
@property (nonatomic, weak) id<WBGImageEditorDataSource> dataSource;
@property (nonatomic, weak) id<WBGActionIndicatorDataSource> indicatorDataSource;

- (id)initWithImage:(UIImage*)image;
- (id)initWithImage:(UIImage*)image delegate:(id<WBGImageEditorDelegate>)delegate dataSource:(id<WBGImageEditorDataSource>)dataSource;
- (id)initWithImage:(UIImage*)image delegate:(id<WBGImageEditorDelegate>)delegate dataSource:(id<WBGImageEditorDataSource>)dataSource andIndicatorDataSource:(id<WBGActionIndicatorDataSource>)indicatorDataSource;
- (id)initWithImage:(UIImage*)image delegate:(id<WBGImageEditorDelegate>)delegate dataSource:(id<WBGImageEditorDataSource>)dataSource andPlaceHolderText:(NSString*)placeholder;
- (id)initWithDelegate:(id<WBGImageEditorDelegate>)delegate;

- (void)showInViewController:(UIViewController<WBGImageEditorTransitionDelegate> *)controller withImageView:(UIImageView*)imageView;
- (void)refreshToolSettings;
@end


#pragma mark - Protocol
@protocol WBGImageEditorDelegate <NSObject>
@optional
- (void)imageEditor:(WBGImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image;
- (void)imageEditorDidCancel:(WBGImageEditor *)editor;
- (void)indicatorsPlaced:(NSArray *)indicators;

@end

@protocol WBGImageEditorDataSource <NSObject>

@required
- (NSArray<WBGMoreKeyboardItem *> *)imageItemsEditor:(WBGImageEditor *)editor;
- (WBGImageEditorComponent)imageEditorCompoment;

@optional
- (UIColor *)imageEditorDefaultColor;
- (NSNumber *)imageEditorDrawPathWidth;
@end


@protocol WBGImageEditorTransitionDelegate <WBGImageEditorDelegate>
@optional
- (void)imageEditor:(WBGImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled;
- (void)imageEditor:(WBGImageEditor *)editor didDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled;

@end

@protocol WBGActionIndicatorDataSource <NSObject>

@required
- (NSArray *)actionIndicatorItems;
@end
