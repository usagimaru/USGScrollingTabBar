//
//  UIView+USGViewFrame.m
//
//  Created by M.Satori on 14.10.24.
//  Copyright (c) 2014 M.Satori. All rights reserved.
//

#import "UIView+USGViewFrame.h"

@implementation UIView (USGViewFrame)

- (CGPoint)origin
{
	return self.frame.origin;
}
- (CGFloat)x
{
	return self.origin.x;
}
- (CGFloat)y
{
	return self.origin.y;
}

- (CGSize)size
{
	return self.frame.size;
}
- (CGFloat)width
{
	return self.size.width;
}
- (CGFloat)height
{
	return self.size.height;
}

// frame.origin を設定
- (void)setOrigin:(CGPoint)p
{
	CGRect r = self.frame;
	r.origin = p;
	self.frame = r;
}
- (void)setX:(CGFloat)x
{
	CGRect r = self.frame;
	r.origin.x = x;
	self.frame = r;
}
- (void)setY:(CGFloat)y
{
	CGRect r = self.frame;
	r.origin.y = y;
	self.frame = r;
}

// frame.size を設定
- (void)setSize:(CGSize)s
{
	CGRect r = self.frame;
	r.size = s;
	self.frame = r;
}
- (void)setWidth:(CGFloat)w
{
	CGRect r = self.frame;
	r.size.width = w;
	self.frame = r;
}
- (void)setHeight:(CGFloat)h
{
	CGRect r = self.frame;
	r.size.height = h;
	self.frame = r;
}

// frame.origin を相対的に設定
- (void)setOriginRelative:(CGPoint)p
{
	CGRect r = self.frame;
	CGPoint point = r.origin;
	point.x += p.x;
	point.y += p.y;
	r.origin = point;
	self.frame = r;
}
- (void)setXRelative:(CGFloat)x
{
	CGRect r = self.frame;
	CGPoint point = r.origin;
	point.x += x;
	r.origin = point;
	self.frame = r;
}
- (void)setYRelative:(CGFloat)y
{
	CGRect r = self.frame;
	CGPoint point = r.origin;
	point.y += y;
	r.origin = point;
	self.frame = r;
}

// frame.size を相対的に設定
- (void)setSizeRelative:(CGSize)s
{
	CGRect r = self.frame;
	r.size.width += s.width;
	r.size.height += s.height;
	self.frame = r;
}
- (void)setWidthRelative:(CGFloat)w
{
	CGRect r = self.frame;
	r.size.width += w;
	self.frame = r;
}
- (void)setHeightRelative:(CGFloat)h
{
	CGRect r = self.frame;
	r.size.height += h;
	self.frame = r;
}

@end
