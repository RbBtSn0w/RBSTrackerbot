//
//  RBSTrackedView+Private.m
//  RBSTrackerbotDemo
//
//  Created by Snow Wu on 9/29/16.
//  Copyright © 2016 RbBtSn0w. All rights reserved.
//

#import "RBSTrackedView.h"
#import "RBSTrackReporter.h"

NS_ASSUME_NONNULL_BEGIN
@interface RBSTrackedView ()

@property (nonatomic, strong) RBSTrackReporter *trackReporter;


@property (nonatomic, strong) NSHashTable<__kindof UITableViewCell*> *lastExposeByTableViewCells;
@property (nonatomic, strong) NSHashTable<__kindof UICollectionViewCell*> *lastExposeByCollectionViewCells;

@end

NS_ASSUME_NONNULL_END
