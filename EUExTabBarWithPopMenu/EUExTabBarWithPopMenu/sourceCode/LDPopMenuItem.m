//
//  LDPopMenuItem.m
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import "LDPopMenuItem.h"
//#import "UIView+Helpers.h"
#define kDefaultTitleLabelTextColor [UIColor whiteColor]

@interface LDPopMenuItem()
@property(nonatomic,strong)UIImageView *contentImgView;
@property(nonatomic,strong)UILabel *titleLab;
@end
@implementation LDPopMenuItem

-(id)initWithTitle:(NSString *)title textSize:(CGFloat)textSize textColor:(UIColor*)textColor highlightedTextColor:(UIColor*)highlightedTextColor image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    if (self = [super initWithFrame:CGRectZero]) {
        UIImageView *contentImgView = [[UIImageView alloc] initWithImage:image highlightedImage:selectedImage];
        [contentImgView setUserInteractionEnabled:YES];
        [self addSubview:contentImgView];
        self.contentImgView = contentImgView;
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [tLabel setBackgroundColor:[UIColor clearColor]];
        [tLabel setText:title];
        [tLabel setTextColor:textColor];
        [tLabel setHighlightedTextColor:highlightedTextColor];
        [tLabel setTextAlignment:NSTextAlignmentCenter];
        //[tLabel setTextColor:textColor?textColor:kDefaultTitleLabelTextColor];
        [tLabel setFont:[UIFont boldSystemFontOfSize:textSize]];
        [self addSubview:tLabel];
        self.titleLab = tLabel;
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
    [self.titleLab setFrame:CGRectMake(0,_contentImgView.frame.origin.y+_contentImgView.frame.size.height+5, self.frame.size.width, 12)];
    
}
@end
