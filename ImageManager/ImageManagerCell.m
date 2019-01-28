//
//  ImageManagerCell.m
//  ZMJImageEditor
//
//  Created by Will Choy on 5/11/18.
//

#import "ImageManagerCell.h"

@implementation ImageManagerCell

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imgThumbnail];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


#pragma mark - Getter -
- (UIImageView *)imgThumbnail
{
    if (_imgThumbnail == nil) {
        _imgThumbnail = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imgThumbnail.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imgThumbnail.clipsToBounds = YES;
        _imgThumbnail.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgThumbnail;
}

@end
