//
//  LDCustomTabBarItem.h
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDCustomTabBarItem : UIView
@property(nonatomic,strong)UIImageView *contentImgView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIColor* textColor;
@property(nonatomic,strong)UIColor*highlightedTextColor;
@property(nonatomic,strong)UIImage *contentImg;
@property(nonatomic,strong)UIImage *contentHImage;
-(LDCustomTabBarItem*)initWithTitle:(NSString *)title textSize:(CGFloat)textSize textColor:(UIColor*)textColor highlightedTextColor:(UIColor*)highlightedTextColor  contentImage:(UIImage *)contentImg contentHighlightImage:(UIImage *)contentHImage;

@end
