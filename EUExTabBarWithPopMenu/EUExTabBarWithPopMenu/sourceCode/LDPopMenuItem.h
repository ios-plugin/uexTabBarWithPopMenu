//
//  LDPopMenuItem.h
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LDPopMenuItem : UIView
-(id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage textColor:(UIColor *)textColor;
@property(nonatomic,assign)int row;
@property(nonatomic,assign)int column;
@end
