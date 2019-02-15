//
//  WBGActionIndicatorView.h
//  Pods
//
//  Created by Will Choy on 31/10/18.
//

#import <UIKit/UIKit.h>
#import "WBGTextTool.h"

@class WBGActionToolOverlapView;
@class WBGIndicatorViewProperties;
@class WBGActionIndicatorView;

@protocol WBGActionIndicatorViewDelegate <NSObject>
@optional
- (void) indicatorViewTapped:(WBGActionIndicatorView *)indicatorView;
@end

@interface WBGActionIndicatorView : UIView
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) NSMutableArray *detailImages;
@property (nonatomic, strong) WBGIndicatorViewProperties *property;
@property (nonatomic, weak) WBGTextTool *textTool;

@property (nonatomic, weak) id<WBGActionIndicatorViewDelegate> delegate;

// Schematic Logics
/*
 **Modules**
 IndicatorImagesViewer
    - List Images
    - Upload Images (Camera/Gallery) can be multiple
    - Change Images
    - Remove Images
 
 **Variables**
 PointImages
 IndicatorPosition (x,y)
 Rotations
 Sequence
 */

@property (nonatomic, strong) WBGActionToolOverlapView *archerBGView;

+ (void)setActiveIndicatorView:(WBGActionIndicatorView *)view;
+ (void)setInactiveIndicatorView:(WBGActionIndicatorView *)view;
- (instancetype)initWithTool:(WBGTextTool *)tool andProperties:(WBGIndicatorViewProperties *)property;
//- (void)setDefaultRotations;
@end

@interface WBGActionToolOverlapView : UIView
@property (nonatomic, copy  ) NSString *text;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIImage *image;
- (void)resetColors;
@end

@interface WBGIndicatorViewProperties : NSObject
@property (nonatomic, assign) CGFloat viewRotation;
@property (nonatomic, assign) CGFloat viewScale;
@property (nonatomic, assign) CGPoint viewCenter;
@end
