//
//  LDCustomTabBarItem.m
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import "LDCustomTabBarItem.h"
//#import "UIView+Helpers.h"
#define kDefaultTitleLabelTextColor [UIColor whiteColor]
@interface LDCustomTabBarItem()
@property(nonatomic,strong)UIImageView *contentImgView;
@property(nonatomic,strong)UILabel *titleLabel;
@end
@implementation LDCustomTabBarItem
-(id)initWithTitle:(NSString *)title contentImage:(UIImage *)contentImg contentHighlightImage:(UIImage *)contentHImage{
    if (self = [super initWithFrame:CGRectZero]) {
        UIImageView *contentImgView = [[UIImageView alloc] initWithImage:contentImg highlightedImage:contentHImage];
        [contentImgView setUserInteractionEnabled:YES];
        [self addSubview:contentImgView];
        self.contentImgView = contentImgView;
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [tLabel setBackgroundColor:[UIColor clearColor]];
        [tLabel setText:title];
        [tLabel setTextAlignment:NSTextAlignmentCenter];
        [tLabel setTextColor:kDefaultTitleLabelTextColor];        
        [tLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
        [self addSubview:tLabel];
        self.titleLabel = tLabel;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    float imgW = self.contentImgView.image.size.width;
    float imgH = self.contentImgView.image.size.height;
    float contentW = MIN(imgW, self.frame.size.width);
    float contentH = MIN(imgH, self.frame.size.height - 20);
    [self.contentImgView setFrame:CGRectMake((self.frame.size.width - contentW)/2, 4, contentW,contentH)];
    [self.titleLabel setFrame:CGRectMake(0,_contentImgView.frame.origin.y+_contentImgView.frame.size.height+2, self.frame.size.width, 12)];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
