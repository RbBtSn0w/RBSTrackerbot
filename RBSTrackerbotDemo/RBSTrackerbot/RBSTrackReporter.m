//
//  RBSTrackReporter.m
//  RBSTrackerbotDemo
//
//  Created by Snow Wu on 9/29/16.
//  Copyright © 2016 RbBtSn0w. All rights reserved.
//

#import "RBSTrackReporter.h"
#import "RBSTrackerItem.h"

@implementation RBSTrackReporter

- (void)_handReportTrackerItems:(NSArray<RBSTrackerItem*> *)trackerItems{
    
    [trackerItems enumerateObjectsUsingBlock:^(RBSTrackerItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //[report reportEventIdentifier:obj.trackerKey params:obj.trackerValue addCoreInfo:obj.needCoreInfo];
        
        NSLog(@"trackerItems \n trackerKey:%@ \n trackerValue:%@", obj.trackerKey, obj.trackerValue);
    }];
}

#pragma mark    -   QNBTrackerDelegate

- (void)reportTrackerItems:(NSArray<RBSTrackerItem*> *)trackerItems{
    
    if ([NSThread isMainThread]){
        [self _handReportTrackerItems:trackerItems];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _handReportTrackerItems:trackerItems];
        });
    }
}


@end
