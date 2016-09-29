//
//  RBSTrackedView.h
//  RBSTrackerbotDemo
//
//  Created by Snow Wu on 9/29/16.
//  Copyright © 2016 RbBtSn0w. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RBSTrackSnifferDataSource, RBSTrackedViewDelegate, RBSTrackerDelegate;

@interface RBSTrackedView : UIView

@property (nonatomic, weak) id<RBSTrackerDelegate> tracker;


/**
 if nil, next time will auto report
 */
@property (nonatomic, weak) id<RBSTrackedViewDelegate> trackedDelegate;

#pragma mark    expose track bot

- (void)exposeScrollViewDidEndDragging:(__kindof UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)exposeScrollViewDidEndDecelerating:(__kindof UIScrollView *)scrollView;

- (void)exposeView:(__kindof UIView<RBSTrackSnifferDataSource> *)view;

- (void)exposeScrollView:(UIScrollView*)scrollView;

@end

@class RBSTrackerItem;

@protocol RBSTrackedViewDelegate <NSObject>

- (void)trackedViewResultTrackedItems:(NSArray<RBSTrackerItem*> *)trackedItems;

@end
NS_ASSUME_NONNULL_END
