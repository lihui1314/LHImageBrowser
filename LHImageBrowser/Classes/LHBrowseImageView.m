//
//  LHBrowseImageView.m
//  ImageBrow
//
//  Created by lihui on 2020/7/23.
//  Copyright © 2020 lihui. All rights reserved.
//
#define  S_W   [UIScreen mainScreen].bounds.size.width
#define  S_H   [UIScreen mainScreen].bounds.size.height

#define botom_zoomScale 0.5 //top移动到底部缩放的比例
#define hidden_scale  0.65 //当k达到什么比例时hidden
#import "LHBrowseImageView.h"
@interface LHBrowseImageView ()
@property (nonatomic, assign) CGRect originalFrame;

@property (nonatomic, assign) CGPoint beginPoint;

@property (nonatomic, assign) CGFloat A;
@property (nonatomic, assign) CGFloat B;


@end

@implementation LHBrowseImageView

- (instancetype)init {
    self = [super init];
    self.canMove = NO;
    self.isNeedMove = YES;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    self.userInteractionEnabled = YES;
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isNeedMove) {
        return;
    }
    UITouch *touch = [touches anyObject];
    //当前的point
    CGPoint currentP = [touch locationInView:self];
    self.beginPoint = currentP;
    self.originalFrame = self.frame;
    self.A = (currentP.y)/(self.originalFrame.size.height/2);
    self.B = (currentP.x)/ (self.originalFrame.size.width/2);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isNeedMove) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPs = [touch locationInView:self];

    //当前的point 在主屏幕位置
    CGPoint currentP = [touch locationInView:[self superview]];

    //以前的point
    CGPoint preP = [touch previousLocationInView:self];

    if (currentPs.y -  preP.y > 0) {
        self.canMove = YES;
    }
    
    if (!self.canMove) {
        return;
    }
    
    
//    CGFloat k = (S_H/2 + 1*S_H/3 - 2*currentP.y/3)/((1-self.A)*(1/3.0)*self.originalFrame.size.height  + S_H/2);
    CGFloat numerator = S_H/2 - currentP.y * (1 - botom_zoomScale) + (S_H/2) * (1 - botom_zoomScale);
    CGFloat denominator = S_H/2 + (1 - botom_zoomScale) * (self.originalFrame.size.height/2) * (1-self.A);
    CGFloat k = numerator / denominator;
    
    if (k > 1) {
        k = 1;
    }
    
    CGFloat Y = currentP.y + self.originalFrame.size.height/2 * k -  self.originalFrame.size.height/2 * k * self.A;
    
    CGFloat X = currentP.x + self.originalFrame.size.width/2 * k - self.originalFrame.size.width/2 * k * self.B;
    
    
    self.frame = CGRectMake(X - self.originalFrame.size.width*k/2, Y - self.originalFrame.size.height *k/2, self.originalFrame.size.width*k, self.originalFrame.size.height *k);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(moved:point:)]) {
        [self.delegate moved:self point:currentP];
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isNeedMove) {
        return;
    }
    

    UITouch *touch = [touches anyObject];
    //当前的point
    CGPoint currentP = [touch locationInView:self.superview];
    
    CGFloat numerator = S_H/2 - currentP.y * (1 - botom_zoomScale) + (S_H/2) * (1 - botom_zoomScale);
    CGFloat denominator = S_H/2 + (1 - botom_zoomScale) * (self.originalFrame.size.height/2) * (1-self.A);
    CGFloat k = numerator / denominator;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(endMove:point:hidden:)]) {
        [self.delegate endMove:self point:currentP hidden:k<hidden_scale ? YES : NO];
    }
    self.canMove = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isNeedMove) {
        return;
    }
    if (!self.canMove) {
        return;
    }
    UITouch *touch = [touches anyObject];
    //当前的point
    CGPoint currentP = [touch locationInView:self.superview];
    CGFloat numerator = S_H/2 - currentP.y * (1 - botom_zoomScale) + (S_H/2) * (1 - botom_zoomScale);
    CGFloat denominator = S_H/2 + (1 - botom_zoomScale) * (self.originalFrame.size.height/2) * (1-self.A);
    CGFloat k = numerator / denominator;
    if (self.delegate && [self.delegate respondsToSelector:@selector(endMove:point:hidden:)]) {
        [self.delegate endMove:self point:currentP hidden:k < hidden_scale ? YES : NO];
    }
    self.canMove = NO;
}

@end
