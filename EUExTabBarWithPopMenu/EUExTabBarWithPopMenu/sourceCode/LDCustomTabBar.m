//
//  LDCustomTabBar.m
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import "LDCustomTabBar.h"
#import "LDCustomCenterItem.h"
//#import "UIView+Helpers.h"
//#import "LDPluginUtil.h"
#import "LDCustomTabBarItem.h"
#import "LDPopMenuView.h"
#import "EUtility.h"
//32394a
#define kDefaultBackgroundColor ([UIColor colorWithRed:50/255.0 green:57/255.0 blue:74/255.0 alpha:1.0])
//f5b82c
#define kDefaultStatusViewColor ([UIColor colorWithRed:245/255.0 green:184/255.0 blue:44/255.0 alpha:1.0])
#define kDefaultPopBackColor ([UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1.0])

#define kDefaultStatusViewHeight  2
static CGFloat const kDefaultCenterWidth = 59;
static CGFloat const kDefaultCenterHeight = 59;

@interface LDCustomTabBar() <LDCustomCenterItemDelegate>
@property(nonatomic,strong)NSArray *tabItems;
@property(nonatomic,strong)NSArray *popItems;
@property(nonatomic,strong)UIView *statusView;
@property(nonatomic,strong)LDCustomCenterItem *centerView;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)UIView *popMainBackView;
@property(nonatomic,strong)LDPopMenuView *popContainerView;
@end
@implementation LDCustomTabBar
-(id)initWithFrame:(CGRect)frame centerImage:(UIImage*)centerImage backgroundColor:(UIColor*)backgroundColor statusColor:(UIColor*) statusColor delegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:backgroundColor];
        self.delegate = delegate;
        [self drawCenterItemWithCenterImage:centerImage];
        [self drawStatusViewWithStatusColor:statusColor];
    }
    return self;
}
-(void)drawCenterItemWithCenterImage:(UIImage*)centerImage{
    LDCustomCenterItem *centerItem = [[LDCustomCenterItem alloc] initWithFrame:CGRectMake((self.frame.size.width - kDefaultCenterWidth)*0.5, self.frame.size.height - kDefaultCenterHeight, kDefaultCenterWidth, kDefaultCenterHeight) contentImg:centerImage];
    centerItem.delegate = self;
    [self addSubview:centerItem];
    self.centerView = centerItem;
    
    
}
-(void)drawStatusViewWithStatusColor:(UIColor*)statusColor{
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - kDefaultStatusViewHeight,self.frame.size.width, kDefaultStatusViewHeight)];
    [statusView setBackgroundColor:statusColor];
    [self addSubview:statusView];
    statusView.hidden = YES;
    self.statusView = statusView;
    
}
-(void)setTabBarItems:(NSArray *)items{
    self.tabItems = items;
    [self addTabItems];
}
-(void)addTabItems{
    int count = self.tabItems.count;
    if (count > 0&&count%2==0) {
        int middle = count/2;
        CGFloat itemWidth = (self.frame.size.width - self.centerView.frame.size.width)/count;
        for (int i = 0;i < self.tabItems.count;i++) {
            LDCustomTabBarItem *itemView = self.tabItems[i];
            if (i < middle) {
                [itemView setFrame:CGRectMake(i*itemWidth, 0, itemWidth, self.frame.size.height - self.statusView.frame.size.height)];
            }else{
                [itemView setFrame:CGRectMake(self.centerView.frame.size.width+(i*itemWidth), 0, itemWidth, self.frame.size.height - self.statusView.frame.size.height)];
            }
            [self addSubview:itemView];
            
        }
    }

}
-(void)setPopMenuItems:(NSArray *)items WithBackgroundColor:(UIColor *)bgColor popMenuColor:(UIColor*)popMenuColor BottomDistance:(CGFloat)bottomDistance {
    self.popItems = items;
    [self addPopItemsWithBackgroundColor:bgColor popMenuColor:popMenuColor bottomDistance:bottomDistance];
}
-(void)drawBackgroundView:(UIColor *)bgColor{
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [EUtility screenWidth], [EUtility screenHeight])];
    [mainView setBackgroundColor:bgColor];//[UIColor colorWithWhite:0 alpha:0.5]];
    [mainView setHidden:YES];
    UITapGestureRecognizer *mainBackTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popMainBackTap:)];
    [mainView addGestureRecognizer:mainBackTap];
    [[UIApplication sharedApplication].keyWindow addSubview:mainView];
    self.popMainBackView = mainView;
}
-(void)drawPopContainerVieWWithBottomDistance:(CGFloat)bottomDistance popMenuColor:(UIColor*)popMenuColor{

    LDPopMenuView *containerView = [[LDPopMenuView alloc] initWithFrame:CGRectMake(0,[EUtility screenHeight] - bottomDistance,self.popMainBackView.frame.size.width , self.popMainBackView.frame.size.height - 200 ) items:self.popItems];
    [containerView setOpaque:YES];
    [containerView setBackgroundColor:popMenuColor];
    [self.popMainBackView addSubview:containerView];
    self.popContainerView = containerView;
}
-(void)popMainBackTap:(UIGestureRecognizer *)tapG{
    UIView *gView = tapG.view;
    [gView setHidden:YES];
    [self.centerView resetAnimations];
}
-(void)addPopItemsWithBackgroundColor:(UIColor *)bgColor popMenuColor:(UIColor*)popMenuColor bottomDistance:(CGFloat)bottomDistance{
    [self drawBackgroundView:bgColor];
    [self drawPopContainerVieWWithBottomDistance:bottomDistance popMenuColor:popMenuColor];

}
-(void)selectTabItemWithIndex:(int)index{
    if (index > self.tabItems.count) {
        return;
    }
    self.currentIndex = index;
    [self changeCurrentStatusView];
    
}
-(void)centerItemClickWithStatus:(BOOL)isExpanding{
    if (!self.popItems) {
        return;
    }
    self.popMainBackView.hidden = NO;
    //CGRect frame = self.centerView.frame;
    //[self.popContainerView addSubview:self.centerView.contentImgView];
    //[self.centerView.contentImgView setFrame:CGRectMake(5, 5, frame.size.width - 10, frame.size.width - 10)];
    //[self insertSubview:self.centerView.contentImgView  aboveSubview:self.popContainerView];
    //[self bringSubviewToFront:self.centerView];
  
}
-(void)changeCurrentStatusView{
    if (self.statusView.hidden) {
        assert(self.tabItems.count!=0);
        self.statusView.hidden = NO;
        float w = (self.frame.size.width - self.centerView.frame.size.width)/self.tabItems.count;
        CGRect rect =  self.statusView.frame;
        rect.size.width = w;
        self.statusView.frame = rect;
    }
    [UIView animateWithDuration:0.25 animations:^{
        if (self.currentIndex < (self.tabItems.count/2)) {
            float x = _statusView.frame.size.width*self.currentIndex;
            CGRect rect = self.statusView.frame;
            rect.origin.x = x;
            self.statusView.frame = rect;
        }else{
            float x = _statusView.frame.size.width*self.currentIndex + self.centerView.frame.size.width;
            CGRect rect = self.statusView.frame;
            rect.origin.x = x;
            self.statusView.frame = rect;
            
        }
    } completion:^(BOOL finished) {
        
    }];
}

@end
