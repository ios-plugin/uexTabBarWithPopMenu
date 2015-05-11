//
//  EUExTabBarWithPopMenu.m
//  AppCanPlugin
//
//  Created by Frank on 14/12/27.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import "EUExTabBarWithPopMenu.h"
#import "EUtility.h"
#import "LDCustomTabBarItem.h"
#import "JSON.h"
#import "LDPopMenuItem.h"
#define kBaseTag 1245
@interface EUExTabBarWithPopMenu(){

}
@end
@implementation EUExTabBarWithPopMenu
-(id)initWithBrwView:(EBrowserView *)eInBrwView{
    self = [super initWithBrwView:eInBrwView];
    if (self) {
        
    }
    return self;
}
-(void)open:(NSMutableArray *)array{
    if ([array isKindOfClass:[NSMutableArray class]] && [array count]>0) {
//        CGFloat x = [[array objectAtIndex:0] floatValue];
//        CGFloat y = [[array objectAtIndex:1] floatValue];
//        CGFloat w = [[array objectAtIndex:2] floatValue];
//        CGFloat h = [[array objectAtIndex:3] floatValue];
//        LDCustomTabBar *tabbar = [[LDCustomTabBar alloc] initWithFrame:CGRectMake(x, y, w, h) delegate:self];
        if (self.tabBar == nil) {
            LDCustomTabBar *tabbar = [[LDCustomTabBar alloc] initWithFrame:CGRectMake(0,[EUtility screenHeight] - 49 - 20,[EUtility screenWidth], 49) delegate:self];
            [EUtility brwView:self.meBrwView addSubview:tabbar];
            self.tabBar = tabbar;
            [tabbar release];
        }
    }
}
-(void)setTabItems:(NSMutableArray *)array{
    if (!self.tabBar) {
        //如果没有创建，不添加
        return;
    }
    NSString *jsonString = [array firstObject];
    NSDictionary *inDict = [jsonString JSONValue];
    NSArray *inTabList = [inDict objectForKey:@"tabItems"];
    NSArray *tabbarImages = [self readTabBarItemImages];
    if (tabbarImages.count!=inTabList.count) {
        //如果传入的items和图片不一致，不等于4个，不添加
        return;
    }
    NSMutableArray *itemButtons = [NSMutableArray arrayWithCapacity:inTabList.count];
    for (int i = 0; i < inTabList.count; i++) {
        NSDictionary *inItem = [inTabList objectAtIndex:i];
        LDCustomTabBarItem *item = [[LDCustomTabBarItem alloc] initWithTitle:inItem[@"text"] contentImage:tabbarImages[i] contentHighlightImage:tabbarImages[i]];
        item.tag = kBaseTag+i;
        UITapGestureRecognizer *tabTapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabBarItemClick:)];
        [item addGestureRecognizer:tabTapG];
        [itemButtons addObject:item];
        [item release];
    }
    [self.tabBar setTabBarItems:itemButtons];
    
}
-(void)setPopMenuItems:(NSMutableArray *)array{
    if (!self.tabBar) {
        return;
    }
    NSString *jsonString = [array firstObject];
    NSDictionary *inDict = [jsonString JSONValue];
    NSArray *inPopList = [inDict objectForKey:@"popMenuItems"];
    if (inPopList.count == 0) {
        return;
    }
    NSMutableArray *itemButtons = [NSMutableArray arrayWithCapacity:inPopList.count];
    for (int i = 0; i < inPopList.count; i++) {
        NSDictionary *itemDict = [[inPopList objectAtIndex:i] objectForKey:@"item"];
        NSString *normalPath = [EUtility getAbsPath:self.meBrwView path:itemDict[@"imgNormal"]];
        UIImage *contentImg = [UIImage imageWithContentsOfFile:normalPath];
        NSString *hightPath = [EUtility getAbsPath:self.meBrwView path:itemDict[@"imgHighlight"]];
        UIImage *hImage = [UIImage imageWithContentsOfFile:hightPath];
        NSString *textColor = [itemDict objectForKey:@"textColor"];
        
        LDPopMenuItem *item = [[LDPopMenuItem alloc] initWithTitle:itemDict[@"text"] image:contentImg selectedImage:hImage textColor:[[self class] getColorWithHexColor:textColor]];
        item.tag = kBaseTag+i;
        UITapGestureRecognizer *tabTapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popItemClick:)];
        [item addGestureRecognizer:tabTapG];
        [itemButtons addObject:item];
        [item release];
        
    }
    [self.tabBar setPopMenuItems:itemButtons];
}
-(NSArray *)readTabBarItemImages{
    NSString *pluginName = @"uexTabBarWithPopMenu";
    UIImage *image1 = [[self class] loadLocalImgWithPluginName:pluginName fileName:@"plugin_tabbar_homepage@2x"];
    UIImage *image2 = [[self class]  loadLocalImgWithPluginName:pluginName fileName:@"plugin_tabbar_camera@2x"];
    UIImage *image3 = [[self class]  loadLocalImgWithPluginName:pluginName fileName:@"plugin_tabbar_search@2x"];

    UIImage *image4 = [[self class]  loadLocalImgWithPluginName:pluginName fileName:@"plugin_tabbar_upload@2x"];
    if (image1&&image2&&image3&&image4) {
        return @[image1,image2,image3,image4];
    }
    return nil;
}
-(void)tabBarItemClick:(UITapGestureRecognizer *)gesture{
    UIView *v = gesture.view;
    int idx = v.tag - kBaseTag;
    [self.tabBar selectTabItemWithIndex:idx];
    [self.meBrwView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"uexTabBarWithPopMenu.onTabItemClick(%d);",idx]];
}
-(void)popItemClick:(UITapGestureRecognizer *)gesture{
    UIView *v = gesture.view;
    int idx = v.tag - kBaseTag;
    [self.meBrwView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"uexTabBarWithPopMenu.onPopMenuItemClick(%d);",idx]];

}
-(void)close:(NSMutableArray *)array{
    if (self.tabBar) {
        [_tabBar removeFromSuperview];
        self.tabBar = nil;
    }
}
#define DEFAULT_VOID_COLOR [UIColor whiteColor]

+(UIColor *)getColorWithHexColor:(NSString*)hexColor
{
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
+(UIImage *)loadLocalImgWithPluginName:(NSString *)plgName fileName:(NSString *)fName{
    NSString *bPath = [plgName stringByAppendingPathComponent:fName];
    NSString *path = [[NSBundle mainBundle] pathForResource:bPath ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}
@end
