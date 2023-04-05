//
//  ViewController.m
//  ZMRangeList
//
//  Created by M Z on 2023/4/5.
//  Copyright © 2023 M Z. All rights reserved.
//

#import "ViewController.h"
#import "ZMRangeList.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZMRangeList *rangeList = [[ZMRangeList alloc] init];
    [rangeList print];
    [rangeList add:@[@(1), @(5)]];
    [rangeList print];
    [rangeList add:@[@(10), @(20)]];
    [rangeList print];
    [rangeList add:@[@(20), @(20)]];
    [rangeList print];
    [rangeList add:@[@(20), @(21)]];
    [rangeList print];
    [rangeList add:@[@(2), @(4)]];
    [rangeList print];
    [rangeList add:@[@(3), @(8)]];
    [rangeList print];
    
    [rangeList remove:@[@(10), @(10)]];
    [rangeList print];
    [rangeList remove:@[@(10), @(11)]];
    [rangeList print];
    [rangeList remove:@[@(15), @(17)]];
    [rangeList print];
    [rangeList remove:@[@(3), @(19)]];
    [rangeList print];
    
    // Do any additional setup after loading the view.
}


@end
