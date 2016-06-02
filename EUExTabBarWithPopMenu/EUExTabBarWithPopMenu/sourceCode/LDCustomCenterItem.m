//
//  LDCustomCenterItem.m
//  AppCanPlugin
//
//  Created by Frank on 14/12/28.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import "LDCustomCenterItem.h"
#import "EUtility.h"
@interface LDCustomCenterItem()

@end
@implementation LDCustomCenterItem
-(LDCustomCenterItem*)initWithFrame:(CGRect)frame contentImg:(UIImage *)contentImg{
    if (self = [super initWithFrame:frame]) {
        self.popMenuIsExpanding = NO;
        [self setUserInteractionEnabled:YES];
        UIImageView *contentImgView = [[UIImageView alloc] initWithImage:contentImg];
        [contentImgView setFrame:CGRectMake(5, 5, frame.size.width - 10, frame.size.width - 10)];
        [contentImgView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *centerTapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerItemTap:)];
        [contentImgView addGestureRecognizer:centerTapG];
        [self addSubview:contentImgView];
        self.contentImgView = contentImgView;
       
    }
    return self;
}
-(void)centerItemTap:(UITapGestureRecognizer *)tapG{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(centerItemClickWithStatus:)]) {
        [_delegate centerItemClickWithStatus:self.popMenuIsExpanding];
        
    }
    
    [self resetAnimations];

}
-(void)resetAnimations{
    float angle = !self.popMenuIsExpanding ? M_PI_4*3 : 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        _contentImgView.transform = CGAffineTransformMakeRotation(angle);
                
    } completion:^(BOOL finished) {
        self.popMenuIsExpanding = !self.popMenuIsExpanding;
    }];
    
}
@end
