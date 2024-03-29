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

#import "LDPopMenuItem.h"
#define kBaseTag 1245
@interface EUExTabBarWithPopMenu(){
    BOOL currentOpenStaus;
    BOOL setBadage;
}
@property(nonatomic,strong)NSMutableDictionary *badageDic;
@property(nonatomic,strong) NSMutableArray *itemButtons;
@end
@implementation EUExTabBarWithPopMenu

-(void)open:(NSMutableArray *)inArguments{
    self.badageDic = [NSMutableDictionary dictionary];
    if(inArguments.count<1){
        return;
    }
    if (currentOpenStaus == YES) {
        return;
    }
   
    //id info=[inArguments[0] ac_JSONValue];
    ACArgsUnpack(NSDictionary *info) = inArguments;
    float x = [[info objectForKey:@"left"] floatValue]?:0;
    float hei = 50;//0.1*[EUtility screenHeight];
    float width = [[info objectForKey:@"width"] floatValue]?:[EUtility screenWidth];
    float height = [[info objectForKey:@"height"] floatValue]?:hei;
    float y = [[info objectForKey:@"top"] floatValue]?:[EUtility screenHeight] -height ;
    NSDictionary *tabDic = [info objectForKey:@"tab"];
    NSString *statusColor = [info objectForKey:@"statusColor"]?:@"#EA7C24";
    NSString *pageBgColor = [info objectForKey:@"indicatorColor"]?:@"#EA7C24";
    NSString *pageCurrentColor = [info objectForKey:@"indicatorSelectColor"]?:@"#EE0000";
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
    NSArray *dataArr = [popMenuDic objectForKey:@"data"];
 

    /*-----------------------*/
    self.tabBar = [[LDCustomTabBar alloc] initWithFrame:CGRectMake(x,y ,width, height) centerImage:[self readImageFromPath:centerImgSrc] backgroundColor:[EUtility colorFromHTMLString:bgColor] statusColor:[EUtility colorFromHTMLString:statusColor] delegate:self count:tabDataArr.count statusColorStr:[info objectForKey:@"statusColor"]];
    
    /*----------- set tab data------------*/
    self.itemButtons = [NSMutableArray arrayWithCapacity:tabDataArr.count];
    for (int i = 0; i < tabDataArr.count; i++) {
       LDCustomTabBarItem *item = [[LDCustomTabBarItem alloc] initWithTitle:titleArr[i] textSize:tabTextSize textColor:[EUtility colorFromHTMLString:tabTextNColor] highlightedTextColor:[EUtility colorFromHTMLString:tabTextHColor]  contentImage:imageNArr[i] contentHighlightImage:imageHArr[i]];
        item.tag = kBaseTag+i;
        UITapGestureRecognizer *tabTapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabBarItemClick:)];
        [item addGestureRecognizer:tabTapG];
        [_itemButtons addObject:item];
        //[item release];
        
    }
    [self.tabBar setTabBarItems:_itemButtons];
     /*----------set pop data--------------*/
   
    [self.tabBar setPopMenuItems:dataArr WithBackgroundColor:[EUtility colorFromHTMLString:popBgColor] popMenuColor:[EUtility colorFromHTMLString:popMenuColor] BottomDistance:bottomDistance popTextSize:popTextSize popTextNColor:popTextNColor popTextHColor:popTextHColor Obj:self.webViewEngine uexObj:self  pageBgColor:[EUtility colorFromHTMLString:pageBgColor] pageCurrentColor:[EUtility colorFromHTMLString:pageCurrentColor]];
    /*------------------------*/
    currentOpenStaus = YES;
    //[EUtility brwView:self.meBrwView addSubview:self.tabBar];
    [[self.webViewEngine webView] addSubview:self.tabBar];
    
    [imageHArr removeAllObjects];
    [imageNArr removeAllObjects];
    [titleArr removeAllObjects];

}
-(void)setItemChecked:(NSMutableArray *)inArguments{
    if(inArguments.count<1){
        return;
    }
    //id info=[inArguments[0] ac_JSONValue];
    ACArgsUnpack(NSDictionary *info) = inArguments;
    int index = [[info objectForKey:@"index"]intValue];
    [self.tabBar selectTabItemWithIndex:index];

}
-(void)setBadge:(NSMutableArray *)inArguments{
    if (setBadage) {
        return;
    }
    if(inArguments.count<1){
        return;
    }
    //id info=[inArguments[0] ac_JSONValue];
    ACArgsUnpack(NSDictionary *info) = inArguments;
    NSArray *indexArr = [info objectForKey:@"indexes"];
    for (int i = 0; i < indexArr.count; i++) {
        int index = [indexArr[i] intValue];
        NSInteger tag = index + kBaseTag;
        LDCustomTabBarItem *barItemView = (LDCustomTabBarItem*)[self.tabBar viewWithTag:tag];
        CGRect frame = barItemView.frame;
        NSLog(@"%@",NSStringFromCGRect(frame));
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 5)];
        view.center = CGPointMake(frame.origin.x + frame.size.width-15, frame.origin.y+5);
        view.backgroundColor = [UIColor redColor];
        [view.layer setBorderColor:[UIColor redColor].CGColor];
        [view.layer setCornerRadius:2.0];
        view.layer.masksToBounds = YES;
        NSString *id = [@(tag) stringValue];
        if ([self.badageDic objectForKey:id]) {
            [[self.badageDic objectForKey:id] removeFromSuperview];
            [self.badageDic removeObjectForKey:id];
        }
        [self.badageDic setObject:view forKey:id];
        [self.tabBar addSubview:view];
        //[view release];
    }
    setBadage = YES;
    
}
-(void)removeBadge:(NSMutableArray *)inArguments{
     setBadage = NO;
    if(inArguments.count<1){
        NSArray *views = [self.badageDic allValues];
        for (UIView *view in views) {
            [view removeFromSuperview];
        }
       
        return;
    }
    //id info=[inArguments[0] ac_JSONValue];
    ACArgsUnpack(NSDictionary *info) = inArguments;
    NSArray *indexArr = [info objectForKey:@"indexes"];
    for (int i = 0; i < indexArr.count; i++) {
        int index = [indexArr[i] intValue];
        NSInteger tag = index + kBaseTag;
        NSString *id = [@(tag) stringValue];
        UIView *view = [self.badageDic objectForKey:id];
        [view removeFromSuperview];
    }
    
}
-(UIImage*)readImageFromPath:(NSString*)imagePath{
    imagePath = [self absPath:imagePath];
     UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}
-(void)tabBarItemClick:(UITapGestureRecognizer *)gesture{
    UIView *v = gesture.view;
    int idx = (int)v.tag - kBaseTag;
    [self.tabBar selectTabItemWithIndex:idx];
    NSDictionary *dic = @{@"index":@(idx)};
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexTabBarWithPopMenu.onTabItemClick" arguments:ACArgsPack(dic)];
}

-(void)close:(NSMutableArray *)array{
    currentOpenStaus = NO;
    if (self.tabBar) {
        [_itemButtons removeAllObjects];
        [self.badageDic removeAllObjects];
        [_tabBar removeFromSuperview];
        self.tabBar = nil;
    }
}


@end
