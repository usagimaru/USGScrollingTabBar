//
//  ViewController.m
//  ScrollingTabBar
//
//  Created by M.Satori on 15.08.01.
//  Copyright (c) 2015 usagimaru. All rights reserved.
//

#import "ViewController.h"
#import "USGScrollingTabBar.h"
#import "UIView+USGViewFrame.h"

@interface ViewController () <UIScrollViewDelegate, USGScrollingTabBarDelegate>

@property (weak, nonatomic) IBOutlet USGScrollingTabBar *scrollingTabBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) NSArray *tabItems;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.scrollingTabBar.delegate = self;
	self.scrollingTabBar.tabBarInset = 12;
	self.scrollingTabBar.tabSpacing = 8;
	self.scrollingTabBar.tabInset = 8;
	self.scrollingTabBar.focusVerticalMargin = 4;
	self.scrollingTabBar.focusCornerRadius = USGScrollingTabFocusCircleCorner;
	self.scrollingTabBar.focusColor = [UIColor whiteColor];
	self.scrollingTabBar.decelerationRate = UIScrollViewDecelerationRateFast;
	self.scrollingTabBar.backgroundColor = [UIColor colorWithRed:0.576 green:0.494 blue:0.718 alpha:1.000];
	
	self.scrollView.pagingEnabled = YES;
	
	NSMutableArray *tabItems = @[].mutableCopy;
	UIFont *font = [UIFont systemFontOfSize:13];
	UIFont *boldFont = [UIFont boldSystemFontOfSize:13];
	UIColor *color = [UIColor whiteColor];
	UIColor *highlightColor = [UIColor colorWithRed:0.9 green:0.6 blue:0.9 alpha:1.0];
	UIColor *selectionColor = [UIColor blackColor];
	
	NSArray *strings = @[
						 @"渋谷",
						 @"表参道",
						 @"青山一丁目",
						 @"永田町",
						 @"半蔵門",
						 @"九段下",
						 @"神保町",
						 @"大手町",
						 @"三越前",
						 @"水天宮前",
						 @"清澄白河",
						 @"住吉",
						 @"錦糸町",
						 @"押上〈スカイツリー前〉",
						 ];
	
	[strings enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
		
		NSAttributedString *string = [USGScrollingTabItem attributedStringFromString:[NSString stringWithFormat:@"Z%02ld %@", (long)idx+1, title]
																				font:font
																		   textColor:color
																	   textAlignment:NSTextAlignmentCenter
																	   lineBreakMode:NSLineBreakByTruncatingTail];
		USGScrollingTabItem *tabItem = [USGScrollingTabItem tabItemWithString:string];
		tabItem.highlightedString = [USGScrollingTabItem attributedString:string
														 replaceTextColor:highlightColor
																	 font:nil];
		tabItem.selectedString = [USGScrollingTabItem attributedString:string
													  replaceTextColor:selectionColor
																  font:boldFont];
		
		[tabItems addObject:tabItem];
	}];
	
	self.tabItems = tabItems;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}
- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
}
- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self.tabItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.scrollView.width * idx, 0, self.scrollView.width, 0)];
		label.textAlignment = NSTextAlignmentCenter;
		label.backgroundColor = [UIColor clearColor];
		label.text = [NSString stringWithFormat:@"%ld", (long)idx];
		label.font = [UIFont boldSystemFontOfSize:20];
		label.numberOfLines = 0;
		[label sizeToFit];
		label.width = self.scrollView.width;
		label.y = 100;
		[self.scrollView addSubview:label];
	}];
	
	self.scrollView.contentSize = CGSizeMake(self.view.width * self.tabItems.count, self.scrollView.contentSize.height);
	
	self.scrollingTabBar.width = self.view.width - 20;
	self.scrollingTabBar.pageWidth = self.scrollView.width;
	[self.scrollingTabBar reloadTabItems:self.tabItems];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


#pragma mark - USGScrollingTabBarDelegate

- (void)scrollingTabBar:(USGScrollingTabBar*)tabBar didSelectTabAtIndex:(NSUInteger)index
{
	[self.scrollView setContentOffset:CGPointMake(self.scrollView.width * index, self.scrollView.contentOffset.y)
							 animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	self.scrollingTabBar.enabled = !scrollView.tracking;
	
	if (scrollView.tracking || scrollView.decelerating) {
		[self.scrollingTabBar scrollTabBarWithPageOffset:scrollView.contentOffset.x];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self.scrollingTabBar stopScrollDeceleration];
	self.scrollingTabBar.enabled = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	self.scrollingTabBar.enabled = YES;
}


@end
