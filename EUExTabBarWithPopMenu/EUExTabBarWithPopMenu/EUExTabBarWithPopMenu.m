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
    BOOL currentOpenStaus;
}
@end
@implementation EUExTabBarWithPopMenu
-(id)initWithBrwView:(EBrowserView *)eInBrwView{
    self = [super initWithBrwView:eInBrwView];
    if (self) {
        
    }
    return self;
}
-(void)open:(NSMutableArray *)inArguments{
    if(inArguments.count<1){
        return;
    }
    if (currentOpenStaus == YES) {
        return;
    }
    id info=[inArguments[0] JSONValue];
    float x = [[info objectForKey:@"left"] floatValue]?:0;
    float hei = 50;//0.068*[EUtility screenHeight];
    float width = [[info objectForKey:@"width"] floatValue]?:[EUtility screenWidth];
    float height = [[info objectForKey:@"height"] floatValue]?:hei;
    float y = [[info objectForKey:@"top"] floatValue]?:[EUtility screenHeight] -height ;
    NSString *statusColor = [info objectForKey:@"statusColor"]?:@"#EA7C24";
    NSDictionary *tabDic = [info objectForKey:@"tab"];
    float tabTextSize = [[tabDic objectForKey:@"textSize"] floatValue]?:10;
    NSString *tabTextNColor = [tabDic objectForKey:@"textNColor"]?:@"#000000";
    NSString *tabTextHColor = [tabDic objectForKey:@"textHColor"]?:@"#FFFFFF";
    NSString *centerImgSrc = [tabDic objectForKey:@"centerImg"];
    NSString *bgColor = [tabDic objectForKey:@"bgColor"]?:@"#FFFFFF";
    /*-----------tab data------------*/
    NSArray *tabDataArr = [tabDic objectForKey:@"data"];
    NSMutableArray *imageNArr = [NSMutableArray arrayWithCapacity:tabDataArr.count];
    NSMutableArray *imageHArr = [NSMutableArray arrayWithCapacity:tabDataArr.count];
    NSMutableArray *titleArr = [NSMutableArray arrayWithCapacity:tabDataArr.count];
    for (NSDictionary *dic in tabDataArr) {
        NSString *iconH = [dic objectForKey:@"iconH"];
        NSString *iconN = [dic objectForKey:@"iconN"];
        NSString *title = [dic objectForKey:@"title"];
        if (iconH) {
            [imageHArr addObject:[self readImageFromPath:iconH]];
        }
        if (iconN) {
            [imageNArr addObject:[self readImageFromPath:iconN]];
        }
        if (title) {
            [titleArr addObject:title];
        }
    }
    if (imageNArr.count != imageHArr.count ||titleArr.count != imageHArr.count) {
        return;
    }
     /*-----------popMenu data------------*/
    NSDictionary *popMenuDic = [info objectForKey:@"popMenu"];
    float popTextSize = [[popMenuDic objectForKey:@"textSize"] floatValue]?:13;
    float bottomDistance = [[popMenuDic objectForKey:@"bottomDistance"] floatValue]?:300;
    NSString *popTextNColor = [popMenuDic objectForKey:@"textNColor"]?:@"#000000";
    NSString *popTextHColor = [popMenuDic objectForKey:@"textHColor"]?:@"#FFFFFF";
    NSString *popBgColor = [popMenuDic objectForKey:@"bgColor"]?:@"#66ffffff";
    NSString *popMenuColor = [popMenuDic objectForKey:@"popMenuColor"]?:@"#66ffffff";
    NSArray *popDataArr = [popMenuDic objectForKey:@"data"];
    NSMutableArray *popImageNArr = [NSMutableArray arrayWithCapacity:popDataArr.count];
    NSMutableArray *popImageHArr = [NSMutableArray arrayWithCapacity:popDataArr.count];
    NSMutableArray *popTitleArr = [NSMutableArray arrayWithCapacity:popDataArr.count];
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

    /*-----------------------*/
    self.tabBar = [[LDCustomTabBar alloc] initWithFrame:CGRectMake(x,y ,width, height) centerImage:[self readImageFromPath:centerImgSrc] backgroundColor:[EUtility ColorFromString:bgColor] statusColor:[EUtility ColorFromString:statusColor] delegate:self];
    [EUtility brwView:self.meBrwView addSubview:self.tabBar];
    /*----------- set tab data------------*/
    NSMutableArray *itemButtons = [NSMutableArray arrayWithCapacity:tabDataArr.count];
    for (int i = 0; i < tabDataArr.count; i++) {
        LDCustomTabBarItem *item = [[LDCustomTabBarItem alloc] initWithTitle:titleArr[i] textSize:tabTextSize textColor:[EUtility ColorFromString:tabTextNColor] highlightedTextColor:[EUtility ColorFromString:tabTextHColor]  contentImage:imageNArr[i] contentHighlightImage:imageHArr[i]];
        item.tag = kBaseTag+i;
        UITapGestureRecognizer *tabTapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabBarItemClick:)];
        [item addGestureRecognizer:tabTapG];
        [itemButtons addObject:item];
        
    }
    [self.tabBar setTabBarItems:itemButtons];
     /*------------------------*/
    NSMutableArray *popItemButtons = [NSMutableArray arrayWithCapacity:popDataArr.count];
    for (int i = 0; i < popDataArr.count; i++) {
        LDPopMenuItem *item = [[LDPopMenuItem alloc] initWithTitle:popTitleArr[i] textSize:popTextSize textColor:[EUtility ColorFromString:popTextNColor] highlightedTextColor:[EUtility ColorFromString:popTextHColor] image:popImageNArr[i] selectedImage:popImageHArr[i]];
        item.tag = kBaseTag+i;
        UITapGestureRecognizer *tabTapP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popItemClick:)];
        [item addGestureRecognizer:tabTapP];
        [popItemButtons addObject:item];
    }
    [self.tabBar setPopMenuItems:popItemButtons WithBackgroundColor:[EUtility ColorFromString:popBgColor] popMenuColor:[EUtility ColorFromString:popMenuColor] BottomDistance:bottomDistance];
    /*------------------------*/
    currentOpenStaus = YES;
    
}
-(void)setItemChecked:(NSMutableArray *)inArguments{
    if(inArguments.count<1){
        return;
    }
    id info=[inArguments[0] JSONValue];
    int index = [[info objectForKey:@"index"]intValue];
    [self.tabBar selectTabItemWithIndex:index];

}
-(UIImage*)readImageFromPath:(NSString*)imagePath{
     imagePath = [EUtility getAbsPath:meBrwView path:imagePath];
     UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}
-(void)tabBarItemClick:(UITapGestureRecognizer *)gesture{
    UIView *v = gesture.view;
    int idx = (int)v.tag - kBaseTag;
    [self.tabBar selectTabItemWithIndex:idx];
    [self.meBrwView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"uexTabBarWithPopMenu.onTabItemClick(%d);",idx]];
}
-(void)popItemClick:(UITapGestureRecognizer *)gesture{
    UIView *v = gesture.view;
    int idx = (int)v.tag - kBaseTag;
    [self.meBrwView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"uexTabBarWithPopMenu.onPopMenuItemClick(%d);",idx]];

}
-(void)close:(NSMutableArray *)array{
    currentOpenStaus = NO;
    if (self.tabBar) {
        [_tabBar removeFromSuperview];
        self.tabBar = nil;
    }
}
@end
