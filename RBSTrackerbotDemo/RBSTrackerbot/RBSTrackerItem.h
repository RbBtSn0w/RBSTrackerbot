//
//  RBSTrackerItem.h
//  RBSTrackerbotDemo
//
//  Created by Snow Wu on 9/29/16.
//  Copyright © 2016 RbBtSn0w. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Track information， track key and value.
 */
@interface RBSTrackerItem : NSObject

+ (instancetype)trackerItemBykey:(NSString*)trackerKey withValue:(NSDictionary*)trackerValue;

- (instancetype)initWithkey:(NSString*)trackerKey withValue:(NSDictionary*)trackerValue;

@property (nonatomic, copy) NSString *trackerKey;

@property (nonatomic, strong) NSDictionary *trackerValue;


@end
NS_ASSUME_NONNULL_END
