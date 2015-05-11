//
//  LDPopMenuView.m
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import "LDPopMenuView.h"
#import "LDPopMenuItem.h"
#import "LDGridTableViewCell.h"
//#import "UIView+Helpers.h"
#define kDefaultPreRowCount  4
#define kDefaultItemH 80
#define kDefaultItemSpace 20
@interface LDPopMenuView() <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *datas;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)int rowCount;
@property(nonatomic,assign)CGFloat itemWidth;
@end
@implementation LDPopMenuView
-(id)initWithFrame:(CGRect)frame items:(NSArray *)items{
    if (self = [super initWithFrame:frame]) {
        self.datas = items;
        [self calculateRowCount];
        [self calculateItemWidth];
        [self drawGirdView];
    }
    return self;
}
-(void)drawGirdView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBounces:NO];
    [tableView setScrollEnabled:NO];
    [self addSubview:tableView];
    self.tableView = tableView;
}
-(void)calculateRowCount{
    self.rowCount = self.datas.count%kDefaultPreRowCount==0?self.datas.count/kDefaultPreRowCount:self.datas.count/kDefaultPreRowCount+1;
}
-(void)calculateItemWidth{
    self.itemWidth = (self.frame.size.width - kDefaultItemSpace*(kDefaultPreRowCount + 1))/kDefaultPreRowCount;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rowCount;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    LDGridTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LDGridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        cell.selectedBackgroundView = [[UIView alloc] init];
        NSMutableArray *array = [NSMutableArray array];
        int columnCount = kDefaultPreRowCount;
        if ((indexPath.row == self.rowCount - 1)&&(self.rowCount == self.datas.count/kDefaultPreRowCount +1)) {
              //最后一行
            columnCount = self.datas.count%kDefaultPreRowCount;
        }
        for (int i=0; i<columnCount; i++) {
            int index = i + kDefaultPreRowCount*indexPath.row;
            LDPopMenuItem *item = [self.datas objectAtIndex:index];
            item.frame = CGRectMake(kDefaultItemSpace + ((_itemWidth + kDefaultItemSpace) * i), 0, _itemWidth, kDefaultItemH);
            [item setValue:[NSNumber numberWithInt:i] forKey:@"column"];
            [cell.contentView addSubview:item];
            [array addObject:item];
        }
        [cell setValue:array forKey:@"cellItems"];
    }
    
    NSArray *imageButtons =cell.cellItems;
    [imageButtons setValue:[NSNumber numberWithInt:indexPath.row] forKey:@"row"];
    return cell;
}
@end
