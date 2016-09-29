//
//  RBSTrackerItem.m
//  RBSTrackerbotDemo
//
//  Created by Snow Wu on 9/29/16.
//  Copyright © 2016 RbBtSn0w. All rights reserved.
//

#import "RBSTrackerItem.h"

@implementation RBSTrackerItem

+ (instancetype)trackerItemBykey:(NSString*)trackerKey withValue:(NSDictionary*)trackerValue{
    return [[[self class] alloc] initWithkey:trackerKey withValue:trackerValue];
}

- (instancetype)initWithkey:(NSString*)trackerKey withValue:(NSDictionary*)trackerValue{
    self = [super init];
    if (self) {
        self.trackerKey = trackerKey;
        self.trackerValue = trackerValue;
    }
    return self;
}

@end
