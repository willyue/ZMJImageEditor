//
//  ZMJViewController.m
//  ZMJImageEditor
//
//  Created by keshiim on 04/01/2017.
//  Copyright (c) 2017 keshiim. All rights reserved.
//

#import "ZMJViewController.h"
#import <ZMJImageEditor/WBGImageEditor.h>
#import <ZMJImageEditor/WBGMoreKeyboardItem.h>
@interface ZMJViewController () <WBGImageEditorDelegate, WBGImageEditorDataSource, WBGActionIndicatorDataSource>  {
    UIImage *defaultImage;
    NSArray *objects;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ZMJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    defaultImage = self.imageView.image;
}

- (IBAction)editButtonAction:(UIBarButtonItem *)sender {
    if (self.imageView.image) {
        WBGImageEditor *editor = [[WBGImageEditor alloc] initWithImage:defaultImage delegate:self dataSource:self andIndicatorDataSource:self];
        [self presentViewController:editor animated:YES completion:nil];
    } else {
        NSLog(@"木有图片");
    }
    
}

- (IBAction)clearButtonAction:(id)sender {
    self.imageView.image = defaultImage;
    objects = [NSArray array];
}

#pragma mark - WBGImageEditorDelegate
- (void)imageEditor:(WBGImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image {
    self.imageView.image = image;
    [editor.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageEditorDidCancel:(WBGImageEditor *)editor {
    
}

- (void)indicatorsPlaced:(NSArray *)indicators {
    objects = indicators;
}

#pragma mark - WBGActionIndicatorDataSource
- (NSArray *)actionIndicatorItems {
    return objects;
}

#pragma mark - WBGImageEditorDataSource
- (NSArray<WBGMoreKeyboardItem *> *)imageItemsEditor:(WBGImageEditor *)editor {
    return @[
             [WBGMoreKeyboardItem createByTitle:@"p1" imagePath:@"p1" image:[UIImage imageNamed:@"p1"]],
             [WBGMoreKeyboardItem createByTitle:@"p2" imagePath:@"p2" image:[UIImage imageNamed:@"p2"]],
             [WBGMoreKeyboardItem createByTitle:@"p1" imagePath:@"p1" image:[UIImage imageNamed:@"p1"]],
             [WBGMoreKeyboardItem createByTitle:@"p2" imagePath:@"p2" image:[UIImage imageNamed:@"p2"]],
             [WBGMoreKeyboardItem createByTitle:@"p1" imagePath:@"p1" image:[UIImage imageNamed:@"p1"]],
             [WBGMoreKeyboardItem createByTitle:@"p2" imagePath:@"p2" image:[UIImage imageNamed:@"p2"]],
             [WBGMoreKeyboardItem createByTitle:@"p1" imagePath:@"p1" image:[UIImage imageNamed:@"p1"]],
             [WBGMoreKeyboardItem createByTitle:@"p2" imagePath:@"p2" image:[UIImage imageNamed:@"p2"]],
             [WBGMoreKeyboardItem createByTitle:@"p1" imagePath:@"p1" image:[UIImage imageNamed:@"p1"]],
             [WBGMoreKeyboardItem createByTitle:@"p2" imagePath:@"p2" image:[UIImage imageNamed:@"p2"]]
             ];
}

- (WBGImageEditorComponent)imageEditorCompoment {
    return WBGImageEditorIndicatorComponent | WBGImageEditorColorPanComponent;
//    return WBGImageEditorWholeComponent;
}

- (UIColor *)imageEditorDefaultColor {
    return UIColor.redColor;
}

- (NSNumber *)imageEditorDrawPathWidth {
    return @(5.f);
}
#pragma mark - ------line------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
