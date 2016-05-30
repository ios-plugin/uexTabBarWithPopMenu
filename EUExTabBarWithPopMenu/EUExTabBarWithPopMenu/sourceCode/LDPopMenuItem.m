//
//  LDPopMenuItem.m
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import "LDPopMenuItem.h"

#define kDefaultTitleLabelTextColor [UIColor whiteColor]

@interface LDPopMenuItem()
@property(nonatomic,strong)UIImageView *contentImgView;

@end
@implementation LDPopMenuItem

-(id)initWithTitle:(NSString *)title textSize:(CGFloat)textSize textColor:(UIColor*)textColor highlightedTextColor:(UIColor*)highlightedTextColor image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    if (self = [super initWithFrame:CGRectZero]) {

        [self setImage:image forState:UIControlStateNormal];
        [self setImage:selectedImage forState:UIControlStateSelected];
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:textSize];
        [self setTitleColor:textColor forState:UIControlStateNormal];
        [self setTitleColor:highlightedTextColor forState:UIControlStateHighlighted];
        
        
    }
    return self;

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat midX = self.frame.size.width / 2;
    CGFloat midY = self.frame.size.height/ 2 ;
    
    self.imageView.center = CGPointMake(midX, midY);
    //self.titleLabel.center = CGPointMake(midX, midY +100);
     CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    NSLog(@"titleSize:%@",NSStringFromCGSize(titleSize));
    // CGSize textSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width-37.333333333333336, - (imageSize.height+20),  0);
    //self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0,  0);
//    CGFloat selfWidth = self.frame.size.width;
//    CGFloat selfHeight = self.frame.size.height;
//    CGRect titleRect = self.titleLabel.frame;
//    CGRect imageRect = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);//self.imageView.frame;
//    CGFloat padding;
//    
//    CGFloat totalHeight = titleRect.size.height +padding +imageRect.size.height;
//    self.titleEdgeInsets =UIEdgeInsetsMake(((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
//                                      (selfWidth/2 - titleRect.origin.x - titleRect.size.width /2) - (selfWidth - titleRect.size.width) /2,
//                                      -((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
//                                      -(selfWidth/2 - titleRect.origin.x - titleRect.size.width /2) - (selfWidth - titleRect.size.width) /2);
//    
//    self.imageEdgeInsets =UIEdgeInsetsMake(((selfHeight - totalHeight)/2 - imageRect.origin.y),
//                                      (selfWidth /2 - imageRect.origin.x - imageRect.size.width /2),
//                                      -((selfHeight - totalHeight)/2 - imageRect.origin.y),
//                                      -(selfWidth /2 - imageRect.origin.x - imageRect.size.width /2));
    
}
@end
