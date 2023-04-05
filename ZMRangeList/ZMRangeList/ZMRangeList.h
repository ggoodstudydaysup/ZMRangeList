//
//  ZMRangeList.h
//  ZMRangeList
//
//  Created by M Z on 2023/4/5.
//  Copyright © 2023 M Z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMRangeList : NSObject

@property (nonatomic, strong) NSMutableArray *rangeList;

- (void)add:(NSArray<NSNumber *> *)rangeArray;

- (void)remove:(NSArray<NSNumber *> *)rangeArray;

- (void)print;

@end

NS_ASSUME_NONNULL_END
