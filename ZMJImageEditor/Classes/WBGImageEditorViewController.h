//
//  WBGImageEditorViewController.h
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/27.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGImageEditor.h"

typedef NS_ENUM(NSUInteger, EditorMode) {
    EditorNonMode,
    EditorDrawMode,
    EditorTextMode,
    EditorClipMode,
    EditorPaperMode,
    EditorIndicatorMode,
};

extern NSString * const kColorPanNotificaiton;

@interface WBGColorPan : UIView
@property (nonatomic, strong, readonly) UIColor *currentColor;
@property (nonatomic, weak) id<WBGImageEditorDataSource> dataSource;
@end

@interface WBGImageEditorViewController : WBGImageEditor
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;

@property (weak,   nonatomic, readonly) IBOutlet UIImageView *imageView;
@property (strong, nonatomic, readonly) IBOutlet UIImageView *drawingView;
@property (weak,   nonatomic, readonly) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic, readonly) IBOutlet WBGColorPan *colorPan;

@property (weak, nonatomic) IBOutlet UISlider *valueSlider;

@property (nonatomic, assign) EditorMode currentMode;

- (void)resetCurrentTool;

- (void)editTextAgain;
- (void)hiddenTopAndBottomBar:(BOOL)isHide animation:(BOOL)animation;
- (void)hiddenColorPan:(BOOL)yesOrNot animation:(BOOL)animation;
- (void)hiddenValueSlider:(BOOL)yesOrNot animation:(BOOL)animation;
@end
