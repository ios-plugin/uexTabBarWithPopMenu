//
//  LDCustomTabBar.m
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import "LDCustomTabBar.h"
#import "LDCustomTabBarItem.h"
#import "LDPopMenuView.h"
#import "EUtility.h"
#import "LDPopMenuItem.h"

//32394a
#define kBaseTag 1245
#define kDefaultBackgroundColor ([UIColor colorWithRed:50/255.0 green:57/255.0 blue:74/255.0 alpha:1.0])
//f5b82c
#define kDefaultStatusViewColor ([UIColor colorWithRed:245/255.0 green:184/255.0 blue:44/255.0 alpha:1.0])
#define kDefaultPopBackColor ([UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1.0])

#define kDefaultStatusViewHeight  2
static CGFloat const kDefaultCenterWidth = 59;
static CGFloat const kDefaultCenterHeight = 59;

@interface LDCustomTabBar() <LDCustomCenterItemDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)NSArray *tabItems;
@property(nonatomic,strong)NSArray *popItems;
@property(nonatomic,strong)UIView *statusView;
@property(nonatomic,strong)LDPopMenuView *containerView;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)UIColor *statusColor;
@property(nonatomic,strong)LDCustomCenterItem *centerItem;
@property(nonatomic,strong)NSMutableArray *selectArr;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,strong)UIImage *centerImage;
@property(nonatomic,assign)CGFloat bottom;
@property(nonatomic,strong)NSString *statusStr;
@property(nonatomic, weak) id<AppCanWebViewEngineObject> webView0bj;
@property(nonatomic, weak) EUExTabBarWithPopMenu *uexObj;
@property(nonatomic,strong)UIPageControl *page;
@property(nonatomic,assign)NSInteger pageCount;
@property(nonatomic,strong) UIColor *pageBgColor;
@property(nonatomic,strong) UIColor *pageCurrentColor;
@end
@implementation LDCustomTabBar
-(id)initWithFrame:(CGRect)frame centerImage:(UIImage*)centerImage backgroundColor:(UIColor*)backgroundColor statusColor:(UIColor*) statusColor delegate:(id)delegate count:(NSInteger)count statusColorStr:(NSString *)str{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:backgroundColor];
        self.delegate = delegate;
        self.statusColor = statusColor;
        self.statusStr = str;
        self.count = count;
        self.selectArr = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            [self.selectArr addObject:@(i)];
        }
        
        [self drawCenterItemWithCenterImage:centerImage];
        [self drawStatusViewWithStatusColor:statusColor];
    }
    return self;
}
-(void)drawCenterItemWithCenterImage:(UIImage*)centerImage{
    LDCustomCenterItem *centerItem = [[LDCustomCenterItem alloc] initWithFrame:CGRectMake((self.frame.size.width - kDefaultCenterWidth)*0.5, self.frame.size.height - kDefaultCenterHeight, kDefaultCenterWidth, kDefaultCenterHeight) contentImg:centerImage];
    self.centerImage = centerImage;
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
    NSUInteger count = self.tabItems.count;
    if (count > 0&&count%2==0) {
        NSUInteger middle = count/2;
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
-(void)setPopMenuItems:(NSArray *)items WithBackgroundColor:(UIColor *)bgColor popMenuColor:(UIColor*)popMenuColor BottomDistance:(CGFloat)bottomDistance popTextSize:(CGFloat)popTextSize popTextNColor:(NSString*)popTextNColor popTextHColor:(NSString*)popTextHColor Obj:(id<AppCanWebViewEngineObject>)obj uexObj:(EUExTabBarWithPopMenu*)uexObj pageBgColor:(UIColor*)pageBgColor pageCurrentColor:(UIColor*)pageCurrentColor{
    self.webView0bj = obj;
    self.uexObj = uexObj;
    self.bottom = bottomDistance;
    self.pageCount = items.count;
    self.pageBgColor = pageBgColor;
    self.pageCurrentColor = pageCurrentColor;
    self.popMainBackView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [EUtility screenWidth], [EUtility screenHeight])];
    [self.popMainBackView setBackgroundColor:bgColor];
    [self.popMainBackView setHidden:YES];
    UITapGestureRecognizer *mainBackTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popMainBackTap:)];
    [self.popMainBackView addGestureRecognizer:mainBackTap];
    [[UIApplication sharedApplication].keyWindow addSubview:self.popMainBackView];
    self.popMainBackView.delegate = self;
    
    self.popMainBackView.contentSize = CGSizeMake(items.count *[EUtility screenWidth],0);
    self.popMainBackView.pagingEnabled = YES;
    self.popMainBackView.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < items.count; i++) {
                NSMutableArray *popImageNArr = [NSMutableArray array];
                NSMutableArray *popImageHArr = [NSMutableArray array];
                NSMutableArray *popTitleArr = [NSMutableArray array];
                NSArray *popDataArr = items[i];
                for (NSDictionary *dic in popDataArr) {
                    NSString *iconH = [dic objectForKey:@"iconH"];
                    NSString *iconN = [dic objectForKey:@"iconN"];
                    NSString *title = [dic objectForKey:@"title"];
                    if (iconH) {
                        [popImageHArr addObject:[self readImageFromPath:iconH]];
                    }
                    if (iconN) {
                        [popImageNArr addObject:[self readImageFromPath:iconN]];
                    }
                    if (title) {
                        [popTitleArr addObject:title];
                    }
                }
                if (popImageNArr.count != popImageHArr.count ||popTitleArr.count != popImageHArr.count) {
                    return;
                }
                NSMutableArray *popItemButtons = [NSMutableArray arrayWithCapacity:popDataArr.count];
                for (int j = 0; j < popDataArr.count; j++) {
                    LDPopMenuItem *item = [[LDPopMenuItem alloc] initWithTitle:popTitleArr[j] textSize:popTextSize textColor:[EUtility colorFromHTMLString:popTextNColor] highlightedTextColor:[EUtility colorFromHTMLString:popTextHColor] image:popImageNArr[j] selectedImage:popImageHArr[j]];
                    item.tag = kBaseTag+j;
                    [item addTarget:self action:@selector(popItemClick:) forControlEvents:UIControlEventTouchUpInside];
                    [popItemButtons addObject:item];
                
            }
        self.popItems = popItemButtons;
        self.containerView = [[LDPopMenuView alloc] initWithFrame:CGRectMake(i*self.popMainBackView.frame.size.width,[EUtility screenHeight] - bottomDistance,self.popMainBackView.frame.size.width , self.popMainBackView.frame.size.height) items:self.popItems Title:popTitleArr];
        [self.containerView setOpaque:YES];
        [self.containerView setBackgroundColor:popMenuColor];
        [self.popMainBackView addSubview:self.containerView];
        [popTitleArr removeAllObjects];
        [popImageHArr removeAllObjects];
        [popImageNArr removeAllObjects];
        [popItemButtons removeAllObjects];
    }
    
}
-(void)popItemClick:(UIButton*)gesture{
    int idx = (int)gesture.tag - kBaseTag;
    NSDictionary *dic = @{@"page":@(self.page.currentPage),@"index":@(idx)};
    [self.page removeFromSuperview];
    [self.centerView resetAnimations];
    [self.centerItem removeFromSuperview];
    self.popMainBackView.hidden = YES;
    [self.webView0bj callbackWithFunctionKeyPath:@"uexTabBarWithPopMenu.onPopMenuItemClick" arguments:ACArgsPack(dic)];
    
    
}

-(UIImage*)readImageFromPath:(NSString*)imagePath{
    imagePath = [self.uexObj absPath:imagePath];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}
-(void)popMainBackTap:(UIGestureRecognizer *)tapG{
    [self.page removeFromSuperview];
    [self.centerItem removeFromSuperview];
    UIView *gView = tapG.view;
    [gView setHidden:YES];
    [self.centerView resetAnimations];
}

-(void)selectTabItemWithIndex:(int)index{
    if (index > self.tabItems.count) {
        return;
    }
    self.currentIndex = index;
    [self changeCurrentStatusViewWithIndex:index];
    
}
-(void)centerItemClickWithStatus:(BOOL)isExpanding{
    if (!self.popItems) {
        return;
    }
    self.popMainBackView.hidden = NO;
    if (!isExpanding) {
        
       self.centerItem = [[LDCustomCenterItem alloc] initWithFrame:CGRectMake((self.frame.size.width - kDefaultCenterWidth)*0.5,[EUtility screenHeight] - kDefaultCenterHeight, kDefaultCenterWidth, kDefaultCenterHeight) contentImg:self.centerImage];
        UITapGestureRecognizer *mainBackTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerTap:)];
        [self.centerItem resetAnimations];
        [self.centerItem.contentImgView addGestureRecognizer:mainBackTap];
        [[UIApplication sharedApplication].keyWindow addSubview:self.centerItem];
        self.page = [UIPageControl new];
        self.page.numberOfPages = self.pageCount;
        self.page.hidesForSinglePage = YES;
        self.page.currentPageIndicatorTintColor = self.pageCurrentColor;
        self.page.pageIndicatorTintColor = self.pageBgColor;
        self.page.center = CGPointMake([EUtility screenWidth]/2, [EUtility screenHeight] - 80);
        [[UIApplication sharedApplication].keyWindow addSubview:self.page];
        
        
        
    }else{
        [self.page removeFromSuperview];
        [self.centerItem removeFromSuperview];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取内容的偏移量，向左移动为正
    CGPoint offSet = scrollView.contentOffset;
    //把值进行四舍五入，使用round()函数
    NSInteger index = round(offSet.x/scrollView.frame.size.width);
    //设置当前页
    self.page.currentPage = index;
}
-(void)centerTap:(UIGestureRecognizer *)tapG{
    UIView *gView = tapG.view;
    [gView setHidden:YES];
    [self.page removeFromSuperview];
    [self.centerItem removeFromSuperview];
    self.popMainBackView.hidden = YES;
    [self.centerView resetAnimations];
}
-(void)changeCurrentStatusViewWithIndex:(int)index{
    
    if (self.statusView.hidden) {
        assert(self.tabItems.count!=0);
        self.statusView.hidden = NO;
        float w = (self.frame.size.width - self.centerView.frame.size.width)/self.tabItems.count;
        CGRect rect =  self.statusView.frame;
        rect.size.width = w;
        self.statusView.frame = rect;
    }
    
    
    for (NSNumber*num  in self.selectArr) {
        if (index == [num intValue]) {
            [self setIndex:@(index)];
        }else{
            for (int i = 0; i < self.selectArr.count; i++) {
                if (i != index) {
                    [self cancelIndex:self.selectArr[i]];
                }
                
            }
            
        }
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
-(void)setIndex:(NSNumber*)x{
    int index = [x intValue];
    LDCustomTabBarItem *itemView = self.tabItems[index];
    itemView.contentImgView.image = itemView.contentHImage;
    if ([self.statusStr isEqualToString:@"#ffffff"] || [self.statusStr isEqualToString:@"#ffffff"]) {
        [itemView.titleLabel setTextColor:itemView.highlightedTextColor];
        
    }else{
         itemView.titleLabel.textColor = self.statusColor;
    }
    
    
    }
    
 -(void)cancelIndex:(NSNumber*)x{
     int index = [x intValue];
     LDCustomTabBarItem *itemView = self.tabItems[index];
     itemView.contentImgView.image = itemView.contentImg;
     [itemView.titleLabel setTextColor:itemView.textColor];
     [itemView.titleLabel setHighlightedTextColor:itemView.highlightedTextColor];
 }


    

@end
