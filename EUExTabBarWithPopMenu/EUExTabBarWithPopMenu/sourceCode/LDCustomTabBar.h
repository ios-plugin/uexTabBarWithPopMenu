//
//  LDCustomTabBar.h
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDCustomCenterItem.h"
@protocol LDCustomTabBarDelegate;

@interface LDCustomTabBar : UIView
@property(nonatomic,weak)id <LDCustomTabBarDelegate> delegate;
@property(nonatomic,strong)UIView *popMainBackView;
@property(nonatomic,strong)LDCustomCenterItem *centerView;
-(id)initWithFrame:(CGRect)frame centerImage:(UIImage*)centerImage backgroundColor:(UIColor*)backgroundColor statusColor:(UIColor*) statusColor delegate:(id)delegate count:(NSInteger)count;

-(void)setTabBarItems:(NSArray *)items;
-(void)setPopMenuItems:(NSArray *)items WithBackgroundColor:(UIColor *)bgColor popMenuColor:(UIColor*)popMenuColor BottomDistance:(CGFloat)bottomDistance;
-(void)selectTabItemWithIndex:(int)index;

@end

@protocol LDCustomTabBarDelegate <NSObject>


@end
