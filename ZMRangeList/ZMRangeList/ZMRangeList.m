//
//  ZMRangeList.m
//  ZMRangeList
//
//  Created by M Z on 2023/4/5.
//  Copyright © 2023 M Z. All rights reserved.
//

#import "ZMRangeList.h"

@implementation ZMRangeList

#pragma mark - Init Method
- (instancetype)init
{
    self = [super init];
    if (self) {
        _rangeList = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Public Method
- (void)add:(NSArray<NSNumber *> *)rangeArray
{
    if (![self checkRAValid:rangeArray]) {
        return;
    }
    
    if (_rangeList.count == 0) {
        [_rangeList addObject:rangeArray];
    }else{
        NSArray *beginIndex = [self findBeginIndex:rangeArray];
        NSArray *endIndex = [self findEndIndex:rangeArray];
        BOOL beginInOne = [self isInOneRange:beginIndex];
        BOOL endInOne = [self isInOneRange:endIndex];
        if (beginInOne && endInOne) {
            if ([self indexInSameOne:beginIndex indexArray2:endIndex]) {
                return;
            }else{
                int beginIndexTemp = [beginIndex.firstObject intValue];
                int endIndexTemp = [endIndex.firstObject intValue];
                NSNumber *startR = [(_rangeList[beginIndexTemp]) firstObject];
                NSNumber *endR = [(_rangeList[endIndexTemp]) lastObject];
                NSArray *added = @[startR, endR];
                NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                for (int i = beginIndexTemp; i <= endIndexTemp; ++i) {
                    [indexSet addIndex:i];
                    
                }
                [_rangeList replaceObjectsAtIndexes:indexSet withObjects:@[added]];
            }
        }
        
        if (beginInOne && !endInOne) {
            int beginIndexTemp = [beginIndex.firstObject intValue];
            int endIndexTemp = [endIndex.firstObject intValue];
            NSNumber *startR = [(_rangeList[beginIndexTemp]) firstObject];
            NSArray *added = @[startR, [rangeArray lastObject]];
            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
            for (int i = beginIndexTemp; i <= endIndexTemp; ++i) {
                [indexSet addIndex:i];
            }
            [_rangeList replaceObjectsAtIndexes:indexSet withObjects:@[added]];
        }
        
        if (!beginInOne && endInOne) {
            int beginIndexTemp = [beginIndex.lastObject intValue];
            int endIndexTemp = [endIndex.firstObject intValue];
            NSNumber *startR = [rangeArray firstObject];
            NSNumber *endR = [(_rangeList[endIndexTemp]) lastObject];
            NSArray *added = @[startR, endR];
            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
            for (int i = beginIndexTemp; i <= endIndexTemp; ++i) {
                [indexSet addIndex:i];
            }
            [_rangeList replaceObjectsAtIndexes:indexSet withObjects:@[added]];
        }
        
        if (!beginInOne && !endInOne) {
            if (([beginIndex.firstObject intValue] == [endIndex.firstObject intValue]) &&
                ([beginIndex.lastObject intValue] == [endIndex.lastObject intValue])) {
                
                
                [_rangeList insertObject:rangeArray atIndex:[beginIndex.lastObject intValue]];
            }else{
                int beginIndexTemp = [beginIndex.lastObject intValue];
                int endIndexTemp = [endIndex.firstObject intValue];
                NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                for (int i = beginIndexTemp; i <= endIndexTemp; ++i) {
                    [indexSet addIndex:i];
                }
                [_rangeList replaceObjectsAtIndexes:indexSet withObjects:@[rangeArray]];
            }
        }
    }
}

- (void)remove:(NSArray<NSNumber *> *)rangeArray
{
    if (![self checkRAValid:rangeArray]) {
        return;
    }
    
    if (_rangeList.count == 0) {
        return;
    }else{
        NSArray *beginIndex = [self findBeginIndex:rangeArray];
        NSArray *endIndex = [self findEndIndex:rangeArray];
        BOOL beginInOne = [self isInOneRange:beginIndex];
        BOOL endInOne = [self isInOneRange:endIndex];
        if (beginInOne && endInOne) {
            if ([self indexInSameOne:beginIndex indexArray2:endIndex]) {
                int indexTemp = [beginIndex.firstObject intValue];
                NSNumber *startR = [(_rangeList[indexTemp]) firstObject];
                NSNumber *endR = [(_rangeList[indexTemp]) lastObject];
                
                if (([startR intValue] == [rangeArray.firstObject intValue]) &&
                    ([endR intValue] == [rangeArray.lastObject intValue])) {
                    [_rangeList removeObjectAtIndex:indexTemp];
                }else if (([startR intValue] == [rangeArray.firstObject intValue]) &&
                ([endR intValue] != [rangeArray.lastObject intValue])){
                    NSArray *added = @[rangeArray.lastObject, endR];
                    [_rangeList replaceObjectAtIndex:indexTemp withObject:added];
                }else if (([startR intValue] != [rangeArray.firstObject intValue]) &&
                ([endR intValue] == [rangeArray.lastObject intValue])){
                    NSArray *added = @[startR, rangeArray.firstObject];
                    [_rangeList replaceObjectAtIndex:indexTemp withObject:added];
                }else{
                    NSArray *added1 = @[startR, rangeArray.firstObject];
                    NSArray *added2 = @[rangeArray.lastObject, endR];
                    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                    [indexSet addIndex:indexTemp];
                    [_rangeList removeObjectAtIndex:indexTemp];
                    [_rangeList insertObjects:@[added2] atIndexes:indexSet];
                    [_rangeList insertObjects:@[added1] atIndexes:indexSet];
                }
            }else{
                int beginIndexTemp = [beginIndex.firstObject intValue];
                int endIndexTemp = [endIndex.firstObject intValue];
                NSNumber *bStartR = [(_rangeList[beginIndexTemp]) firstObject];
                NSNumber *bEndR = [(_rangeList[beginIndexTemp]) lastObject];
                NSNumber *eStartR = [(_rangeList[endIndexTemp]) firstObject];
                NSNumber *eEndR = [(_rangeList[endIndexTemp]) lastObject];
                NSNumber *deleteBegin = rangeArray.firstObject;
                NSNumber *deleteEnd = rangeArray.lastObject;
                if (([deleteBegin intValue] == [bStartR intValue]) &&
                    ([deleteEnd intValue] == [eEndR intValue])) {
                    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                    for (int i = beginIndexTemp; i <= endIndexTemp; ++i) {
                        [indexSet addIndex:i];
                    }
                    [_rangeList removeObjectsAtIndexes:indexSet];
                }else if (([deleteBegin intValue] == [bStartR intValue]) &&
                          ([deleteEnd intValue] != [eEndR intValue])){
                    if ([deleteEnd intValue] == [eStartR intValue]) {
                        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                        for (int i = beginIndexTemp; i < endIndexTemp; ++i) {
                            [indexSet addIndex:i];
                        }
                        [_rangeList removeObjectsAtIndexes:indexSet];
                    }else{
                        NSArray *added = @[deleteEnd, eEndR];
                        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                        for (int i = beginIndexTemp; i <= endIndexTemp; ++i) {
                            [indexSet addIndex:i];
                        }
                        [_rangeList replaceObjectsAtIndexes:indexSet withObjects:@[added]];
                    }
                }else if (([deleteBegin intValue] != [bStartR intValue]) &&
                          ([deleteEnd intValue] == [eEndR intValue])) {
                    if ([deleteBegin intValue] == [bEndR intValue]) {
                        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                        for (int i = (beginIndexTemp + 1); i <= endIndexTemp; ++i) {
                            [indexSet addIndex:i];
                        }
                        [_rangeList removeObjectsAtIndexes:indexSet];
                    }else{
                        NSArray *added = @[bStartR, deleteBegin];
                        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                        for (int i = beginIndexTemp; i <= endIndexTemp; ++i) {
                            [indexSet addIndex:i];
                        }
                        [_rangeList replaceObjectsAtIndexes:indexSet withObjects:@[added]];
                    }
                }else{
                    if (([deleteBegin intValue] == [bEndR intValue]) &&
                        ([deleteEnd intValue] == [eStartR intValue])) {
                        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                        for (int i = (beginIndexTemp + 1); i < endIndexTemp; ++i) {
                            [indexSet addIndex:i];
                        }
                        [_rangeList removeObjectsAtIndexes:indexSet];
                    }else if (([deleteBegin intValue] == [bEndR intValue]) &&
                              ([deleteEnd intValue] != [eStartR intValue])){
                        NSArray *added = @[deleteEnd, eEndR];
                        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                        for (int i = (beginIndexTemp + 1); i <= endIndexTemp; ++i) {
                            [indexSet addIndex:i];
                        }
                        [_rangeList replaceObjectsAtIndexes:indexSet withObjects:@[added]];
                    }else if (([deleteBegin intValue] != [bEndR intValue]) &&
                              ([deleteEnd intValue] == [eStartR intValue])){
                        NSArray *added = @[bStartR, deleteBegin];
                        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                        for (int i = beginIndexTemp; i < endIndexTemp; ++i) {
                            [indexSet addIndex:i];
                        }
                        [_rangeList replaceObjectsAtIndexes:indexSet withObjects:@[added]];
                    }else{
                        NSArray *added1 = @[bStartR, deleteBegin];
                        NSArray *added2 = @[deleteEnd, eEndR];
                        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                        [indexSet addIndex:beginIndexTemp];
                        int count = 0;
                        for (int i = beginIndexTemp; i <= endIndexTemp; ++i) {
                            ++count;
                        }
                        while (count > 0) {
                            [_rangeList removeObjectAtIndex:beginIndexTemp];
                            --count;
                        }
                        
                        [_rangeList insertObjects:@[added2] atIndexes:indexSet];
                        [_rangeList insertObjects:@[added1] atIndexes:indexSet];
                    }
                }
            }
        }
        
        if (beginInOne && !endInOne) {
            int beginIndexTemp = [beginIndex.firstObject intValue];
            int endIndexTemp = [endIndex.firstObject intValue];
            NSNumber *startR = [(_rangeList[beginIndexTemp]) firstObject];
            if ([startR intValue] == [rangeArray.firstObject intValue]) {
                NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                for (int i = beginIndexTemp; i <= endIndexTemp; ++i) {
                    [indexSet addIndex:i];
                }
                [_rangeList removeObjectsAtIndexes:indexSet];
            }else{
                NSArray *added = @[startR, rangeArray.firstObject];
                NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                for (int i = beginIndexTemp; i <= endIndexTemp; ++i) {
                    [indexSet addIndex:i];
                }
                [_rangeList replaceObjectsAtIndexes:indexSet withObjects:@[added]];
            }
        }
        
        if (!beginInOne && endInOne) {
            int beginIndexTemp = [beginIndex.lastObject intValue];
            int endIndexTemp = [endIndex.firstObject intValue];
            NSNumber *startR = [(_rangeList[endIndexTemp]) firstObject];
            NSNumber *endR = [(_rangeList[endIndexTemp]) lastObject];
            if ([startR intValue] == [rangeArray.lastObject intValue]) {
                NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                for (int i = beginIndexTemp; i < endIndexTemp; ++i) {
                    [indexSet addIndex:i];
                }
                [_rangeList removeObjectsAtIndexes:indexSet];
            }else if ([endR intValue] == [rangeArray.lastObject intValue]){
                NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                for (int i = beginIndexTemp; i <= endIndexTemp; ++i) {
                    [indexSet addIndex:i];
                }
                [_rangeList removeObjectsAtIndexes:indexSet];
            }else{
                NSArray *added = @[rangeArray.lastObject, endR];
                NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                for (int i = beginIndexTemp; i <= endIndexTemp; ++i) {
                    [indexSet addIndex:i];
                }
                [_rangeList replaceObjectsAtIndexes:indexSet withObjects:@[added]];
            }
        }
        
        if (!beginInOne && !endInOne) {
            if (([beginIndex.firstObject intValue] == [endIndex.firstObject intValue]) &&
                ([beginIndex.lastObject intValue] == [endIndex.lastObject intValue])) {
                return;
            }else{
                int beginIndexTemp = [beginIndex.lastObject intValue];
                int endIndexTemp = [endIndex.firstObject intValue];
                NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                for (int i = beginIndexTemp; i <= endIndexTemp; ++i) {
                    [indexSet addIndex:i];
                }
                [_rangeList removeObjectsAtIndexes:indexSet];
            }
        }
    }
}

- (void)print
{
    if (_rangeList == nil || _rangeList.count == 0) {
        printf("The RangeList is empty.\n");
        return;
    }
    
    for (NSArray *range in _rangeList) {
        printf("[%d, %d) \n", [self getBegin:range], [self getEnd:range]);
    }
}

#pragma mark - Private Method
- (BOOL)indexInSameOne:(NSArray<NSNumber *> *)indexArray1 indexArray2:(NSArray<NSNumber *> *)indexArray2
{
    if (indexArray1.firstObject.intValue == indexArray2.firstObject.intValue) {
        return YES;
    }
    return NO;
}

- (BOOL)isInOneRange:(NSArray<NSNumber *> *)indexArray
{
    if (indexArray.firstObject.intValue == indexArray.lastObject.intValue) {
        return YES;
    }
    return NO;
}

- (NSArray<NSNumber *> *)findBeginIndex:(NSArray<NSNumber *> *)rangeArray
{
    int start = 0;
    int end = (int)_rangeList.count - 1;
    int target = [self getBegin:rangeArray];
    while (start <= end) {
        int middle = (start + end) >> 1;
        NSArray *range = _rangeList[middle];
        int beginI = [self getBegin:range];
        int endI = [self getEnd:range];
        if (target >= beginI && target <= endI) {
            return @[@(middle), @(middle)];
        }else if (target < beginI) {
            end = middle - 1;
        }else{
            start = middle + 1;
        }
    }
    
    return @[@(end), @(start)];
}

- (NSArray<NSNumber *> *)findEndIndex:(NSArray<NSNumber *> *)rangeArray
{
    int start = 0;
    int end = (int)_rangeList.count - 1;
    int target = [self getEnd:rangeArray];
    while (start <= end) {
        int middle = (start + end) >> 1;
        NSArray *range = _rangeList[middle];
        int beginI = [self getBegin:range];
        int endI = [self getEnd:range];
        if (target >= beginI && target <= endI) {
            return @[@(middle), @(middle)];
        }else if (target < beginI) {
            end = middle - 1;
        }else{
            start = middle + 1;
        }
    }
    
    return @[@(end), @(start)];
}

- (int)getBegin:(NSArray<NSNumber *> *)rangeArray
{
    return [rangeArray.firstObject intValue];
}

- (int)getEnd:(NSArray<NSNumber *> *)rangeArray
{
    return [rangeArray.lastObject intValue];
}

- (BOOL)checkRAValid:(NSArray<NSNumber *> *)rArray
{
    BOOL isValid = YES;
    if (rArray == nil || ![rArray isKindOfClass:[NSArray class]] || rArray.count != 2) {
        isValid = NO;
    }
    
    int begin = [rArray.firstObject intValue];
    int end = [rArray.lastObject intValue];
    if (begin >= end) {
        isValid = NO;
    }
    
    return isValid;
}

@end

