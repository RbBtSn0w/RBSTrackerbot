//
//  RBSTrackedViewController.h
//  RBSTrackerbotDemo
//
//  Created by Snow Wu on 9/29/16.
//  Copyright © 2016 RbBtSn0w. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RBSTrackerDelegate;

@class RBSTrackerItem;

@interface RBSTrackedViewController : UIViewController

@property(nonatomic, weak) id<RBSTrackerDelegate> tracker;


/**
 Default is Class Name when viewDidLoad
 */
@property(nonatomic, copy) NSString *screenName;


/**
 Default is NO
 */
- (BOOL)needEnterTacker;


/**
 Default is NO
 */
- (BOOL)needLeaveTacker;



#pragma mark    cusom tracker action

- (void)enterTracker;

- (void)leaveTracker;


#pragma mark    expose track bot

- (void)exposeScrollViewDidEndDragging:(__kindof UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)exposeScrollViewDidEndDecelerating:(__kindof UIScrollView *)scrollView;


/**
 handle expose scroll view

 @param scrollView result expose kind of UIScrollView
 */
- (void)exposeScrollView:(__kindof UIScrollView*)scrollView;

@end
NS_ASSUME_NONNULL_END

