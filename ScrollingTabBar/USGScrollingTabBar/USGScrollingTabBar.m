//
//  USGScrollingTabBar.m
//  ScrollingTabBar
//
//  Created by M.Satori on 15.08.01.
//  Copyright (c) 2015 usagimaru. All rights reserved.
//

#import "USGScrollingTabBar.h"
#import "USGScrollingTabCell.h"
#import "UIView+USGViewFrame.h"

CGFloat const USGScrollingTabFocusCircleCorner = -1;

@interface USGScrollingTabBar () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIView *focus;

@property (nonatomic) NSArray *tabItems;
@property (nonatomic) NSArray *tabWidths;
@property (nonatomic) NSArray *tabIntervals;
@property (nonatomic, readwrite) NSUInteger indexOfSelectedTab;

#ifdef USGScrollingTabDrawLines
@property (nonatomic) UIView *centerMarker;
#endif

@end

@implementation USGScrollingTabBar

- (void)__initialSetup
{
	if (self)
	{
		self.focusCornerRadius = USGScrollingTabFocusCircleCorner;
		
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		layout.minimumInteritemSpacing = 0;
		layout.minimumLineSpacing = 0;
		layout.sectionInset = UIEdgeInsetsZero;
		
		self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
		self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.collectionView.dataSource = self;
		self.collectionView.delegate = self;
		self.collectionView.backgroundColor = [UIColor clearColor];
		self.collectionView.scrollsToTop = NO;
		self.collectionView.showsVerticalScrollIndicator = NO;
		self.collectionView.showsHorizontalScrollIndicator = NO;
		self.collectionView.directionalLockEnabled = YES;
		self.collectionView.delaysContentTouches = NO;
		
		[self.collectionView registerNib:[USGScrollingTabCell nib] forCellWithReuseIdentifier:[USGScrollingTabCell reuseIdentifier]];
		[self addSubview:self.collectionView];
		
		
		self.focus = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.height)];
		self.focus.clipsToBounds = YES;
		[self.collectionView addSubview:self.focus];
		
		
#ifdef USGScrollingTabDrawLines
		self.centerMarker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.height)];
		self.centerMarker.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
		[self addSubview:self.centerMarker];
#endif
	}
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	[self __initialSetup];
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	[self __initialSetup];
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
#ifdef USGScrollingTabDrawLines
	self.centerMarker.x = self.width / 2.0;
#endif
}


#pragma mark -

/// タブ幅とタブ間隔を計算
- (void)__setupTabsWithTabItems:(NSArray*)tabItems
					  tabWidths:(NSArray**)tabWidths
				   tabIntervals:(NSArray**)tabIntervals
{
	CGFloat viewWidth_half = self.collectionView.width / 2.0;
	CGSize tabMaxSize = CGSizeMake(CGFLOAT_MAX, self.collectionView.height);
	
	NSMutableArray *tabWidthArray = @[].mutableCopy;
	NSMutableArray *tabIntervalArray = @[].mutableCopy;
	
	__block CGFloat totalTabWidth = self.tabBarInset;
	__block BOOL tabIntervalAdjusted = NO;
	
	[tabItems enumerateObjectsUsingBlock:^(USGScrollingTabItem *prevTabItem, NSUInteger idx, BOOL *stop) {
		
		CGFloat prevTabWidth = [USGScrollingTabCell tabWidth:prevTabItem.string
													 maxSize:tabMaxSize
													tabInset:self.tabInset];
		[tabWidthArray addObject:@(prevTabWidth)];
		
		// タブ同士の間隔を計算
		if (idx < tabItems.count-1)
		{
			// 累計タブ幅
			totalTabWidth += prevTabWidth + self.tabSpacing;
			
			// 次のタブ項目と、そこからタブ幅を算出
			USGScrollingTabItem *nextTabItem = tabItems[idx+1];
			CGFloat nextTabWidth = [USGScrollingTabCell tabWidth:nextTabItem.string
														 maxSize:tabMaxSize
														tabInset:self.tabInset];
			
			CGFloat tabInterval = 0;
			
			// 選択タブを中心に配置するための、タブ間隔の調整
			// 累計タブ幅がビューの半分以上という条件が成り立つ最初のタブなら、タブ間隔を調整する
			// 累計タブ幅がビューの半分未満の場合、タブ間隔を0のままにする
			if (totalTabWidth + nextTabWidth >= viewWidth_half)
			{
				// タブ同士の間隔を算出
				tabInterval = (prevTabWidth + nextTabWidth) / 2.0 + self.tabSpacing;
				
				// 累計タブ幅がビューの半分以上が成り立つ最初のタブ
				if (!tabIntervalAdjusted) {
					tabInterval = totalTabWidth - viewWidth_half + (nextTabWidth / 2.0);
					tabIntervalAdjusted = YES;
				}
			}
			
			[tabIntervalArray addObject:@(tabInterval)];
		}
	}];
	
	// 要素数合わせで最後の要素を複製
	if (tabIntervalArray.count) {
		[tabIntervalArray addObject:[tabIntervalArray lastObject]];
	}
	
	if (tabWidths) *tabWidths = tabWidthArray;
	if (tabIntervals) *tabIntervals = tabIntervalArray;
}

CGFloat linearFunction(CGFloat x, CGFloat a1, CGFloat a2, NSInteger index)
{
	CGFloat a = a1 - a2;
	CGFloat b = -a * index + a2;
	CGFloat y = a * x + b;
	return y;
}


#pragma mark -

- (CGFloat)tabCount
{
	return self.tabItems.count;
}

- (void)setDecelerationRate:(CGFloat)decelerationRate
{
	self.collectionView.decelerationRate = decelerationRate;
}
- (CGFloat)decelerationRate
{
	return self.collectionView.decelerationRate;
}

- (void)reloadTabItems:(NSArray*)tabItems
{
	self.tabItems = tabItems;
	
	UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
	layout.minimumInteritemSpacing = self.tabSpacing;
	
	
	// タブ幅・タブ間隔を計算
	NSArray *tabWidths = nil;
	NSArray *tabIntervals = nil;
	[self __setupTabsWithTabItems:tabItems
						tabWidths:&tabWidths
					 tabIntervals:&tabIntervals];
	self.tabWidths = tabWidths;
	self.tabIntervals = tabIntervals;
	
	
	self.focus.backgroundColor = self.focusColor;
	self.focus.y = self.focusVerticalMargin;
	self.focus.height = self.height - self.focusVerticalMargin * 2.0;
	self.focus.layer.cornerRadius = self.focusCornerRadius <= USGScrollingTabFocusCircleCorner ? self.focus.height / 2.0 : self.focusCornerRadius;
	
	if (tabItems.count) {
		self.focus.x = self.tabBarInset;
		self.focus.width = [self.tabWidths[self.indexOfSelectedTab] doubleValue];
		self.focus.hidden = NO;
	}
	else {
		self.focus.hidden = YES;
	}
	
	
	[self.collectionView reloadData];
	
	__weak __typeof(self) wself = self;
	dispatch_async(dispatch_get_main_queue(), ^{
		[wself selectTabAtIndex:wself.indexOfSelectedTab animated:NO];
	});
}

- (void)scrollTabBarWithPageOffset:(CGFloat)pageOffset
{
	NSUInteger tabCount = self.tabItems.count;
	
	// ページレート
	CGFloat pageRate = pageOffset / self.pageWidth;
	
	// インデックスがタブ項目数を超過しないよう調整
	NSInteger pageIndexRaw = floor(pageRate);
	NSInteger pageIndex = MAX(MIN(floor(pageRate), tabCount-1), 0);
	NSInteger pageIndexRounded = MAX(MIN(round(pageRate), tabCount-1), 0);
	NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:pageIndexRounded inSection:0];
	
	// 現在のタブ幅・タブページ幅
	CGFloat tabWidth = [self.tabWidths[pageIndex] doubleValue] + self.tabSpacing;
	CGFloat tabInterval = [self.tabIntervals[pageIndex] doubleValue];
	
	// 以前のタブ幅・タブページ幅の合計値
	CGFloat beforeFocusOffset = 0;
	CGFloat beforeTabBarOffset = 0;
	for (int i=0; i<pageIndex; i++) {
		beforeFocusOffset += [self.tabWidths[i] doubleValue] + self.tabSpacing;
		beforeTabBarOffset += [self.tabIntervals[i] doubleValue];
	}
	
	// 次ページに移ったらページオフセットを0に戻す
	CGFloat currentPageOffset = (pageIndex > 0) ? pageOffset - self.pageWidth * pageIndex : pageOffset;
	
	// オフセット×レート+以前のタブ幅・タブページ幅の合計値
	CGFloat tabOffset = currentPageOffset * (tabWidth / self.pageWidth) + beforeFocusOffset + self.tabBarInset;
	CGFloat tabBarOffset = currentPageOffset * (tabInterval / self.pageWidth) + beforeTabBarOffset;
	
	// 最適なフォーカス幅を計算
	// -1番目のときは、幅0と0番目の幅を扱う
	CGFloat prev_a = (pageRate >= 0) ? [self.tabWidths[pageIndex] doubleValue] : 0;
	CGFloat next_a = (pageIndexRaw+1 < self.tabWidths.count) ? [self.tabWidths[pageIndexRaw+1] doubleValue] : 0;
	CGFloat focusWidth = linearFunction(pageRate, next_a, prev_a, pageIndexRaw);
	
	
	// 範囲調整
	tabBarOffset = MIN(MAX(tabBarOffset, 0), self.collectionView.contentSize.width - self.collectionView.width);
	tabOffset = MIN(MAX(tabOffset, self.tabBarInset), self.collectionView.contentSize.width - focusWidth - self.tabBarInset);
	
	
	// オフセットとフォーカスのフレームを設定
	self.collectionView.contentOffset = CGPointMake(tabBarOffset, 0);
	self.focus.x = tabOffset;
	self.focus.width = focusWidth;
	
	[self.collectionView selectItemAtIndexPath:selectionIndexPath
									  animated:YES
								scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)selectTabAtIndex:(NSUInteger)index animated:(BOOL)animated
{
	if (index >= self.tabItems.count) {
		return;
	}
	
	self.indexOfSelectedTab = index;
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	
	[self.collectionView selectItemAtIndexPath:indexPath
									  animated:animated
								scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
	
	USGScrollingTabCell *tab = (USGScrollingTabCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
	CGRect focusFrame = self.focus.frame;
	focusFrame.origin.x = tab.x;
	focusFrame.size.width = [self.tabWidths[index] doubleValue];
	
	[UIView animateWithDuration:animated ? 0.33 : 0.0
						  delay:0
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 
						 self.focus.frame = focusFrame;
					 }
					 completion:nil];
}

- (void)stopScrollDeceleration
{
	[self.collectionView setContentOffset:self.collectionView.contentOffset animated:NO];
}

- (void)setEnabled:(BOOL)enabled
{
	self.collectionView.scrollEnabled = enabled;
}
- (BOOL)enabled
{
	return self.collectionView.scrollEnabled;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.tabItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	USGScrollingTabItem *tabItem = self.tabItems[indexPath.row];
	USGScrollingTabCell *tab = (USGScrollingTabCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[USGScrollingTabCell reuseIdentifier]
																							   forIndexPath:indexPath];
	
	[tab setTabItem:tabItem];
	tab.inset = self.tabInset;
	tab.index = indexPath.row;
	tab.collectionView = self.collectionView;
	
	return tab;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
	[collectionView insertSubview:self.focus atIndex:0];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self selectTabAtIndex:indexPath.row animated:YES];
	
	if ([self.delegate respondsToSelector:@selector(scrollingTabBar:didSelectTabAtIndex:)]) {
		[self.delegate scrollingTabBar:self didSelectTabAtIndex:indexPath.row];
	}
}


#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
				  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	USGScrollingTabItem *tabItem = self.tabItems[indexPath.row];
	CGFloat tabWidth = [USGScrollingTabCell tabWidth:tabItem.string
											 maxSize:CGSizeMake(CGFLOAT_MAX, collectionView.height)
											tabInset:self.tabInset];
	
	return CGSizeMake(tabWidth, collectionView.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
						layout:(UICollectionViewLayout*)collectionViewLayout
		insetForSectionAtIndex:(NSInteger)section
{
	return UIEdgeInsetsMake(0, self.tabBarInset, 0, self.tabBarInset);
}

@end


@implementation USGScrollingTabItem

+ (instancetype)tabItemWithString:(NSAttributedString*)string
{
	return [self tabItemWithString:string
				 highlightedString:string
					selectedString:string];
}
+ (instancetype)tabItemWithString:(NSAttributedString*)string
				highlightedString:(NSAttributedString*)highlightedString
				   selectedString:(NSAttributedString*)selecttedString
{
	USGScrollingTabItem *tabItem = [[self alloc] init];
	tabItem.string = string;
	tabItem.highlightedString = highlightedString;
	tabItem.selectedString = selecttedString;
	return tabItem;
}

@end


@implementation USGScrollingTabItem (NSAttributedStringBuilder)

+ (NSAttributedString*)attributedStringFromString:(NSString*)string
											 font:(UIFont*)font
										textColor:(UIColor*)color
									textAlignment:(NSTextAlignment)textAlignment
									lineBreakMode:(NSLineBreakMode)lineBreakMode
{
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.alignment = textAlignment;
	paragraphStyle.lineBreakMode = lineBreakMode;
	
	return [self attributedStringFromString:string
									   font:font
								  textColor:color
							 paragraphStyle:paragraphStyle];
}
+ (NSAttributedString*)attributedStringFromString:(NSString*)string
											 font:(UIFont*)font
										textColor:(UIColor*)color
								   paragraphStyle:(NSParagraphStyle*)paragraphStyle
{
	if (!string) {
		string = @"";
	}
	if (!font) {
		font = [UIFont systemFontOfSize:11];
	}
	if (!color) {
		color = [UIColor blackColor];
	}
	
	NSDictionary *attributes = @{
								 NSFontAttributeName : font,
								 NSForegroundColorAttributeName : color,
								 NSParagraphStyleAttributeName : paragraphStyle,
								 };
	return [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
}
+ (NSAttributedString*)attributedString:(NSAttributedString*)attributedString
					   replaceTextColor:(UIColor*)color
								   font:(UIFont*)font
{
	if (!attributedString) {
		return nil;
	}
	
	NSMutableDictionary *attributes = @{}.mutableCopy;
	
	if (color) {
		attributes[NSForegroundColorAttributeName] = color;
	}
	if (font) {
		attributes[NSFontAttributeName] = font;
	}
	
	NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
	[mutableAttributedString addAttributes:attributes
									 range:NSMakeRange(0, attributedString.length)];
	
	return [mutableAttributedString copy];
}

@end
