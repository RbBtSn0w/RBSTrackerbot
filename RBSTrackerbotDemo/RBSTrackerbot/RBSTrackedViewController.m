//
//  RBSTrackedViewController.m
//  RBSTrackerbotDemo
//
//  Created by Snow Wu on 9/29/16.
//  Copyright © 2016 RbBtSn0w. All rights reserved.
//

#import "RBSTrackedViewController.h"
#import "RBSTrackReporter.h"
#import "RBSTrackedView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBSTrackedViewController ()<RBSTrackedViewDelegate>

@property (nonatomic, strong) RBSTrackedView *trackedView;

@property (nonatomic, weak) UIScrollView *lastSV;

@end

@implementation RBSTrackedViewController


- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.trackedView = [[RBSTrackedView alloc] initWithFrame:CGRectZero];
        self.trackedView.trackedDelegate = self;
        self.tracker = self.trackedView.tracker;
        
        self.screenName = NSStringFromClass([self class]);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self _handleEnterTracker];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSNotificationCenter *nCenter = [NSNotificationCenter defaultCenter];
    [nCenter addObserver:self selector:@selector(_ApplicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [nCenter addObserver:self selector:@selector(_ApplicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    if (self.lastSV) {
        [self.trackedView exposeScrollView:self.lastSV];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self _handleLeaveTracker];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)_handleEnterTracker{
    
    if (![self needEnterTacker]) {
        return;
    }
    [self enterTracker];
}

- (void)_handleLeaveTracker{
    
    if (![self needLeaveTacker]) {
        return;
    }
    [self leaveTracker];
}

- (void)_ApplicationDidEnterBackgroundNotification:(NSNotification*)notification{
    
    [self _handleLeaveTracker];
}

- (void)_ApplicationWillEnterForegroundNotification:(NSNotification*)notification{
    
    [self _handleEnterTracker];
    
    if (self.lastSV) {
        [self.trackedView exposeScrollView:self.lastSV];
    }
}

#pragma mark    - Interface Methods
- (BOOL)needEnterTacker{
    return NO;
}
- (BOOL)needLeaveTacker{
    return NO;
}


- (void)enterTracker{
    
    NSLog(@"enterTracker at %@", self.screenName);
}

- (void)leaveTracker{
    
    NSLog(@"leaveTracker at %@", self.screenName);
}


#pragma mark    -

#pragma mark    expose track bot

- (void)exposeScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.trackedView exposeScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)exposeScrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.trackedView exposeScrollViewDidEndDecelerating:scrollView];
}

- (void)exposeScrollView:(UIScrollView*)scrollView{
    [self.trackedView exposeScrollView:scrollView];
    self.lastSV = scrollView;
}

#pragma mark    QNBTrackedViewDelegate

- (void)trackedViewResultTrackedItems:(NSArray<RBSTrackerItem*> *)trackedItems{
    [self.tracker reportTrackerItems:trackedItems];
}

@end
NS_ASSUME_NONNULL_END
