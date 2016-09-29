//
//  RBSTrackedView.m
//  RBSTrackerbotDemo
//
//  Created by Snow Wu on 9/29/16.
//  Copyright © 2016 RbBtSn0w. All rights reserved.
//

#import "RBSTrackedView.h"
#import "RBSTrackedView+Private.h"
#import "RBSTrackSnifferDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@implementation RBSTrackedView
{
    CGPoint _lastContentOffsetByTableView;
    CGPoint _lastContentOffsetByCollectionView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.trackReporter = [[RBSTrackReporter alloc] init];
        self.tracker = self.trackReporter;
        
        self.lastExposeByTableViewCells = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
        self.lastExposeByCollectionViewCells = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
    }
    return self;
}

#pragma mark    expose track bot

- (void)exposeScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {//decelerate == NO
        [self _onceHandReport:scrollView];
    }
}

- (void)exposeScrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (![scrollView isDecelerating] && ![scrollView isDragging]) {
        
        [self _onceHandReport:scrollView];
    }
}


- (void)exposeView:(__kindof UIView<RBSTrackSnifferDataSource> *)view{
    
    NSArray<RBSTrackerItem*> * results = [view trackSniffer];
    
    if ([self.trackedDelegate respondsToSelector:@selector(trackedViewResultTrackedItems:)]) {
        
        [self.trackedDelegate trackedViewResultTrackedItems:results];
    }else{
        
        [self.tracker reportTrackerItems:results];
    }
}

- (void)exposeScrollView:(UIScrollView*)scrollView{
    [self.lastExposeByCollectionViewCells removeAllObjects];
    [self.lastExposeByTableViewCells removeAllObjects];
    [self _onceHandReport:scrollView];
}

#pragma mark    -   inner methods

- (void)_exposeView:(__kindof UIView*)view{
    
    if ([view conformsToProtocol:@protocol(RBSTrackSnifferDataSource)]) {
        
        UIView <RBSTrackSnifferDataSource> *datasource = view;
        
        [self exposeView:datasource];
        
    }
    
}

- (void)_onceHandReport:(UIScrollView*)scrollView{
    [self _checkReportInfo:scrollView];
}

- (void)_checkReportInfo:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
        [self _handReportVisableCellByTableView:(UITableView*)scrollView];
        
    }else if ([scrollView isKindOfClass:[UICollectionView class]]){
        
        UICollectionView *collection = (UICollectionView*)scrollView;
        
        if ([collection.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
            [self _handReportVisableCellByCollectionView:collection];
        }
    }
}

#pragma mark    UITableView

- (void)_handReportVisableCellByTableView:(UITableView*)tableView{
    
    BOOL needFilter = NO;
    CGSize size                  = tableView.frame.size;
    CGPoint currentContentOffset = tableView.contentOffset;
    if ( ABS(_lastContentOffsetByTableView.y - currentContentOffset.y) < size.height) {//Current scrrent context
        needFilter = YES;
    }
    _lastContentOffsetByTableView = currentContentOffset;
    
    
    NSArray<__kindof UITableViewCell *> *visibleCells = [tableView visibleCells];
    
    if (needFilter) {
        [self _reportVisableCellByTableView:[self uniqVisibleCells:visibleCells withLastExpose:self.lastExposeByTableViewCells] currentVisiableCells:visibleCells];
    }else{
        [self _reportVisableCellByTableView:visibleCells currentVisiableCells:nil];
    }
    
    
}

- (void)_reportVisableCellByTableView:(NSArray<__kindof UITableViewCell *> *)needReportVisiableCells currentVisiableCells:(nullable NSArray<__kindof UITableViewCell *> *)visiableCells{
    
    if (needReportVisiableCells.count == 0){
        return;
    }
    
    [self.lastExposeByTableViewCells removeAllObjects];
    
    // sniffer
    [needReportVisiableCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray<__kindof UIView*> *subviews = obj.contentView.subviews;
        
        [subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self _exposeView:obj];
            
        }];
        
    }];
    
    //keep last visable cells
    if (visiableCells) {
        [visiableCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.lastExposeByTableViewCells addObject:obj];
        }];
    }
    
}


#pragma mark    UICollectionView

- (void)_handReportVisableCellByCollectionView:(UICollectionView*)collectionView{
    
    BOOL needFilter = NO;
    
    CGSize size                  = collectionView.frame.size;
    CGPoint currentContentOffset = collectionView.contentOffset;
    
    UICollectionViewFlowLayout *cvLayout = (UICollectionViewFlowLayout*)collectionView.collectionViewLayout;
    if (cvLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        if ( ABS(_lastContentOffsetByCollectionView.y - currentContentOffset.y) < size.height){//visable screen context zone
            needFilter = YES;
        }
    }else{
        if ( ABS(_lastContentOffsetByCollectionView.x - currentContentOffset.x) < size.width) {//visable screen context zone
            needFilter = YES;
        }
    }
    _lastContentOffsetByCollectionView = currentContentOffset;
    
    NSArray<__kindof UICollectionViewCell *> *visibleCells = [collectionView visibleCells];
    if (needFilter) {
        [self _reportVisableCellByCollectionView:[self uniqVisibleCells:visibleCells withLastExpose:self.lastExposeByCollectionViewCells] currentVisiableCells:visibleCells];
    }else{
        [self _reportVisableCellByCollectionView:visibleCells currentVisiableCells:nil];
    }
    
}

- (void)_reportVisableCellByCollectionView:(NSArray<__kindof UICollectionViewCell *> *)needReportVisiableCells currentVisiableCells:(nullable NSArray<__kindof UICollectionViewCell *> *)visiableCells{
    
    if (needReportVisiableCells.count == 0){
        return;
    }
    
    [self.lastExposeByCollectionViewCells removeAllObjects];
    
    // sniffer
    [needReportVisiableCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray<__kindof UIView*> *subviews = obj.contentView.subviews;
        
        [subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self _exposeView:obj];
            
        }];
    }];
    //keep last visable cells
    if (visiableCells) {
        [visiableCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.lastExposeByCollectionViewCells addObject:obj];
        }];
    }
    
}


#pragma mark    -   Helper Methods

- (NSArray*)uniqVisibleCells:(NSArray*)visibleCells withLastExpose:(NSHashTable*)lastExpose {
    
    NSMutableArray *resultCells = [NSMutableArray array];
    
    [visibleCells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(![lastExpose containsObject:obj]){
            [resultCells addObject:obj];
        }
        
    }];
    
    return resultCells;
}



@end
NS_ASSUME_NONNULL_END

