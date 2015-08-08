//
//  USGScrollingTabCell.h
//  ScrollingTabBar
//
//  Created by M.Satori on 15.08.01.
//  Copyright (c) 2015 usagimaru. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USGScrollingTabItem;

@interface USGScrollingTabCell : UICollectionViewCell

@property (nonatomic) CGFloat inset;
@property (nonatomic) NSAttributedString *string;
@property (nonatomic) NSAttributedString *highlightedString;
@property (nonatomic) NSAttributedString *selectedString;
@property (nonatomic) NSInteger index;
@property (nonatomic, weak) UICollectionView *collectionView;

+ (UINib*)nib;
+ (NSString*)reuseIdentifier;
+ (CGFloat)tabWidth:(NSAttributedString*)string
			maxSize:(CGSize)masSize
		   tabInset:(CGFloat)tabInset;

- (void)setTabItem:(USGScrollingTabItem*)tabItem;

@end
