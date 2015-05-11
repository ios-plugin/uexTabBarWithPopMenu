//
//  LDCustomTabBar.h
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LDCustomTabBarDelegate;

@interface LDCustomTabBar : UIView
@property(nonatomic,weak)id <LDCustomTabBarDelegate> delegate;


-(id)initWithFrame:(CGRect)frame delegate:(id)delegate;

-(void)setTabBarItems:(NSArray *)items;
-(void)setPopMenuItems:(NSArray *)items;
-(void)selectTabItemWithIndex:(int)index;

@end

@protocol LDCustomTabBarDelegate <NSObject>


@end
