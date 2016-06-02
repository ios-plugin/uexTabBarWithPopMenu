//
//  LDPopMenuItem.m
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import "LDPopMenuItem.h"
#import "UIView+Extenssion.h"
#define kDefaultTitleLabelTextColor [UIColor whiteColor]

@interface LDPopMenuItem()
@property(nonatomic,strong)UIImageView *contentImgView;

@end
@implementation LDPopMenuItem

-(id)initWithTitle:(NSString *)title textSize:(CGFloat)textSize textColor:(UIColor*)textColor highlightedTextColor:(UIColor*)highlightedTextColor image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    if (self = [super initWithFrame:CGRectZero]) {
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:selectedImage forState:UIControlStateSelected];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:textSize];
        [self setTitleColor:textColor forState:UIControlStateNormal];
        [self setTitleColor:highlightedTextColor forState:UIControlStateHighlighted];
        
        
    }
    return self;

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    self.titleLabel.width = self.width;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame)+20;
    self.titleLabel.x = 0;
    self.titleLabel.height = self.height - self.titleLabel.y;
   
}
@end
