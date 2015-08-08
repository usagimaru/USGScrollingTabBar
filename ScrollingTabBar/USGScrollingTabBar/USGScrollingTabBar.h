//
//  USGScrollingTabBar.h
//  ScrollingTabBar
//
//  Created by M.Satori on 15.08.01.
//  Copyright (c) 2015 usagimaru. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
//#define USGScrollingTabDrawLines
#endif

@class USGScrollingTabBar;

@protocol USGScrollingTabBarDelegate <NSObject>
@optional

- (void)scrollingTabBar:(USGScrollingTabBar*)tabBar didSelectTabAtIndex:(NSUInteger)index;

@end

extern CGFloat const USGScrollingTabFocusCircleCorner;

@interface USGScrollingTabBar : UIView

@property (nonatomic) id<USGScrollingTabBarDelegate> delegate;
@property (nonatomic) CGFloat pageWidth;
@property (nonatomic) CGFloat tabBarInset;
@property (nonatomic) CGFloat tabSpacing;
@property (nonatomic) CGFloat tabInset;
@property (nonatomic) CGFloat focusVerticalMargin;
@property (nonatomic) CGFloat focusCornerRadius;
@property (nonatomic) UIColor *focusColor;
@property (nonatomic) CGFloat decelerationRate;
@property (nonatomic) BOOL enabled;
@property (nonatomic, readonly) CGFloat tabCount;
@property (nonatomic, readonly) NSUInteger indexOfSelectedTab;

- (void)reloadTabItems:(NSArray*)tabItems;
- (void)scrollTabBarWithPageOffset:(CGFloat)pageOffset;
- (void)selectTabAtIndex:(NSUInteger)index animated:(BOOL)animated;

- (void)stopScrollDeceleration;

@end

@interface USGScrollingTabItem : NSObject

@property (nonatomic) NSAttributedString *string;
@property (nonatomic) NSAttributedString *highlightedString;
@property (nonatomic) NSAttributedString *selectedString;

+ (instancetype)tabItemWithString:(NSAttributedString*)string;
+ (instancetype)tabItemWithString:(NSAttributedString*)string
				highlightedString:(NSAttributedString*)highlightedString
				   selectedString:(NSAttributedString*)selecttedString;

@end

@interface USGScrollingTabItem (NSAttributedStringBuilder)

+ (NSAttributedString*)attributedStringFromString:(NSString*)string
											 font:(UIFont*)font
										textColor:(UIColor*)color
									textAlignment:(NSTextAlignment)textAlignment
									lineBreakMode:(NSLineBreakMode)lineBreakMode;
+ (NSAttributedString*)attributedStringFromString:(NSString*)string
											 font:(UIFont*)font
										textColor:(UIColor*)color
								   paragraphStyle:(NSParagraphStyle*)paragraphStyle;
+ (NSAttributedString*)attributedString:(NSAttributedString*)attributedString
					   replaceTextColor:(UIColor*)color
								   font:(UIFont*)font;

@end
