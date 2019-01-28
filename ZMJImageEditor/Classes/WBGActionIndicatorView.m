//
//  WBGActionIndicatorView.m
//  Pods
//
//  Created by Will Choy on 31/10/18.
//

#import "WBGActionIndicatorView.h"
#import "WBGImageEditorGestureManager.h"
#import "ImageManagerVC.h"
#import "UIView+YYAdd.h"
#import "UIImage+library.h"

static const CGFloat MIN_TEXT_SCAL = 0.614f;
static const CGFloat MAX_TEXT_SCAL = 4.0f;
static const CGFloat DELETEBUTTON_BOUNDS = 26.f;
static const CGFloat SELECTED_ALPHA = 0.15f;

@interface WBGActionToolOverlapContentView : UIView
@property (nonatomic, copy  ) NSString *text;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat defaultFont;


@property (nonatomic, strong) UIView *rotateView;
@property (nonatomic, strong) UIView *frameView;
@property (nonatomic) CGAffineTransform defaultRotateTransform;

@end

@implementation WBGActionToolOverlapContentView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
#warning calculate dynamic
        // Draw border
        _frameView = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 40, 40)];
        _frameView.layer.borderWidth = 0.0f;
        _frameView.layer.cornerRadius = 20.0f;
        [self addSubview:_frameView];
        
        // Indicator
        _rotateView = [[UIView alloc] initWithFrame:self.frame];
        // Add Arrow
#warning calculate dynamic
        UIImageView *indicator = [[UIImageView alloc] initWithFrame:CGRectMake(40,10,20,20)];
        indicator.image = [UIImage my_imageNamed:@"arrow_long2" inBundle:[NSBundle bundleForClass:self.class]];
//        indicator.backgroundColor = [UIColor purpleColor];
        [_rotateView addSubview:indicator];
        
        _defaultRotateTransform = _rotateView.transform;
        
        [self addSubview:_rotateView];
    }
    
    return self;
}

- (void)setText:(NSString *)text {
    if (_text != text) {
        _text = text;
        [self setNeedsDisplay];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor != textColor) {
        _textColor = textColor;
        [self setNeedsDisplay];
        [self updateOthersViewColor];
        
    }
}

- (void)setTextFont:(UIFont *)textFont {
    if (_textFont != textFont) {
        _textFont = textFont;
        _defaultFont = textFont.pointSize;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor grayColor]; //阴影颜色
    shadow.shadowOffset= CGSizeMake(2, 2);//偏移量
    shadow.shadowBlurRadius = 5;//模糊度
    

    
    rect.origin = CGPointMake(1, 2);
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:self.text
                                                                 attributes:@{NSForegroundColorAttributeName : self.textColor,
                                                                              NSFontAttributeName : self.textFont,
                                                                              NSParagraphStyleAttributeName:paragraphStyle,
                                                                              NSShadowAttributeName: shadow}];
    
#warning calculate dynamic
    [string drawInRect:CGRectMake(35, 40, 30, 30)];
}

- (void)updateOthersViewColor {
    for (UIView *subView in self.rotateView.subviews) {
       if([subView isKindOfClass:[UIImageView class]]) {
           UIImageView *imgView = (UIImageView *)subView;
           [imgView setTintColor:self.textColor];
       }
    }
    
    [_frameView.layer setBorderColor:self.textColor.CGColor];
}

@end

@interface WBGActionToolOverlapView ()
@property (nonatomic, strong) WBGActionToolOverlapContentView *contentView;
@end
@implementation WBGActionToolOverlapView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [[WBGActionToolOverlapContentView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
    }
    return self;
}

- (void)setText:(NSString *)text {
    if (_text != text) {
        _text = text;
        [_contentView setText:_text];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor != textColor) {
        _textColor = textColor;
        [_contentView setTextColor:_textColor];
    }
}

- (void)setTextFont:(UIFont *)textFont {
    if (_textFont != textFont) {
        _textFont = textFont;
        _contentView.defaultFont = textFont.pointSize;
        [_contentView setTextFont:_textFont];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.bounds = self.bounds;
    _contentView.origin = CGPointZero;
}

- (void)resetColors {
    [_contentView.frameView setBackgroundColor:[UIColor clearColor]];
}

@end

@implementation WBGIndicatorViewProperties
- (instancetype)init {
    self = [super init];
    if(self) {
        self.viewRotation = 0.0f;
        self.viewScale = 1.0f;
        self.viewCenter = CGPointMake(0, 0);
    }
    return self;
}
@end

@interface WBGActionIndicatorView() <UIGestureRecognizerDelegate>
@end

@implementation WBGActionIndicatorView
{
    UIButton *_deleteButton;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
    
    CALayer *rectLayer1;
    CALayer *rectLayer2;
    CALayer *rectLayer3;
    
    CGAffineTransform defaultTransform;
}

static WBGActionIndicatorView *activeView = nil;
+ (void)setActiveIndicatorView:(WBGActionIndicatorView *)view
{
    if(view) {
        activeView.textTool.editor.currentMode = EditorIndicatorMode;
        [activeView.textTool.editor hiddenValueSlider:NO animation:YES];
        [activeView.textTool.editor hiddenColorPan:NO animation:YES];
    }else{
        [activeView.textTool.editor resetCurrentTool];
        [activeView.textTool.editor hiddenValueSlider:YES animation:YES];
    }
    
    if(view != activeView){
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        
        [activeView.archerBGView.superview bringSubviewToFront:activeView.archerBGView];
        [activeView.superview bringSubviewToFront:activeView];
    }
}

+ (void)setInactiveIndicatorView:(WBGActionIndicatorView *)view {
    [activeView.textTool.editor resetCurrentTool];
    [activeView.textTool.editor hiddenValueSlider:YES animation:YES];
    
    if (activeView) {activeView = nil;}
    
    [view setAvtive:NO];
}


- (instancetype)initWithTool:(WBGTextTool *)tool andProperties:(WBGIndicatorViewProperties *)property
{
    self = [super initWithFrame:CGRectMake(0, 0, 100,100)];
    if(self){
        _arg = 0;
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage my_imageNamed:@"close_Text" inBundle:[NSBundle bundleForClass:self.class]] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0,0, DELETEBUTTON_BOUNDS, DELETEBUTTON_BOUNDS);
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_deleteButton];
        
        _detailImages = [NSMutableArray array];
        
        _property = property;
        if(!_property) {
            _property = [[WBGIndicatorViewProperties alloc] init];
            _property.viewCenter = self.center;
        }
        
        _archerBGView = [[WBGActionToolOverlapView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _archerBGView.backgroundColor = [UIColor clearColor];
        
        _textTool = tool;
        
        defaultTransform = _archerBGView.transform;
        
        self.center = _property.viewCenter;
        
    }
    return self;
}

- (void)initGestures
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPinch:)];
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidRotation:)];
    
    [pinch requireGestureRecognizerToFail:tap];
    [rotation requireGestureRecognizerToFail:tap];
    
    [self.textTool.editor.scrollView.panGestureRecognizer requireGestureRecognizerToFail:pan];
    
    tap.delegate = [WBGImageEditorGestureManager instance];
    pan.delegate = [WBGImageEditorGestureManager instance];
    pinch.delegate = [WBGImageEditorGestureManager instance];
    rotation.delegate = [WBGImageEditorGestureManager instance];
    
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:pan];
//    [self addGestureRecognizer:pinch];
    [self.textTool.editor.view addGestureRecognizer:rotation];
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    CGFloat radius = 100.0;
//    CGRect frame = CGRectMake(0, 0, 30, 30);
//
//    if (CGRectContainsPoint(frame, point)) {
//        return YES;
//    }
//
//    return [super pointInside:point withEvent:event];
//}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    CGFloat radius = 100.0;
//    CGRect frame = CGRectMake(0, 0, 30, 30);
//
//    if (CGRectContainsPoint(frame, point)) {
//        [self viewDidTap:nil];
////        return self;
//    }
//    return [super hitTest:point withEvent:event];
//}

//
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if(view == self) {
        return self;
    }
    return view;
}

#pragma mark- helper methods
- (NSArray *) getIndicatorViews {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [WBGActionIndicatorView class]];
    NSMutableArray* indicatorViews = [[[self.superview.subviews filteredArrayUsingPredicate:predicate] sortedArrayUsingComparator:^NSComparisonResult(WBGActionIndicatorView *obj1, WBGActionIndicatorView *obj2) {
        NSInteger counter1 = [obj1.text integerValue];
        NSInteger counter2 = [obj2.text integerValue];
        
        return counter1 > counter2;
    }] mutableCopy];
    
    return indicatorViews;
}

//- (void)setDefaultRotations {
//    NSArray *indicatorViews = [self getIndicatorViews];
//
//    if([indicatorViews count] > 1) {
//        WBGActionIndicatorView *lastIndicator = (WBGActionIndicatorView *)[indicatorViews objectAtIndex:[indicatorViews count]-2];
//        self.rotation = lastIndicator.rotation;
//        _archerBGView.contentView.rotateView.transform = CGAffineTransformRotate(_archerBGView.contentView.rotateView.transform,  self.rotation);
//    }
//
//    self.rotation = 0.0f;
//}

#pragma mark- gesture events
- (void)pushedDeleteBtn:(id)sender
{
    NSMutableArray *indicatorViews = [[self getIndicatorViews] mutableCopy];
    
    WBGActionIndicatorView *nextTarget = nil;
    
    const NSInteger index = [indicatorViews indexOfObject:self];
    
    for(NSInteger i=index+1; i<[indicatorViews count]; ++i){
        UIView *view = [indicatorViews objectAtIndex:i];
        nextTarget = (WBGActionIndicatorView *)view;
        break;
    }
    
    if(nextTarget==nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [indicatorViews objectAtIndex:i];
            nextTarget = (WBGActionIndicatorView *)view;
            break;
        }
    }
    
    // Reset counter values
    [indicatorViews removeObject:self];
    NSInteger counter = 1;
    for(WBGActionIndicatorView *indicator in indicatorViews) {
        indicator.text = [NSString stringWithFormat:@"%ld",(long)counter];
        counter += 1;
    }

    [[self class] setActiveIndicatorView:nextTarget];
    [self removeFromSuperview];
    [_archerBGView removeFromSuperview];
}

- (void)pushedForImageManager {
    NSLog(@"pressed: %@",self.text);
    ImageManagerVC *imageManager = [[ImageManagerVC alloc] initWithNibName:@"ImageManagerVC" bundle:[NSBundle bundleForClass:[ImageManagerVC class]]];
    imageManager.images = self.detailImages;
    
    [self.superview.viewController presentViewController:imageManager animated:YES completion:nil];
}

- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if(self.active){
            [self pushedForImageManager];
        } else {
            //取消当前
//            [self.textTool.editor resetCurrentTool];
        }
        [[self class] setActiveIndicatorView:self];
        [self.textTool.editor hiddenTopAndBottomBar:NO animation:YES];
    }
}

- (void)viewDidPan:(UIPanGestureRecognizer*)recognizer
{
    //平移
    [[self class] setActiveIndicatorView:self];
    UIView *piece = activeView.archerBGView;
    CGPoint translation = [recognizer translationInView:piece.superview];
    piece.center = CGPointMake(piece.center.x + translation.x, piece.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:piece.superview];
    
    _property.viewCenter = piece.center;
    
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged) {
        [self.textTool.editor hiddenTopAndBottomBar:YES animation:YES];
        [self.textTool.editor hiddenColorPan:YES animation:YES];
        [self.textTool.editor hiddenValueSlider:YES animation:YES];
        //取消当前
//        [self.textTool.editor resetCurrentTool];
    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateFailed ||
               recognizer.state == UIGestureRecognizerStateCancelled) {
        
        CGRect rectCoordinate = [piece.superview convertRect:piece.frame toView:self.textTool.editor.imageView.superview];
        if (!CGRectIntersectsRect(CGRectInset(self.textTool.editor.imageView.frame, 30, 30), rectCoordinate)) {
            [UIView animateWithDuration:.2f animations:^{
                piece.center = piece.superview.center;
                self.center = piece.center;
            }];
        }
        
        [self.textTool.editor hiddenTopAndBottomBar:NO animation:YES];
        [self.textTool.editor hiddenColorPan:NO animation:YES];
        [self.textTool.editor hiddenValueSlider:NO animation:YES];
    }
    [activeView layoutSubviews];
}

- (void)viewDidPinch:(UIPinchGestureRecognizer *)recognizer {
    //缩放
    [[self class] setActiveIndicatorView:self];
    
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged) {
        //坑点：recognizer.scale是相对原图片大小的scal
        
        CGFloat scale = [(NSNumber *)[_archerBGView valueForKeyPath:@"layer.transform.scale.x"] floatValue];
        NSLog(@"scale = %f", scale);
        
        [self.textTool.editor hiddenTopAndBottomBar:YES animation:YES];
        //取消当前
        [self.textTool.editor resetCurrentTool];
        
        _property.viewScale = recognizer.scale;
        
        if (scale > MAX_TEXT_SCAL && _property.viewScale > 1) {
            return;
        }
        
        if (scale < MIN_TEXT_SCAL && _property.viewScale < 1) {
            return;
        }
        
        
        _archerBGView.transform = CGAffineTransformScale(_archerBGView.transform, _property.viewScale, _property.viewScale);
        recognizer.scale = 1;
        [self layoutSubviews];
        
        [self.textTool.editor hiddenTopAndBottomBar:YES animation:YES];
    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateFailed ||
               recognizer.state == UIGestureRecognizerStateCancelled) {
        [self.textTool.editor hiddenTopAndBottomBar:NO animation:YES];
    }
}

- (void)viewDidRotation:(UIRotationGestureRecognizer *)recognizer {
    //旋转
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged) {
        
        activeView.archerBGView.contentView.rotateView.transform = CGAffineTransformRotate(activeView.archerBGView.contentView.rotateView.transform, recognizer.rotation);
        activeView.property.viewRotation = [[activeView.archerBGView.contentView.rotateView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        
        NSLog(@"%.2f - %.2f",recognizer.rotation,activeView.property.viewRotation);
        
        recognizer.rotation = 0;
        [activeView layoutSubviews];
        
        [self.textTool.editor hiddenTopAndBottomBar:YES animation:YES];
        [self.textTool.editor hiddenColorPan:YES animation:YES];
        [self.textTool.editor hiddenValueSlider:YES animation:YES];
        //取消当前
        self.textTool.editor.currentMode = EditorIndicatorMode;
    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateFailed ||
               recognizer.state == UIGestureRecognizerStateCancelled) {
        [self.textTool.editor hiddenTopAndBottomBar:NO animation:YES];
        [self.textTool.editor hiddenColorPan:NO animation:YES];
        [self.textTool.editor hiddenValueSlider:NO animation:YES];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect boundss;
    if (!_archerBGView.superview) {
        [self.superview insertSubview:_archerBGView belowSubview:self];
        _archerBGView.frame = self.frame;
        boundss = self.bounds;
        
        // Set defaults rotation & scale
        _archerBGView.contentView.rotateView.transform = CGAffineTransformRotate(_archerBGView.contentView.defaultRotateTransform, _property.viewRotation);
        _archerBGView.transform = CGAffineTransformScale(defaultTransform, _property.viewScale, _property.viewScale);
        
        
        [self initGestures];
    }
    boundss = _archerBGView.bounds;
//    self.transform = CGAffineTransformMakeRotation(activeView.rotation);
    
    CGFloat w = boundss.size.width;
    CGFloat h = boundss.size.height;
    CGFloat scale = [(NSNumber *)[_archerBGView valueForKeyPath:@"layer.transform.scale.x"] floatValue];
    
    self.bounds = CGRectMake(0, 0, w*scale, h*scale);
    self.center = _archerBGView.center;
}



#pragma mark- Properties
- (void)setAvtive:(BOOL)active {
    dispatch_async(dispatch_get_main_queue(), ^{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _deleteButton.hidden = !active;
        
        _deleteButton.layer.shadowColor = [UIColor grayColor].CGColor;
        _deleteButton.layer.shadowOffset= CGSizeMake(0, 0);
        _deleteButton.layer.shadowOpacity = .6f;
        _deleteButton.layer.shadowRadius = 2.f;
        
        rectLayer1.hidden = rectLayer2.hidden = rectLayer3.hidden = !active;
        [CATransaction commit];
        
        // Set the value slider value when active object switched
        CGFloat scale = [(NSNumber *)[_archerBGView valueForKeyPath:@"layer.transform.scale.x"] floatValue];
        self.textTool.editor.valueSlider.minimumValue = 0.3f;
        self.textTool.editor.valueSlider.value = scale;
        
        if (active) {
            [self.archerBGView.contentView.frameView setBackgroundColor:[self.archerBGView.contentView.textColor colorWithAlphaComponent:SELECTED_ALPHA]];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor:) name:@"kColorPanNotificaiton" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueSlider:) name:@"kValueSliderNotification" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAnnotation) name:@"kRemoveAnnotationNotification" object:nil];
        } else {
            [self.archerBGView.contentView.frameView setBackgroundColor:[UIColor clearColor]];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kColorPanNotificaiton" object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kValueSliderNotification" object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kRemoveAnnotationNotification" object:nil];
        }
    });
}

- (void)changeColor:(NSNotification *)notification {
    UIColor *currentColor = (UIColor *)notification.object;
    self.fillColor = currentColor;
}

- (void)valueSlider:(NSNotification *)notification {
    CGFloat scale = [(NSNumber *)[_archerBGView valueForKeyPath:@"layer.transform.scale.x"] floatValue];
    NSLog(@"scale = %f, %f", scale,[notification.object floatValue]);
    
    [self.textTool.editor hiddenTopAndBottomBar:YES animation:YES];
    //取消当前
//    [self.textTool.editor resetCurrentTool];
    
    _property.viewScale = [notification.object floatValue];
    _archerBGView.transform = CGAffineTransformScale(defaultTransform, _property.viewScale, _property.viewScale);
    
    [self layoutSubviews];
}

- (void)removeAnnotation {
    [self pushedDeleteBtn:nil];
}

- (BOOL)active
{
    return !_deleteButton.hidden;
}

- (void)setFillColor:(UIColor *)fillColor
{
    _archerBGView.textColor = fillColor;
    [self.archerBGView.contentView.frameView setBackgroundColor:[self.archerBGView.textColor colorWithAlphaComponent:SELECTED_ALPHA]];
}


- (void)setFont:(UIFont *)font
{
    _archerBGView.textFont = font;
}

- (UIFont*)font
{
    return _archerBGView.textFont;
}

- (void)setText:(NSString *)text
{
    if(![text isEqualToString:_text]){
        _text = text;
        _archerBGView.text = _text;
    }
}

@end
