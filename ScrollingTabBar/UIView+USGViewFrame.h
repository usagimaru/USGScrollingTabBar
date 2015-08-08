//
//  UIView+USGViewFrame.h
//
//  Created by M.Satori on 14.10.24.
//  Copyright (c) 2014 M.Satori. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (USGViewFrame)

// frame.origin を取得
- (CGPoint)origin;
- (CGFloat)x;
- (CGFloat)y;

// frame.size を取得
- (CGSize)size;
- (CGFloat)width;
- (CGFloat)height;

// frame.origin を設定
- (void)setOrigin:(CGPoint)p;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;

// frame.size を設定
- (void)setSize:(CGSize)s;
- (void)setWidth:(CGFloat)w;
- (void)setHeight:(CGFloat)h;

// frame.origin を相対的に設定
- (void)setOriginRelative:(CGPoint)p;
- (void)setXRelative:(CGFloat)x;
- (void)setYRelative:(CGFloat)y;

// frame.size を相対的に設定
- (void)setSizeRelative:(CGSize)s;
- (void)setWidthRelative:(CGFloat)w;
- (void)setHeightRelative:(CGFloat)h;

@end
