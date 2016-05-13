//
//  LDCustomCenterItem.h
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LDCustomCenterItemDelegate;

@interface LDCustomCenterItem : UIImageView
@property(nonatomic,assign)BOOL popMenuIsExpanding;
@property(nonatomic,strong)UIImageView *contentImgView;
@property(nonatomic,weak)id <LDCustomCenterItemDelegate>delegate;
-(id)initWithFrame:(CGRect)frame contentImg:(UIImage *)contentImg;
-(void)resetAnimations;

@end

@protocol LDCustomCenterItemDelegate <NSObject>
-(void)centerItemClickWithStatus:(BOOL)isExpanding;

@end