//
//  LDPopMenuView.h
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LDPopMenuView :UIView
@property(nonatomic,strong)UITableView *tableView;
-(id)initWithFrame:(CGRect)frame items:(NSArray *)items;
@end
