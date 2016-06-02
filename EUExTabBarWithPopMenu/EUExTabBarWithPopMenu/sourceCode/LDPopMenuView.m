//
//  LDPopMenuView.m
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import "LDPopMenuView.h"
#import "LDPopMenuItem.h"
#define kDefaultPreRowCount  4
//#define kDefaultItemH 80
#define kDefaultItemSpace 20
@interface LDPopMenuView() 
@property(nonatomic,strong)NSArray *datas;
@property(nonatomic,assign)CGFloat itemWidth;
@end
@implementation LDPopMenuView
-(id)initWithFrame:(CGRect)frame items:(NSArray *)items Title:(NSArray*)titles{
    if (self = [super initWithFrame:frame]) {
        self.datas = items;
        [self calculateItemWidth];
        [self drawGirdViewWithTitle:titles];
    }
    return self;
}
-(void)drawGirdViewWithTitle:(NSArray*)titles{
    UIView *tableView = [[UIView alloc] initWithFrame:self.bounds];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:tableView];
    self.tableView = tableView;
    for (int i = 0; i < self.datas.count; i++) {
         LDPopMenuItem *item = [self.datas objectAtIndex:i];
        [item setTitle:titles[i] forState:UIControlStateNormal];
        item.backgroundColor = [UIColor clearColor];
        int count = i/kDefaultPreRowCount;
        int countRow = i%kDefaultPreRowCount;
        item.frame = CGRectMake(kDefaultItemSpace + ((_itemWidth + kDefaultItemSpace) * countRow),  count*(self.itemWidth+25), _itemWidth, self.itemWidth);
        [self.tableView addSubview:item];
    }
}

-(void)calculateItemWidth{
    self.itemWidth = (self.frame.size.width - kDefaultItemSpace*(kDefaultPreRowCount + 1))/kDefaultPreRowCount;
}

@end
