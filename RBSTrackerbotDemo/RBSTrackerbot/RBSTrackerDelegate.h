//
//  RBSTrackerDelegate.h
//  RBSTrackerbotDemo
//
//  Created by Snow Wu on 9/29/16.
//  Copyright © 2016 RbBtSn0w. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RBSTrackerItem;

@protocol RBSTrackerDelegate <NSObject>

- (void)reportTrackerItems:(NSArray<RBSTrackerItem*> *)trackerItems;

@end
NS_ASSUME_NONNULL_END
