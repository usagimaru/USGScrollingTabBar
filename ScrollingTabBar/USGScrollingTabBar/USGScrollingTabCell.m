//
//  USGScrollingTabCell.m
//  ScrollingTabBar
//
//  Created by M.Satori on 15.08.01.
//  Copyright (c) 2015 usagimaru. All rights reserved.
//

#import "USGScrollingTabCell.h"
#import "USGScrollingTabBar.h"
#import "UIView+USGViewFrame.h"

@interface USGScrollingTabCell ()

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelRightConstraint;

#ifdef USGScrollingTabDrawLines
@property (nonatomic) UIView *centerMarker;
#endif

@end

@implementation USGScrollingTabCell

+ (UINib*)nib
{
	return [UINib nibWithNibName:@"USGScrollingTabCell" bundle:nil];
}

+ (NSString*)reuseIdentifier
{
	return @"cell";
}

+ (CGFloat)tabWidth:(NSAttributedString*)string
			maxSize:(CGSize)masSize
		   tabInset:(CGFloat)tabInset
{
	CGFloat width = [string boundingRectWithSize:masSize
										 options:NSStringDrawingUsesLineFragmentOrigin
										 context:nil].size.width;
	width += tabInset * 2.0;
	
	return ceil(width);
}

- (void)awakeFromNib
{
	self.label.text = nil;
	[self __update];
	
	[self __setBorder:self];
}

- (void)__setBorder:(UIView*)view
{
#ifdef USGScrollingTabDrawLines
	[view.subviews enumerateObjectsUsingBlock:^(UIView *v, NSUInteger idx, BOOL *stop) {
		v.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
		v.layer.borderWidth = 0.5;
		[self __setBorder:v];
	}];

	
	if (!self.centerMarker) {
		self.centerMarker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.height)];
		self.centerMarker.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
		[self addSubview:self.centerMarker];
	}
#endif
}

- (void)prepareForReuse
{
}

- (void)__update
{
	[self setNeedsLayout];
}

- (void)setInset:(CGFloat)inset
{
	_inset = inset;
	self.labelLeftConstraint.constant = inset;
	self.labelRightConstraint.constant = inset;
}

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
	[self setNeedsLayout];
}
- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
	[self setNeedsLayout];
}


- (void)setTabItem:(USGScrollingTabItem*)tabItem
{
	self.string = tabItem.string;
	self.selectedString = tabItem.selectedString;
	self.highlightedString = tabItem.highlightedString;
	[self setNeedsLayout];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
	NSAttributedString *attributedString = nil;
	CGFloat duration = 0.2;
	
	if (self.highlighted) {
		attributedString = self.highlightedString;
		duration = 0.0;
	}
	else if (self.selected && indexPath.row == self.index) {
		attributedString = self.selectedString;
	}
	else if (indexPath.row != self.index) {
		attributedString = self.string;
	}
	
	if (attributedString) {
		[UIView transitionWithView:self.label
						  duration:duration
						   options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionBeginFromCurrentState
						animations:^{
							self.label.attributedText = attributedString;
						}
						completion:^(BOOL finished) {
						}];
	}
	
	
#ifdef USGScrollingTabDrawLines
	self.centerMarker.x = self.width / 2.0;
#endif
}

@end
