//
//  WBGImageEditor.m
//  Trader
//
//  Created by Jason on 2017/3/13.
//
//

#import "WBGImageEditor.h"
#import "WBGImageEditorViewController.h"

@interface WBGImageEditor ()

@end

@implementation WBGImageEditor

- (instancetype)init
{
    return [WBGImageEditorViewController new];
}

- (id)initWithImage:(UIImage*)image
{
    return [self initWithImage:image delegate:nil dataSource:nil];
}

- (id)initWithImage:(UIImage*)image delegate:(id<WBGImageEditorDelegate>)delegate dataSource:(id<WBGImageEditorDataSource>)dataSource;
{
    return [[WBGImageEditorViewController alloc] initWithImage:image delegate:delegate dataSource:dataSource];
}

- (id)initWithImage:(UIImage*)image delegate:(id<WBGImageEditorDelegate>)delegate dataSource:(id<WBGImageEditorDataSource>)dataSource andIndicatorDataSource:(id<WBGActionIndicatorDataSource>)indicatorDataSource andIndicatorDelegate:(id<WBGActionIndicatorDelegate>)indicatorDelegate
{
    return [[WBGImageEditorViewController alloc] initWithImage:image delegate:delegate dataSource:dataSource andIndicatorDataSource:indicatorDataSource andIndicatorDelegate:indicatorDelegate];
}

- (id)initWithImage:(UIImage*)image delegate:(id<WBGImageEditorDelegate>)delegate dataSource:(id<WBGImageEditorDataSource>)dataSource andPlaceHolderText:(NSString *)placeholder;
{
    return [[WBGImageEditorViewController alloc] initWithImage:image delegate:delegate dataSource:dataSource andPlaceHolderText:placeholder];
}

- (id)initWithDelegate:(id<WBGImageEditorDelegate>)delegate
{
    return [[WBGImageEditorViewController alloc] initWithDelegate:delegate];
}

- (void)showInViewController:(UIViewController*)controller withImageView:(UIImageView*)imageView;
{
    
}

- (void)refreshToolSettings
{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
