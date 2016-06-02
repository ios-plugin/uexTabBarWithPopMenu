//
//  LDCustomTabBarItem.m
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import "LDCustomTabBarItem.h"
#define kDefaultTitleLabelTextColor [UIColor whiteColor]
@interface LDCustomTabBarItem()

@end
@implementation LDCustomTabBarItem
-(LDCustomTabBarItem*)initWithTitle:(NSString *)title textSize:(CGFloat)textSize textColor:(UIColor*)textColor highlightedTextColor:(UIColor*)highlightedTextColor  contentImage:(UIImage *)contentImg contentHighlightImage:(UIImage *)contentHImage{
    if (self = [super initWithFrame:CGRectZero]) {
        UIImageView *contentImgView = [[UIImageView alloc] initWithImage:contentImg];
        self.textColor = textColor;
        self.highlightedTextColor = highlightedTextColor;
        self.contentImg = contentImg;
        self.contentHImage = contentHImage;
        [contentImgView setUserInteractionEnabled:YES];
        [self addSubview:contentImgView];
        self.contentImgView = contentImgView;
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [tLabel setBackgroundColor:[UIColor clearColor]];
        [tLabel setText:title];
        [tLabel setTextAlignment:NSTextAlignmentCenter];
        [tLabel setTextColor:textColor];
        [tLabel setHighlightedTextColor:highlightedTextColor];
        [tLabel setFont:[UIFont boldSystemFontOfSize:textSize]];
        [self addSubview:tLabel];
        self.titleLabel = tLabel;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    float imgW = self.contentImgView.image.size.width/1.35;
    float imgH = self.contentImgView.image.size.height/1.35;
    float contentW = MIN(imgW, self.frame.size.width);
    float contentH = MIN(imgH, self.frame.size.height);
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
